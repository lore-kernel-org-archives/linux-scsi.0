Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99C6C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiGFXfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiGFXfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:40 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8E62C67E;
        Wed,  6 Jul 2022 16:35:40 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 12B24C06E7;
        Wed,  6 Jul 2022 23:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150540; bh=m9ECj4YTF1Q8AeFPvov7DBXyw0CywQmT4c9/1eSyfPM=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=e8r1PmY0MUmGdoZlHd8GGIj5cHz9FhCnWAZzZj3t8SWu6G+HnC3pFCI1qRhxUDAJF
         ryORhQOB02bDTyVS0K6wGMOkO7RR7Lwv97nJVG/BXPjQeJa/TkEdkAHS2WQo5HAQGN
         Xa2tTnlYDt6p+rSHZI9j4uCcHze+9JdZtUGvX8SdPUu6QdgwRhsal52SK+sY0nFLXp
         0xP32CoC4GThsIAl+bEiJSRQFMJUm5dQOAElhUuySvKoR1sPbz1RbWz+9YcKGxeaIg
         k5Y9tYJ2oGD54XDA0Qjed2qfbfhro9eP6EL8BHYB7Q+F0u/5rA0RSvXanaC4oBlvdg
         dv6DdgJwJSRcw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id CB6B4A006F;
        Wed,  6 Jul 2022 23:35:38 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:38 -0700
Date:   Wed, 06 Jul 2022 16:35:38 -0700
Message-Id: <9cb2ee13f6edbcfd9b719e4b4b53f7cec0080d3b.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 12/36] target: Properly set Sense data length when copy sense
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

The transport_get_sense_buffer() sets sense data length to be the
allocated sense buffer length TRANSPORT_SENSE_BUFFER. However, the sense
data length is depending on the sense data description. Check the sense
data for cmd->scsi_sense_length.

See SPC4-R37 section 4.5.2.1.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_transport.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9734952a6228..2fc4ba1814c6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -771,8 +771,6 @@ static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION)
 		return NULL;
 
-	cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
-
 	pr_debug("HBA_[%u]_PLUG[%s]: Requesting sense for SAM STATUS: 0x%02x\n",
 		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
 	return cmd->sense_buffer;
@@ -791,7 +789,12 @@ void transport_copy_sense_to_cmd(struct se_cmd *cmd, unsigned char *sense)
 	}
 
 	cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
-	memcpy(cmd_sense_buf, sense, cmd->scsi_sense_length);
+	memcpy(cmd_sense_buf, sense, TRANSPORT_SENSE_BUFFER);
+
+	/* Sense data length = min sense data + additional sense data length */
+	cmd->scsi_sense_length = min_t(int, 8 + cmd_sense_buf[7],
+				       TRANSPORT_SENSE_BUFFER);
+
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 EXPORT_SYMBOL(transport_copy_sense_to_cmd);
-- 
2.28.0

