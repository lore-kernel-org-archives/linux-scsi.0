Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9A6C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FDA964D5D
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhB1F7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:59:14 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1337 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhB1F7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:59:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491947; x=1646027947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jlnYlB7KkBVHxXDXY5DxM2q8kiiMAJP13pVGde6cMSM=;
  b=ijRLk9SSokZLIuy1WLt9xwJCkTUXRFawl+xheS8vhFkcTPu4NuE8wb0X
   SpD3kDWwXMRxU0L2cw5cgZRIIiUj9N0VaP0X33wq9GjgAEI3MqRAAYnrn
   dAKyEAP506nTSLuE3UqCWzLV2nu1XSG4c73M3ICsBoaIRc4T4iephAzdR
   gJSvdwKyhVWCtJS4UseAl/r+9SqcWnXRH88lXeS6I/zh8ukwQ3XnIi0sR
   O6zkJSTqe2MrqmMgWKNR2TMMgNBX0QxwT0j3lyOnxptWAsBX8XKFiJCl8
   o3weO2IcXPWSx2OkXoNorFGX5YeccLpOHm4PB0bQZ8DV2wUi64sJW+04R
   Q==;
IronPort-SDR: cw0BfvLGwNTtqULfoeZu4CHdHnCwTrFjqH1W4eZ2kixnK/sSYjgkWFB9qexuzGqbfuujymbkWd
 YjucrWMuhjwRPlUuyBqBFz5PzK2r7vHnU3nhe1MHilMKxMzDICgJXAKfcTGxDL/nmPVtzZV1UE
 QePWLUwWzFaj1AU7/lzuy4N12yX6hj9QNnD1Cx9+cY4Mma2mwFdgB35HLzybXWVJVQD/k0mEFk
 ILdMdtydpph53GGtztzkuAtcSVOeqip0DW1a10mJ6CNVaFu6xn7j22aY5BCED+OUReBFuBMsjw
 kzo=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564078"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:58:17 +0800
IronPort-SDR: 7MKI43X742fkPF4t8ltBPPOUqdrqSX+N0ktSFCLyeEMkQHJTqAWr+a8qKXWIM5vrBktedfLTwG
 Lh4ZtdSZOtXROkF75WD2EPilN+W08HyCFc+EpPaONelvhIDP63fT+Uot2kOoY7xzZ10DeRa86z
 gOuuePt4EgoAaLQPPHWPqxM41pO193GM3hDxuGWDHvzoRIiVMwt7pMDe7qVC0VEvvAHNgONryG
 YvXoeTjxyHtEbaQhngo3Y3Tat9cGnKdgvq8IKlm72ci1AATeVG1iUvtYy1L+XndYdLaM2kPpIC
 IkWqI2szF96CKik560udggjH
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:39:36 -0800
IronPort-SDR: vlg45nhZbx3XPbsLO8fq+IjFknI7UevZ2WZDK13r6q29xQhJtafrr7DRev9seq2qtg3qbtzwo1
 dhc7TO2WWIWqBrOuWvRWdOhWjvXSm2lE7EyS5k35Z82Ds9W8gaMNVEhc2H/kstBO/0WbtAj8bw
 Tq5e6GV7KiYfaSb5UqStP33DS7OdVJzEjRIR5BmQMI+gQaGz+eiEEzQysVQDE4XnIZnH4V/65K
 4aPJYoDcAgZvZ+J8z2qUVU4V1oRGsX8Hrlrc9xdxXPz2UJv1TLPg2ut/ey9KhaAlfr6kY9vyWh
 x/A=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:58:17 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 08/23] target/stat: remove unsed macro NONE
Date:   Sat, 27 Feb 2021 21:56:30 -0800
Message-Id: <20210228055645.22253-9-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the unused macro that fixes the following compilation warning:-

drivers/target//target_core_stat.c:34: warning: macro "NONE" is not used [-Wunused-macros]
#define NONE  "None"

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_stat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 2d2c7e377722..62d15bcc3d93 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -31,8 +31,6 @@
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
 #endif
 
-#define NONE		"None"
-
 #define SCSI_LU_INDEX			1
 #define LU_COUNT			1
 
-- 
2.22.1

