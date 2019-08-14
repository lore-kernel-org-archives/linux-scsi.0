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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70972C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F58020866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBFhYK/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfHNX50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41271 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbfHNX5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so329113pfz.8
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ufh7J06ZyfQOGHUbRrtKxOG6lzDenBtiH1xV7O5IK/4=;
        b=gBFhYK/gw11+JdyV2Z3nGX4o7LeqezWJAZYVVz23GoRxNoeWDMmj1H0y5sxFg5yM+1
         8WE31+6B37Np18iT+CcDJcH6j0QvwHoCaF3ARY7yli1QK8yZYb4SmLi70pfWO5IbbBtE
         KM1XI20VfbpexBUCtUPkrQyOxIJzY/v87Wl7xbVTVClWYXlBKUitvLftq8ppIZtH7f8O
         0TL8l+OJA34y2KTpquLZPGfjeMGkznePhOvSeEsdeHjP3yFOIcKw9aybVse+Xds5BmoG
         jfLvUJ4oQ7eJUfh7Sy0DrlHqnvG+hcznPbnJaYONTtGfBSQQPpsQ81j9EZfEI1A6La1t
         s4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ufh7J06ZyfQOGHUbRrtKxOG6lzDenBtiH1xV7O5IK/4=;
        b=oEa0yL2RnOoLM0zih3sfSZVtotTzvGpWbyPEbpMNuSZEyBQjd7hkq+p2iVS9U5dywE
         lDeQ2zfOPS10eiW4GjBJajx/2lkVsCHMKUvY4gWxrlIJHsyhEq37dhcTndA5m9H4+Sic
         NRBp66PVVuafF+uoVICHZZxVuTkPpGKHdWYrM2Ou6ycm8aUX8i83VXyvbdfgc2p13YHO
         9Ys1jgm65hQX5Ujc3siE1NhtH9xq3qIClzknV2LNWi4VeoT+79bQooVq1ikyLddCijcG
         /ytK+UdfXrWoiAzWQBoKpL/wt13np87yZ0pAB37EBoX26VQFtqwme1sBJDfqXLzJeq6v
         D12A==
X-Gm-Message-State: APjAAAXVreOtShPBh1b1mJPhr61hRwNemPKHW4TSv2uReLm0yabK6gHM
        G8R4OzXzKauc0ngjHU1xUHh3OhMN
X-Google-Smtp-Source: APXvYqx54PpIyNtyDMuKVzyYlj9wKAzmUZVEBFCe6iS4dfnK1nRZteiAL6T7eVfE+IA0TVfpQ0DmGw==
X-Received: by 2002:aa7:95b8:: with SMTP id a24mr2548850pfk.103.1565827044791;
        Wed, 14 Aug 2019 16:57:24 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/42] lpfc: Fix ELS field alignments
Date:   Wed, 14 Aug 2019 16:56:33 -0700
Message-Id: <20190814235712.4487-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After seeing some interoperability issues with ADISC, it was
determined the ELS definitions in lpfc were using types that
allowed the compiler to add pad to the structure, causing the
structure to no longer be per spec. The offending structures
are ADISC, FAN, and RNID.

This patch implements the simple fix of eliminating the pad by
forcing the compiler to pack the structure. Care was taken to
ensure field accesses won't be by operations that would hit a
bad field alignment.

The better solution would be to convert to the uapi fc header
definitions, but the number of changes required to do is
rather intrusive so this course of action was deferred.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 5b439a6dcde1..436cdc8c5ef4 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -843,7 +843,7 @@ typedef struct _ADISC {		/* Structure is in Big Endian format */
 	struct lpfc_name portName;
 	struct lpfc_name nodeName;
 	uint32_t DID;
-} ADISC;
+} __packed ADISC;
 
 typedef struct _FARP {		/* Structure is in Big Endian format */
 	uint32_t Mflags:8;
@@ -873,7 +873,7 @@ typedef struct _FAN {		/* Structure is in Big Endian format */
 	uint32_t Fdid;
 	struct lpfc_name FportName;
 	struct lpfc_name FnodeName;
-} FAN;
+} __packed FAN;
 
 typedef struct _SCR {		/* Structure is in Big Endian format */
 	uint8_t resvd1;
@@ -917,7 +917,7 @@ typedef struct _RNID {		/* Structure is in Big Endian format */
 	union {
 		RNID_TOP_DISC topologyDisc;	/* topology disc (0xdf) */
 	} un;
-} RNID;
+} __packed RNID;
 
 typedef struct  _RPS {		/* Structure is in Big Endian format */
 	union {
-- 
2.13.7

