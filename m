Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68290C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D2B64E62
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355599AbhCDAcA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244434AbhCCOs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:26 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7D8C0613E4
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:46 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n4so6576621wmq.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LQo94ZcfBBuoFY/1jYEsk/EDMJmQ504CLIYBmOmNlDo=;
        b=ERgJAswEWwGJcDUkR52X8TC8ezcOCCa6+8alb64vHVFwshhU4Gm2kFN4zKH/+7aHr+
         2k67F1awD2Roqqo2RG6++tlvEY9Prf3wENCLCTfyjbg7HULZQoSdkRFyXzoXPOngbHkb
         BtRtpHemEXNtobp14or4D2hLNo46tcV8e4+mEuu2Nl03JNQZeV1dNQopa07/2rSinanS
         9ib3CNZUf4RHpdxrbrCpeqM75UUAMo3tXUkhOV8mcjJX6oH1ttfRAbJJaTR/TApUe1A8
         yy1QyqUbe9COAc5bzP7yj2x9Q8b7iPztsqbtQKoAULqDcZFg7LF75YApXwLnVlK/Epmi
         pvrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LQo94ZcfBBuoFY/1jYEsk/EDMJmQ504CLIYBmOmNlDo=;
        b=XizAME+QuSUQIiiycpfQQDhGnmx18WGu392UDDRSeeqyn11DExgDGNF5MgXlxs88N3
         n0vwK9JIkGwwsUkrcoAF3WmWVBGwNNOsjtaOYHeloSjSJy4lmfG2rmwjc3YIRvl4xTSU
         4zCggf76+wDjpRcyWch+Yfscux3DosOnyymtPsp9Aan2y/whrbhwweVfKZQZ3ARgdRj1
         7WbeohnpMWcidR6EbHjCPs2ucy6US/TAiSHJ2bNabzR+GKlylpZsB+Lpl5YUs1NN1wYY
         qVMlSoYbG5fU6TASI23ew5/JYGsoOOY3EQP+dp92lMceNcPru3iR0SYz403O65GddwlI
         QRRQ==
X-Gm-Message-State: AOAM533N2G/4t9yMpIMpdQBnBSmhnkuxBIIrTUUNoVQ9aMuEKhcI6iiJ
        xpox99n+q7LAyRwhip4dPFMMrpuGGL4Y4Q==
X-Google-Smtp-Source: ABdhPJyY3dGJO9LEZjajUPaKUxzIN5qx3Ifi9H/Au4nQ0TT37FozWbX0DBkV6eljG6DOvXBrf23QZQ==
X-Received: by 2002:a1c:2403:: with SMTP id k3mr9542103wmk.130.1614782805138;
        Wed, 03 Mar 2021 06:46:45 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:44 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 05/30] scsi: fcoe: fcoe_ctlr: Fix a couple of incorrectly named functions
Date:   Wed,  3 Mar 2021 14:46:06 +0000
Message-Id: <20210303144631.3175331-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/fcoe/fcoe_ctlr.c:1314: warning: expecting prototype for fcoe_ctlr_recv_els(). Prototype was for fcoe_ctlr_recv_clr_vlink() instead
 drivers/scsi/fcoe/fcoe_ctlr.c:2963: warning: expecting prototype for fcoe_ctlr_vlan_disk_reply(). Prototype was for fcoe_ctlr_vlan_disc_reply() instead

Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 5ea426effa609..1756a0ac6f083 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1302,7 +1302,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 }
 
 /**
- * fcoe_ctlr_recv_els() - Handle an incoming link reset frame
+ * fcoe_ctlr_recv_clr_vlink() - Handle an incoming link reset frame
  * @fip: The FCoE controller that received the frame
  * @skb: The received FIP packet
  *
@@ -2952,7 +2952,7 @@ static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
 }
 
 /**
- * fcoe_ctlr_vlan_disk_reply() - send FIP VLAN Discovery Notification.
+ * fcoe_ctlr_vlan_disc_reply() - send FIP VLAN Discovery Notification.
  * @fip: The FCoE controller
  * @frport: The newly-parsed FCoE rport from the Discovery Request
  *
-- 
2.27.0

