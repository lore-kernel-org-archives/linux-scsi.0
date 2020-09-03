Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D712C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC538215A4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OeSUI7+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgICIPn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgICIBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 04:01:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2ECC061245;
        Thu,  3 Sep 2020 01:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GAh0vVFEhCXA70kAe0Y+yEC9hZCV2ibXINKGKfT3XfY=; b=OeSUI7+01Hk0fPdyWoHh1ve1/8
        T4bqVIdsMN4WlAytBfIwpWMCsadyDFmkkqkaggRNNVC8TOH61LbRnYsCwndKj955Z8iHLr6+HqlOt
        z5fMTSuZ2YijCOtTDQUZ4kHpQEeqQZsc465afsQUcLUVpAIOPeQgoGTX9/lK5EWRPsj6om2T0NXfu
        z8ZF+LqrI69uIHLdJo2i0GLCPONoiFD9RdmKRGcXUPCLSZYg/y3kWmbRFd4IkKWmn1MNqeK+Uk6X0
        esb2Rqe2Zx7O43y4reLYAw9yfc8DCS3ztjnJfHGaKEWTtttNw5qITLSfuE1VI/GO/68JW8ugP2j7x
        cISEboJg==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkBV-0006aw-Jj; Thu, 03 Sep 2020 08:01:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 06/19] block: add an optional probe callback to major_names
Date:   Thu,  3 Sep 2020 10:01:06 +0200
Message-Id: <20200903080119.441674-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903080119.441674-1-hch@lst.de>
References: <20200903080119.441674-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a callback to the major_names array that allows a driver to override
how to probe for dev_t that doesn't currently have a gendisk registered.
This will help separating the lookup of the gendisk by dev_t vs probe
action for a not currently registered dev_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 21 ++++++++++++++++++---
 include/linux/genhd.h |  5 ++++-
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index d9ecc751fc956c..3abd764443a6af 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -399,6 +399,7 @@ static struct blk_major_name {
 	struct blk_major_name *next;
 	int major;
 	char name[16];
+	void (*probe)(dev_t devt);
 } *major_names[BLKDEV_MAJOR_HASH_SIZE];
 static DEFINE_MUTEX(major_names_lock);
 
@@ -441,7 +442,8 @@ void blkdev_show(struct seq_file *seqf, off_t offset)
  * See Documentation/admin-guide/devices.txt for the list of allocated
  * major numbers.
  */
-int register_blkdev(unsigned int major, const char *name)
+int __register_blkdev(unsigned int major, const char *name,
+		void (*probe)(dev_t devt))
 {
 	struct blk_major_name **n, *p;
 	int index, ret = 0;
@@ -480,6 +482,7 @@ int register_blkdev(unsigned int major, const char *name)
 	}
 
 	p->major = major;
+	p->probe = probe;
 	strlcpy(p->name, name, sizeof(p->name));
 	p->next = NULL;
 	index = major_to_index(major);
@@ -502,8 +505,7 @@ int register_blkdev(unsigned int major, const char *name)
 	mutex_unlock(&major_names_lock);
 	return ret;
 }
-
-EXPORT_SYMBOL(register_blkdev);
+EXPORT_SYMBOL(__register_blkdev);
 
 void unregister_blkdev(unsigned int major, const char *name)
 {
@@ -1035,6 +1037,19 @@ static ssize_t disk_badblocks_store(struct device *dev,
 
 static void request_gendisk_module(dev_t devt)
 {
+	unsigned int major = MAJOR(devt);
+	struct blk_major_name **n;
+
+	mutex_lock(&major_names_lock);
+	for (n = &major_names[major_to_index(major)]; *n; n = &(*n)->next) {
+		if ((*n)->major == major && (*n)->probe) {
+			(*n)->probe(devt);
+			mutex_unlock(&major_names_lock);
+			return;
+		}
+	}
+	mutex_unlock(&major_names_lock);
+
 	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
 		/* Make old-style 2.4 aliases work */
 		request_module("block-major-%d", MAJOR(devt));
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c618b27292fcc8..a808afe80a4fec 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -367,7 +367,10 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
 
-int register_blkdev(unsigned int major, const char *name);
+int __register_blkdev(unsigned int major, const char *name,
+		void (*probe)(dev_t devt));
+#define register_blkdev(major, name) \
+	__register_blkdev(major, name, NULL)
 void unregister_blkdev(unsigned int major, const char *name);
 
 void revalidate_disk_size(struct gendisk *disk, bool verbose);
-- 
2.28.0

