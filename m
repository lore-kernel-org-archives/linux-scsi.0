Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B85C4320E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 07:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32AF61075
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 07:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbhIAHnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 03:43:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:38323 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242752AbhIAHnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Sep 2021 03:43:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="279674482"
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="279674482"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 00:42:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="520095007"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga004.fm.intel.com with ESMTP; 01 Sep 2021 00:42:11 -0700
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
 <020bd6be-0944-8e25-c9fd-972cab5e6746@acm.org>
 <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
 <2719c43f-d56b-b2bb-0e34-53bcec74e0d9@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <77088200-5fab-78e9-777b-ceb259f44f03@intel.com>
Date:   Wed, 1 Sep 2021 10:42:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2719c43f-d56b-b2bb-0e34-53bcec74e0d9@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/08/21 8:18 pm, Bart Van Assche wrote:
> On 8/31/21 12:24 AM, Adrian Hunter wrote:
>> How does splitting the host_sem address the potential deadlock
>> between the error handler and runtime resume?
> 
> Hmm ... how do runtime resume and the error handler deadlock? If shost->eh_noresume == 0 then scsi_error_handler() will call scsi_autopm_get_host() before invoking the eh_strategy_handler callback. The definition of scsi_autopm_get_host() is as follows:
> 
> int scsi_autopm_get_host(struct Scsi_Host *shost)
> {
>     int    err;
> 
>     err = pm_runtime_get_sync(&shost->shost_gendev);
>     if (err < 0 && err !=-EACCES)
>         pm_runtime_put_sync(&shost->shost_gendev);
>     else
>         err = 0;
>     return err;
> }

That resumes the host, but the problem is with resuming the UFS device.
The UFS device can be resumed by ufshcd_err_handling_prepare(),
notably before it calls ufshcd_scsi_block_requests()

> 
> The power management operations used for shost_gendev instances are defined by scsi_bus_pm_ops (see also scsi_host_alloc()). The following function is the runtime resume function referenced by scsi_bus_pm_ops and skips shost_gendevs since these are not SCSI devices:
> 
> static int scsi_runtime_resume(struct device *dev)
> {
>     int err = 0;
> 
>     dev_dbg(dev, "scsi_runtime_resume\n");
>     if (scsi_is_sdev_device(dev))
>         err = sdev_runtime_resume(dev);
> 
>     /* Insert hooks here for targets, hosts, and transport classes*/
> 
>     return err;
> }
> 
> In addition to the above function the runtime resume callback of the UFS platform device is also invoked. I think all these functions call ufshcd_runtime_resume(). As far as I can see ufshcd_runtime_resume() does not touch host_sem?

No it doesn't use host_sem.  The problem is with issuing requests to a blocked queue.
If the UFS device is in SLEEP state, runtime resume will try to do a
SCSI request to change to ACTIVE state.  That will block while the error
handler is running.  So if the error handler is waiting on runtime resume,
deadlock.

Here is an example:

First instrument debugfs stats file to trigger SCSI error handling:

From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 1 Sep 2021 09:16:34 +0300
Subject: [PATCH] HACK: scsi: ufs: Hack debugfs stats to do scsi_schedule_eh()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufs-debugfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 4e1ff209b9336..614ba42203a54 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -3,6 +3,8 @@
 
 #include <linux/debugfs.h>
 
+#include <scsi/scsi_transport.h>
+#include "../scsi_transport_api.h"
 #include "ufs-debugfs.h"
 #include "ufshcd.h"
 
@@ -40,6 +42,10 @@ static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
 	PRT("Host Resets: %llu\n", HOST_RESET);
 	PRT("SCSI command aborts: %llu\n", ABORT);
 #undef PRT
+	seq_printf(s, "\n%s: Calling scsi_schedule_eh\n\n", __func__);
+	dev_info(hba->dev, "%s: Calling scsi_schedule_eh\n", __func__);
+	hba->force_reset = true;
+	scsi_schedule_eh(hba->host);
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ufs_debugfs_stats);
-- 
2.25.1


Then set an rpm_lvl to SLEEP:

# echo 2 > /sys/bus/pci/drivers/ufshcd/0000\:00\:12.5/rpm_lvl
# grep -H . /sys/bus/pci/drivers/ufshcd/0000\:00\:12.5/*pm*
/sys/bus/pci/drivers/ufshcd/0000:00:12.5/rpm_lvl:2
/sys/bus/pci/drivers/ufshcd/0000:00:12.5/rpm_target_dev_state:SLEEP
/sys/bus/pci/drivers/ufshcd/0000:00:12.5/rpm_target_link_state:ACTIVE
/sys/bus/pci/drivers/ufshcd/0000:00:12.5/spm_lvl:5
/sys/bus/pci/drivers/ufshcd/0000:00:12.5/spm_target_dev_state:POWERDOWN
/sys/bus/pci/drivers/ufshcd/0000:00:12.5/spm_target_link_state:OFF


I have to do a little IO to make sure the new rpm_lvl
has been used to runtime suspend:

# dd if=/dev/sdb of=/dev/null bs=4096 count=1 &
# 1+0 records in
1+0 records out
4096 bytes (4.1 kB, 4.0 KiB) copied, 0.202648 s, 20.2 kB/


Then trigger the error handler while runtime suspended:

# cat /sys/kernel/debug/ufshcd/0000\:00\:12.5/stats
PHY Adapter Layer errors (except LINERESET): 0
Data Link Layer errors: 0
Network Layer errors: 0
Transport Layer errors: 0
Generic DME errors: 0
Auto-hibernate errors: 0
IS Fatal errors (CEFES, SBFES, HCFES, DFES): 0
DME Link Startup errors: 0
PM Resume errors: 0
PM Suspend errors : 0
Logical Unit Resets: 0
Host Resets: 1
SCSI command aborts: 0

ufs_debugfs_stats_show: Calling scsi_schedule_eh


And show blocked tasks:

# echo w > /proc/sysrq-trigger
# dmesg | tail -29
[  269.223247] sysrq: Show Blocked State
[  269.224452] task:scsi_eh_1       state:D stack:13936 pid:  258 ppid:     2 flags:0x00004000
[  269.225318] Call Trace:
[  269.226133]  __schedule+0x26c/0x6c0
[  269.227265]  schedule+0x3f/0xa0
[  269.228472]  schedule_timeout+0x209/0x290
[  269.228872]  ? blk_mq_sched_dispatch_requests+0x2b/0x50
[  269.229247]  io_schedule_timeout+0x14/0x40
[  269.229825] wait_for_completion_io+0x81/0xe0
[  269.230273]  blk_execute_rq+0x64/0xd0
[  269.230868]  __scsi_execute+0x109/0x260
[  269.231301] ufshcd_set_dev_pwr_mode+0xe2/0x1c0 [ufshcd_core]
[  269.231754]  __ufshcd_wl_resume+0x96/0x220 [ufshcd_core]
[  269.232146] ufshcd_wl_runtime_resume+0x28/0xd0 [ufshcd_core]
[  269.232756]  scsi_runtime_resume+0x76/0xb0
[  269.233499]  ? scsi_autopm_put_device+0x20/0x20
[  269.234171]  __rpm_callback+0x3b/0x110
[  269.235095]  ? scsi_autopm_put_device+0x20/0x20
[  269.235988]  rpm_callback+0x54/0x60
[  269.236607]  rpm_resume+0x503/0x700
[  269.237134]  ? __pm_runtime_idle+0x4c/0xe0
[  269.237822]  __pm_runtime_resume+0x45/0x70
[  269.238376] ufshcd_err_handler+0x112/0x9f0 [ufshcd_core]
[  269.238928]  ? __pm_runtime_resume+0x53/0x70
[  269.239392]  scsi_error_handler+0xa8/0x3a0
[  269.239832]  ? scsi_eh_get_sense+0x140/0x140
[  269.240266]  kthread+0x11f/0x140
[  269.240860]  ? set_kthread_struct+0x40/0x40
[  269.241275]  ret_from_fork+0x1f/0x30
# 
