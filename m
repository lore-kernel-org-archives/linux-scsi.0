Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F84DC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 09:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbjFHJ4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 05:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjFHJ4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 05:56:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351932706;
        Thu,  8 Jun 2023 02:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD26164B8F;
        Thu,  8 Jun 2023 09:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDF3C433EF;
        Thu,  8 Jun 2023 09:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686218158;
        bh=orvAfFB1al0I5E+N/dd1jRm8DcYqs+dBcPiT7570GoU=;
        h=From:To:Cc:Subject:Date:From;
        b=em1GgHm/m1aDnLB+lun7eRnUfT6i4/d2dLvOdMF+XQNgGvWubkwMDp6z0VCQ5jJ7Y
         5cHgvYWBbaFu9ISmmsxBI9Z2IkQE7Gu4rrhdXrZYRv0yTC5pNnIROo6v703i9t2XGg
         ZsGWDsrR1aEDsqoS9UU0zgVFiiiD1xkDTd7Bqm+oWwDa5CfDq9q5J964FYUrjVUM3D
         MKdXP/XdNCLqWrFaWgUX8Oo9Nf4KdL+jPb3licINBAZSpOPOwADLAJahUio98R1AXg
         565v45NVV4KLLihtDz8h3wIxIE2Uj0LqhkoFBseDATInLymdQm6GWx7YGzSOe4QZM4
         qQ/yNIGaK1eRA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH RESEND] block: improve ioprio value validity checks
Date:   Thu,  8 Jun 2023 18:55:56 +0900
Message-Id: <20230608095556.124001-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The introduction of the macro IOPRIO_PRIO_LEVEL() in commit
eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
results in an iopriority level to always be masked using the macro
IOPRIO_LEVEL_MASK, and thus to the kernel always seeing an acceptable
value for an I/O priority level when checked in ioprio_check_cap().
Before this patch, this function would return an error for some (but not
all) invalid values for a level valid range of [0..7].

Restore and improve the detection of invalid priority levels by
introducing the inline function ioprio_value() to check an ioprio class,
level and hint value before combining these fields into a single value
to be used with ioprio_set() or AIOs. If an invalid value for the class,
level or hint of an ioprio is detected, ioprio_value() returns an ioprio
using the class IOPRIO_CLASS_INVALID, indicating an invalid value and
causing ioprio_check_cap() to return -EINVAL.

Fixes: 6c913257226a ("scsi: block: Introduce ioprio hints")
Fixes: eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/ioprio.c              |  1 +
 include/uapi/linux/ioprio.h | 47 +++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index f0d9e818abc5..b5a942519a79 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -58,6 +58,7 @@ int ioprio_check_cap(int ioprio)
 			if (level)
 				return -EINVAL;
 			break;
+		case IOPRIO_CLASS_INVALID:
 		default:
 			return -EINVAL;
 	}
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index 607c7617b9d2..7310449c0178 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -6,15 +6,13 @@
  * Gives us 8 prio classes with 13-bits of data for each class
  */
 #define IOPRIO_CLASS_SHIFT	13
-#define IOPRIO_CLASS_MASK	0x07
+#define IOPRIO_NR_CLASSES	8
+#define IOPRIO_CLASS_MASK	(IOPRIO_NR_CLASSES - 1)
 #define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
 
 #define IOPRIO_PRIO_CLASS(ioprio)	\
 	(((ioprio) >> IOPRIO_CLASS_SHIFT) & IOPRIO_CLASS_MASK)
 #define IOPRIO_PRIO_DATA(ioprio)	((ioprio) & IOPRIO_PRIO_MASK)
-#define IOPRIO_PRIO_VALUE(class, data)	\
-	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
-	 ((data) & IOPRIO_PRIO_MASK))
 
 /*
  * These are the io priority classes as implemented by the BFQ and mq-deadline
@@ -25,10 +23,13 @@
  * served when no one else is using the disk.
  */
 enum {
-	IOPRIO_CLASS_NONE,
-	IOPRIO_CLASS_RT,
-	IOPRIO_CLASS_BE,
-	IOPRIO_CLASS_IDLE,
+	IOPRIO_CLASS_NONE	= 0,
+	IOPRIO_CLASS_RT		= 1,
+	IOPRIO_CLASS_BE		= 2,
+	IOPRIO_CLASS_IDLE	= 3,
+
+	/* Special class to indicate an invalid ioprio value */
+	IOPRIO_CLASS_INVALID	= 7,
 };
 
 /*
@@ -73,15 +74,6 @@ enum {
 #define IOPRIO_PRIO_HINT(ioprio)	\
 	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_HINT_MASK)
 
-/*
- * Alternate macro for IOPRIO_PRIO_VALUE() to define an IO priority with
- * a class, level and hint.
- */
-#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)		 \
-	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
-	 (((hint) & IOPRIO_HINT_MASK) << IOPRIO_HINT_SHIFT) |	 \
-	 ((level) & IOPRIO_LEVEL_MASK))
-
 /*
  * IO hints.
  */
@@ -107,4 +99,25 @@ enum {
 	IOPRIO_HINT_DEV_DURATION_LIMIT_7 = 7,
 };
 
+#define IOPRIO_BAD_VALUE(val, max) ((val) < 0 || (val) >= (max))
+
+/*
+ * Return an I/O priority value based on a class, a level and a hint.
+ */
+static __always_inline __u16 ioprio_value(int class, int level, int hint)
+{
+	if (IOPRIO_BAD_VALUE(class, IOPRIO_NR_CLASSES) ||
+	    IOPRIO_BAD_VALUE(level, IOPRIO_NR_LEVELS) ||
+	    IOPRIO_BAD_VALUE(hint, IOPRIO_NR_HINTS))
+		return IOPRIO_CLASS_INVALID << IOPRIO_CLASS_SHIFT;
+
+	return (class << IOPRIO_CLASS_SHIFT) |
+		(hint << IOPRIO_HINT_SHIFT) | level;
+}
+
+#define IOPRIO_PRIO_VALUE(class, level)			\
+	ioprio_value(class, level, IOPRIO_HINT_NONE)
+#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)	\
+	ioprio_value(class, level, hint)
+
 #endif /* _UAPI_LINUX_IOPRIO_H */
-- 
2.40.1

