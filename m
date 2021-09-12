Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A82C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 21:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 559496108E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 21:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbhILV7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 17:59:01 -0400
Received: from tartarus.angband.pl ([51.83.246.204]:39842 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhILV7A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 17:59:00 -0400
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 17:59:00 EDT
Received: from 89-73-149-240.dynamic.chello.pl ([89.73.149.240] helo=barad-dur.angband.pl)
        by tartarus.angband.pl with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mPX5I-00C2fQ-2B; Sun, 12 Sep 2021 23:32:21 +0200
Received: from [2a02:a31c:8245:f980::4] (helo=valinor.angband.pl)
        by barad-dur.angband.pl with esmtp (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mPX5H-0003DR-9h; Sun, 12 Sep 2021 23:32:19 +0200
Received: from kilobyte by valinor.angband.pl with local (Exim 4.95-RC2)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1mPX5F-0003Ae-7j;
        Sun, 12 Sep 2021 23:32:17 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Sun, 12 Sep 2021 23:32:11 +0200
Message-Id: <20210912213212.12169-2-kilobyte@angband.pl>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210912213212.12169-1-kilobyte@angband.pl>
References: <20210912213212.12169-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 89.73.149.240
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH 2/3] scsi: aic7xxx: explain a mysterious build failure message
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

"*** Install db development libraries" doesn't ring a bell that it's talking
about libdb (Berkeley DB).  Because of BDB's relicensing to Affero,
incompatible with many users including Linux, most if not all distributions
can be expected to keep version 5.3 for the foreseable future, thus we can
point the user directly to libdb5.3-dev as the package to install.

(This patch was written in 2017 -- since then, distributions are getting
serious about dropping BDB).

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/scsi/aic7xxx/aicasm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index 243adb0a38d1..635a2d52dc37 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -55,7 +55,7 @@ $(OUTDIR)/aicdb.h:
 	 elif [ -e "/usr/include/db_185.h" ]; then		\
 		echo "#include <db_185.h>" > $@;		\
 	 else							\
-		echo "*** Install db development libraries";	\
+		echo "*** Install BerkeleyDB development libraries (usually libdb5.3-dev)";\
 	 fi
 
 clean:
-- 
2.33.0

