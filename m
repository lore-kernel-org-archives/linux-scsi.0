Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95070C33CB8
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7459D24676
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgAWEYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:24:00 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44054 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgAWEYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:24:00 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so684311pgl.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q67q+ZIimFokwlwPHxPZ1RkWcY1q40l9vcSwtRqU7yE=;
        b=nUHDuWr48Taet+XHvE+e1GoErfkE+KInwBdT3uXN5Pd/LcdA/JD/fCz6LM2rrJKEwl
         zUH+TntyI919ZpbVDgXug7ulQmVsZQiCyIEbJn6zb355GXD2yre2sYV/8G/7MaCHgJqD
         SgidvaPeELdWCI3k5TVCqRVSbxFpY7dYa8d3GVLcis09+OBM+WEORTkVRpmvxrSJF04e
         D8E30UQ+Fqt4qtiIqSzYLkcMGs8ZJEKngYFHrp0kWkqPCN1e4AwNbSNcaGsL3r5H5HSA
         QKuRlbIahy99EE9/81O2RO6imV0K2z7+XlTs1FbcJtaM+4ZTPG5F1PniGnvQrmsLHpJE
         HFjA==
X-Gm-Message-State: APjAAAU1ERFrOwWOzni0qqnBYjUdO8he7g1Jutx0yJrc0Wi9xeCFWWlk
        qHCCxzrl+wD8Fco6z+RQTVHPnfLr
X-Google-Smtp-Source: APXvYqz7fExpE3TBFvSY0W/RHKtAn0o1ygz8asaAeMbgwVmWvgFIWKewXmGntkXtaf0Z+dyeJc3C/w==
X-Received: by 2002:a62:7681:: with SMTP id r123mr2541617pfc.169.1579753439979;
        Wed, 22 Jan 2020 20:23:59 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id p16sm492879pfq.184.2020.01.22.20.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 20:23:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 5/6] qla2xxx: Convert MAKE_HANDLE() from a define into an inline function
Date:   Wed, 22 Jan 2020 20:23:44 -0800
Message-Id: <20200123042345.23886-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123042345.23886-1-bvanassche@acm.org>
References: <20200123042345.23886-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows sparse to verify the endianness of the arguments passed
to MAKE_HANDLE().

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b04d334933ef..968f19995063 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -119,7 +119,10 @@ typedef struct {
 #define LSD(x)	((uint32_t)((uint64_t)(x)))
 #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))
 
-#define MAKE_HANDLE(x, y) ((uint32_t)((((uint32_t)(x)) << 16) | (uint32_t)(y)))
+static inline uint32_t MAKE_HANDLE(uint16_t x, uint16_t y)
+{
+	return ((uint32_t)x << 16) | y;
+}
 
 /*
  * I/O register
