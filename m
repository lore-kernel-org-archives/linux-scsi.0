Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974ADC3F2CE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 02:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C3F52469F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 02:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qfDTCOc9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbgB1CMZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 21:12:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43598 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbgB1CMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Feb 2020 21:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=rUbHo/iSA4OojiqqN3boyQPCM+9w5ozJWmrKCLdqwUA=; b=qfDTCOc9M7tFOsEWaCkVpeIFQT
        S6Z7WjOM//7VMGPstpuv6B4OBj2C3dvs5elNLcPyCr8Fzv7joMnAN29RnuOUGrlIxlw6p1cD4I4Dj
        88mPIIacDn7+eoIWzXJ8imeQ2nXy84Je0c4nNnwupnnqT89R93eZyLVREd/GJOWE2R1J+3gSyaKuU
        UoqUzJtKJK4qxuAMD8uslp7DJ8j4LwpDJ56dAx6/0RLO0HHeJI/hsIH5Qddv553G3E7IFlPkDyXL2
        rGcIs3N+oiBfefR96aUMS58YUinqCWPFb9MCfbzWnZ/F1gN8sHRH9Q62NDv3ne99900liJoueTUxa
        W7Xq/Rdw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j7V8Z-00075q-MN; Fri, 28 Feb 2020 02:12:23 +0000
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] fusion: fix if-statement empty body warning
Message-ID: <ce2233a7-e470-0fc2-f908-75f52c6ec3e1@infradead.org>
Date:   Thu, 27 Feb 2020 18:12:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

When driver debugging is not enabled, make the debug print macros
be empty do-while loops.

This fixes a gcc warning when -Wextra is set:
../drivers/message/fusion/mptlan.c:266:39: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]

I have verified that there is no object code change (with gcc 7.5.0).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
---
 drivers/message/fusion/mptlan.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200225.orig/drivers/message/fusion/mptlan.h
+++ linux-next-20200225/drivers/message/fusion/mptlan.h
@@ -111,13 +111,13 @@ MODULE_DESCRIPTION(LANAME);
 #ifdef MPT_LAN_IO_DEBUG
 #define dioprintk(x)  printk x
 #else
-#define dioprintk(x)
+#define dioprintk(x)  do {} while (0)
 #endif
 
 #ifdef MPT_LAN_DEBUG
 #define dlprintk(x)  printk x
 #else
-#define dlprintk(x)
+#define dlprintk(x)  do {} while (0)
 #endif
 
 #define NETDEV_TO_LANPRIV_PTR(d)	((struct mpt_lan_priv *)netdev_priv(d))

