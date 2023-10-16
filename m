Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFBFCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 07:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjJPH0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 03:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjJPH0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 03:26:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5B0E1;
        Mon, 16 Oct 2023 00:26:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9bf0ac97fdeso216514166b.2;
        Mon, 16 Oct 2023 00:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697441177; x=1698045977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnxVJqIRdQtouvx5n5R9hP/D5oVVipLHSJQwRP3ossw=;
        b=TlUmt8hZ4LVdRAf781E3554vUA8EVfRwwmGzOD5eA7/8B7f4WsmPiM3YfqytxtS4YX
         LO3k3/nMSmnx0qh00U3dmHG6mE7wjOItSX2Sfb4tzizdQupVInJMB3G26PZ5pLfVum60
         HLjhubNwo1YtVXWayYuvZceL765Gm+yZDuvHlMkrAR+ijWPmegB1M8sfVYSct1DD1aAN
         b8pcm4D4tZ8feAzlTeKDYYEL/O6pDM0bI0dli4sV+pQ2qvERueHCl+HQvaKlNe4ic8aS
         uNfQiBC5LouSln7uuoPRmg4YwkOlUhxLLBPxkP06wU+6O1NxW4ZvoqbK8rsy9McL7zup
         QWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697441177; x=1698045977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnxVJqIRdQtouvx5n5R9hP/D5oVVipLHSJQwRP3ossw=;
        b=FA3c3f3/ifnlOzJe67tiq7bXgRhgOXDHmipYB2Q0gOmcegjETOMRGKpg0zn12jjjIA
         L4IL4NOfVlZYklWZ3xwC7i4XTKOtDX7MCRVN3JEHC9mOdM2Fop32JMvqW41CSxKO02WS
         BWefSKJ+nAhqNsF9fRm3PrhyEOAO9XugpT/ac/wbIriP59RIcF1X3mVoNTUw0Q0qumsx
         YdkJjdhZT6tsuW/G90e+IrqTu+d6JZ0NRlqBlj4P9SqMNSipD1tVNGiagq73bd1JNUYJ
         BQ+Etx9pwnccZFEuztfGRxsLzjXFU2G5AAo9VVmAsTcg/G5975NYbM38mfqKOGyN3pne
         AhEQ==
X-Gm-Message-State: AOJu0Yw3jBKkdMUpKpJfVylP/hQImkN8U65MYvGQjxqxJA5tzmQqoAGB
        ZszxrxxPz9L1FaqATS2Fp0ne63gm4R5rLg==
X-Google-Smtp-Source: AGHT+IH9KvZqYihmyg2FnPlR7/ZYAkszc3cWqEXIzdLn9JoffIMrIfjfZIs0poWr0ZmOjTinLnsjuA==
X-Received: by 2002:a17:906:9c1:b0:9b2:89ec:d701 with SMTP id r1-20020a17090609c100b009b289ecd701mr32086734eje.27.1697441177480;
        Mon, 16 Oct 2023 00:26:17 -0700 (PDT)
Received: from sauvignon.fi.muni.cz ([2001:718:801:22c:bdcb:518:be8f:6a76])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090673d900b0099297782aa9sm3399980ejl.49.2023.10.16.00.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 00:26:17 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        oneukum@suse.com, Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 5/7] usb-storage,uas: do not convert device_info for 64-bit platforms
Date:   Mon, 16 Oct 2023 09:26:02 +0200
Message-ID: <20231016072604.40179-6-gmazyland@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016072604.40179-1-gmazyland@gmail.com>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch optimizes the previous one for 64-bit platforms, where
unsigned long is 64-bit, so we do not need to convert quirk flags
to 32-bit index.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/usb/storage/Makefile  | 3 +++
 drivers/usb/storage/mkflags.c | 9 +++++++++
 drivers/usb/storage/usb-ids.h | 4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index 612678f108d0..62ebaa76ef95 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -57,6 +57,9 @@ $(obj)/usual-tables.o: $(obj)/usb-ids.c
 $(obj)/uas.o: $(obj)/usb-ids-uas.c
 clean-files		:= usb-ids.c usb-ids-uas.c
 HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
+ifdef CONFIG_64BIT
+HOSTCFLAGS_mkflags.o	+= -D CONFIG_64BIT
+endif
 hostprogs		+= mkflags
 
 quiet_cmd_mkflag_storage = FLAGS   $@
diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
index 2514ffef0154..08c37d2e52d6 100644
--- a/drivers/usb/storage/mkflags.c
+++ b/drivers/usb/storage/mkflags.c
@@ -89,11 +89,15 @@ static struct svals vals[] = {
 
 static unsigned long get_device_info(uint64_t flags, unsigned int idx)
 {
+#ifndef CONFIG_64BIT
 	if (flags < HI32)
 		return (unsigned long)flags;
 
 	/* Use index that will be processed in usb_stor_di2flags */
 	return HI32 + idx;
+#else
+	return flags;
+#endif
 }
 
 static void print_class(uint8_t bDeviceSubClass, uint8_t bDeviceProtocol)
@@ -123,6 +127,10 @@ static void print_type(unsigned int type)
 
 static void print_usb_flags(const char *type)
 {
+#ifdef CONFIG_64BIT
+	printf("const u64 usb_%s_di_to_u64[] = {};\n", type);
+	printf("const unsigned long usb_%s_di_idx_size = 0;\n\n", type);
+#else
 	int i, count;
 
 	printf("const u64 usb_%s_di_to_u64[] = {\n", type);
@@ -134,6 +142,7 @@ static void print_usb_flags(const char *type)
 	}
 	printf("};\n\n");
 	printf("const unsigned long usb_%s_di_idx_size = %i;\n\n", type, count);
+#endif
 }
 
 static void print_usb_storage(void)
diff --git a/drivers/usb/storage/usb-ids.h b/drivers/usb/storage/usb-ids.h
index 8bfd84e07f96..4abe1a6d3a66 100644
--- a/drivers/usb/storage/usb-ids.h
+++ b/drivers/usb/storage/usb-ids.h
@@ -15,6 +15,9 @@ extern const u64 usb_uas_di_to_u64[];
 static u64 usb_stor_di2flags(const u64 *di_to_u64,
 		unsigned long idx_size, unsigned long idx)
 {
+#if IS_ENABLED(CONFIG_64BIT)
+	return idx;
+#else
 	u64 flags = 0;
 
 	if (idx < (1UL << 31))
@@ -28,6 +31,7 @@ static u64 usb_stor_di2flags(const u64 *di_to_u64,
 		WARN_ONCE(true, "usb_stor_di_to_u64 table not updated");
 
 	return flags;
+#endif
 }
 
 #endif
-- 
2.42.0

