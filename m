Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D26FECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiJaWrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJaWrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:47:47 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E499215733
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:46 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id c24so12003799pls.9
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5K7L4ibRKPx9mBzDYLIMTolb/4bdgW8u1F5Fm8YTkU=;
        b=SvTnHp7bSSXMGd/3XT+cRlomRaZVoOMQrBPWjyyIUivgQzxsrcDsbkoQLUtqzFOhgX
         7gudlHzriEEqHclsRCE6YKYiEnzgDmrq3COfwrWG7xYVSMe16QSNq+Ec7TB8cSvRRGKG
         rgRHGt1JG0JD1DVZYASv7XeAgGEnDRkXiKuX0LPP6kRe7ZC1n5VnqgQ6MS+1MVhtm8EJ
         NHhRiopVzNGQd5YEaTAk/XJVjV/3++Wr3GUZDUTvwP3rORncN6BQ5dvTALlCI+z6uI4Z
         GgzHxCDBSFWUeGaWhHBj6gMfWdDFYkKAMk7972H51ez8loVy55d/S83w/bjg1/JKHOle
         YoNw==
X-Gm-Message-State: ACrzQf1vddXqnnniXW6Dy3Q9P9cJfAiHXzfOz0vjRkXp35BysgSP4aHp
        4gmB767tGKhejDP/xzrxrzw=
X-Google-Smtp-Source: AMsMyM77sWqY1Ki/eAGzzZrCiLng8sUOR9LhwjAIeMQAVhC/NjqQTTuatenvqaZwIDD1ipqmyt/iVA==
X-Received: by 2002:a17:902:a612:b0:17e:539:c415 with SMTP id u18-20020a170902a61200b0017e0539c415mr15863483plq.173.1667256466263;
        Mon, 31 Oct 2022 15:47:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id x6-20020a626306000000b00565c8634e55sm5096019pfb.135.2022.10.31.15.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:47:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 3/4] scsi: bfa: Convert bfad_reset_sdev_bflags() from a macro into a function
Date:   Mon, 31 Oct 2022 15:47:27 -0700
Message-Id: <20221031224728.2607760-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
In-Reply-To: <20221031224728.2607760-1-bvanassche@acm.org>
References: <20221031224728.2607760-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before modifying bfad_reset_sdev_bflags(), convert it from a macro into a
function.

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 27 +++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_im.h  | 26 --------------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index be8dfbe13e90..73754032e25c 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2540,6 +2540,33 @@ bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
+/*
+ * Set the SCSI device sdev_bflags - sdev_bflags are used by the
+ * SCSI mid-layer to choose LUN Scanning mode REPORT_LUNS vs. Sequential Scan
+ *
+ * Internally iterates over all the ITNIM's part of the im_port & sets the
+ * sdev_bflags for the scsi_device associated with LUN #0.
+ */
+static void bfad_reset_sdev_bflags(struct bfad_im_port_s *im_port,
+				   int lunmask_cfg)
+{
+	const u32 scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;
+	struct bfad_itnim_s *itnim;
+	struct scsi_device *sdev;
+
+	list_for_each_entry(itnim, &im_port->itnim_mapped_list, list_entry) {
+		sdev = scsi_device_lookup(im_port->shost, itnim->channel,
+					  itnim->scsi_tgt_id, 0);
+		if (sdev) {
+			if (lunmask_cfg == BFA_TRUE)
+				sdev->sdev_bflags |= scan_flags;
+			else
+				sdev->sdev_bflags &= ~scan_flags;
+			scsi_device_put(sdev);
+		}
+	}
+}
+
 /* Function to reset the LUN SCAN mode */
 static void
 bfad_iocmd_lunmask_reset_lunscan_mode(struct bfad_s *bfad, int lunmask_cfg)
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index c03b225ea1ba..4353feedf76a 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -198,30 +198,4 @@ irqreturn_t bfad_intx(int irq, void *dev_id);
 int bfad_im_bsg_request(struct bsg_job *job);
 int bfad_im_bsg_timeout(struct bsg_job *job);
 
-/*
- * Macro to set the SCSI device sdev_bflags - sdev_bflags are used by the
- * SCSI mid-layer to choose LUN Scanning mode REPORT_LUNS vs. Sequential Scan
- *
- * Internally iterate's over all the ITNIM's part of the im_port & set's the
- * sdev_bflags for the scsi_device associated with LUN #0.
- */
-#define bfad_reset_sdev_bflags(__im_port, __lunmask_cfg) do {		\
-	struct scsi_device *__sdev = NULL;				\
-	struct bfad_itnim_s *__itnim = NULL;				\
-	u32 scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;		\
-	list_for_each_entry(__itnim, &((__im_port)->itnim_mapped_list),	\
-			    list_entry) {				\
-		__sdev = scsi_device_lookup((__im_port)->shost,		\
-					    __itnim->channel,		\
-					    __itnim->scsi_tgt_id, 0);	\
-		if (__sdev) {						\
-			if ((__lunmask_cfg) == BFA_TRUE)		\
-				__sdev->sdev_bflags |= scan_flags;	\
-			else						\
-				__sdev->sdev_bflags &= ~scan_flags;	\
-			scsi_device_put(__sdev);			\
-		}							\
-	}								\
-} while (0)
-
 #endif
