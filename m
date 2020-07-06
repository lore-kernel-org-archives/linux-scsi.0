Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE213C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF43520715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mpz8vB3R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgGFMdy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:54 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMdy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038834; x=1625574834;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gnPXzBFWtlmUJUaYSaiOxtdE3FpOzp8I0AYuL/PA/Z0=;
  b=mpz8vB3R5aSSXPe4PuPR9KmfnWoiavZvtMufBMzEuuBKvyJhieNtICoN
   3BpKE0upm77JvhoOJRG1G9U88jdWVtirYXKxixur9CZ4c0KF2ImLbCwoW
   KTdOuP4xcuHad7zVUlBFb9o9/12kO9kpNavD154sKE0fx8zhtcbYa9Jkv
   zjOU0avQm+8ip2gY7L0juvpSLre/EnR9v/6pkZqVJm+GVrY/DB3eH/khz
   FWbACxsGU492GV8Qq4a87e3xRjEytp7PulL4vOqMPRAxXfE3X/VDBJFVM
   5gL5WB0PaydL/fQG+ENGz3IA+5TEO+VccRurc4d+NLK0ebe8feAWXuop6
   Q==;
IronPort-SDR: eakyinCsle7rNqcybtfTew7Lxsn4pQRI/2n4CdHm8Dl3mL0Z9GfoP67WO2Ny7oHQ8EGn+Rqrjg
 C3J1mcAwzcxF+JyvmlsTj8MDlhqTf7QA9qPIRMPlzu/lNPMBgmSBdNlRpWT7h+nfS7ZN1OAQDh
 TFuV5Zl8ldc3496dwTxO0lpKjGE4r6q4A95ceUDy2K7ckqNkgTY4onioh+AHA/49lL6B6FAugm
 BVGjEK7vxXU/M0oeQr01aB4xVKMLKIQCOlbyCEwK/iknsgXEgRVVfwVQy66ZG4qrnrb5zTiMZt
 aGQ=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052066"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:54 +0800
IronPort-SDR: EhXZzuk+MIe3jkT1WJwIK+Y+nF+CmGYZWZGzSMcMYJLPU31pdqMPOlSEDLniqIEjVnj73l50Br
 Som+SOiKA8L5tiOrbVwMLfnkrBpy6bPmg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:22:02 -0700
IronPort-SDR: 8PPRyk9J6oqi+00HDsnqBmRRYO72wB2It9X0NqaonLBSs+OqQTsRhqWL8xQg2GpyY7B5xNrRwk
 8X5Arw1r5Obg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:53 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06/10] scsi: megaraid: Remove set but unused variable
Date:   Mon,  6 Jul 2020 21:33:52 +0900
Message-Id: <20200706123352.452003-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mega_is_bios_enabled(), the variable ret is set but unused. Remove
it to avoid a compiler warning.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/megaraid.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index acd7c6ed77b1..0484ee52ae80 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3571,7 +3571,6 @@ mega_is_bios_enabled(adapter_t *adapter)
 {
 	unsigned char	raw_mbox[sizeof(struct mbox_out)];
 	mbox_t	*mbox;
-	int	ret;
 
 	mbox = (mbox_t *)raw_mbox;
 
@@ -3584,8 +3583,7 @@ mega_is_bios_enabled(adapter_t *adapter)
 	raw_mbox[0] = IS_BIOS_ENABLED;
 	raw_mbox[2] = GET_BIOS;
 
-
-	ret = issue_scb_block(adapter, raw_mbox);
+	issue_scb_block(adapter, raw_mbox);
 
 	return *(char *)adapter->mega_buffer;
 }
-- 
2.26.2

