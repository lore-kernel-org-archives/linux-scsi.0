Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E8BC388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D806206F8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bOlVl7aq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgKBOYl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgKBOY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:27 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB345C0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:26 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id g12so14801602wrp.10
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DRufDNzm9kpYb+RMx6EOR5JDO8dhM8oippZOTHhZhUw=;
        b=bOlVl7aqbhqa2uIFx/thpl7k5ga9JikzHLncZ7w45NvZKsvPhvYm3EGaddLi6x1zWw
         lLXtkcsb222aCe2jDePmwDN0hM6tQ38rZY8R9idyWM4z5awdnpjPu164hyUMp06yVnpg
         nG7lDMuDos7/QzOLUUF34PVnlkbonu5HPiPPrY+VrSU5BTozEwLxWKBV4L/TPzy161XZ
         T0dt1s/ZeAMkZXMkpve16q81k1DL3fensL5lel212l898g860SpfUlgXOK5Zyqp5bE06
         kn7vN9zXp5cdO706ZCppB2IKIOtwqPFEW3IgAkH/LtEIV/oWMY7ydYcFVjZHvWQXezc8
         LofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DRufDNzm9kpYb+RMx6EOR5JDO8dhM8oippZOTHhZhUw=;
        b=YnWJxIJpQbOS9JL8e2Mp9eIR51nWCwGuDeBjMxEqvG7uQqpClncGm5uwUCRE97+2zm
         HoW0HR2cCxyxnQwhliUbBjfFKa28tbL1H+d1U6/UAGLunRZaOtiusZajg+OgFRaDDTvX
         hjmHzPCWGi3ZLNGyUlyPHSp3nvFfOOtE5FwCV3vZPIyN1MY0Ke2R6/EHIKkhgb8sCU0J
         CzQkAgxMVSjMM1T8z3tZo9TrGqb5UWBl0Q2zFNIodw0N+SJz0nJHeOYXzlnjaCNvRMVh
         wE5P7jwk+yjtJasm9pqvgFzCwJicdbSIX4/GXumkYjy7N8Ld/46/ZqKv9CTHF0s6LMbN
         cMpg==
X-Gm-Message-State: AOAM530U81gUz024NgELinVBkgeZrKM+Gf76rQMqzkzkkCb5Tp0l+qVh
        ABLC8A1OWpQQ+g9X/md6ljeoAQ==
X-Google-Smtp-Source: ABdhPJx06+cWC3E2SeDJYJR0wnU20P2bEhF/IKREhO/rDa5k/Z5idx3DYjmRWtLvOlCITS9+oeyiCQ==
X-Received: by 2002:adf:ce91:: with SMTP id r17mr21408494wrn.326.1604327065586;
        Mon, 02 Nov 2020 06:24:25 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:24 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "C.L. Huang" <ching@tekram.com.tw>,
        Erich Chen <erich@tekram.com.tw>,
        Kurt Garloff <garloff@suse.de>, dc395x@twibble.org
Subject: [RESEND 17/19] scsi: dc395x: Remove a few unused variables
Date:   Mon,  2 Nov 2020 14:23:57 +0000
Message-Id: <20201102142359.561122-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/dc395x.c: In function ‘data_io_transfer’:
 drivers/scsi/dc395x.c:2400:16: warning: variable ‘data2’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/dc395x.c:2400:6: warning: variable ‘data’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/dc395x.c: In function ‘reselect’:
 drivers/scsi/dc395x.c:2992:5: warning: variable ‘arblostflag’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/dc395x.c: In function ‘doing_srb_done’:
 drivers/scsi/dc395x.c:3393:28: warning: variable ‘dir’ set but not used [-Wunused-but-set-variable]

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: "C.L. Huang" <ching@tekram.com.tw>
Cc: Erich Chen <erich@tekram.com.tw>
Cc: Kurt Garloff <garloff@suse.de>
Cc: dc395x@twibble.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/dc395x.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index fa16894d8758c..f838fe8d74578 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -2397,7 +2397,6 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 	}
 #endif				/* DC395x_LASTPIO */
 	else {		/* xfer pad */
-		u8 data = 0, data2 = 0;
 		if (srb->sg_count) {
 			srb->adapter_status = H_OVER_UNDER_RUN;
 			srb->status |= OVER_RUN;
@@ -2412,8 +2411,8 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 			DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				      CFG2_WIDEFIFO);
 			if (io_dir & DMACMD_DIR) {
-				data = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
-				data2 = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 			} else {
 				/* Danger, Robinson: If you find KGs
 				 * scattered over the wide disk, the driver
@@ -2427,7 +2426,7 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 			/* Danger, Robinson: If you find a collection of Ks on your disk
 			 * something broke :-( */
 			if (io_dir & DMACMD_DIR)
-				data = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 			else
 				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 'K');
 		}
@@ -2989,7 +2988,6 @@ static void reselect(struct AdapterCtlBlk *acb)
 	struct ScsiReqBlk *srb = NULL;
 	u16 rsel_tar_lun_id;
 	u8 id, lun;
-	u8 arblostflag = 0;
 	dprintkdbg(DBG_0, "reselect: acb=%p\n", acb);
 
 	clear_fifo(acb, "reselect");
@@ -3011,7 +3009,6 @@ static void reselect(struct AdapterCtlBlk *acb)
 				srb->cmd, dcb->target_id,
 				dcb->target_lun, rsel_tar_lun_id,
 				DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
-			arblostflag = 1;
 			/*srb->state |= SRB_DISCONNECT; */
 
 			srb->state = SRB_READY;
@@ -3042,7 +3039,7 @@ static void reselect(struct AdapterCtlBlk *acb)
 			"disconnection? <%02i-%i>\n",
 			dcb->target_id, dcb->target_lun);
 
-	if (dcb->sync_mode & EN_TAG_QUEUEING /*&& !arblostflag */) {
+	if (dcb->sync_mode & EN_TAG_QUEUEING) {
 		srb = acb->tmp_srb;
 		dcb->active_srb = srb;
 	} else {
@@ -3390,11 +3387,9 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 		struct scsi_cmnd *p;
 
 		list_for_each_entry_safe(srb, tmp, &dcb->srb_going_list, list) {
-			enum dma_data_direction dir;
 			int result;
 
 			p = srb->cmd;
-			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
 			printk("G:%p(%02i-%i) ", p,
 			       p->device->id, (u8)p->device->lun);
-- 
2.25.1

