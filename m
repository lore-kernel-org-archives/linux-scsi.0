Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D93C001DB
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 15:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjHGP75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 11:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjHGP74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 11:59:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F31E72
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 08:59:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5646f8ac115so2716122a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2023 08:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691423994; x=1692028794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zG8gWbogFzhgd3wtD3bT+brZ3je6WXuDDPPCFV8Q2Og=;
        b=OrtSEeaCGbZy4176W6x7IVE6y6a22u5kJr8JXOVw0SE7Cu+j39NNgRw8b0bZd2KcVg
         DjcemeoS6rUU7fq37Lxjsuh9hG6qBkYEh+b9T5eFOsD2o11wLbU7Ch07YHzQMnARVL3K
         /tUqo1K5FvjpaaILCFMMSHwDaISF3rhnxEYhbMz2cFBBVvhT7IEdMTVmsL9paSQ54Amo
         D+eMxVLSYx7JZO61S8V1ZpPFb6hgVYMEbWWRfQwZGLp6KZlL1hzaJHPAWT54CjMUbzHm
         OH8W35/tciL4yNE+95bWZ2c7wWJH1xBZUhu6oaE7Z3qaCYeiq8UIypjo4CT++AkOMN+3
         yFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691423994; x=1692028794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zG8gWbogFzhgd3wtD3bT+brZ3je6WXuDDPPCFV8Q2Og=;
        b=LVU2yp05ZRSxjJY2Xj2Cn799HcLcIRYkXMXtJoCZztmTmVMZJHvMFR590b8fsOT3EA
         vwV0/WIUcKbrxI76lyqSFDNSti6YPwJ9zeqmBBWrR0HbQLP4NFNc0PeuYvkrNwWvmv0b
         akkWeznazCvnGxfmX/os2wJrRTQwPPrPfPwgfJRlcrA3/cD6zzbVA23bowOqJClHcErt
         gdutuErY2zs35v6haMrik1WwfcVTbvVExTtXz43HFijhrHWwlTPGbCH7EmIkNieABc/x
         aNzDkqbeg7lSJeSD7tiq4wH4UzQMBt9jUQKc14toOc0fcZ0FZKTk3i0dcMuz1LrOxaG8
         MN7Q==
X-Gm-Message-State: AOJu0YyWxXhSXUOCTgp8OZChRjC/f263SZyZhfjud7TkE3JQn/wvqdn0
        x+Rb5usgbd2VhN+1AhLmJzlN3FSwDoY=
X-Google-Smtp-Source: AGHT+IGRkAMbBqpKZksqcC8F6jla/OuV6SfEcU/yceIQ69+zm4Qqhii3CZNnHX/S8R0YuvGaQIITGw==
X-Received: by 2002:a05:6a20:3d94:b0:140:a6ec:b55e with SMTP id s20-20020a056a203d9400b00140a6ecb55emr5792383pzi.3.1691423993915;
        Mon, 07 Aug 2023 08:59:53 -0700 (PDT)
Received: from xavier.lan ([2607:fa18:92fe:92b::2a2])
        by smtp.gmail.com with ESMTPSA id 206-20020a6300d7000000b0056471d2ae8fsm5030561pga.90.2023.08.07.08.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 08:59:53 -0700 (PDT)
From:   Alex Henrie <alexhenrie24@gmail.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        alan@llwyncelyn.cymru
Cc:     Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH 1/2] scsi: ppa: Fix compilation with PPA_DEBUG=1
Date:   Mon,  7 Aug 2023 09:52:57 -0600
Message-ID: <20230807155856.362864-1-alexhenrie24@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a regression introduced in February 2003 in Linux 2.5.61 by a patch
from Alan Cox titled "fix ppa for new scsi".[1]

Link: https://lore.kernel.org/lkml/E18jn1B-0005gQ-00@the-village.bc.nu/
Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
---
 drivers/scsi/ppa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 909c49541984..d1f6aa256eba 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -637,7 +637,7 @@ static void ppa_interrupt(struct work_struct *work)
 	case DID_OK:
 		break;
 	case DID_NO_CONNECT:
-		printk(KERN_DEBUG "ppa: no device at SCSI ID %i\n", cmd->device->target);
+		printk(KERN_DEBUG "ppa: no device at SCSI ID %i\n", scmd_id(cmd));
 		break;
 	case DID_BUS_BUSY:
 		printk(KERN_DEBUG "ppa: BUS BUSY - EPP timeout detected\n");
-- 
2.41.0

