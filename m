Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188D0C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EB564EB8
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhBTVmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:42:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43957 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhBTVmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857328; x=1645393328;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Def7Pmhe7nl2nwbzkNC0E/C7Ibx8KE9SjYFMt9IMIQ8=;
  b=O/gC0jdY4mjRQ4rb1NSfeuW6uHBw+B7h4UYP+kWSYtmE8zSNKP1TFBzy
   sLp7GeGUVQL2shL/K3Wxp0O7SL7bNzZkTcoLJ73J+xnrrwgehANVfakRg
   ABV7dT3M2pVTyv7+90aWR/wkDpS2Z6z2cd6K6F/z/vrPR0gOC9GtAkGk1
   v/YB/CLWUoxgyGCl3o8H9fZhM5y2F1ov0Hz5RWGQYf2F4xWI80rGUKPKH
   9qbYEPvUgpZLFUKXKNu5uRP5VJ7RhWwpdufZrCnbUBy9hNxPjK/Vm5t2S
   NYkphiVfxprPpg8IwzxXJiL6rD2DIR4BiFYWbKTGkqdkhal08I0C8A81N
   w==;
IronPort-SDR: XIOoOtoXxSIy8h6GQ/An6Bv5efVk6rXOW6MX9YUJO/eSL9mhBso3FFT/95AmTSyRmW/mt8eWEA
 B1gzqT39ZqRWEORMQxyqN0uUzT6nc5FsdcjVyEeAUuCFvRUSVQOHIwLLcl1nJfbr4YHuyDaWV0
 msWilK27gfILeo4vSWl4XbsiCo2ojOhVbGGH9S1LwOVQ7xmpE4CVlyozRT4kfWK76UnXg4UStK
 gh4BSwnVBdeW7CqHy1ZksZVOC4+BuIiBl0OBrI2Fv1qhls/j+xiul6nbe2NEXctMbCnuT1rQom
 DOo=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591334"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:41:03 +0800
IronPort-SDR: FYoqzbCza8IYlHQ9vIcaSEzKknV+dCEYvhBVFy5LKegOkUn2chGChAbR3evEt0fjW5RPe4vZNM
 J4hlMxqOinw/iF1h9Nvsxgw8oqSHVCjYzbkFM0soHO1RZIDXT24WDx3LmWygPcOrESa6zWB6TL
 QABv3XH8UPXi5s2iwfk4U3j996dUptUjeNLlKCw+fzC1sZ1A6tZGUBveC9TY5W1UYZI/gVnUgz
 fB4YPbpzXVm1DyHQzCL1mucghIMhS2XOx35Eg49QjNK4YWfPUm2eBsSftAcGZHuTZ/izlKCsYQ
 viX5lz4yK7J3FQbtv1p5Cxdp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:24:25 -0800
IronPort-SDR: f/K98XIfX44U0e1IbSwX9nDfDJ1oBRiljHktNPvawWlQ8mAcnCEI2nTNVlakW3AWXcxoR932Dv
 gyw6hXAtK4iJqqhoIFNrSJxuSyQ9KFQviSZqLJhUDstlWPJm30faUwQb7LPVjgPyBqhexcrTAY
 1bDqz4MgFW+mQOpH31/6PT/Fw+6LiGlwJ30VSCe+xW9sWUPl6EBr3WOtKD92iP8jbPREuCcg1p
 2CqO2WKDoQ8jvVo+bCX/DWh0fNH5/nERDBTOzxxcd6kZyiCQoAGsYKGKnZesw0yxnreHwV4YX9
 /OU=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:41:03 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 23/24] target/core: don't duplicate memset 0xff
Date:   Sat, 20 Feb 2021 13:41:02 -0800
Message-Id: <20210220214102.7425-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index cce455929778..3ea5c879d15a 100644
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

