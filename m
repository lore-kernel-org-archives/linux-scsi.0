Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721CCC25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 18:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiHPSA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiHPSAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 14:00:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C21E8284C
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 11:00:40 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4M6f4b4HX9z682kB;
        Wed, 17 Aug 2022 01:57:35 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 16 Aug 2022 20:00:38 +0200
Received: from [10.48.154.245] (10.48.154.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 16 Aug 2022 19:00:37 +0100
Message-ID: <8a83665a-1951-a326-f930-8fcbb0c4dd9a@huawei.com>
Date:   Tue, 16 Aug 2022 19:00:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>, <gzhqyz@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220816172638.538734-1-bvanassche@acm.org>
In-Reply-To: <20220816172638.538734-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.154.245]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/08/2022 18:26, Bart Van Assche wrote:
> Although patch "Rework asynchronous resume support" eliminates the delay
> for some ATA disks after resume, it causes resume of ATA disks to fail
> on other setups. See also:
> * "Resume process hangs for 5-6 seconds starting sometime in 5.16"
>    (https://bugzilla.kernel.org/show_bug.cgi?id=215880).
> * Geert's regression report
>    (https://lore.kernel.org/linux-scsi/alpine.DEB.2.22.394.2207191125130.1006766@ramsan.of.borg/).
> 
> This is what I understand about this issue:
> * During resume, ata_port_pm_resume() starts the SCSI error handler.
>    This changes the SCSI host state into SHOST_RECOVERY and causes
>    scsi_queue_rq() to return BLK_STS_RESOURCE.
> * sd_resume() calls sd_start_stop_device() for ATA devices. That
>    function in turn calls sd_submit_start() which tries to submit a START
>    STOP UNIT command. That command can only be submitted after the SCSI
>    error handler has changed the SCSI host state back to SHOST_RUNNING.
> * The SCSI error handler runs on its own thread and calls
>    schedule_work(&(ap->scsi_rescan_task)). That causes
>    ata_scsi_dev_rescan() to be called from the context of a kernel
>    workqueue. That call hangs in blk_mq_get_tag(). I'm not sure why -
>    maybe because all available tags have been allocated by
>    sd_submit_start() calls (this is a guess).
> 
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: gzhqyz@gmail.com
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: gzhqyz@gmail.com
> Fixes: 88f1669019bd ("scsi: sd: Rework asynchronous resume support"; v6.0-rc1~114^2~68)


JFYI, Just now I see that 88f1669019bd also causes me issues for my SATA 
disk:

root@(none)$ echo 0 > sys/class/sas_phy/phy-0:0:2/enable
[58.271646] sas: ex 500e004aaaaaaa1f phy02 change count has changed
[58.305876] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
[58.305898] sd 0:0:1:0: [sdb] Synchronize Cache(10) failed: Result: 
hostbyte=0x04 driverbyte=DRIVER_OK
[58.305901] sd 0:0:1:0: [sdb] Stopping disk
[58.305911] sd 0:0:1:0: [sdb] Start/Stop Unit failed: Result: 
hostbyte=0x04 driverbyte=DRIVER_OK

root@(none)$ echo 1 > sys/class/sas_phy/phy-0:0:2/enable
[95.405836] INFO: task kworker/u128:0:8 blocked for more than 30 seconds.
[95.412618] Not tainted 5.19.0-rc1-00128-g88f1669019bd-dirty #1166
[95.419311] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[95.427130] task:kworker/u128:0  state:D stack: 0 pid: 8 ppid:  2 
flags:0x00000008
[95.435475] Workqueue: HISI0162:01_event_q sas_port_event_worker
[95.441481] Call trace:
[95.443918]  __switch_to+0x11c/0x1a8
[95.447491]  __schedule+0x264/0x718
[95.450972]  schedule+0x50/0xc8
[95.454106]  schedule_timeout+0x19c/0x250
[95.458108]  wait_for_completion+0x84/0x140
[95.462283]  flush_workqueue+0xfc/0x3d0
[95.466114]  sas_porte_broadcast_rcvd+0x5c/0x68
[95.470638]  sas_port_event_worker+0x2c/0x50
[95.474899]  process_one_work+0x1e4/0x348
[95.478901]  worker_thread+0x48/0x418
[95.482555]  kthread+0xf4/0x110
[95.485687]  ret_from_fork+0x10/0x20
[95.489274] INFO: task kworker/u128:1:462 blocked for more than 30 seconds.
[95.496226] Not tainted 5.19.0-rc1-00128-g88f1669019bd-dirty #1166
[95.502918] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[95.510736] task:kworker/u128:1  state:D stack: 0 pid:  462 ppid:  2 
flags:0x00000008
[95.519080] Workqueue: HISI0162:01_disco_q sas_revalidate_domain
[95.525080] Call trace:
[95.527517]  __switch_to+0x11c/0x1a8
[95.531085]  __schedule+0x264/0x718
[95.534565]  schedule+0x50/0xc8
[95.537694]  blk_mq_freeze_queue_wait+0x7c/0xb0
[95.542218]  blk_mq_freeze_queue+0x1c/0x28
[95.546307]  disk_release+0x40/0xf0
[95.549784]  device_release+0x30/0x90
[95.553441]  kobject_put+0x90/0x108
[95.556923]  put_device+0x10/0x20
[95.560231]  put_disk+0x18/0x28
[95.563363]  sd_remove+0x44/0x58
[95.566585]  device_remove+0x6c/0x78
[95.570153]  device_release_driver_internal+0xd8/0x180
[95.575284]  device_release_driver+0x14/0x20
[95.579545]  bus_remove_device+0xc8/0x108
[95.583547]  device_del+0x16c/0x3a0
[95.587028]  __scsi_remove_device+0xf0/0x130
[95.591290]  scsi_remove_device+0x28/0x40
[95.595291]  scsi_remove_target+0x1b8/0x220
[95.599466]  sas_rphy_remove+0x5c/0x60
[95.603208]  sas_rphy_delete+0x14/0x28
[95.606949]  sas_destruct_devices+0x54/0x88
[95.611124]  sas_revalidate_domain+0x60/0x148
[95.615472]  process_one_work+0x1e4/0x348
[95.619474]  worker_thread+0x48/0x418
[95.623129]  kthread+0xf4/0x110
[95.626261]  ret_from_fork+0x10/0x20
[95.629830] INFO: task sh:541 blocked for more than 30 seconds.
[95.635740] Not tainted 5.19.0-rc1-00128-g88f1669019bd-dirty #1166
[95.642431] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[95.650250] task:sh  state:D stack: 0 pid:  541 ppid:  1 flags:0x00000000
[95.658594] Call trace:
[95.661028]  __switch_to+0x11c/0x1a8
[95.664597]  __schedule+0x264/0x718
[95.668076]  schedule+0x50/0xc8
[95.671210]  schedule_timeout+0x19c/0x250
[95.675211]  wait_for_completion+0x84/0x140
[95.679387]  flush_workqueue+0xfc/0x3d0
[95.683214]  drain_workqueue+0xb0/0x158
[95.687043]  __sas_drain_work+0x3c/0x98
[95.690870]  sas_drain_work+0x58/0x60
[95.694524]  queue_phy_enable+0x84/0xc8
[95.698352]  do_sas_phy_enable.isra.7+0x58/0xb0
[95.702875]  store_sas_phy_enable+0x48/0x78
[95.707051]  dev_attr_store+0x14/0x28
[95.710706]  sysfs_kf_write+0x48/0x58
[95.714362]  kernfs_fop_write_iter+0x118/0x1a0
[95.718798]  new_sync_write+0xdc/0x168
[95.722543]  vfs_write+0x1b8/0x388
[95.725938]  ksys_write+0x64/0xf0
[95.729241]  __arm64_sys_write+0x14/0x20
[95.733157]  invoke_syscall+0x40/0xf8
[95.736814]  el0_svc_common.constprop.3+0x6c/0xf8
[95.741511]  do_el0_svc+0x28/0xc8
[95.744818]  el0_svc+0x28/0x80
[95.747865]  el0t_64_sync_handler+0x94/0xb8
[95.752039]  el0t_64_sync+0x178/0x17c


BTW, I see 88f1669019bd is queued for stable...


> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/sd.c | 84 ++++++++++-------------------------------------
>   drivers/scsi/sd.h |  5 ---
>   2 files changed, 18 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8f79fa6318fe..eb76ba055021 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -103,7 +103,6 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
>   static void sd_config_write_same(struct scsi_disk *);
>   static int  sd_revalidate_disk(struct gendisk *);
>   static void sd_unlock_native_capacity(struct gendisk *disk);
> -static void sd_start_done_work(struct work_struct *work);
>   static int  sd_probe(struct device *);
>   static int  sd_remove(struct device *);
>   static void sd_shutdown(struct device *);
> @@ -3471,7 +3470,6 @@ static int sd_probe(struct device *dev)
>   	sdkp->max_retries = SD_MAX_RETRIES;
>   	atomic_set(&sdkp->openers, 0);
>   	atomic_set(&sdkp->device->ioerr_cnt, 0);
> -	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
>   
>   	if (!sdp->request_queue->rq_timeout) {
>   		if (sdp->type != TYPE_MOD)
> @@ -3594,69 +3592,12 @@ static void scsi_disk_release(struct device *dev)
>   	kfree(sdkp);
>   }
>   
> -/* Process sense data after a START command finished. */
> -static void sd_start_done_work(struct work_struct *work)
> -{
> -	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
> -					      start_done_work);
> -	struct scsi_sense_hdr sshdr;
> -	int res = sdkp->start_result;
> -
> -	if (res == 0)
> -		return;
> -
> -	sd_print_result(sdkp, "Start/Stop Unit failed", res);
> -
> -	if (res < 0)
> -		return;
> -
> -	if (scsi_normalize_sense(sdkp->start_sense_buffer,
> -				 sdkp->start_sense_len, &sshdr))
> -		sd_print_sense_hdr(sdkp, &sshdr);
> -}
> -
> -/* A START command finished. May be called from interrupt context. */
> -static void sd_start_done(struct request *req, blk_status_t status)
> -{
> -	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
> -	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
> -
> -	sdkp->start_result = scmd->result;
> -	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
> -	sdkp->start_sense_len = scmd->sense_len;
> -	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer,
> -	       ARRAY_SIZE(sdkp->start_sense_buffer));
> -	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
> -}
> -
> -/* Submit a START command asynchronously. */
> -static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
> -{
> -	struct scsi_device *sdev = sdkp->device;
> -	struct request_queue *q = sdev->request_queue;
> -	struct request *req;
> -	struct scsi_cmnd *scmd;
> -
> -	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
> -	if (IS_ERR(req))
> -		return PTR_ERR(req);
> -
> -	scmd = blk_mq_rq_to_pdu(req);
> -	scmd->cmd_len = cmd_len;
> -	memcpy(scmd->cmnd, cmd, cmd_len);
> -	scmd->allowed = sdkp->max_retries;
> -	req->timeout = SD_TIMEOUT;
> -	req->rq_flags |= RQF_PM | RQF_QUIET;
> -	req->end_io = sd_start_done;
> -	blk_execute_rq_nowait(req, /*at_head=*/true);
> -
> -	return 0;
> -}
> -
>   static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   {
>   	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
> +	struct scsi_sense_hdr sshdr;
>   	struct scsi_device *sdp = sdkp->device;
> +	int res;
>   
>   	if (start)
>   		cmd[4] |= 1;	/* START */
> @@ -3667,10 +3608,23 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   	if (!scsi_device_online(sdp))
>   		return -ENODEV;
>   
> -	/* Wait until processing of sense data has finished. */
> -	flush_work(&sdkp->start_done_work);
> +	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
> +	if (res) {
> +		sd_print_result(sdkp, "Start/Stop Unit failed", res);
> +		if (res > 0 && scsi_sense_valid(&sshdr)) {
> +			sd_print_sense_hdr(sdkp, &sshdr);
> +			/* 0x3a is medium not present */
> +			if (sshdr.asc == 0x3a)
> +				res = 0;
> +		}
> +	}
>   
> -	return sd_submit_start(sdkp, cmd, sizeof(cmd));
> +	/* SCSI error codes must not go to the generic layer */
> +	if (res)
> +		return -EIO;
> +
> +	return 0;
>   }
>   
>   /*
> @@ -3697,8 +3651,6 @@ static void sd_shutdown(struct device *dev)
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		sd_start_stop_device(sdkp, 0);
>   	}
> -
> -	flush_work(&sdkp->start_done_work);
>   }
>   
>   static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index b89187761d61..5eea762f84d1 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -150,11 +150,6 @@ struct scsi_disk {
>   	unsigned	urswrz : 1;
>   	unsigned	security : 1;
>   	unsigned	ignore_medium_access_errors : 1;
> -
> -	int		start_result;
> -	u32		start_sense_len;
> -	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
> -	struct work_struct start_done_work;
>   };
>   #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
>   
> .

