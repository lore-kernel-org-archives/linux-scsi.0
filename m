Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A38C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 17:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348958AbiDKRuf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 13:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiDKRue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 13:50:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17DFE2722
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 10:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649699293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UM/pY0B56ZIojYfpBYET4rQaf0XG/Qm0KUr3TRSmnlw=;
        b=iqjhiSYHB8RsxNiJ6PRZqEBLaD10+59eLHQ7uEsZviOgcUbcE+EUHPd2o8TZRJiabpfPnG
        AIexu1rfaN4PT9sYOuPHkrHKw3gyhKeBFenSbAwbEE71hVAgMOQzL/ilJisRddrMVGFAq2
        5HbUjJW6COOQsv+KxIGSJcQQ6TK0x8s=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-JlujBegIOKC3MAc0I7WU3w-1; Mon, 11 Apr 2022 13:48:12 -0400
X-MC-Unique: JlujBegIOKC3MAc0I7WU3w-1
Received: by mail-qk1-f200.google.com with SMTP id i2-20020a05620a248200b0067b51fa1269so8007663qkn.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 10:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UM/pY0B56ZIojYfpBYET4rQaf0XG/Qm0KUr3TRSmnlw=;
        b=f4b5iyznCxNKS/FmkpxoVQq7xB2QKuBjmbJcgZ1RTEzspxYI5An9qSJmsICAEwHSZG
         YdFKbaZnPxjYL/d4gzNWsN9kAXz6uADE2iBNQHCSSDFIV74x/DVvMLNZZGLoRUxWmfOF
         BzOkKDJ8ujfo/KzlfgSyqRiLIYtoJWp9gNmjc5pgw3xS3Sg/FgK2KCUj5KGm5twjSAsJ
         undOCrXR6EFgMpLq/dbMM1pD2OdtPgD6hzqEBxelZI9rugb+viQyhu1g5kEmOQz5uVqs
         KFUBljGMHh0jUWPE6LhsO5DG6rpxiBl1RJedaNHgVW2A+tFfG3uYy/9jpx1AgnzQlG+p
         SV6w==
X-Gm-Message-State: AOAM5322r2UOiTSHYG9VXPeiE4sLzDTHpLWv6MO/sNPHrl+Fk8NStkw6
        KoPb4MwGp2MpZYMMz+BDUi9iWMVFSby+0+VitsLMi0orYEmX5V+kBNSr77oU3GRZzEfZjQ6avDK
        dO1GB2iGGn6Pkzk/2HiUYrA==
X-Received: by 2002:a05:620a:29cb:b0:699:fee3:265a with SMTP id s11-20020a05620a29cb00b00699fee3265amr344680qkp.513.1649699291479;
        Mon, 11 Apr 2022 10:48:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQkJp+3hI9ThPxyj8PrJe1MP+oIxpg2KccPU8Yg1TBKGUS0YRlwQnXFHru9URmxPBM9smFrQ==
X-Received: by 2002:a05:620a:29cb:b0:699:fee3:265a with SMTP id s11-20020a05620a29cb00b00699fee3265amr344671qkp.513.1649699291276;
        Mon, 11 Apr 2022 10:48:11 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h27-20020ac8777b000000b002eff87a2c42sm380858qtu.4.2022.04.11.10.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:48:10 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH v2] scsi: do not leak information in ioctl
Date:   Mon, 11 Apr 2022 13:47:56 -0400
Message-Id: <20220411174756.2418435-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sr_ioctl.c uses this pattern

  result = sr_do_ioctl(cd, &cgc);
  to-user = buffer[];
  kfree(buffer);
  return result;

Use a buffer without checking leaks information.
Check result and jump over the use of buffer
if there is an error.

  result = sr_do_ioctl(cd, &cgc);
  if (result)
    goto err;
  to-user = buffer[];
err:
  kfree(buffer);
  return result;

Additionally initialize the buffer to zero.

This problem can be seen in the 2.4.0 kernel
However this scm only goes back as far as 2.6.12

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Tom Rix <trix@redhat.com>
---
v2 : split from combined pcd,scsi patch

 drivers/scsi/sr_ioctl.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ddd00efc4882..fbdb5124d7f7 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -41,7 +41,7 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL);
+	buffer = kzalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -55,10 +55,13 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	cgc.data_direction = DMA_FROM_DEVICE;
 
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	tochdr->cdth_trk0 = buffer[2];
 	tochdr->cdth_trk1 = buffer[3];
 
+err:
 	kfree(buffer);
 	return result;
 }
@@ -71,7 +74,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL);
+	buffer = kzalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -86,6 +89,8 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	cgc.data_direction = DMA_FROM_DEVICE;
 
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	tocentry->cdte_ctrl = buffer[5] & 0xf;
 	tocentry->cdte_adr = buffer[5] >> 4;
@@ -98,6 +103,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 		tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
 			+ buffer[10]) << 8) + buffer[11];
 
+err:
 	kfree(buffer);
 	return result;
 }
@@ -384,7 +390,7 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL);
+	char *buffer = kzalloc(32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -400,10 +406,13 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 	cgc.data_direction = DMA_FROM_DEVICE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	memcpy(mcn->medium_catalog_number, buffer + 9, 13);
 	mcn->medium_catalog_number[13] = 0;
 
+err:
 	kfree(buffer);
 	return result;
 }
-- 
2.27.0

