Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CD8C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6B1824676
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hSuSOKwB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgANLWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:30 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35691 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANLWa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so13280303wmb.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ei1nq34szNaXZAhYb7pYFwvPJy7EAj/c+sFsT9jAc6E=;
        b=hSuSOKwBzI4wF4HGGz3SVI2sOdFonpcOL74TMdwPXb4ujm9EmYmd1OTZWakVSbM056
         LD1jF6w26HmTXqDYoWEIjaix+vCLV4I+4GLyK1+WMGduxxYQUXwf7rMknpY6Jp1Gw22n
         bzLqakFRe7dXgr50cDdVub4ICWLV7ack6K1R8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ei1nq34szNaXZAhYb7pYFwvPJy7EAj/c+sFsT9jAc6E=;
        b=tT09ayiVQq0XyQyXO+ZnrrxgLnOnmHV1Plss3jaGCjnMMwf95ViANQqdE46NPNQoud
         EmM8Sr9KGj92q6PX7/LAqTEvZmJ95QCHN22Q55PsTKIPhcVTq22WQQWiHB0iPUlUxfnh
         qWWEOiv6yI27w9QA5qgBAekYDwgIWULbyqgvGqo/lpBAKA5JXo9Co/VTWKE588poKgT1
         w3UufAmooUa+REXyCN8D/4SXVJO40DI+dsKU6Kr4OgCJL/LPdkb2cEw54PdG68qqruRY
         XlJfVHb5zSAKBUV+FlmeeLRBlDbUufLQ/4RNcXZPwzX8YTR5GHDUrg131XoUm4pFm8W2
         OXCw==
X-Gm-Message-State: APjAAAXLv+qmWmX6YXEG4eP6P0/DFzh8a1z0vNNCjtgxzWjbzrfOAstL
        9pXSjFg6rYtZWpZJIcDT2j9Mn9cvOxZqB6jzxipkTroOpIHZ67XKl8oLpBe/ym4EF4KRIotTfPt
        RYznzIIKktlkQEXzCL6tB/7qazTXTIZ8FpGUezzkKRAmwjiA3Hl+a3PYDmx4iE1eyEgGV4JzO60
        JfRcLoag==
X-Google-Smtp-Source: APXvYqxDUrq85ZkViZE0yjC13w9mvM7MhMgJSQFQOS5w8WMYfa0R9G5YjYK7vH5hUBOfHDLo+NaDJg==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr26707464wme.90.1579000948261;
        Tue, 14 Jan 2020 03:22:28 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:27 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 03/11] megaraid_sas: Update optimal queue depth for SAS and NVMe devices
Date:   Tue, 14 Jan 2020 16:51:14 +0530
Message-Id: <1579000882-20246-4-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ideally, optimal queue depth will be provided by firmware.
The driver defines will be used as a fallback mechanism, in case the FW
assisted QD is not supported.
The driver defined values provide optimal queue depth for most of the
drives and the workloads, as is learned from the firmware assisted QD
results.

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

