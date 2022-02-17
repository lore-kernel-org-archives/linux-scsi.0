Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A45C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 16:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbiBQQEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 11:04:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiBQQE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 11:04:29 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D9029C123
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 08:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645113855; x=1676649855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5PnPblB2dEcdUQGZACQ1ce9/vgFw8Z/19p4VslBiQf4=;
  b=F7tY5qa2XNHdfrzWG7V1jNFE+J1zUEK9NV2x5q4fOuOxYHRspoBnvkn9
   PY2xbg3qD5yc1omD7TI6hysliQhDCKVOXwcH6MIHBwsjuVMlizLOqphoA
   6Yt2j/zR9Eni9SMToQR8d02LCTrSCu4ms7C88K4vGZKKI+Ey3hAejepwg
   c=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 17 Feb 2022 08:04:14 -0800
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 08:04:13 -0800
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 17 Feb 2022 08:04:13 -0800
Date:   Thu, 17 Feb 2022 08:04:13 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V3] scsi: ufs: Fix runtime PM messages never-ending cycle
Message-ID: <20220217160413.GA3214@asutoshd-linux1.qualcomm.com>
References: <20220216075122.370532-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20220216075122.370532-1-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 16 2022 at 23:53 -0800, Adrian Hunter wrote:
>Kernel messages produced during runtime PM can cause a never-ending
>cycle because user space utilities (e.g. journald or rsyslog) write the
>messages back to storage, causing runtime resume, more messages, and so
>on.
>
>Messages that tell of things that are expected to happen, are arguably
>unnecessary, so suppress them.
>
>UFS driver messages are changes to from dev_err() to dev_dbg() which means
>they will not display unless activated by dynamic debug of building
>with -DDEBUG.
>
>sd_suspend_common() messages are removed.
>
>scsi_report_sense() "Power-on or device reset occurred" message is
>suppressed only for UFS.  Note, that message appears when the LUN is
>accessed after runtime PM, not during runtime PM.
>
> Example messages from Ubuntu 21.10:
>
> $ dmesg | tail
> [ 1620.380071] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [ 1620.408825] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
> [ 1620.409020] ufshcd 0000:00:12.5: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
> [ 1620.409524] sd 0:0:0:0: Power-on or device reset occurred
> [ 1622.938794] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 1622.939184] ufs_device_wlun 0:0:0:49488: Power-on or device reset occurred
> [ 1625.183175] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [ 1625.208041] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
> [ 1625.208311] ufshcd 0000:00:12.5: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
> [ 1625.209035] sd 0:0:0:0: Power-on or device reset occurred
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>---
>
Reviewed-by: Asutosh Das <quic_asutoshd@quicinc.com>

>
>Changes in V3:
>
>	Keep reset sense message for non-UFS devices
>
>Changes in V2:
>
>	Remove offending SCSI messages
>	Use dev_dbg for offending UFSHCD messages
>
>
> drivers/scsi/scsi_error.c  |  9 +++++++--
> drivers/scsi/sd.c          |  7 +++++--
> drivers/scsi/ufs/ufshcd.c  | 21 +++++++++++++++++++--
> include/scsi/scsi_device.h |  1 +
> 4 files changed, 32 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>index 60a6ae9d1219..c944600f7931 100644
>--- a/drivers/scsi/scsi_error.c
>+++ b/drivers/scsi/scsi_error.c
>@@ -484,8 +484,13 @@ static void scsi_report_sense(struct scsi_device *sdev,
>
> 		if (sshdr->asc == 0x29) {
> 			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
>-			sdev_printk(KERN_WARNING, sdev,
>-				    "Power-on or device reset occurred\n");
>+			/*
>+			 * Do not print message if it is an expected side-effect
>+			 * of runtime PM.
>+			 */
>+			if (!sdev->no_rst_sense_msg)
>+				sdev_printk(KERN_WARNING, sdev,
>+					    "Power-on or device reset occurred\n");
> 		}
>
> 		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
>diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>index 62eb9921cc94..18cdf5f9415a 100644
>--- a/drivers/scsi/sd.c
>+++ b/drivers/scsi/sd.c
>@@ -3742,6 +3742,11 @@ static void sd_shutdown(struct device *dev)
> 	}
> }
>
>+/*
>+ * Do not print messages during runtime PM to avoid never-ending cycles of
>+ * messages written back to storage by user space causing runtime resume,
>+ * causing more messages and so on.
>+ */
> static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> {
> 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>@@ -3752,7 +3757,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> 		return 0;
>
> 	if (sdkp->WCE && sdkp->media_present) {
>-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> 		ret = sd_sync_cache(sdkp, &sshdr);
>
> 		if (ret) {
>@@ -3774,7 +3778,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> 	}
>
> 	if (sdkp->device->manage_start_stop) {
>-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> 		/* an error is not worth aborting a system sleep */
> 		ret = sd_start_stop_device(sdkp, 0);
> 		if (ignore_stop_errors)
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 50b12d60dc1b..294e55955a76 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -585,7 +585,12 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hba)
> 		"INVALID MODE",
> 	};
>
>-	dev_err(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
>+	/*
>+	 * Using dev_dbg to avoid messages during runtime PM to avoid
>+	 * never-ending cycles of messages written back to storage by user space
>+	 * causing runtime resume, causing more messages and so on.
>+	 */
>+	dev_dbg(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
> 		 __func__,
> 		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
> 		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
>@@ -5024,6 +5029,12 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
> 		pm_runtime_get_noresume(&sdev->sdev_gendev);
> 	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
> 		sdev->rpm_autosuspend = 1;
>+	/*
>+	 * Do not print messages during runtime PM to avoid never-ending cycles
>+	 * of messages written back to storage by user space causing runtime
>+	 * resume, causing more messages and so on.
>+	 */
>+	sdev->no_rst_sense_msg = 1;
>
> 	ufshcd_crypto_register(hba, q);
>
>@@ -7339,7 +7350,13 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
>
> 	if (!hba->vreg_info.vcc || !hba->vreg_info.vccq ||
> 						!hba->vreg_info.vccq2) {
>-		dev_err(hba->dev,
>+		/*
>+		 * Using dev_dbg to avoid messages during runtime PM to avoid
>+		 * never-ending cycles of messages written back to storage by
>+		 * user space causing runtime resume, causing more messages and
>+		 * so on.
>+		 */
>+		dev_dbg(hba->dev,
> 			"%s: Regulator capability was not set, actvIccLevel=%d",
> 							__func__, icc_level);
> 		goto out;
>diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>index 647c53b26105..785dbf6e3e24 100644
>--- a/include/scsi/scsi_device.h
>+++ b/include/scsi/scsi_device.h
>@@ -206,6 +206,7 @@ struct scsi_device {
> 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
> 					 * creation time */
> 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
>+	unsigned no_rst_sense_msg:1;	/* Do not print reset sense message */
>
> 	unsigned int queue_stopped;	/* request queue is quiesced */
> 	bool offline_already;		/* Device offline message logged */
>-- 
>2.25.1
>
