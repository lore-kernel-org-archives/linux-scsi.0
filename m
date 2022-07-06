Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57971C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbiGFXf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiGFXfW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:22 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F12CC85;
        Wed,  6 Jul 2022 16:35:22 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B06BFC06E7;
        Wed,  6 Jul 2022 23:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150521; bh=q878+lWPBGSxxokg46YfF8UDwB3RmWNiMqYhoPO3WVw=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=TAHBkuf0ERT0AJ5voU2S9W450+/0+kWfwcaxW0bVLmiE+ubuDPTi1rcOKMdAUrt0a
         HdpZXUZKYjBLSc2cCoJoDLKdrrkmNnJOu2lp7nJXqEiYvWZG6huUgjZSrX9a9Y61kg
         PaQyXfqGgh3Q0XJtnloxCVPS0mQ7hAAyx+Lg1ODm8kIdagZbig0kyNI+2QlPxzYyv5
         z8f3JS3uhk8oyOZP0aYormwk7kiJipCFhUsiJ3JR/ynRUrEK+K8VMyI45jqjOPPGqm
         On8aJKPbuF1HXRHPhqV1ByhOhEp9SIKB2TdYbZXT5OFZKsNM2Ch0pqcLkp5phNlIjA
         PPMiIHVfGOFVQ==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 74ADBA0096;
        Wed,  6 Jul 2022 23:35:20 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:20 -0700
Date:   Wed, 06 Jul 2022 16:35:20 -0700
Message-Id: <d89b41eb3be83be3ef532209245caca356a8db49.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 09/36] target: Add common Task Management values
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

Add some standard TMR and match their code id based on UAS-r04 and
SPL4-r13. Note that the non-standard TMR_LUN_RESET_PRO is using the same
id value of QUERY TASK. Change it to 0xf0 instead.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_transport.c | 10 ++++++++++
 include/target/target_core_base.h      |  8 ++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 105d3b0e470f..cbd876e44cf0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3090,6 +3090,10 @@ static const char *target_tmf_name(enum tcm_tmreq_table tmf)
 	case TMR_TARGET_WARM_RESET:	return "TARGET_WARM_RESET";
 	case TMR_TARGET_COLD_RESET:	return "TARGET_COLD_RESET";
 	case TMR_LUN_RESET_PRO:		return "LUN_RESET_PRO";
+	case TMR_I_T_NEXUS_RESET:	return "I_T_NEXUS_RESET";
+	case TMR_QUERY_TASK:		return "QUERY_TASK";
+	case TMR_QUERY_TASK_SET:	return "QUERY_TASK_SET";
+	case TMR_QUERY_ASYNC_EVENT:	return "QUERY_ASYNC_EVENT";
 	case TMR_UNKNOWN:		break;
 	}
 	return "(?)";
@@ -3538,6 +3542,12 @@ static void target_tmr_work(struct work_struct *work)
 	case TMR_TARGET_COLD_RESET:
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
+	case TMR_I_T_NEXUS_RESET:
+	case TMR_QUERY_TASK:
+	case TMR_QUERY_TASK_SET:
+	case TMR_QUERY_ASYNC_EVENT:
+		tmr->response = TMR_FUNCTION_REJECTED;
+		break;
 	default:
 		pr_err("Unknown TMR function: 0x%02x.\n",
 				tmr->function);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8e3da143a1ce..ccd98604eaf4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -206,12 +206,16 @@ enum target_sc_flags_table {
 enum tcm_tmreq_table {
 	TMR_ABORT_TASK		= 1,
 	TMR_ABORT_TASK_SET	= 2,
-	TMR_CLEAR_ACA		= 3,
+	TMR_CLEAR_ACA		= 0x40,
 	TMR_CLEAR_TASK_SET	= 4,
 	TMR_LUN_RESET		= 5,
 	TMR_TARGET_WARM_RESET	= 6,
 	TMR_TARGET_COLD_RESET	= 7,
-	TMR_LUN_RESET_PRO	= 0x80,
+	TMR_I_T_NEXUS_RESET	= 0x10,
+	TMR_QUERY_TASK		= 0x80,
+	TMR_QUERY_TASK_SET	= 0x81,
+	TMR_QUERY_ASYNC_EVENT	= 0x82,
+	TMR_LUN_RESET_PRO	= 0xf0,
 	TMR_UNKNOWN		= 0xff,
 };
 
-- 
2.28.0

