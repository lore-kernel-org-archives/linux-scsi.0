Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E262C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D61020715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jT60lnrW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgGFMj4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:39:55 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6E2C061794;
        Mon,  6 Jul 2020 05:39:55 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e15so34696387edr.2;
        Mon, 06 Jul 2020 05:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NTlfd07fqo6vbcLIkW9eOz07H1uYGq6Yd8TcAIKMezk=;
        b=jT60lnrWqEs+enEym1/52DmnK/Rv8ejhL51zZlrHoWv72f/rplS+thUb5UzeuPe7p1
         Q0mCp5xzimOTWR3dap9kc0eH2Tn39RK9iaaNCDUa4sjCgNSXtn3SRbUKCBP8MKdAlM29
         PUGmF2n2xmSai7dYg+ypxAHHzkXrMP1sKlf++4AxPVgXbSbPUOLJydmMIHoCzM4tUfrg
         nj9PEUl7Ge5wbfGzTouF7LDyHCp9qgmCxESG0bM/ZLdFik18wh3eS+XXv+6Ue+KrZK5O
         tOTusnvKnBhlmEY7Qy/XDazQs8ju7CfltGJiKhP0NxcnQgKbfu+7+TXZQSy2nvRNOQVt
         dufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NTlfd07fqo6vbcLIkW9eOz07H1uYGq6Yd8TcAIKMezk=;
        b=dTCrGpsHiSt9On2/uhbnuD/sxR9R21gyCOcqVy7MPK4d7S/+4M6Npumj72AQpIaiER
         SlFTPF86YUQOHlHqFRfFrcW8e0UGjIqbZ1csBGJ2lsN+yB/fmAC/RgQUAXLf3+fUZv2S
         DaDteWS+8T85S4DnWLLhGqbP5hHZfEzTmTBmyNh69TmBcVHWQOeArK5UzvH5/HZ5M1iN
         kgY1syxK+2YtocY4RTBlLFe7gvcUXl0ET+gPiEoLhPNBCjMmBVzWSjslM5j9ZryZbUxo
         WHKHG/6z2RcI0wh5O0sgYZx54H7nFZDFYzUQr/8oNnfOFd0+HdRJaEuMUaAlPpthAJtE
         +Eig==
X-Gm-Message-State: AOAM531sW8GhYCWd+WJaYiNcUnfy9NIalSUyoo0VLxX3P+W3c8xSU81u
        op4xye9k94Z5oGun8eBUvJs=
X-Google-Smtp-Source: ABdhPJwhC+LZRRcmLZlHXGO3pfrhBXsF36KDAaHBxKBYcYr3PhC8Ndk7bFDM3/uGasU2nRYbjk14aw==
X-Received: by 2002:aa7:d802:: with SMTP id v2mr47963009edq.77.1594039193976;
        Mon, 06 Jul 2020 05:39:53 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id bq8sm12968578ejb.103.2020.07.06.05.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 05:39:53 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: change upiu_flags to be u8
Date:   Mon,  6 Jul 2020 14:39:36 +0200
Message-Id: <20200706123936.24799-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

According to the UFS Spec, the Flags in the UPIU is one-byte length, not
4 bytes. change it to be u8.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 96d830bb900f..d7fd5891e81f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2240,7 +2240,7 @@ static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
  * @cmd_dir: requests data direction
  */
 static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
-			u32 *upiu_flags, enum dma_data_direction cmd_dir)
+			u8 *upiu_flags, enum dma_data_direction cmd_dir)
 {
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
 	u32 data_direction;
@@ -2286,7 +2286,7 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
  * @upiu_flags: flags
  */
 static
-void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
+void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 {
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
@@ -2319,7 +2319,7 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
  * @upiu_flags: flags
  */
 static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
-				struct ufshcd_lrb *lrbp, u32 upiu_flags)
+				struct ufshcd_lrb *lrbp, u8 upiu_flags)
 {
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	struct ufs_query *query = &hba->dev_cmd.query;
@@ -2376,7 +2376,7 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
 				      struct ufshcd_lrb *lrbp)
 {
-	u32 upiu_flags;
+	u8 upiu_flags;
 	int ret = 0;
 
 	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
@@ -2404,7 +2404,7 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
  */
 static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	u32 upiu_flags;
+	u8 upiu_flags;
 	int ret = 0;
 
 	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
@@ -6124,7 +6124,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	int tag;
 	struct completion wait;
 	unsigned long flags;
-	u32 upiu_flags;
+	u8 upiu_flags;
 
 	down_read(&hba->clk_scaling_lock);
 
-- 
2.17.1

