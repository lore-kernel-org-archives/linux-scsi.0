Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A821C00454
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D3E021556
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLKUrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 15:47:25 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:44493 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfLKUrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 15:47:25 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MYNS0-1iAqRJ0S8I-00VNnz; Wed, 11 Dec 2019 21:47:11 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 13/24] compat_ioctl: bsg: add handler
Date:   Wed, 11 Dec 2019 21:42:47 +0100
Message-Id: <20191211204306.1207817-14-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:9E//4H5jUjxcz88C86R1AD+v07xscBKEn+U5T2BAdtLUAnLN0TR
 pJgxkACJ2VOrwR21uFSKt045qw16CVFBKgxXRjl0wRXdIi5qvgtMPA2iOaEdMhuh+mWULCt
 EUPuHtjCDvcR/p3/P41WVjN3SGzN2XxCq0aarb5ncSCwLZiBPEKJmhY3WKVzezophJM9sQp
 yCYgZnaFk6bm8zt5Q8ozA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:v55hPGbeD1k=:IimA31h3OAuyU1W0DDaoVL
 g3OvsSmdNHSaEs4Gs3UxXci2k4RCJNRBJKKffYXVlD10ugWEUY706Wsw/XVqt2dVNSIGEVXhA
 dvGgAN0AuKEfOq5Nr0oXoiJqkxCe44UFhuA7h+Sy4+bZja7QiweCUAynaH7Ek7yIHCu928Ez3
 CvDvPNgttFkSqonwZYX3/RnPO1a3iQbOW1/vN6ND6tFLN8A/OYn4HidUrtseO+1mkmyG8FcnA
 iJXScjWKnL4tqXgMvrfRQkEFrOEGgf6UW7eKKIEr8ngL2bZmpuI197iNv5aTI1Pp+b+44SUs3
 mQD4jJ0xqPv+j11bZNqRawcLFtm1spFQNnWb3tidW3guiC8lrJSajAlCE6/kvkRxmen5rxvrq
 XBhbze+FZfygxhggJERbbk+41YUTfg55I2gJVbXCrIkkTTnN0Od+/lQUkCQtMxYapqX7MIToa
 Em/vHawJc2dL4FVsupr2V+/H6OEcgHZfb4RMYLMdhqCUaJ31tesvtmvDd51l4SPNPhLznfeIy
 7OVhdD05wE7GN98NgSBQBh0IYZOE82NOU3tvk9NScW44ZETUBByBOOavsTmG8xKUakgx8mMR6
 exaE4zh0EwsTfnwNR7e7G+cS01mRpVT2XaIp1GTxEI3XptQRkiGak5XEQhVzoLtQlejkQEIF2
 EeHI58uWrmr5WVkixR8GE95knlczX1j0ZOAnfGn/08CEylXQCV6hqKOlEGXq6rHu7qraoR0Mv
 sBXSSOxLCkiH35xBBwc8Fr0dMR9d9uAu4ubde7KiPPNX+5R5TRjsGYer3bj96/L5SAVl604vB
 r/PrNrfEq0chmpD/BedGKE5ayZasUml2ioBCsX2dmqJ+l8mZySv68q8O4gjp8CakeUK7DZsZc
 d0oG+rl2zmJMClUdj1yw==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

bsg_ioctl() calls into scsi_cmd_ioctl() for a couple of generic commands
and relies on fs/compat_ioctl.c to handle it correctly in compat mode.

Adding a private compat_ioctl() handler avoids that round-trip and lets
us get rid of the generic emulation once this is done.

Note that bsg implements an SG_IO command that is different from the
other drivers and does not need emulation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bsg.c b/block/bsg.c
index 833c44b3d458..d7bae94b64d9 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -382,6 +382,7 @@ static const struct file_operations bsg_fops = {
 	.open		=	bsg_open,
 	.release	=	bsg_release,
 	.unlocked_ioctl	=	bsg_ioctl,
+	.compat_ioctl	=	compat_ptr_ioctl,
 	.owner		=	THIS_MODULE,
 	.llseek		=	default_llseek,
 };
-- 
2.20.0

