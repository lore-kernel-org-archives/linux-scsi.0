Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEFDC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 19:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiI0TaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 15:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiI0TaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 15:30:14 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917D362ABC
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 12:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1664307013; x=1695843013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r9BWVKd8K3LtmUg8HyjZVYvQeK+ryfU9c5mcPQKOxxY=;
  b=wq8MBrNX6w7GuxVKb3Xgyz3a+h0mZl4jlspaAhE7ezqhNy7vg8nqfJj0
   d/bXdxGXmcE/RwHst/3JAWzQUvxcrDuzNzWpWThqUI/rcu2PBOtHDZo+p
   jhIMw0Q0ILOGshn/ouUS0IQBdmu8+01alViw62MLArUkbkF/qjcFCTxUp
   8=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 27 Sep 2022 12:30:13 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:30:13 -0700
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 27 Sep 2022 12:30:12 -0700
Date:   Tue, 27 Sep 2022 12:30:12 -0700
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: Re: [PATCH v2 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Message-ID: <20220927193012.GE15228@asutoshd-linux1.qualcomm.com>
References: <20220927184309.2223322-1-bvanassche@acm.org>
 <20220927184309.2223322-9-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20220927184309.2223322-9-bvanassche@acm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 27 2022 at 11:45 -0700, Bart Van Assche wrote:
>The following deadlock has been observed on multiple test setups:
>* ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
>  holds host_sem.
>* ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>  latter function tries to obtain host_sem.
>This is a deadlock because blk_execute_rq() can't execute SCSI commands
>while the host is in the SHOST_RECOVERY state and because the error
>handler cannot make progress either.
>
>Fix this deadlock as follows:
>* Fail attempts to suspend the system while the SCSI error handler is in
>  progress.
>* If the system is suspending and a START STOP UNIT command times out,
>  handle the SCSI command timeout from inside the context of the SCSI
>  timeout handler instead of activating the SCSI error handler.
>* Reduce the START STOP UNIT command timeout to one second since on
>  Android devices a kernel panic is triggered if an attempt to suspend
>  the system takes more than 20 seconds. One second should be enough for
>  the START STOP UNIT command since this command completes in less than
>  a millisecond for the UFS devices I have access to.
>
>The runtime power management code is not affected by this deadlock since
>hba->host_sem is not touched by the runtime power management functions
>in the UFS driver.
>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> drivers/ufs/core/ufshcd.c | 51 ++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 50 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>index 5507d93a4bba..010a5d1b984b 100644
>--- a/drivers/ufs/core/ufshcd.c
>+++ b/drivers/ufs/core/ufshcd.c
>@@ -8295,6 +8295,54 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
> 	}
> }
>
>+static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>+{
>+	struct ufs_hba *hba = shost_priv(scmd->device->host);
>+	bool reset_controller = false;
>+	int tag, ret;
>+
>+	if (!hba->system_suspending) {
>+		/* Activate the error handler in the SCSI core. */
>+		return SCSI_EH_NOT_HANDLED;
>+	}
>+
>+	/*
>+	 * Handle errors directly to prevent a deadlock between
>+	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
>+	 */
>+	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
>+		ret = ufshcd_try_to_abort_task(hba, tag);
>+		dev_info(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
>+			 hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
>+			 ret == 0 ? "succeeded" : "failed");
>+		if (ret != 0) {
>+			reset_controller = true;
>+			break;
>+		}
>+	}
>+	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
>+		ret = ufshcd_clear_tm_cmd(hba, tag);

If reset_controller is true, then the HC would be reset and it would
anyway clear up all resources. Would this be needed if reset_controller is true?

>
>+		dev_info(hba->dev, "Aborting TMF %d %s\n", tag,
>+			 ret == 0 ? "succeeded" : "failed");
>+		if (ret != 0) {
>+			reset_controller = true;
>+			break;
>+		}
>+	}
>+	if (reset_controller) {
>+		dev_info(hba->dev, "Resetting controller\n");
>+		ufshcd_reset_and_restore(hba);
>+		if (ufshcd_clear_cmds(hba, 0xffffffff))
ufshcd_reset_and_restore() would reset the host and the device.
So is the ufshcd_clear_cmds() needed after that?

>+			dev_err(hba->dev,
>+				"Clearing outstanding commands failed\n");
>+	}
>+	ufshcd_complete_requests(hba);
>+	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
>+		 __func__, hba->outstanding_tasks);
>+
>+	return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
