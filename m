Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D24BC43216
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552BC60FE6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhHLC1U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 22:27:20 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55309 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbhHLC1R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 22:27:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628735213; x=1660271213;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=mhabWCigeMf23LkXW4lJkPoqzA+1/WMbsc4DZ/vq3tw=;
  b=GbEdocbOl9Jf65Yc/eQwt+uMJCxP5EHAjJ0oZXphZ3mcrOcmaXEmxs3e
   +1w4eYRP7m2a1KtyBeluzXI6YkZhX4pByhBMNkkPha4MY9jPeRaGOuZJG
   LT5uU9n1+qwQKay84BdNbis6jp7bXcuLsBqwZwUX5HB9BcnDeNhvYbwwV
   MbQForUTZhZEGnHQph7A8Zrr2T2CeT4h/1VG9g0ROIZeCy0IYNxfQllxn
   OrIz8K6QxV/XFFpHxXLv1Q7M5FgxtY5qgc+G9ttIvKAyZ2sMBgAAd4X42
   pvU41QT0rM8lKzKoX2kFuPVCd98KrYsdIa2BTxRpDY0OffhihJBBFBTAp
   w==;
X-IronPort-AV: E=Sophos;i="5.84,314,1620662400"; 
   d="scan'208";a="280823449"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 10:26:52 +0800
IronPort-SDR: +UGJa06FDdMUMdvmZrBtSy+Wh2A7n+o10LavZHOsi57kTPY2JjilabluIPVT4KB0eQdVJIkjfj
 jI1tMt0H2+D2Kos3ncuUw9nhhJctLfhlmHNUuxFU1eOvfSmspnwBIWTkeK4V13NNAHxMvxdqqO
 hapLjHIN4ziILXsTJcR0B6PDejhfGEG8v2kxFrsxo/wD6ezMun+DorHqFkPae35d1EdVW9nEUJ
 zkdTpRfsciFcSmxAInpPMAmVPHAj1Px8vqDmglUs2BFkKAkbNFrCSIs1yW0HmLsPOHMCllahNr
 1vFx5N5nNs4+BYiPDhaJH+nE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 19:04:12 -0700
IronPort-SDR: 1SHvz2Bxt0vzkv2iBbE1z9fLqxs2kOjDcWX3osiiWlZCbwD4wE19mnIxmnlN9ePKneEx99x3vf
 qgShd9kzvq4k1uc/mxDGtodPNU/viRMh826Kl6OggSnV3u7vcoVOU0icjei5W2ebHfU2NwHSFG
 ZENTb2UnYfXK2gAVy8OVNlMH0BqZD+dgj9xkWudp4AWY/e4hXJbwg2OICz15TmqV16qOkIiBGY
 xPAmLXklBO0n0Nm1pu2f5j83eOoezQ+XyM76JpwItr+AGHdWJ8uE22d+QL6fhH209WNH4QfSX9
 IMw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Aug 2021 19:26:52 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v4 5/5] doc: Fix typo in request queue sysfs documentation
Date:   Thu, 12 Aug 2021 11:26:26 +0900
Message-Id: <20210812022626.694329-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812022626.694329-1-damien.lemoal@wdc.com>
References: <20210812022626.694329-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a typo (are -> as) in the introduction paragraph of
Documentation/block/queue-sysfs.rst.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 757609bbb1e2..25f4a768f450 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -4,7 +4,7 @@ Queue sysfs files
 
 This text file will detail the queue files that are located in the sysfs tree
 for each block device. Note that stacked devices typically do not export
-any settings, since their queue merely functions are a remapping target.
+any settings, since their queue merely functions as a remapping target.
 These files are the ones found in the /sys/block/xxx/queue/ directory.
 
 Files denoted with a RO postfix are readonly and the RW postfix means
-- 
2.31.1

