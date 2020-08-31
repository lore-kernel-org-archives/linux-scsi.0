Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965FEC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 21:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6699B204FD
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 21:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CpXIUcGf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHaVf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 17:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgHaVf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 17:35:26 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8983FC061573
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2020 14:35:26 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v16so3864148plo.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2020 14:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBFqx7Q2Bj17WNYbZVQWcvRBp3Ijs6sSaFs2UolhrCI=;
        b=CpXIUcGff0tnIl31paNHc1DXvbCv7G/mwHZ8wfhXBqL1Q3eykNGrxaXYKC29rb26e/
         vobv7bPdiM/b7MWiD07qL5D1JwdwwzL1XWPNe+eR31ur7XQ0zz6Oln+tSXckUD4jv05T
         +mEq6wQUZCTvrrGvS0gA8yuGxH9TGjSyE3R+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBFqx7Q2Bj17WNYbZVQWcvRBp3Ijs6sSaFs2UolhrCI=;
        b=lzJkZfLvTnWuopndwv7CfEFVkbngVKVO9S2wB6xt7TroLNayN44gH6b0UWtyGJg51D
         twBTVY7J5AV6TVwVgo+Tk9kVc8TaYs9aaqnrXcHyEUZhlHA7U+QENJPp/svM3bneNfRY
         KLQ+uPTYZQ12nBx8HEckLy2Xqong/Sp5XXp2iwDMNKeQlD00KNncpKS/9Hg1wBSAcNCt
         Ub4ngJ4AWZYsWJ4FplWFOUHf0dua0onF5dFUPqJUTt5gsLgvTDLlF3AtO2a3Bzg6EzMH
         EqsMf1UVJNpIbKmfB3wWbim0cPmTz5eJ+MAcd2bI26ysdon+7oVMuED176GXL7ogdxmS
         CyRw==
X-Gm-Message-State: AOAM533xDNV2/WoCRBY27wwCU/4idNJlJYfQHhiaurigfFR1ubiQq3gV
        GRhzr0KPq0Bnev4NYERolUYP/KngY3OH6YM2vgUUDHy9zPfxZNSwuyxVQE4YHTKSeB/jbKICN1y
        HXx+8VNY58+IkXJl+cDSrcAQs1PwtogvO2GgSUL/kntotCSRobzE9HUPg5m7PeHg9V4uZQBQ7r3
        OC3TE=
X-Google-Smtp-Source: ABdhPJzulasrKn/kzRw3VrEMR/hN0Hu+2uMttJOE55fiN0m+kVzremfFwc0Uh0ny0+MoP30WWHhUIg==
X-Received: by 2002:a17:90a:1697:: with SMTP id o23mr1104432pja.95.1598909725483;
        Mon, 31 Aug 2020 14:35:25 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id w16sm9096855pfq.13.2020.08.31.14.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 14:35:24 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>
Subject: [PATCH] scsi: add 256GBit speed setting to scsi fc transport
Date:   Mon, 31 Aug 2020 14:35:18 -0700
Message-Id: <20200831213518.48409-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add 256GBit speed setting to the scsi fc transport.  This speed can be
reached via FC trunking techniques.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c | 1 +
 include/scsi/scsi_transport_fc.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2732fa65119c..2ff7f06203da 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -253,6 +253,7 @@ static const struct {
 	{ FC_PORTSPEED_25GBIT,		"25 Gbit" },
 	{ FC_PORTSPEED_64GBIT,		"64 Gbit" },
 	{ FC_PORTSPEED_128GBIT,		"128 Gbit" },
+	{ FC_PORTSPEED_256GBIT,		"256 Gbit" },
 	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
 };
 fc_bitfield_name_search(port_speed, fc_port_speed_names)
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 7db2dd783834..1c7dd35cb7a0 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -124,6 +124,7 @@ enum fc_vport_state {
 #define FC_PORTSPEED_25GBIT		0x800
 #define FC_PORTSPEED_64GBIT		0x1000
 #define FC_PORTSPEED_128GBIT		0x2000
+#define FC_PORTSPEED_256GBIT		0x4000
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
 
 /*
-- 
2.26.2

