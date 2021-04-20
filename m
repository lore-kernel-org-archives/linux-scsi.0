Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40447C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10E096109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhDTAKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:06 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:42560 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhDTAJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:52 -0400
Received: by mail-pf1-f169.google.com with SMTP id w8so20841821pfn.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NbaU7m/47T/9oIGXELzbbJnhWBWeeCW/DYssGvSOsUw=;
        b=sPPz+szxFBlIkVK/D6abhjWfxmVmfeie80V/yUZq/vBOkU+Drj3ikmkZPDE/h+LXQ+
         IdxslMzhQmgijDLsDK2SeVyl9LIXq99X990YzwGxsjHdU5WxzKWk9TzTKK9PnVckU2g/
         EXcP5VN90AOKgK1DDyTCjTcOdB9Qr/2yjHPgt7a8rTPyLchhMu3/XZ7I11+JDa68FdsO
         eWjOB6c7MQiS9JYYOrGo68ty/D4DN2qpP3fp5Fk6n19A4YwU8+hbUTZRGe/LfC/3GhqB
         ckzk+gEVLIO+p6S0Yg1GP7uz60aGR0mjg1xtu155n0M2bhtWDTu6vD4babgvesO7b2aU
         9Obg==
X-Gm-Message-State: AOAM531xjUJIAU70QuGCshKOSIFLf4LwyKBzyo2Eb09GaybAtFI8EqxZ
        p8HINkqN7rKBqsZZSavgyaU=
X-Google-Smtp-Source: ABdhPJyGHJeegiEToLYA8wQgEy7b19wvsFAMSFhh3emi5bobbny8/jEEM1dvz8qf21UezW7mhEO0cg==
X-Received: by 2002:a63:da10:: with SMTP id c16mr4729268pgh.221.1618877361269;
        Mon, 19 Apr 2021 17:09:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 025/117] acornscsi: Annotate fallthrough
Date:   Mon, 19 Apr 2021 17:07:13 -0700
Message-Id: <20210420000845.25873-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch suppresses the following compiler warning:

In file included from ./include/linux/bitops.h:32:0,
                 from ./include/linux/kernel.h:11,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from drivers/scsi/arm/acornscsi.c:116:
drivers/scsi/arm/acornscsi.c: In function 'acornscsi_abort':
./arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall through [-Wimplicit-fallthrough=]
  (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
./arch/arm/include/asm/bitops.h:190:27: note: in expansion of macro 'ATOMIC_BITOP'
 #define clear_bit(nr,p)   ATOMIC_BITOP(clear_bit,nr,p)
                           ^~~~~~~~~~~~
drivers/scsi/arm/acornscsi.c:2667:3: note: in expansion of macro 'clear_bit'
   clear_bit(SCpnt->device->id * 8 +
   ^~~~~~~~~
drivers/scsi/arm/acornscsi.c:2675:2: note: here
  case res_success:
  ^~~~

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/acornscsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 248a5bfad153..912828d1dcad 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2664,6 +2664,7 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 //#endif
 		clear_bit(SCpnt->device->id * 8 +
 			  (u8)(SCpnt->device->lun & 0x7), host->busyluns);
+		fallthrough;
 
 	/*
 	 * We found the command, and cleared it out.  Either
