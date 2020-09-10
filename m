Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F470C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F120B20809
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NIInFlbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIJHs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:48:59 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63775 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbgIJHst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599724128; x=1631260128;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/Enw0bxROuh57kxKsP52N1Tlxw3lASJQr7vvPQRxKmk=;
  b=NIInFlbE6BCPlPjjm8EF6Jo49/3t9Gp3DlshuJpBW8PJj0y5es+EHmZ2
   VGM1emd8uXLIG3wzooDgdAf2LUedgsC0exzz9oLJWEj91P0pezpEZl7xI
   yL1V6ueNRx3kcVTfke535uSZq/qa9A2Z/zmo4ww6v90Z0ATcTgjkhtV3B
   HFmdFAUz/mJQrgydqdOOo7AXUXUdH0SDDrKEZA/ytD/cY6gcRB4699x0H
   WmGrXdXVMGwwkU06f/ph23Bv8Y++HRA1jYHoRTpu4LUIZvCIBDQQhOjx+
   Fz1MKs2OU/hnySkCpH7kTbYBVQkSXFraBn2nTq2++Dwtkoo3t6MFCn4Cf
   Q==;
IronPort-SDR: px1aRK5JcRaA/SWxjoa60tLxq341+sU/rdFhHFAMGzkn3GjgXjERpKCiFc9q+8syPBkAszzMcL
 4qHSgW4oJtHWueGZPvHQrgGytFYSj4ydD0X9ZjhFk9KtXEDCTG/oHcy3564QF9MJ9tzhk2VOU0
 h4d+3Xdf6zc4L592nDAHivKDOVeDFbaOzo/DmTEzIV0mNjqnmF3QkeCJImpHCQ976uk0/QOxnm
 oulIMxVkBUnSMyn2V3FMXj/sxwPvTfVupfqoHwejUawtU1uZgaB75OKdq6ber59lXCDJgeycmd
 wrM=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="256599376"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:48:45 +0800
IronPort-SDR: V+wtG2KicFQdYO+D1VIYbgrXSAeIR4snNeVUXYSWlNdlDEW8JH0l8YEwnW4Yt0f4OKhdeBEj08
 JKgO/tfx5lhA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:36:03 -0700
IronPort-SDR: 1a9lupnKL9v/kSaVqlzyhmW3aWbYgIoao1aJMQjr01k+fuRtCObyRVDsQ+uNkAWeBBlNM+/Xor
 Zh8Sc04XGOxw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Sep 2020 00:48:45 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 1/3] scsi: Cleanup scsi_noretry_cmd()
Date:   Thu, 10 Sep 2020 16:48:41 +0900
Message-Id: <20200910074843.217661-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910074843.217661-1-damien.lemoal@wdc.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No need for else after return.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_error.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 927b1e641842..5f3726abed78 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1755,8 +1755,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
 	    blk_rq_is_passthrough(scmd->request))
 		return 1;
-	else
-		return 0;
+
+	return 0;
 }
 
 /**
-- 
2.26.2

