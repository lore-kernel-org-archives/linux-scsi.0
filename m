Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34754C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D8E208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KyATLOt1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEHIx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgEHIx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:53:27 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A86DC05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 01:53:27 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s20so448792plp.6
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 01:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vFDwSqhhUSXIeus3xaDeoXmEZLOoBo/F9r1fuq6y5nE=;
        b=KyATLOt1aGhbtdG/4AGe5Xr/lZPueGfVpYMRR3rGuzblH62BDVgAQN6+cbF9mhioTJ
         gtxisbWQnQWptqoYTN1idvskWUEuxC32/hQF2ejnvFQk+9VknK5d1rUQgMz5KeWy6EQV
         W8inm+NFAZ7JscSQgchkJpIJ9ZBM8g3/Wb7pM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vFDwSqhhUSXIeus3xaDeoXmEZLOoBo/F9r1fuq6y5nE=;
        b=c2i0x+OEt4dWX2NIiqjCQCjOd1BwWr+vxA0qFjm23dLPtPcsX9Ty1a4Ez8rboEHSnL
         sr6WsoisdIl6bs2BU8OWJCnH0dR879lFwXPyfgjVHoHfsEecX1JRg7X2Z3Nk2iaJHhJ9
         ubDp8lknz3d4sXaPXM6nzw9NWfxQeSnhgoPfY6UhtwH78tlXsolpuc3Zx5iyxldzanTU
         VjAXWzqeptnOKdKLGsHClj5TbfhcdCVe7w5ZqpN7auOR6cwbNqBAAwD81BexqP423WM3
         eevuuv8bysvP76cKJ6KoWdlsp7jD9zjhB/i2CtIM7hUVrl5vdLQ1tv8NAY/sWkuLiOBg
         IEIA==
X-Gm-Message-State: AGi0PuY7E1fuKcB43LOz/hHubczFLaS/Tmn5LDPSfVa9gDeXxCQzk2wg
        40eTRom7yrWLhryRvuvDb9KBM2dFzeiITGmdLOxx9zvxMh6Dtchnf1IoxM4bs8D/exXNpribLaK
        Om7I1LgL9ScvPC3pdbXIjZc8RP8d89i4QS8gt1IGjQsrmVqp3NFJMyAUnCzdLLdbWY4zinVEAtV
        juE2Zyqhu/fi5z
X-Google-Smtp-Source: APiQypKtFuMb0Nz1xRL/OuzJGhynfmAMlMduOhdIvR94SW4ZihsCklCnw5z6SfNMrJTDwWOArYGoVg==
X-Received: by 2002:a17:90a:734b:: with SMTP id j11mr4854129pjs.108.1588928005780;
        Fri, 08 May 2020 01:53:25 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z7sm1099731pff.47.2020.05.08.01.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:53:25 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 5/5] megaraid_sas: Update driver version to 07.714.04.00-rc1
Date:   Fri,  8 May 2020 14:23:14 +0530
Message-Id: <20200508085314.23461-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 9882736..af2c7a2 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -21,8 +21,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.713.01.00-rc1"
-#define MEGASAS_RELDATE				"Dec 27, 2019"
+#define MEGASAS_VERSION				"07.714.04.00-rc1"
+#define MEGASAS_RELDATE				"Apr 14, 2020"
 
 #define MEGASAS_MSIX_NAME_LEN			32
 
-- 
2.9.5

