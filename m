Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED8EC77B75
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 20:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbjEEUuk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 16:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjEEUug (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 16:50:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A830426B8
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 13:50:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aae46e62e9so16183105ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2023 13:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1683319832; x=1685911832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+hhlS5Zkngeg/eliQcVzvtVmVkGGHow6adCr97U1D0c=;
        b=MW3xK7xE6sMfY0cMScB6wmcIVaVOq/uPO9q7b4kfNqx58PHaro2afC+5iS6tH4DMYL
         UsNsWsT7AkY/2QsCpGdrcXZVWaDBudPOPZVFKmXWYgl97bqE79e5yRP+MSHUD/lor1M7
         DW/1ChmvA+a7Uv+XM9e7Jw/gDKcEtzwUur0Aaer7y1G1Sat8dYkz/T0wxmlIgQouAQEX
         LjgDUfvZK6aBxoeHqUgWGbPKxg2pA8rIY1TVVR7oE3VNilOjgbO29D0lJ2at5D0qvC7u
         CalhIXERqZ+xBL2Cg8vWNKEtnZ3wrdhsC/xrVM8rkHiZ+FvTnaVmKpCRbqWrEQPNb+PG
         QdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683319832; x=1685911832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hhlS5Zkngeg/eliQcVzvtVmVkGGHow6adCr97U1D0c=;
        b=X/ts2aRS2bHp3+XObnLuGJsXIEIHEpJ7oQDahFyEfIg1WPKlqY+OgWwlecWro+Q9im
         GYvywJsII1FKZvxRHRRkyWVy0rkyMyNeczb6wfCW2i7t528FxwwcfJyEwDcqh4GdDcTU
         e6S+SzuZt+7R+uwTtiVH0gJOySb6qN1VQ1ZyjxaTIccbXUXcD3FgwIdlsE4r7KlJoi93
         QKSNG2HzYUxFA6KjH63wCCI0kuPNPN33JgZUYtIinBQdet4OdoxwdYj+hXd9+msz74gz
         AL6wTDOs+3bpkZXP/5ohsY7z5cnWezagg9GKf4e6Yw8G8bCx8J69rbGoSxGEXQi86vNi
         k64w==
X-Gm-Message-State: AC+VfDxyhVvj9T35JzktTiMncGJaAvSUdoRaRGkFMfDu6mXDZhAy4axO
        9BJo2VSbKMpODDDrnRsdGpuUEgOcd8lXNCCjPQTD4OmivfETG31AHC5+LwC2mSsED4G6KnMjVxx
        9xUPUJl/TQfaFS+Jv8Z4UGhT3o+ZHx/FqxJrsR9B3uO6H00TDGmkQKLfy2kKcnOfgli+x+jLyDa
        XuLDs8LA==
X-Google-Smtp-Source: ACHHUZ5L/eQKT4Ojwa6iMRVHelylBHF/W/YEz8BTV9H9FoGYVgtL7JEZ4+1UP8og54dDl2UPGPxZPA==
X-Received: by 2002:a17:902:d902:b0:1ac:482e:ed4d with SMTP id c2-20020a170902d90200b001ac482eed4dmr1996389plz.18.1683319831506;
        Fri, 05 May 2023 13:50:31 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([2600:1700:6970:bea0:a8bb:edca:20e:21be])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902dac600b00198d7b52eefsm2188568plx.257.2023.05.05.13.50.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 May 2023 13:50:30 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     Brian Bunker <brian@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not supported
Date:   Fri,  5 May 2023 13:49:50 -0700
Message-Id: <20230505204950.21645-1-brian@purestorage.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When SCSI devices are discovered the function sd_read_cpr gets called.
This call results in an INQUIRY to page 0xb9. This VPD page is called
regardless of whether the target has advertised this page as supported.

Instead of just sending this INQUIRY page, first check to see if that
page is in the supported pages. This will avoid sending requests to
targets which do not support the page. The error is unexpected on the
target and leads to questions. I am not sure what percentage of SCSI
devices support this page, but this will eliminate at least one
request to the target in the discovery phase for all that do not. The
function added could also have potential users besides this specific
one.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Reviewed-by: Seamus Connor <sconnor@purestorage.com>
Reviewed-by: Krishna Kant <krishna.kant@purestorage.com>
---
 drivers/scsi/scsi.c        | 40 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |  4 +++-
 include/scsi/scsi_device.h |  1 +
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 09ef0b31dfc0..9265b3d6a18f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -356,6 +356,46 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 	return result;
 }
 
+/**
+ * scsi_vpd_page_supported - Check if a VPD page is supported on a SCSI device
+ * @sdev: The device to ask
+ * @page: Check existence of this Vital Product Data page
+ *
+ * Functions which explicitly request a given VPD page
+ * should first check whether that page is among the
+ * supported VPD pages. This will avoid targets returning
+ * unnecessary errors which can cause confusion. -EINVAL is
+ * returned if the page is not supported and 0 if it is.
+ */
+int scsi_vpd_page_supported(struct scsi_device *sdev, u8 page)
+{
+	const struct scsi_vpd *vpd;
+	uint16_t page_len;
+	int ret = -EINVAL;
+	int pos = 0;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdev->vpd_pg0);
+	if (!vpd)
+		goto out;
+
+	page_len = get_unaligned_be16(&vpd->data[2]);
+
+	/*
+	 * The first supported page starts at byte 4 in the buffer.
+	 * Read from that byte to the last dictated by page_len above.
+	 */
+	for (pos = 4; pos < page_len + 4; ++pos) {
+		if (vpd->data[pos] == page)
+			ret = 0;
+	}
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_vpd_page_supported);
+
 /**
  * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
  * @sdev: The device to ask
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1624d528aa1f..0304b7d60747 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3127,7 +3127,9 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
 	 */
 	buf_len = 64 + 256*32;
 	buffer = kmalloc(buf_len, GFP_KERNEL);
-	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
+	if (!buffer ||
+	    scsi_vpd_page_supported(sdkp->device, 0xb9) ||
+	    scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
 		goto out;
 
 	/* We must have at least a 64B header and one 32B range descriptor */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f10a008e5bfa..359cd8b94312 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -431,6 +431,7 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
+extern int scsi_vpd_page_supported(struct scsi_device *sdev, u8 page);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
 extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
-- 
2.40.1

