Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9283C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 21:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9675361375
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 21:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhFPV0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhFPV0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 17:26:37 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C297BC061574
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 14:24:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c15so1717665pls.13
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jun 2021 14:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9mDyJNpxbZfKyy7RtdpAqA//mXzySL5siK4qAwgwZIk=;
        b=izOVrfiCFy5yXKYpXtpnr4vn5qUA54GYaW3dFSDuO45uysQJhGevfiWYuKG84AAWHD
         u7sLGbp2cez+EL4jXeOgGXFLvQQlTCrwHJ4/8P+QEXKmnlQpIfnOKCcTJrSTwHZpYWCJ
         WKKiAQWKKBRH94SSqISwtIFIIzndkB9QoNtJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9mDyJNpxbZfKyy7RtdpAqA//mXzySL5siK4qAwgwZIk=;
        b=MDZgOY1+8SKBVknGKyRnDp6/aH8yOLJ9GA7uF/ERif5mZv++fx4TQ/anYL/HXot/M6
         hSbJGVV3EHaJ7vKX16/RweBNIgLA5TkRQV1/UiuOyMGnqUIECJl3ra6LBTbPF6x+9mNv
         UmBkkOWWoAmxQCdhUa8j8THaMWMkWXbphoSmGw6iLhFtUMiyKNsRrQNB/zMvTpXrt81H
         9DCNQ0w1cU8XNzfqYfQ1689kUi9feZ+m/54LkwBEFU81HdDIRnkss/ry7cHXEi7g4B7l
         VJBS2BbUamSNDcsCjYzXs2qenR9n+HAC6wD4j5dcXxxAYKONkNHSrbgC7/y03SBQkwK/
         EpWQ==
X-Gm-Message-State: AOAM531iw1UWnWMRRmJUP+dVA9T+C0rVnCwNxIHtw4ZK5LYepH8TE6JA
        oGpq+o97vxb260tIyLz3Jw8snw==
X-Google-Smtp-Source: ABdhPJzWgbUO/DROse1VxvCqkTvtvbZSA5ccSz5dS1WbgeocQY9RqQ8kb79LUxQhw4YCtZlFKWDb8Q==
X-Received: by 2002:a17:90a:fa95:: with SMTP id cu21mr13343910pjb.210.1623878670409;
        Wed, 16 Jun 2021 14:24:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u24sm3187435pfm.200.2021.06.16.14.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:24:29 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: arcmsr: Avoid over-read of sense buffer
Date:   Wed, 16 Jun 2021 14:24:28 -0700
Message-Id: <20210616212428.1726958-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=12ed5885832168ac14ef9d3722ea1bd91ad6bb7c; i=2z1//uxp9rUj226I5jPh8KIjFeGXZ/Z/KUn+4dJoIrk=; m=ewGeyeGy7NM7Qc6xwxoHI0OCT1XLIzmKnYd7SQTiTDg=; p=HZI7Hnd35kAuEhHOejcPJrLHn4tX4nSDWqv1THKws+A=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKbAsACgkQiXL039xtwCZlyRAAi1H Tb1C6RfeYcTEMMhBw3GV9qK5v94F64hR+oVRXtTAEYtnrPjbJFVqHd2XLB4PAEv9WxNl+miI7cCoR XiWMvM1GEzBPTGPDrWhR/sf7yELMrxpEmd7AKrLpGWWccvtYPPnLBXtyJpO98Js0ft35/YjIXKpT5 /9dUmOVpXUndSXXHSpag418H1tLkFjk4MM6Irgm0kbeQBfH6vR+uESbgPOc6w0NHwm2otOV2zZm9Y RYhEo4Q09/Lcqu/1xfPhK7jp3lKqnsOwurepulFdMZH1uG0kPOo4W1J1Bm3RnYN9DAt8Bqv55ULVL 0xNIiX1UgydkJ4oXL2rwKmA80MXz6KDWK8JQURJhKH+FuHccmb5ySQM8m9ag5KJbMCgu6oEPzvVQS aB+z8RUvswqxfcQmhyU7W7RBuavPSL3/EtITOcMF2Xu24f9DHCv0IaK6yPAXiTAfG/2kaRm3AYy4J 9vngWMW+05/XvDWg8QCHTXPAMSlS/Nsl9y3bYCI5QzNeEX7s4/ZBv+lKjcbF55Q1eZusrUhFW8yJL P44eb21xy+Y6wW/O5eDjPq7j7SJw6+8gDVa+narBMFTUb6p1Gcc6L1EtogVvItMzR8IToH0N4+0SV DNEqZold6LY2/2cYcSw6WrmUwsJ0sOld/HGksdifTR1sDVZHHoGHPjiafB7rK3po=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

pcmd->sense_buffer is 96 bytes, and was being manually zero-filled.
However, struct SENSE_DATA is 18 bytes, with ccb->arcmsr_cdb.SenseData
only being 15 bytes, resulting in a 3 byte over-read.

Copy only the contents of ccb->arcmsr_cdb.SenseData and zero fill the
remainder, avoiding potential over-reads.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e5149c9fd4e6..ec1a834c922d 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1323,16 +1323,19 @@ static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)
 
 static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 {
-
 	struct scsi_cmnd *pcmd = ccb->pcmd;
-	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
+
 	pcmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
-	if (sensebuffer) {
-		int sense_data_length =
-			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
-			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
-		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
-		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
+	if (pcmd->sense_buffer) {
+		struct SENSE_DATA *sensebuffer;
+
+		memcpy_and_pad(pcmd->sense_buffer,
+			       SCSI_SENSE_BUFFERSIZE,
+			       ccb->arcmsr_cdb.SenseData,
+			       sizeof(ccb->arcmsr_cdb.SenseData),
+			       0);
+
+		sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
 	}
-- 
2.25.1

