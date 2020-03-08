Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2038C18E5B
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 05:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94F5A2072C
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 05:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FE9NzHd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgCHFBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Mar 2020 00:01:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgCHFBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2020 00:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=SjuaxQQq//VT+ii+wF+8jLqtiJOTEgEVLsaBWwrNUHk=; b=FE9NzHd9sk2YsaRvzenRxcDiZ/
        VGHvaEn+6S2EVEB7e/SGZPpVBw/1cUmKSwx6nlOaNpSt7vRlWDws9pe4I+JNC5TXqyPZe4w5FAKIv
        CHbmq/unYoCkzqcBdYsqda0OVDTqPRbdth0Dqh6NNMdRxMBOxgEI5f8o6W8SD8IKGhJuMCHcU9/uZ
        m2b2GhJ8ZMre9R7A1oVa0J2QfuhSc9cLSE8Yl2sBy7VAxtj2kTM7C29WefI54874lwhIYm/GhT8ec
        lLr7uRsUyJzZube6imZLoCw9pOd+ivKacUQg5xXnUC3hB4UfvxTwEax4vxOyIb2Sfb/DqgIkW3BcF
        oTzE4S4Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAo3w-0007Nx-7O; Sun, 08 Mar 2020 05:01:16 +0000
To:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2] fusion: fix if-statement empty body warning
Message-ID: <ff9df31b-c4c1-c942-1cbf-18039e084c8e@infradead.org>
Date:   Sat, 7 Mar 2020 21:01:15 -0800
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

When driver debugging is not enabled, change the debug print macros
to use the no_printk() macro.

This fixes a gcc warning when -Wextra is set:
../drivers/message/fusion/mptlan.c:266:39: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]

I have verified that there is very little object code change (with
gcc 7.5.0). There are a few changes like:
  cmp %a,%b
  jl $1
to
  cmp %b,%a
  jg $1

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
---
v2: use no_printk() macro instead of an empty do-while loop (Bart)

 drivers/message/fusion/mptlan.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20200306.orig/drivers/message/fusion/mptlan.h
+++ linux-next-20200306/drivers/message/fusion/mptlan.h
@@ -64,6 +64,7 @@
 #include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -111,13 +112,13 @@ MODULE_DESCRIPTION(LANAME);
 #ifdef MPT_LAN_IO_DEBUG
 #define dioprintk(x)  printk x
 #else
-#define dioprintk(x)
+#define dioprintk(x)  no_printk x
 #endif
 
 #ifdef MPT_LAN_DEBUG
 #define dlprintk(x)  printk x
 #else
-#define dlprintk(x)
+#define dlprintk(x)  no_printk x
 #endif
 
 #define NETDEV_TO_LANPRIV_PTR(d)	((struct mpt_lan_priv *)netdev_priv(d))


