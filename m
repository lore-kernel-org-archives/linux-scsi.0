Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C154C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A6360F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbhHQJR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47650 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5E33120022;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmUgTeGoK/w4qa27iV0FbkPd6fWcx/tup0fu7NnX8nk=;
        b=ZoDAEWJje4sAUp6218z7PpZxekw46K0bkrWFvKIzwVCj30K6Uf2xXcrDzNT1KBLexrolOv
        PmnqRtLFPIlK344AzPz0q8ztBD1t5MzsareRZKUJsNT6namXNZF3nB4qXfPc5EWsnJmCf8
        kdKU5hyOhXODd4K2Jie/+Bg1yoMUMo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmUgTeGoK/w4qa27iV0FbkPd6fWcx/tup0fu7NnX8nk=;
        b=RjNcUVbVFUlVdbvhapjX1buwX+qmJqURyRTOAcAw6hWaeu0luaL/A8sW3TvZvz29qBz+Ut
        wjt0v0GEqsgQ32Ag==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 58CF7A3BAC;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 55E7B518CE99; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 29/51] qla2xxx: use fc_block_rport()
Date:   Tue, 17 Aug 2021 11:14:34 +0200
Message-Id: <20210817091456.73342-30-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
will be removed as argument for SCSI EH functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b9cc7cfb5c21..0f2bf06a01d7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1390,9 +1390,11 @@ static char *reset_errors[] = {
 static int
 qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct scsi_device *sdev = cmd->device;
+	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
 	int err;
 
 	if (qla2x00_isp_reg_stat(ha)) {
@@ -1406,7 +1408,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	err = fc_block_scsi_eh(cmd);
+	err = fc_block_rport(rport);
 	if (err != 0)
 		return err;
 
@@ -1456,8 +1458,10 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 static int
 qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct scsi_device *sdev = cmd->device;
+	scsi_qla_host_t *vha = shost_priv(sdev->host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
 	struct qla_hw_data *ha = vha->hw;
 	int err;
 
@@ -1468,14 +1472,14 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
+	err = fc_block_rport(rport);
+	if (err != 0)
+		return err;
+
 	if (!fcport) {
 		return FAILED;
 	}
 
-	err = fc_block_scsi_eh(cmd);
-	if (err != 0)
-		return err;
-
 	if (fcport->deleted)
 		return SUCCESS;
 
-- 
2.29.2

