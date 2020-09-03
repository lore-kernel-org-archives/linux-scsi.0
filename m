Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34453C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052752072A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 05:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vb9/O451"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgICFlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 01:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgICFlJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 01:41:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C067FC061244;
        Wed,  2 Sep 2020 22:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=DmDdOH2GuMXK9+IF4MdnFjGWJaJyD3Fj7/WXKJYHW9U=; b=vb9/O451zA77olU1cVJYN2ZSTO
        2Zi9qkdCcM11VPBQSa0DuIemmhHGqyBGFvr/7cV952tgFjK+BJSSS/BejgM+h1OCLziqHFb09TNFq
        JH0eIlO4Hic4v8gIAPeme397lsJTTbGC0+eMwHsMGK2NiPa8cHzsh7KyzmYTzkhYnhivyjUx1VZTM
        DQlsrwznsCxQVugj0bXBMI88ybgjkfq/v50PWHu3STIGvr/Yxze9dbtV88UhgbzomVmvpaWQiONJT
        veFJDAdAaRZ6O4VfVBHWrHU6RJunJOVm9B7BO70FHnPK7UFAAwJr1Vc+pZADrKGyhnpe0kfQvxid7
        RpbdcSAg==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDhze-0007OE-HE; Thu, 03 Sep 2020 05:41:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 1/9] Documentation/hdio: fix up obscure bd_contains references
Date:   Thu,  3 Sep 2020 07:40:56 +0200
Message-Id: <20200903054104.228829-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

bd_contains is an implementation detail and should not be mentioned in
a userspace API documentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/userspace-api/ioctl/hdio.rst | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/userspace-api/ioctl/hdio.rst b/Documentation/userspace-api/ioctl/hdio.rst
index e822e3dff1769b..817371bf94e948 100644
--- a/Documentation/userspace-api/ioctl/hdio.rst
+++ b/Documentation/userspace-api/ioctl/hdio.rst
@@ -181,7 +181,7 @@ HDIO_SET_UNMASKINTR
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
@@ -231,7 +231,7 @@ HDIO_SET_MULTCOUNT
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range supported by disk.
 	  - EBUSY	Controller busy or blockmode already set.
@@ -295,7 +295,7 @@ HDIO_GET_IDENTITY
 		the ATA specification.
 
 	error returns:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - ENOMSG	IDENTIFY DEVICE information not available
 
 	notes:
@@ -355,7 +355,7 @@ HDIO_SET_KEEPSETTINGS
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY		Controller busy
@@ -1055,7 +1055,7 @@ HDIO_SET_32BIT
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 3]
 	  - EBUSY	Controller busy
@@ -1085,7 +1085,7 @@ HDIO_SET_NOWERR
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY		Controller busy
@@ -1113,7 +1113,7 @@ HDIO_SET_DMA
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
@@ -1141,7 +1141,7 @@ HDIO_SET_PIO_MODE
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 255]
 	  - EBUSY	Controller busy
@@ -1237,7 +1237,7 @@ HDIO_SET_WCACHE
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
@@ -1265,7 +1265,7 @@ HDIO_SET_ACOUSTIC
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 254]
 	  - EBUSY	Controller busy
@@ -1305,7 +1305,7 @@ HDIO_SET_ADDRESS
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 2]
 	  - EBUSY		Controller busy
@@ -1331,7 +1331,7 @@ HDIO_SET_IDE_SCSI
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
-- 
2.28.0

