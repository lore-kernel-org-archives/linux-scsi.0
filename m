Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C2DC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0925060725
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbhH0Hv6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:51:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42493 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244534AbhH0Hvl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 03:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630050652; x=1661586652;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=KLnIFkGLgwZ03ml7AypC27RGZyBe1s3zdaw+yhWbdmA=;
  b=IB8Ie+VrDkGHSnGD7cN7Nw+YWDyNOjzNj8dpK5PRUuneeGtUOlnhNAvN
   f/a4/6nwYWMlWdPqV/DRjgB508U5xnQp7oFqTlyXHQ/1vDlGZWBbTDJK5
   oB9m0vdhPFOBninz9ETkay1tqIwRJNqjcPZ7hOAGp+UbiI8u7mnV1qJKn
   qS7Qou1E+5e17FB2SjTJzdlaf6dzWBc8RUBEgf8fJl+ldQljvvrOjIe6/
   VnJ05tAZW25xcwypp7j40elAeuNUjCsBm9waMWqYHG+rr1shwijIJRJW0
   dMeN3ZiYRHjnYIoKSDffNkdkhajfBmbecE8HZKvhHBZsDHbY786AAbqjv
   A==;
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="183342797"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 15:50:52 +0800
IronPort-SDR: A6FSCnJb0cgdm2npNxWIHDQbQ+Xt4YEJdGE4/K5bPlwXjpCp8K6LgoZvi0NDlJxvh3WW8snOM9
 s8PGEwTzDrjq6LD8HGWg4SYZwL5E6iYOr91P9VpCjAfiCfBcjiT2wWZalemAuBxrK4amhG68yt
 nttBh2HGatPbpCb1kHUq7PH/iUkgbcwA5rO6pNJk5V7SJYZrZA+DY769VM7Mw3TCg8xDRl+ivp
 pyTa6/268F0pY59rzUDPY8jBHJYSrQpJug51s0zrFDaz7QdnFk6uQYa8mgjpnojLIj0uUUrrri
 4bX0v2AQiu1rwTJIw4D0JvOA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:26:05 -0700
IronPort-SDR: GH4lzFBNTInV6OQROMZHSVXJnjzOpbAaoVHEkHHead8JnSqBuVKuhw4EVu+ZZOPlwxHcg1UMd5
 zHSMdxF9iAaIiry/vXFAyq5JPwHkeShZe2qVo4/rQJlNndFryZNl01z1j9g3RffjaM9TSuu3z7
 XDXAkAVOzEk2n8Gz9y3DmoVqNfz38Xvr3JgVHv6wx/Nac9Qhrc4Mz+6GdsmQ4GXPLbVH4khqpj
 6+oXd1gJM5B9v/9eVH5eWCyYm7pAsElB3ZbCIHNh4s5GhYWYUf+MNzjliJhI+1zDMo0KIP+IsO
 h80=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2021 00:50:52 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 5/5] doc: Fix typo in request queue sysfs documentation
Date:   Fri, 27 Aug 2021 16:50:44 +0900
Message-Id: <20210827075045.642269-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827075045.642269-1-damien.lemoal@wdc.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
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
index 17eef55434e7..f4cf9e20f878 100644
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

