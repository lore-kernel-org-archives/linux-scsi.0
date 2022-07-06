Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485F9C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiGFXfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbiGFXfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:34 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6322C675;
        Wed,  6 Jul 2022 16:35:33 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CEB7540C87;
        Wed,  6 Jul 2022 23:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150533; bh=aToiGLA9O7oYZ4jAsz46TfZTlCnEY70cMNLIBmiDQgA=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=E5cjqX8UL3onxIFt07rTN6/7QonYsCpA62Umb8tu6WXXEeyB11QP5UWtj6MFJFBvZ
         Us8yPKh9Wxu/IB7t/cFLthvfC3FIUrcK+AVDe2BnC85j10NKPzMgb47xPX/tBX+VBT
         JSCg29y9dc7OVPwCWdfe6bQw7TxP4cjajHGLJ+tPsFyWuLKw5TJKffiL4qeiSg50Ve
         SjrfnQcuFhR8jRtZWT5yE82Meh9kXZcFd63v02k9xykoZJuaPyFBAjWVZE5J0hah+Z
         WkDVzgb+rwY+exbkN6m8Mhf3s3xMjuVUA0cEL2fRecm5hloSd57bRnGO8CiA6gktfF
         K1t9pZW5ToB+g==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id AC05EA006F;
        Wed,  6 Jul 2022 23:35:32 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:32 -0700
Date:   Wed, 06 Jul 2022 16:35:32 -0700
Message-Id: <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 11/36] target: Properly set Sense Data Length of CHECK CONDITION
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CHECK CONDITION returns sense data, and sense data is minimum 8 bytes
long plus additional sense data length in the data buffer. Don't just
set the allocated buffer length to the cmd->scsi_sense_length and check
the sense data for that.

See SPC4-r37 section 4.5.2.1.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bc1e4a7c4538..9734952a6228 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3459,12 +3459,20 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 
 	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
-	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
+
+	/*
+	 * CHECK CONDITION returns sense data, and sense data is minimum 8
+	 * bytes long. See SPC4-r37 section 4.5.2.1.
+	 */
+	cmd->scsi_sense_length = 8;
+
 	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
 	if (sd->add_sense_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
 							cmd->sense_info) < 0);
+	/* Additional sense data length */
+	cmd->scsi_sense_length += buffer[7];
 }
 
 int
-- 
2.28.0

