Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA0CC433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 11:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4615D205CB
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 11:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgGRLa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 07:30:27 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:50464 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgGRLa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jul 2020 07:30:27 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id D8FD5BC095;
        Sat, 18 Jul 2020 11:30:22 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     linux@highpoint-tech.com, corbet@lwn.net, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] scsi: hptiop: Replace HTTP links with HTTPS ones
Date:   Sat, 18 Jul 2020 13:30:16 +0200
Message-Id: <20200718113016.15647-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spam: Yes
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 Documentation/scsi/hptiop.rst | 2 +-
 drivers/scsi/hptiop.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/hptiop.rst b/Documentation/scsi/hptiop.rst
index 23ae7ae36971..1a6900b456c0 100644
--- a/Documentation/scsi/hptiop.rst
+++ b/Documentation/scsi/hptiop.rst
@@ -212,4 +212,4 @@ Copyright |copy| 2006-2012 HighPoint Technologies, Inc. All Rights Reserved.
 
   linux@highpoint-tech.com
 
-  http://www.highpoint-tech.com
+  https://www.highpoint-tech.com
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 6a2561f26e38..3299624e41ce 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -5,7 +5,7 @@
  *
  * Please report bugs/comments/suggestions to linux@highpoint-tech.com
  *
- * For more information, visit http://www.highpoint-tech.com
+ * For more information, visit https://www.highpoint-tech.com
  */
 #include <linux/module.h>
 #include <linux/types.h>
-- 
2.27.0

