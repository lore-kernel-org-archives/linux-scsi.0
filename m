Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D9CC2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1BD821835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QuFMX0Li"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgACLem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:34:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44701 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbgACLem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:34:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id 195so22581366pfw.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KJ+8YAGRRQLMSwwyfPFUQzGdxL4BTECFGtCSTZEfxI0=;
        b=QuFMX0LixoWMrCAJWgcOg1nDYc3wzzO3cZf2pB+6GeU5o8gfNUg41E1CqMx1xpOD3a
         JYWjpLzyWg8RNzcuV/czjZ/XO1W/+wlyjAi/S8MI0nIrd4I1r7lXB9mEvF+iFek6b+Dm
         lJhGGgYG9dzXSFSdjMCiioDshQ423Mc8lV4wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KJ+8YAGRRQLMSwwyfPFUQzGdxL4BTECFGtCSTZEfxI0=;
        b=QdzB+3SHmjWjvbpybqLwXoJKvD+GEDUT+pRKvyHjc63pfPPbpmVv5JXK+WGnUW0Qaw
         0YI5oTXArL3966ODmJsEZp3Zhdr0FbGCjq3D+bBSU7m3f4/RZyrZLiwjE5iTHMU2ikGR
         C8iIOCtxPdsFFXaeY1r/MnRWMNgKJQ1jYAi0Qz2b1B15WXHIiU7XW7Z3saK7KRM/1+co
         QfgSrQe01EeZH52lK7cUwOFEMdeWN0ahDi2LxjL39HtrsLso/mSIdmC27/1UOUFTo+bL
         yXORFJhDzvyjKDYs7DOXJ7Qol6N0wlNjvRE8FKzg+oGVtOLaAlmndtXRItxgzANo1iv7
         tmqA==
X-Gm-Message-State: APjAAAXq4/UkWHU7tTbZU6OJ6ozJZeO4c53zMJdf5+eAX9FV15EHTIdh
        HgK0iOWsJhV2e+h6cA4ytQKAAvPdmWmufrjAOcVBCd3SGARludh9TPHmJHSbTa5ZVXnhfmcvv7B
        j1BJc88infg92DNdKvO2kBFIqE9bChsp7v44lHllk4PBBD2M2iraoYc75fkgAdTDp5TdW/dy2AH
        NpkRe+Hg==
X-Google-Smtp-Source: APXvYqx6ihDJuVbpzVx3SNXACtB1RC7++MnXGvDIe1flLep8ARE3NGFkBWF2loZ/JT6rdCeozsaEvg==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr97088531pfi.10.1578051281568;
        Fri, 03 Jan 2020 03:34:41 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:34:41 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 03/11] megaraid_sas: Update queue_depth of SAS and NVMe devices
Date:   Fri,  3 Jan 2020 17:02:27 +0530
Message-Id: <1578051155-14716-4-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index bd81840..ddfbe6f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2233,9 +2233,9 @@ enum MR_PD_TYPE {
 
 /* JBOD Queue depth definitions */
 #define MEGASAS_SATA_QD	32
-#define MEGASAS_SAS_QD	64
+#define MEGASAS_SAS_QD 256
 #define MEGASAS_DEFAULT_PD_QD	64
-#define MEGASAS_NVME_QD		32
+#define MEGASAS_NVME_QD        64
 
 #define MR_DEFAULT_NVME_PAGE_SIZE	4096
 #define MR_DEFAULT_NVME_PAGE_SHIFT	12
-- 
1.8.3.1

