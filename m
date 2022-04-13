Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4E9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 02:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiDMCmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 22:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiDMCma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 22:42:30 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC1226E
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 19:40:09 -0700 (PDT)
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220413024006epoutp04e5d217ae336d1d3b42a25d7be1720099~lVF8-JbLj3220932209epoutp04E
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 02:40:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220413024006epoutp04e5d217ae336d1d3b42a25d7be1720099~lVF8-JbLj3220932209epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649817606;
        bh=tMpxUbraKrROWkWuKujaur0cwvXfNfvWCCLh7nfpjLM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=MeMA121TebZrq/t1U+3s7XKrNi7wLxm1joh43jFXepKzZmfh9N7ORzliWV5/3yErc
         nrz+qdQpN9+cA6S7/qXJCZc/JpzwRB5xMzoPJ3Nad3+sSFdZEoDVpQO9ykIhSE+sMC
         BglLWaVdy+yQzgq3AOoWCD79Lmb2/jivTxMQFq1I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20220413024005epcas3p4db9ee846f35c17e05e0fd1ace06c1c27~lVF8Vwe7q0333803338epcas3p4P;
        Wed, 13 Apr 2022 02:40:05 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4KdRdd5vnNz4x9Q6; Wed, 13 Apr 2022 02:40:05 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v2 04/29] scsi: ufs: Simplify statements that return a
 boolean
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220412181853.3715080-5-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1889248251.21649817605815.JavaMail.epsvc@epcpadp3>
Date:   Wed, 13 Apr 2022 11:33:24 +0900
X-CMS-MailID: 20220413023324epcms2p4da7855b6ec30f4f8090b0aa0c8d67adc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220412181947epcas2p18ab1ae9013aeb1f261fb46cb60881263
References: <20220412181853.3715080-5-bvanassche@acm.org>
        <20220412181853.3715080-1-bvanassche@acm.org>
        <CGME20220412181947epcas2p18ab1ae9013aeb1f261fb46cb60881263@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Convert "if (expr) return true; else return false;" into "return expr;"
>if either 'expr' is a boolean expression or the return type of the
>function is 'bool'.

How about adding ufshcd_is_pwr_mode_restore_needed()?

Best Regards,
Keoseong Park

>
>Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> drivers/scsi/ufs/ufs-qcom.h |  5 +----
> drivers/scsi/ufs/ufshcd.c   | 22 +++++-----------------
> drivers/scsi/ufs/ufshpb.c   |  8 ++------
> 3 files changed, 8 insertions(+), 27 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
>index 8208e3a3ef59..51570224a6e2 100644
>--- a/drivers/scsi/ufs/ufs-qcom.h
>+++ b/drivers/scsi/ufs/ufs-qcom.h
>@@ -239,10 +239,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host);
> 
> static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)
> {
>-	if (host->caps & UFS_QCOM_CAP_QUNIPRO)
>-		return true;
>-	else
>-		return false;
>+	return host->caps & UFS_QCOM_CAP_QUNIPRO;
> }
> 
> /* ufs-qcom-ice.c */
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 983fac14b7cd..c60519372b3b 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -939,10 +939,7 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
> 	 * logic simple, we will only do manual tuning if local unipro version
> 	 * doesn't support ver1.6 or later.
> 	 */
>-	if (ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6)
>-		return true;
>-	else
>-		return false;
>+	return ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6;
> }
> 
> /**
>@@ -2216,10 +2213,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>  */
> static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
> {
>-	if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY)
>-		return true;
>-	else
>-		return false;
>+	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY;
> }
> 
> /**
>@@ -5781,10 +5775,7 @@ static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
> 		return false;
> 	}
> 	/* Let it continue to flush when available buffer exceeds threshold */
>-	if (avail_buf < hba->vps->wb_flush_threshold)
>-		return true;
>-
>-	return false;
>+	return avail_buf < hba->vps->wb_flush_threshold;
> }
> 
> static void ufshcd_wb_force_disable(struct ufs_hba *hba)
>@@ -5863,11 +5854,8 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
> 		return false;
> 	}
> 
>-	if (!hba->dev_info.b_presrv_uspc_en) {
>-		if (avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10))
>-			return true;
>-		return false;
>-	}
>+	if (!hba->dev_info.b_presrv_uspc_en)
>+		return avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10);
> 
> 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
> }
>diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>index b2bec19022cd..ebd8fc8fc109 100644
>--- a/drivers/scsi/ufs/ufshpb.c
>+++ b/drivers/scsi/ufs/ufshpb.c
>@@ -90,12 +90,8 @@ static bool ufshpb_is_general_lun(int lun)
> 
> static bool ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
> {
>-	if (hpb->lu_pinned_end != PINNED_NOT_SET &&
>-	    rgn_idx >= hpb->lu_pinned_start &&
>-	    rgn_idx <= hpb->lu_pinned_end)
>-		return true;
>-
>-	return false;
>+	return hpb->lu_pinned_end != PINNED_NOT_SET &&
>+	       rgn_idx >= hpb->lu_pinned_start && rgn_idx <= hpb->lu_pinned_end;
> }
> 
> static void ufshpb_kick_map_work(struct ufshpb_lu *hpb)
>
