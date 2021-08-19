Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500CDC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 01:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 346D660F35
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 01:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhHSBdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 21:33:51 -0400
Received: from condef-01.nifty.com ([202.248.20.66]:51337 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhHSBdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 21:33:50 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2021 21:33:50 EDT
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-01.nifty.com with ESMTP id 17J1OFgS027628
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 10:24:15 +0900
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 17J1Nf9E029141;
        Thu, 19 Aug 2021 10:23:42 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 17J1Nf9E029141
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1629336222;
        bh=u7VXmFiubP5hKc4oyVUhxWbfNwjGL985+TRSCNYe6p0=;
        h=From:To:Cc:Subject:Date:From;
        b=QQnLhu8PTwS9XiIauW92ombkvknDXdVXmOWWaYZn2S5AzOkb9Eo2rN/lUepFQTT4h
         P99Qq0phOMiWMI1Nzq2hg3Xv5DQBqxJGK6+cYYfObKE+wf1ZeK4zZoCa9n6PkIdbT5
         gMatfFxiNEAECpBfW0GhEYhYdYg//bhqfv5d+Q+/QeLxF7jfZ59NPw2JtD0feAUFCz
         geSpIU9KD30x22XY0d0W+rwgPx4MATI+5PQWBxxN34+zA8dzDSY3GKOAuQOk+xO/yV
         LKGA+kXWqf+TEqXGhGjZ3ySSZoCZExTIl5QUFidjWyR4AfOG4yh37Hae5HFFeHUGdA
         KL/xItwBQ2P0A==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fix missing FORCE for scsi_devinfo_tbl.c build rule
Date:   Thu, 19 Aug 2021 10:23:39 +0900
Message-Id: <20210819012339.709409-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add FORCE so that if_changed can detect the command line change.
scsi_devinfo_tbl.c must be added to 'targets' too.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/scsi/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1748d1ec1338..77812ba3c4aa 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -183,7 +183,7 @@ CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 
 # Files generated that shall be removed upon make clean
-clean-files :=	53c700_d.h 53c700_u.h scsi_devinfo_tbl.c
+clean-files :=	53c700_d.h 53c700_u.h
 
 $(obj)/53c700.o: $(obj)/53c700_d.h
 
@@ -192,9 +192,11 @@ $(obj)/scsi_sysfs.o: $(obj)/scsi_devinfo_tbl.c
 quiet_cmd_bflags = GEN     $@
 	cmd_bflags = sed -n 's/.*define *BLIST_\([A-Z0-9_]*\) *.*/BLIST_FLAG_NAME(\1),/p' $< > $@
 
-$(obj)/scsi_devinfo_tbl.c: include/scsi/scsi_devinfo.h
+$(obj)/scsi_devinfo_tbl.c: include/scsi/scsi_devinfo.h FORCE
 	$(call if_changed,bflags)
 
+targets +=  scsi_devinfo_tbl.c
+
 # If you want to play with the firmware, uncomment
 # GENERATE_FIRMWARE := 1
 
-- 
2.30.2

