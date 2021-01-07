Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED51EC43603
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D847A23120
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbhAGAwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbhAGAwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 19:52:10 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B64C0612B1
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2021 16:51:04 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p18so3481260pgm.11
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2021 16:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pCdFxWMmuOfZWudA0mXbDkmU0asgXU+dhVFKYSWdKR0=;
        b=FtpSaVYf855cfTtSFiig9cMxJQR9TmUtiZI5GTU7Xvkf1nf8GWPhLwWvszUjAp3y7O
         pWghKLbPEtIVsXNc6TdQcJVvXwi4RX1MaTBR2DmaVuWT7rdBjStw3bxNHc9uelkDXDyL
         qCJ03LsgSuU4EO2KHm0r/JuHxCC/bxb0QfGaTHVaotyFHL5mhLijtj8/+P7/lkVWmDTw
         vye284bN4nK1La4gADumW0dSBax/GY6IYEO/nH41C6DIQIqC6gfxTMppEkIp2lEsMvSV
         PzxkVtRmw03Jn2NEda22U5hRhQ3RgYLvSIshLUyxuD2NJvpC/qiHwGOx3v2Fvtfboo4z
         OpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pCdFxWMmuOfZWudA0mXbDkmU0asgXU+dhVFKYSWdKR0=;
        b=MLicz/qcO60yYz/JOM3dqGzaDOAUbsJ6w5V+qhXzonW9cCn1R0rEC0OP2oLP8Spcca
         /FkqNLXglgW54u+NKS9zvc+Whro5pyGDUir+c1y/i4KUha9hoUUC/mpFGf3LGs5BHKN5
         7U4gAnTFvBAfsNTMQ0JCtKSVlR3zLlzgJECYqNFJyxkdE484smIJOMSWg8rKYDXelXK+
         nYCSfsVI9+OUna1H/N0ZgxOliXW6HyOSEsPao5p9NVU/2qo0j9RQRiH5R1Aqi6u2z2p4
         UQEOyA6POhQJuzEdssBzCSirR0EDP9t/OqP3sIdIVYkFyH4vT9Fk6vO/Gfb1FiQi2gqP
         Vtzg==
X-Gm-Message-State: AOAM532oVRO5aV4KPgD3h4pT7F9nTlCpRIeTscHl9//zyXDecYPuSzUx
        rC93PSnle7BIf0zBQoTBVjQ96ss++D0Vng==
X-Google-Smtp-Source: ABdhPJxT1Ymzj6fTwvd8fFo4wNpiGEwZQ8x4ZeisXonUyE0fJz2gR204ZaiqZh+EqSqWEALhYTC66A==
X-Received: by 2002:a63:e22:: with SMTP id d34mr7094350pgl.142.1609980664391;
        Wed, 06 Jan 2021 16:51:04 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w27sm3600634pfq.104.2021.01.06.16.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 16:51:03 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v6 31/31] elx: efct: Tie into kernel Kconfig and build process
Date:   Wed,  6 Jan 2021 16:50:30 -0800
Message-Id: <20210107005030.2929-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107005030.2929-1-jsmart2021@gmail.com>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This final patch ties the efct driver into the kernel Kconfig
and build linkages in the drivers/scsi directory.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/Kconfig  | 2 ++
 drivers/scsi/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 701b61ec76ee..f2d47bf55f97 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1170,6 +1170,8 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+source "drivers/scsi/elx/Kconfig"
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on EISA && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index c00e3dd57990..844db573283c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_EFCT)		+= elx/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
-- 
2.26.2

