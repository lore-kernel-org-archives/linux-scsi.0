Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C993E95A9E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377124AbjJIQFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377115AbjJIQFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0CA9F
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c8903a45ccso3057355ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867541; x=1697472341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ba0Cf2+NLE11PutzUzWqa0sMY6wnPnQD7etJtbPA/Iw=;
        b=k1Xc4tyMPvnkN1VyyF2cLZu3ew1RZqpOykKUUfjQ9UBc3GiLPcVKrPl2SOGWp8y2EE
         jZeu3kHNYLRa++QTZevyg3YPuF1xJyp6yvJCLu/mLbLrq5dnODlpYfA+Ivi94KirOO9I
         oC8992Vn6qroklg+bTOPlzSYNGI7+U5iPHWn6mStcp0czm31CYy7/DDnWoVmqazP+IaD
         +0/x6LmdvXRmjQJzW2Undjj6lrNtABAkC2oaUnxP3JdoU1UyJ6CUvYxpHiMAkktF7BEj
         2GSinfJsDpN+2hG3xPqXHImEM7Nji7riJ0cfMCsYMpI0iZ77v8U/O7zCYq4a9sDcxCj2
         ge0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867541; x=1697472341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ba0Cf2+NLE11PutzUzWqa0sMY6wnPnQD7etJtbPA/Iw=;
        b=GQ7ONB2oP7qMthDx28ho3ASKF/Zoq1ecqNnCXZg7uR+hHp1IV6Wtsoi7FarNOouwZf
         flriswVxZY1Ffmxf5DocT9++5hT0E5yWltX2UqwRqlL6CDEih1RwS3QBvaovDhNayH8j
         k+k2AyfSoobxYRcRoI1LT9Gr597NySuoC6S2i7RkeP2JuSBefp1bG3Wb14es+pUD4pop
         OifaHvZ33inrsk+5eVQMamKhjLAnoFJ8WhyY+bg4nHvFl/q+MT1cOZh++SWNyaqh9pjg
         iQCO/TatTq4jLp9xZ9Mi8Q58ICSgTTrDhZo2zE8hdWR/gFm/aTfXdNVdZz9/0sGPCkVa
         QevA==
X-Gm-Message-State: AOJu0YxsYrzgbW3w+IYdoZ9TRkATnC+9jRqA/Fhb/1jmZL8HlIDtyjKv
        4KccXGhvI9jEyKj/3zM7l12TNjXBImI=
X-Google-Smtp-Source: AGHT+IEr6fVRqkoUi30ojuVF/fzcyRkKYIf9g/0ip/caOKLFI5lw4MjxRVU01ZjpBWwcHkB6HxsNQw==
X-Received: by 2002:a17:902:e74b:b0:1c7:1eed:10f2 with SMTP id p11-20020a170902e74b00b001c71eed10f2mr18083549plf.2.1696867541620;
        Mon, 09 Oct 2023 09:05:41 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:41 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/6] lpfc: Introduce LOG_NODE_VERBOSE messaging flag
Date:   Mon,  9 Oct 2023 09:18:11 -0700
Message-Id: <20231009161812.97232-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The preexisting LOG_NODE message flag frequently spams a subset of the same
log messages during normal FC driver operations.  When analyzing driver
logs, this sometimes leads to difficulty in troubleshooting.

Because LOG_IP log message flag is unused, convert it to a new
LOG_NODE_VERBOSE flag.  The LOG_NODE_VERBOSE shall specifically be used for
diagnosing issues that require precise ndlp tracking detail.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 ++++----
 drivers/scsi/lpfc/lpfc_logmsg.h  | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 5154eeaee0ec..7ef9841f0728 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5654,7 +5654,7 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 				 ((uint32_t)ndlp->nlp_xri << 16) |
 				 ((uint32_t)ndlp->nlp_type << 8)
 				 );
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE_VERBOSE,
 					 "0929 FIND node DID "
 					 "Data: x%px x%x x%x x%x x%x x%px\n",
 					 ndlp, ndlp->nlp_DID,
@@ -5701,8 +5701,8 @@ lpfc_findnode_mapped(struct lpfc_vport *vport)
 				 ((uint32_t)ndlp->nlp_type << 8) |
 				 ((uint32_t)ndlp->nlp_rpi & 0xff));
 			spin_unlock_irqrestore(shost->host_lock, iflags);
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-					 "2025 FIND node DID "
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE_VERBOSE,
+					 "2025 FIND node DID MAPPED "
 					 "Data: x%px x%x x%x x%x x%px\n",
 					 ndlp, ndlp->nlp_DID,
 					 ndlp->nlp_flag, data1,
@@ -6468,7 +6468,7 @@ __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (filter(ndlp, param)) {
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE_VERBOSE,
 					 "3185 FIND node filter %ps DID "
 					 "ndlp x%px did x%x flg x%x st x%x "
 					 "xri x%x type x%x rpi x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index f896ec610433..59bd2bafc73f 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -25,7 +25,7 @@
 #define LOG_MBOX	0x00000004	/* Mailbox events */
 #define LOG_INIT	0x00000008	/* Initialization events */
 #define LOG_LINK_EVENT	0x00000010	/* Link events */
-#define LOG_IP		0x00000020	/* IP traffic history */
+#define LOG_NODE_VERBOSE 0x00000020	/* Node verbose events */
 #define LOG_FCP		0x00000040	/* FCP traffic history */
 #define LOG_NODE	0x00000080	/* Node table events */
 #define LOG_TEMP	0x00000100	/* Temperature sensor events */
-- 
2.38.0

