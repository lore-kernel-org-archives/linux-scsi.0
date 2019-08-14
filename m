Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F47C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 485A220866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCIlErtd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfHNX5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34119 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729813AbfHNX5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id b24so355221pfp.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YgQHUvJV8RfoY0jxLAFAhNqTg2LtF8ebtQQpXpTSzXs=;
        b=dCIlErtdloFMg7A5i65oH7XyOhvg44QWd89rDGokZ/b7szzJxyNa5zs9bQMzV6uOXn
         pxOfjj/8IYhhNyoXbZMk7009Vt9uTGB7h6EuetFbkymrsTZeZJaTtBv0QSPi5jpx+L+k
         MaJt6k3RW44gRRMkQdGP783I90dctuNq/JpHby/c6i+EL06NFkjJLv9WIc8xKJ/yAFfz
         xsrm3GiLZT5kWG+AG/IyIP4Khy2gzO9cux7/nU1WZrZdR7FEUF5bNaL/X0xTkyHxr821
         comFDfl273+XR78VGEjcMkXfVivn5jOBWhF1PYJjVTALjg+gGW3XVLIRR2+8H3hq3cSC
         UEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YgQHUvJV8RfoY0jxLAFAhNqTg2LtF8ebtQQpXpTSzXs=;
        b=N2XmnRa64EO0FtRz8YdKNUuOQvNn4+GWhSxXdHyypZx3dhshS2pbNMsEyh4J7srTlp
         Kkan+wsz3WbI7mkNFhUkA0+9aLQPdMeK6i+BXY3PrSRW1DDS4TRndEo3h/aVtL9lBx+j
         jozZ+KpyMKkfzE8u59ypZhW6c3nP7iVIQJohjWfAcLclqsEatNz/tTeIR/ThMg6v6pri
         J+/zzKgvSOEYkFF7Sa8TPIGBlzKIR1w5sDliIgCdxwm6G96VaT+YBs8AtzsAZBLfH7jc
         VdcS664o54j/j+tZGmEKGEKvQlAn/hOIh+I08Ul81E7HeHyApt4rcvAKM2i9sP/Tr2AG
         Q40A==
X-Gm-Message-State: APjAAAVz+pT0Z546a1OUN2QNlTFt3jrypoXwAHiKTQW50Rt57NasHh+G
        sAJCok1TQBTExnYnjLc/UTF99RXS
X-Google-Smtp-Source: APXvYqw0kSBTAbkvpNQ86GZO9vIHrV2kIPMCqQ/P2gzBHs6u8pIg8J+aH5xumwDnnENnbfYlvpGKGA==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr427360pji.136.1565827068220;
        Wed, 14 Aug 2019 16:57:48 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:47 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 33/42] lpfc: Fix nvme first burst module parameter description
Date:   Wed, 14 Aug 2019 16:57:03 -0700
Message-Id: <20190814235712.4487-34-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

modinfo for lpfc_nvme_enable_fb is incorrect. FirstBurst on lpfc
target is not fully supported.

Update the attribute description

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 63e631f116e4..a851bf557dba 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5467,15 +5467,12 @@ LPFC_ATTR_RW(nvmet_fb_size, 0, 0, 65536,
  * lpfc_nvme_enable_fb: Enable NVME first burst on I and T functions.
  * For the Initiator (I), enabling this parameter means that an NVMET
  * PRLI response with FBA enabled and an FB_SIZE set to a nonzero value will be
- * processed by the initiator for subsequent NVME FCP IO. For the target
- * function (T), enabling this parameter qualifies the lpfc_nvmet_fb_size
- * driver parameter as the target function's first burst size returned to the
- * initiator in the target's NVME PRLI response. Parameter supported on physical
- * port only - no NPIV support.
+ * processed by the initiator for subsequent NVME FCP IO.
+ * Currently, this feature is not supported on the NVME target
  * Value range is [0,1]. Default value is 0 (disabled).
  */
 LPFC_ATTR_RW(nvme_enable_fb, 0, 0, 1,
-	     "Enable First Burst feature on I and T functions.");
+	     "Enable First Burst feature for NVME Initiator.");
 
 /*
 # lpfc_max_scsicmpl_time: Use scsi command completion time to control I/O queue
-- 
2.13.7

