Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95059C83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 09:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626D2206D6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 09:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zt0vAmBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgD1JZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 05:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbgD1JZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 05:25:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB64C03C1A9
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 02:25:15 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so23812443wrx.4
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 02:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G31W85DYGcgMX2ne+rMFHMQ8EDxW5cAQVtGHg//N4XI=;
        b=Zt0vAmBZpp7NVzu5IcNQU5mc5/Tn+BiQy2hLzlPGeUypGfNZh89phRCjpdzmU1OCBt
         yt+qljpLSggigEsx+VpXC62hkLet8lGu6OUUiXrWNbDjObvEnsDMH6gq0XN6YGepHgrq
         s6lOImPK35Vh5Y4aGBeXfTVLVXvSmUX4FlMJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G31W85DYGcgMX2ne+rMFHMQ8EDxW5cAQVtGHg//N4XI=;
        b=JtYJBZq4Q5cUkK/AuKCcINmMXKRfTCiCEEyLubf6N6o123YEc8MmVpiEZLA8iL94ek
         ykl69R3r2X7h80dKrzfdHKn0rdmQaUN30eOueJkXYWgeMgGia8ML7DntZl8sb4lMAkUq
         hj2s7hepcfSpogNP38f4CaH/zO9GR3RmlsrANKP/Kw6xsQiodI8J6ZDT1MsOQF6LVkU1
         eoaMym7C87tDIzbLJhj2KEQ2Rcs04lFrPHlzOiJSYXGnR9wQ1uFuWhf2iiSNK7Deu9Wl
         Y/iC38S6W62aACQLibqvsH9L6ZbTG4qYMNJC1dqv//ilTO1dgIp4UwIZ3cgNsHn4ZE/k
         sNvw==
X-Gm-Message-State: AGi0PuagrOWU2P6eMFGta+IAMpmlE7FoaAII03A5y7yT53EBv6jNYTFH
        AWsYoKlDm1+Czt8D8XQye76ntZFp38vk6w==
X-Google-Smtp-Source: APiQypIDQshvS8nE65SfdjiWCnrQY5Q3On67YQ0mPkjgn0tdlr73e1sY9A2RzznQ06y3Tr5KrHJkYQ==
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr35528087wro.347.1588065913949;
        Tue, 28 Apr 2020 02:25:13 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z16sm25773171wrl.0.2020.04.28.02.25.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Apr 2020 02:25:13 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Disable DIF when prot_mask set to zero
Date:   Tue, 28 Apr 2020 05:25:02 -0400
Message-Id: <1588065902-2726-1-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default DIF Type1, DIF Type2 & DIF Type3 will be enabled.
Also users can enable either DIF Type 1 or DIF Type2 or DIF Type3
or in any combination using the prot_mask module parameter.

But when the user provides the prot_mask module parameter
value as zero then the driver is not disabling the DIF,
instead it enables all three typesof DIF's.

So modified the driver to disable the DIF support if the user
provides the prot_mask module parameter value as zero.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 04a40af..2757bdb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10763,8 +10763,8 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 		}
 	}
 	/* register EEDP capabilities with SCSI layer */
-	if (prot_mask > 0)
-		scsi_host_set_prot(shost, prot_mask);
+	if (prot_mask >= 0)
+		scsi_host_set_prot(shost, (prot_mask & 0x07));
 	else
 		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 				   | SHOST_DIF_TYPE2_PROTECTION
-- 
1.8.3.1

