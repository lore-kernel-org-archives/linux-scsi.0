From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 27/36] scsi_dh_alua: Use workqueue for RTPG
Date: Thu, 1 Oct 2015 16:34:33 -0700
Message-ID: <560DC309.90100@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-28-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0099.outbound.protection.outlook.com ([207.46.100.99]:24528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbbJAXei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 19:34:38 -0400
In-Reply-To: <1443523658-87622-28-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:48 AM, Hannes Reinecke wrote:
> +static void alua_rtpg_work(struct work_struct *work)
> +{
> +	struct alua_port_group *pg =
> +		container_of(work, struct alua_port_group, rtpg_work.work);
> +	struct scsi_device *sdev;
> +	LIST_HEAD(qdata_list);
> +	int err = SCSI_DH_OK;
> +	struct alua_queue_data *qdata, *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pg->lock, flags);
> +	sdev = pg->rtpg_sdev;
> +	if (!sdev) {
> +		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG ||
> +			pg->flags & ALUA_PG_RUN_STPG);
> +		spin_unlock_irqrestore(&pg->lock, flags);
> +		return;
> +	}
> +	pg->flags |= ALUA_PG_RUNNING;
> +	if (pg->flags & ALUA_PG_RUN_RTPG) {
> +		spin_unlock_irqrestore(&pg->lock, flags);
> +		err = alua_rtpg(sdev, pg);
> +		spin_lock_irqsave(&pg->lock, flags);
> +		if (err == SCSI_DH_RETRY) {
> +			pg->flags &= ~ALUA_PG_RUNNING;
> +			spin_unlock_irqrestore(&pg->lock, flags);
> +			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
> +					   pg->interval * HZ);
> +			return;
> +		}
> +		pg->flags &= ~ALUA_PG_RUN_RTPG;
> +		if (err != SCSI_DH_OK)
> +			pg->flags &= ~ALUA_PG_RUN_STPG;
> +	}
> +	if (pg->flags & ALUA_PG_RUN_STPG) {
> +		spin_unlock_irqrestore(&pg->lock, flags);
> +		err = alua_stpg(sdev, pg);
> +		spin_lock_irqsave(&pg->lock, flags);
> +		pg->flags &= ~ALUA_PG_RUN_STPG;
> +		if (err == SCSI_DH_RETRY) {
> +			pg->flags |= ALUA_PG_RUN_RTPG;
> +			pg->interval = 0;
> +			pg->flags &= ~ALUA_PG_RUNNING;
> +			spin_unlock_irqrestore(&pg->lock, flags);
> +			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
> +					   pg->interval * HZ);
> +			return;
> +		}
> +	}
> +
> +	list_splice_init(&pg->rtpg_list, &qdata_list);
> +	pg->rtpg_sdev = NULL;
> +	spin_unlock_irqrestore(&pg->lock, flags);
> +
> +	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
> +		list_del(&qdata->entry);
> +		if (qdata->callback_fn)
> +			qdata->callback_fn(qdata->callback_data, err);
> +		kfree(qdata);
> +	}
> +	spin_lock_irqsave(&pg->lock, flags);
> +	pg->flags &= ~ALUA_PG_RUNNING;
> +	spin_unlock_irqrestore(&pg->lock, flags);
> +	scsi_device_put(sdev);
> +	kref_put(&pg->kref, release_port_group);
> +}

With this patch series applied kmemleak reports several leaks that were 
not reported without this patch. Is scsi_device_put() + kref_put() 
always called before this function returns without requeueing the work 
item ? Shouldn't the return value of queue_delayed_work() be checked ? 
The leaks reported by kmemleak are:

unreferenced object 0xffff880423d31728 (size 128):
   comm "kworker/2:3", pid 3589, jiffies 4294946634 (age 501.720s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff814ed75e>] kmemleak_alloc+0x4e/0xb0
     [<ffffffff811a9128>] kmem_cache_alloc_trace+0xc8/0x210
     [<ffffffffa0269d78>] alua_rtpg_work+0x1b8/0xc10 [scsi_dh_alua]
     [<ffffffff8108d9a8>] process_one_work+0x1d8/0x610
     [<ffffffff8108def4>] worker_thread+0x114/0x460
     [<ffffffff810941e8>] kthread+0xf8/0x110
     [<ffffffff814f5c2f>] ret_from_fork+0x3f/0x70
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88042ba00150 (size 8):
   comm "srp_daemon", pid 608, jiffies 4294946454 (age 503.510s)
   hex dump (first 8 bytes):
     68 6f 73 74 31 35 00 a5                          host15..
   backtrace:
     [<ffffffff814ed75e>] kmemleak_alloc+0x4e/0xb0
     [<ffffffff811abd53>] __kmalloc_track_caller+0xe3/0x240
     [<ffffffff81295ce2>] kvasprintf+0x52/0x80
     [<ffffffff8128adbf>] kobject_set_name_vargs+0x1f/0x60
     [<ffffffff81382217>] dev_set_name+0x47/0x50
     [<ffffffffa000dcaa>] scsi_host_alloc+0x32a/0x4b0 [scsi_mod]
     [<ffffffffa0279524>] srp_create_target+0x54/0x1410 [ib_srp]
     [<ffffffff81381bf8>] dev_attr_store+0x18/0x30
     [<ffffffff812300f4>] sysfs_kf_write+0x44/0x60
     [<ffffffff8122f724>] kernfs_fop_write+0x144/0x190
     [<ffffffff811b8788>] __vfs_write+0x28/0xe0
     [<ffffffff811b8e19>] vfs_write+0xa9/0x190
     [<ffffffff811b9b19>] SyS_write+0x49/0xa0
     [<ffffffff814f5876>] entry_SYSCALL_64_fastpath+0x16/0x7a
     [<ffffffffffffffff>] 0xffffffffffffffff

Bart.

