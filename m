Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428C4C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13CF164E54
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhB1GBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:01:46 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30790 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhB1GBg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492095; x=1646028095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xtQnv3V07SWR9jK26U/cYEcspOo5BaukAClUamTYQao=;
  b=h9tLIlrhalIjxcqQ/Si/wxiUc2aBclpuoOlNiTVp5M2QqUpftN94JuoT
   wZCCmOL1kxlVlTwAArj4EkSl43dEEZHIQ1dzOq6scy4lBHke/FBecY7fl
   cUm6RbyjyrrieO1Ib7zfixysrb3xm1HQ9e1Zf0yWE/tkAuuVW4pzhTelD
   bqDziA4NXbiEJnPU8zCOqQIIfQbgYB8YKL1qbiDG/ohcJjiFjRELZCCvo
   1IMcqV4Oi9ystV0He+PTTk8FKvPIWppdaVtvWYFhi+tVaqeJQXS4GkUH+
   cO1ANhldzAOMC3XlMNILO2rOil8Fw3yF9orudkaU3ratGbvvLIeFJcTQD
   A==;
IronPort-SDR: tOUScKfnEW/ZZ6LlKdvuoYfKu2X1UP8359z9PCcAu7g47BOnZuap+BjZ7KnVHqstmOzSSDOz/L
 K6wO739GNLRJBdPL2d8wSv9Zfdcr6mgSltqkrd1itvYwZLUSo1kF64t+MG8sODYLdq2vbENpWi
 F1y17AmB4NMFYa+k9BH9VaBCNY/Hzqiehp53KXZglivQet2GkGzEHSknhSB+mKqihJ9oLuSIC+
 NqOVxqrDfF9fJREyAxbEg3ZIQWAy9TWxCfXrX2DK3ZSk87JwBb0WwHi8544TMYIEEJa0WtNmd2
 314=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="160973086"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:00:33 +0800
IronPort-SDR: goUMcAYGdcCq3YsdCLKX02O2KC1L5A0c6nhC4q58lTehz463wcbGTmKNTa8OwfX53iDP7/LXbE
 dk3uTTAmv9TfHOMEebAY/KW6Gjl1ViZEBKkJDlpxgPcI7L8AVTsq8Rh/9cMk7Sbk4QIZPXGbbb
 Wz0+84HxK5Fm+NX0HSTgXGR2WKLVaWleGqDcrIJy//JHtfpR4DWvKL5R0CWvGvAHpsch8290pp
 dy7JyisJjTMBbKZlctBdumoPtrOHnCRM49Dht3REWv84YwOobmxRczjB4rlBxxPZbTy0TrCJlu
 C0NMz+YBvAXddsvAqEOeVGDF
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:41:51 -0800
IronPort-SDR: JamS46YIsxrQudnalu4I0e/yXjsSucaG7mpJCvZac3RrtXAbFDsxx/ZelHF/QOQNQh19HR62J6
 v6kmcQsgMPkD7h2Hz7q5gSWyo8Awo2jIwlkveDQ1R6EfV4DikySY9yCqK5YvwVpjxIXILrPE2b
 gw4o9fT/Xs+O35ESZDGEYzaXetC0ewQqIoRxIGJ0xU2Iu5f6hkabMlfGQGzqk5QizrXu7RrcVg
 +UOXJqqscQ9vDpAoKnwzE5vZfm+BCP7Cnmg5HJoAyZFn0Dw+9A1tmhxWX1xRK+kU+mXlYTUfE0
 Egk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 22:00:33 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 23/23] target/core: don't duplicate memset 0xff
Date:   Sat, 27 Feb 2021 21:56:45 -0800
Message-Id: <20210228055645.22253-24-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function fd_do_prot_fill() is called from two callers
fd_do_prot_unmap() and fd_format_prot(). Both the callers initialize
the passed buffer with memset to 0xff with its length.

Instead of duplicating the memset call, move the memset call to the
fd_do_prot_fill().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 5a66854def95..ef4a8e189fba 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -498,6 +498,7 @@ fd_do_prot_fill(struct se_device *se_dev, sector_t lba, sector_t nolb,
 
 	prot_length = nolb * se_dev->prot_length;
 
+	memset(buf, 0xff, bufsize);
 	for (prot = 0; prot < prot_length;) {
 		sector_t len = min_t(sector_t, bufsize, prot_length - prot);
 		ssize_t ret = kernel_write(prot_fd, buf, len, &pos);
@@ -523,7 +524,6 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 		pr_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
 	}
-	memset(buf, 0xff, PAGE_SIZE);
 
 	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
 
@@ -882,7 +882,6 @@ static int fd_format_prot(struct se_device *dev)
 		 (unsigned long long)(dev->transport->get_blocks(dev) + 1) *
 					dev->prot_length);
 
-	memset(buf, 0xff, unit_size);
 	ret = fd_do_prot_fill(dev, 0, dev->transport->get_blocks(dev) + 1,
 			      buf, unit_size);
 	vfree(buf);
-- 
2.22.1

