Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8DCC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 08:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4310523B02
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 08:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbhAJIst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 03:48:49 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62862 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbhAJIss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 03:48:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610268528; x=1641804528;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dKUH/8eT9WQR0MY/ea171yF0916vthqpVDusouW2ttM=;
  b=eKRBFnddKUzezpG/FoiWFML/wtyg+1QN2WAE07iV1dFtth07eq5Hz148
   LLUGnS/yyLV1HNoa+ngesAlpRJ7maQO5RuUn/9u2xGZeYFcCfmzuhio1i
   VE9DJQhwvzCwRkMpTjn42aWa2OaoACXiWT5jL4L49+5sWMjQHswsPlRba
   6Tnkosyi8woSYwzaS7UuqNcihS/7myVa9//Lara/WdX1AAbGCoEEeIpZn
   Y0q9iwSVWUVVwMBvQRQddcxVhZm58yhQ13Y1+iXBcGWZDkGUAJQ/fr15B
   dWxSkkhByTkTGQR/oYdnASwyR0dtGmvOGY2JcLSVVH+PYYqKNcckazn9V
   A==;
IronPort-SDR: M2wKaD1CsD/zAcUpiRB6mDelBGREH+a8duMEA75TRVPTh7HmrteIKO+ubevW2epTbbWSOlv/Q9
 0TByeSXuxaAV7LI72IV2SN5dTJu9tO6rF1KpCPRaB28S2FeCEcmr4BK1gK71PvcW+7oCwGu+So
 gpqGphV+ApjVA/z1wFOaw/2qTzLHHqhywuy8gSEJ0SXaku9OldSgmw3jJOCdou6YCeg5CnyGkd
 Ei0Fkq9Pe7Ce+9pWu7m/jK3aGvtURCy8a0jm56L/JK7rGkzcb3vB5Eb3U2XoOMPh7NUq7An36R
 cTY=
X-IronPort-AV: E=Sophos;i="5.79,336,1602518400"; 
   d="scan'208";a="157073250"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 16:47:42 +0800
IronPort-SDR: LfukvEU8b7Y6QTxisfAN4R6YzV/MjGf0v/E+3UV0O8Aa8ZbGKTcUQPtan5Y7QeAcsVBacdf7YC
 NPBxR+ezUs3TxMOAazEEJIKII5huzZhs/vH+CYD35N4sa0BGk+kn4xXZWDjnPryuEg9Fvy2nkT
 BOkRyqJRw6sm87I+h6oSLdefGZVjHZ4V3neQBFHoJvhb9DumHF0YhfOTpRv2R6R+w34t3+r/W7
 sX7mZxR8EaLHsCiTdz47rESiscxDp5LWA1YEkCO72xNPwJGZebtSzkli7TY5Iv7pzFhWzSjzxP
 43N+Bzds+ZwNceIkHdqbmm0+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2021 00:32:30 -0800
IronPort-SDR: aUZQyilq4s1FIoH7A4y9sJ/FCZrPEAnv0f5ZO/+X6EZwJu9tRIAXM0tyWL/LZX89zS9GR0Ni0j
 CEPVbcORn06k9gmdGEWLn1Bob21+LI9RgjUZokkk8ueuAISCBi7A6ZjQ5I8jPhXgHFzYwI7AuN
 ZAteFu/+qrcY4i5zM7lR/ExrXsqh2JOqfAYSuQc8EkfXKegAMjH9o3t3Fnb/KFY0DhOchEy+wk
 llLpw8PFoBMC5K2CokpNfp7Hp4wm8wpr/bSLXLTbcq8Szg3KZySopHGcoGRUlIPdi+i1UqSMBP
 9og=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Jan 2021 00:47:41 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: A tad optimization in query upiu trace
Date:   Sun, 10 Jan 2021 10:46:18 +0200
Message-Id: <20210110084618.189371-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove a redundant if clause in ufshcd_add_query_upiu_trace.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 53fd59ce50b2..678a520b303e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -316,19 +316,13 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 			  UFS_TSF_CDB);
 }
 
-static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
-					enum ufs_trace_str_t str_t)
+static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
+					enum ufs_trace_str_t str_t,
+					struct utp_upiu_req *rq_rsp)
 {
-	struct utp_upiu_req *rq_rsp;
-
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	if (str_t == UFS_QUERY_SEND)
-		rq_rsp = hba->lrb[tag].ucd_req_ptr;
-	else
-		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
-
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq_rsp->header,
 			  &rq_rsp->qr, UFS_TSF_OSF);
 }
@@ -2876,7 +2870,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
-	ufshcd_add_query_upiu_trace(hba, tag, UFS_QUERY_SEND);
+	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -2886,8 +2880,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
 
 out:
-	ufshcd_add_query_upiu_trace(hba, tag,
-			err ? UFS_QUERY_ERR : UFS_QUERY_COMP);
+	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
+				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out_put_tag:
 	blk_put_request(req);
-- 
2.25.1

