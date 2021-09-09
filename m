Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953A5C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7A06101A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348203AbhIIChL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:37:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42529 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbhIIChC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 22:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631154954; x=1662690954;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=3JeErjhCOeicdhDxDeTDah+4oAV2vjbhTuPsGM0V3P0=;
  b=MtitKjQxrqFuhpNYgm87CQNuLvdcxNrnV9J3vovzO1mKEtTH3SiVjxud
   YhML5HG/Lch3xd4I/vwbcZTKkpcpd8+nDXteGR4ph1hhPQexyPaBcut8D
   RhM/xCmHpl0fltahJkJfWQdMqBkFJPDRv4XrRyLnQ29L1RCsPtaGQ6jAO
   htOfDVHbtOFIBnATj+QXc9RXdmewG82+mT3zLqCDeuqC6g+fMtyRDd8Jl
   kB6+aMHtrjCyZGKmv3nvrZggxJ/2qBm7twSIytT7zBQjXUvb2ifCXiRkt
   yinoqpWXW4NFLWcvt27ybeIytXcfEdEAdN8/QOvGbGGNcl77ZtidpW8p7
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="180062219"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 10:35:53 +0800
IronPort-SDR: EXYvubKZgZJpPiq+j2YPIuOWpFkDl3SZ2tazwzFMyGRQUt4CdP+BiAOaGUIlG9JDnjA9QuNny3
 ztbqfJ5Qk51xjmtNweUJzhETollwpMU8o+nkU8uie36XK/5giFXoLrhTMFSJywFg2wdJQRgeDK
 4ct0haURdnG0dtIm7hGGnzH33c3Ca/ie0nadN9GVQTH9vQPKLDEBVO7GIfvJCZlSRRjiRvZpng
 t3zIOMNEGHyeqYn+GiSHBtVKH40To3KFxlpLUCJzQnxmUf2oiOh7R4M/0FM6C+0a2ndsLq5ceO
 WVFsaHXbgDgrgLdkQKf1udMe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 19:12:28 -0700
IronPort-SDR: mR7H0Nr8Gkjfb5QWSVCaYbWG5kQ/0nkzNG0jw7yK8YkHxz9HsSGaX5s4FEeoLrhzKNQiIt7027
 HEjcghKhYl0bSNyxZr/4Ppw2EnGn+mzUwVVUsahQwhB7ySpkwrgkG69X6RbfckKGp+qER3GyMa
 KLcjiFlEQ//rI2h+qYM+n5ai0mD1lb75+cImfHLIJpN5sXQbRjx6m9rcG/Ng+OWNyUtuQUmhl1
 3QtE4K1b6tHZZWY8BJ9ZPU3SRTdSy1cUiOTFk7Huc4MRXb3lMAQ1Kysh7yN/reVvF+dKqzt83B
 AVY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 19:35:52 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v8 5/5] doc: Fix typo in request queue sysfs documentation
Date:   Thu,  9 Sep 2021 11:35:45 +0900
Message-Id: <20210909023545.1101672-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a typo (are -> as) in the introduction paragraph of
Documentation/block/queue-sysfs.rst.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/block/queue-sysfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index b6e8983d8eda..e8c74306f70a 100644
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

