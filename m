From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv5 00/36] asynchronous ALUA device handler
Date: Tue, 13 Oct 2015 11:44:52 +0200
Message-ID: <561CD294.3080905@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de> <560AD88B.9050902@sandisk.com> <560BE1DC.9060600@suse.de> <560C5509.6050206@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbbJMJoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 05:44:55 -0400
In-Reply-To: <560C5509.6050206@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/30/2015 11:32 PM, Bart Van Assche wrote:
> On 09/30/2015 06:21 AM, Hannes Reinecke wrote:
>> On 09/29/2015 08:29 PM, Bart Van Assche wrote:
>>> On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
>>>> here the next round of my update to the ALUA device handler.
>>>
>>> Sorry but this with this version I see an initiator kernel lockup
>>> shortly after the initiator system had been booted. I have attached
>>> the output of echo t > /proc/sysrq-trigger to this e-mail.
>>>
>> Hmm. Weird.
>> Everything seems to wait for alua_rtpg() to complete: [ ... ]
>=20
> Hello Hannes,
>=20
> Would it be possible to add the patch to your tree that causes
> scsi_dh_alua to be loaded automatically again
> (http://thread.gmane.org/gmane.linux.scsi/105276) ? I might have
> forgotten to load the scsi_dh_alua driver manually before I ran
> my test ...
>=20
> However, even with the scsi_dh_alua driver loaded a kernel lockup is
> reported. Please note that I do not know whether or not that lockup i=
s
> related to this patch series or to the changes in v4.3-rc1:
>=20
> INFO: task srp_daemon:600 blocked for more than 120 seconds.
>       Not tainted 4.3.0-rc1-debug+ #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> srp_daemon      D ffff88045c6a2d00     0   600    593 0x00000000
>  ffff88043060b960 0000000000000092 ffffffff810ba0bd ffff88047fc95ad8
>  ffff88045c6a2d00 ffff880430559680 ffff88043060c000 ffff8804181061c8
>  ffff88041dbd3cf8 ffff8804181055e8 ffff880418104ad0 ffff88043060b978
> Call Trace:
>  [<ffffffff810ba0bd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff814efcda>] schedule+0x3a/0x90
>  [<ffffffff81271a46>] blk_mq_freeze_queue_wait+0x56/0xb0
>  [<ffffffff810b45c0>] ? prepare_to_wait_event+0xf0/0xf0
>  [<ffffffff81273a61>] blk_mq_update_tag_set_depth+0x41/0xb0
>  [<ffffffff81274294>] blk_mq_init_allocated_queue+0x7c4/0x860
>  [<ffffffff8127436a>] blk_mq_init_queue+0x3a/0x60
>  [<ffffffffa0016a6c>] scsi_mq_alloc_queue+0x1c/0x50 [scsi_mod]
>  [<ffffffffa0017c51>] scsi_alloc_sdev+0x331/0x3b0 [scsi_mod]
>  [<ffffffffa0018554>] scsi_probe_and_add_lun+0x884/0xd20 [scsi_mod]
>  [<ffffffffa00191cb>] __scsi_scan_target+0x52b/0x5f0 [scsi_mod]
>  [<ffffffff8139198c>] ? __pm_runtime_resume+0x5c/0x80
>  [<ffffffffa001936c>] scsi_scan_target+0xdc/0x100 [scsi_mod]
>  [<ffffffffa04374ae>] srp_create_target+0xfde/0x1410 [ib_srp]
>  [<ffffffff810b8201>] ? match_held_lock+0x1c1/0x200
>  [<ffffffff81381b68>] dev_attr_store+0x18/0x30
>  [<ffffffff812300f4>] sysfs_kf_write+0x44/0x60
>  [<ffffffff8122f724>] kernfs_fop_write+0x144/0x190
>  [<ffffffff811b8788>] __vfs_write+0x28/0xe0
>  [<ffffffff810b6a4a>] ? percpu_down_read+0x5a/0x90
>  [<ffffffff811bba70>] ? __sb_start_write+0xe0/0x100
>  [<ffffffff811bba70>] ? __sb_start_write+0xe0/0x100
>  [<ffffffff811d7455>] ? __fget+0x5/0x210
>  [<ffffffff811b8e19>] vfs_write+0xa9/0x190
>  [<ffffffff811b9b19>] SyS_write+0x49/0xa0
>  [<ffffffff814f57b6>] entry_SYSCALL_64_fastpath+0x16/0x7a
> 7 locks held by srp_daemon/600:
>  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff811d84b3>] __fdget_pos+=
0x43/0x50
>  #1:  (sb_writers#3){.+.+.+}, at: [<ffffffff811bba70>] __sb_start_wri=
te+0xe0/0x100
>  #2:  (&of->mutex){+.+.+.}, at: [<ffffffff8122f646>] kernfs_fop_write=
+0x66/0x190
>  #3:  (s_active#142){.+.+.+}, at: [<ffffffff8122f64e>] kernfs_fop_wri=
te+0x6e/0x190
>  #4:  (&host->add_target_mutex){+.+.+.}, at: [<ffffffffa043660b>] srp=
_create_target+0x13b/0x1410 [ib_srp]
>  #5:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffffa0019317>] scsi_sca=
n_target+0x87/0x100 [scsi_mod]
>  #6:  (&set->tag_list_lock){+.+...}, at: [<ffffffff81274272>] blk_mq_=
init_allocated_queue+0x7a2/0x860
>=20
I have rebased my patches to 4.3.0-rc5 and didn't see any lockups;
tested with hpsa and lpfc, both mq enabled and disabled.

Can you check if it's specific to ib_srp? Is there a way to simulate
an ib_srp setup?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
