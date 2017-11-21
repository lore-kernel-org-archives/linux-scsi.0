From: Jason Ozolins <jason.ozolins@hpe.com>
Subject: Re: [REPOST PATCH] scsi: ses: don't ask for diagnostic pages
 repeatedly during probe
Date: Wed, 22 Nov 2017 04:45:41 +1100
Message-ID: <5A146645.6070307@hpe.com>
References: <20171113234804.4675-1-dongyang.li@anu.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:18098 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdKURqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Nov 2017 12:46:00 -0500
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id 33CA3F94
        for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2017 17:46:00 +0000 (UTC)
In-Reply-To: <20171113234804.4675-1-dongyang.li@anu.edu.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Dongyang <dongyang.li@anu.edu.au>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Supporting info for the use case this patch addresses:
On 14/11/2017 10:48, Li Dongyang wrote:
> We are testing if there is a match with the ses device in a loop
> by calling ses_match_to_enclosure(), which will issue scsi receive
> diagnostics commands to the ses device for every device on the
> same host.
> On one of our boxes with 840 disks, it takes a long time to load
> the driver:
> 
> [root@g1b-oss06 ~]# time modprobe ses
> 
> real	40m48.247s
> user	0m0.001s
> sys	0m0.196s

The use case the patch addresses is Linux HA storage servers natively
handling block storage at scales that until now have been handled
by proprietary modular storage arrays.

Config tested has 840 targets across 26 SES devices in chained JBODS:
host#  #targets #enclosures
1       40       2
2      400      12
3      400      12

Without the patch, time taken in ses_init goes up as
#disks * #SES enclosures; so ~41 minutes is spent within
class_interface_register(), holding the scsi_device class mutex.

Stack from kworker during modprobe ses:
[<ffffffff812f440b>] blk_execute_rq+0xab/0x150
[<ffffffff81457653>] scsi_execute+0xd3/0x170
[<ffffffff81458ffe>] scsi_execute_req_flags+0xee/0x100
[<ffffffffa028e19c>] ses_recv_diag+0x7c/0xd0 [ses]
[<ffffffffa028e9fc>] ses_enclosure_data_process+0x7c/0x3e0 [ses]
[<ffffffffa028edac>] ses_match_to_enclosure+0x4c/0xb0 [ses]
[<ffffffffa028f279>] ses_intf_add+0x469/0x4d0 [ses]
[<ffffffff8142dbe9>] class_interface_register+0xb9/0x110
[<ffffffff8145fcb6>] scsi_register_interface+0x16/0x20
[<ffffffffa0037013>] ses_init+0x13/0x1000 [ses]
[<ffffffff810020e8>] do_one_initcall+0xb8/0x230
[<ffffffff81100288>] load_module+0x22c8/0x2930
[<ffffffff81100aa6>] SyS_finit_module+0xa6/0xd0
[<ffffffff816964c9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

During this time, if e.g. failed disks are replaced, the kworker
handling that event in the hpsa driver will block trying to get
the scsi_device class mutex, and hung task messages will be printed.

Task dump excerpt after disk insertion:
[  961.323141] kworker/u56:2   D ffff88407ee98680     0   676      2 0x00000000
[  961.323429] Workqueue: rescan_3_hpsa hpsa_rescan_ctlr_worker [hpsa]
[  961.323727]  ffff881ff456f890 0000000000000046 ffff881ffa454f10 ffff881ff456ffd8
[  961.324034]  ffff881ff456ffd8 ffff881ff456ffd8 ffff881ffa454f10 ffff88407ee98678
[  961.324332]  ffff88407ee9867c ffff881ffa454f10 00000000ffffffff ffff88407ee98680
[  961.324646] Call Trace:
[  961.324951]  [<ffffffff816aa409>] schedule_preempt_disabled+0x29/0x70
[  961.325252]  [<ffffffff816a8337>] __mutex_lock_slowpath+0xc7/0x1d0
[  961.325605]  [<ffffffff816a774f>] mutex_lock+0x1f/0x2f
[  961.325939]  [<ffffffff8143c7f5>] device_add+0x535/0x7c0
[  961.326266]  [<ffffffff81473d27>] scsi_sysfs_add_sdev+0xb7/0x280
[  961.326633]  [<ffffffff81470d05>] scsi_probe_and_add_lun+0xc35/0xe30
[  961.326971]  [<ffffffff8144acfc>] ? __pm_runtime_resume+0x5c/0x80
[  961.327327]  [<ffffffff8147189d>] __scsi_scan_target+0xad/0x260
[  961.327662]  [<ffffffff81471b68>] scsi_scan_target+0x118/0x130
[  961.327981]  [<ffffffffc00a9df6>] sas_rphy_add+0x106/0x170 [scsi_transport_sas]
[  961.328334]  [<ffffffffc00f2c3c>] adjust_hpsa_scsi_table+0xefc/0x10b0 [hpsa]
[  961.328705]  [<ffffffffc00f4120>] ? hpsa_update_scsi_devices+0x1330/0x18f0 [hpsa]
[  961.329055]  [<ffffffffc00f37d7>] hpsa_update_scsi_devices+0x9e7/0x18f0 [hpsa]
[  961.329442]  [<ffffffff812fa413>] ? blk_peek_request+0x83/0x280
[  961.329841]  [<ffffffffc00f4890>] hpsa_scan_start+0x1b0/0x1e0 [hpsa]
[  961.330216]  [<ffffffffc00f4fd1>] hpsa_rescan_ctlr_worker+0x181/0x657 [hpsa]
[  961.330655]  [<ffffffff810a881a>] process_one_work+0x17a/0x440
[  961.331089]  [<ffffffff810a94e6>] worker_thread+0x126/0x3c0
[  961.331519]  [<ffffffff810a93c0>] ? manage_workers.isra.24+0x2a0/0x2a0
[  961.331951]  [<ffffffff810b098f>] kthread+0xcf/0xe0
[  961.332379]  [<ffffffff810b08c0>] ? insert_kthread_work+0x40/0x40
[  961.332830]  [<ffffffff816b4f58>] ret_from_fork+0x58/0x90
[  961.333249]  [<ffffffff810b08c0>] ? insert_kthread_work+0x40/0x40

The delay processing disk changes causes problems in maintenance and
hardware failure situations where the machine has recently rebooted.

The HPSA HBA firmware presents disks before enclosures when it detects
a change to the SAS fabric; the patch speeds up initialization in
this case:

- When the module loads at boot, in the ses_intf_add() for each
disk device, there are not yet any enclosures registered for that host;
so ses_match_to_enclosure() in the enclosure_find() loop body is not
called.

- When ses_intf_add() is called for an enclosure device, it directly
calls ses_enclosure_data_process(), which populates the enclosure_device
with results from one page 10/page 7 query.  The subsequent
call to ses_match_to_enclosure() within the shost_for_each_device()
loop fixes up all the disks for that enclosure, with refresh=0
preventing redundant ses_enclosure_data_process() calls on all
registered enclosure_devices for each device processed within the loop.

- Once enclosure_devices have been registered for a host, ses_intf_add()
calls for disk devices in that host will refresh registered
enclosure_devices through the ses_match_to_enclosure() call within the
enclosure_find() loop. For disks within enclosures not yet processed
by ses_intf_add(), they get handled by the cases already given above.

The detection ordering of disks then enclosures at boot holds for HPSA
driver HBAs, but may not hold in general.  This case is also produced
by the HPSA driver if a cable to a chain of enclosures is replaced,
causing a whole chain of disks and enclosures to be re-detected, while 
other disks and enclosures remain on the host.

We confirmed that enclosure device sysfs entries are correctly created
for that case, and correctly re-created if the module is removed and
reprobed, just with extra time taken during ses_init() for the
disks that follow already created enclosure devices. For any ordering
of devices on a host where disks precede enclosure devices, this patch
will reduce time taken in ses_init(). 

So the patch helps for this use case, and does not hurt in general.

Tested-by: Jason Ozolins <jason.ozolins@hpe.com>

> With the patch:
> 
> [root@g1b-oss06 ~]# time modprobe ses
> 
> real	0m17.915s
> user	0m0.008s
> sys	0m0.053s
> 
> Note that we still need to refresh page 10 when we see a new disk
> to create the link.
> 
> Signed-off-by: Li Dongyang <dongyang.li@anu.edu.au>
> ---
>  drivers/scsi/ses.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 11826c5c2dd4..62f04c0511cf 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -615,13 +615,16 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  }
>  
>  static void ses_match_to_enclosure(struct enclosure_device *edev,
> -				   struct scsi_device *sdev)
> +				   struct scsi_device *sdev,
> +				   int refresh)
>  {
> +	struct scsi_device *edev_sdev = to_scsi_device(edev->edev.parent);
>  	struct efd efd = {
>  		.addr = 0,
>  	};
>  
> -	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
> +	if (refresh)
> +		ses_enclosure_data_process(edev, edev_sdev, 0);
>  
>  	if (scsi_is_sas_rphy(sdev->sdev_target->dev.parent))
>  		efd.addr = sas_get_address(sdev);
> @@ -652,7 +655,7 @@ static int ses_intf_add(struct device *cdev,
>  		struct enclosure_device *prev = NULL;
>  
>  		while ((edev = enclosure_find(&sdev->host->shost_gendev, prev)) != NULL) {
> -			ses_match_to_enclosure(edev, sdev);
> +			ses_match_to_enclosure(edev, sdev, 1);
>  			prev = edev;
>  		}
>  		return -ENODEV;
> @@ -768,7 +771,7 @@ static int ses_intf_add(struct device *cdev,
>  	shost_for_each_device(tmp_sdev, sdev->host) {
>  		if (tmp_sdev->lun != 0 || scsi_device_enclosure(tmp_sdev))
>  			continue;
> -		ses_match_to_enclosure(edev, tmp_sdev);
> +		ses_match_to_enclosure(edev, tmp_sdev, 0);
>  	}
>  
>  	return 0;
> 
