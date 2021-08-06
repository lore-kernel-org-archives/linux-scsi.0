Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819ECC4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6655960F25
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhHFHnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:11 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24064 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhHFHnL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235775; x=1659771775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bJFUvSu2jxaDKZ3bBp8YruRrixre9uNygCd7ppaDfh0=;
  b=Q5FO4Me3iCUuqMPW5gFqzpa0cOaGFF5pNNMGaoACeSE5xtFOQz5uLwWA
   lcUpdG8Cfl2xc9OV80D/LT/W6EiaCmLmaYGHp7+ZvdyKOjdLxHJZTW99k
   0D52cxMcRFdhqQS96clb+maxE0qaaeBEGXOGT75vcEWPJu+G49x/ox3WA
   rWyrWS6Fxjr3MrozNVw6FuhMTSWlmTm/ZYkuradXKGMYeNsFWmBsH83v+
   NsUHdUOiYUyMtd0sJdmiztz5vQL0XfiyG2HQf9SrmvbnXhZMyLZ9IR6yu
   1trJ+ZlYstXdTU3lI5MnWQbbBGf9gd+gaK8TGdvhmevFwwMTODnZ6fM2o
   g==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296842"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:42:55 +0800
IronPort-SDR: 8URcNQSwGYqiQayFdzR74LVeIvtqgn/q1X++hXfFKR/YgK59fz7zwAz4d9HL6fOPhg4pCtgoZa
 mq85Hx4FSkTApMzOfGfN5+eRdHQjJm8a/74CgjLjG99ozvq1qBef9jlWrF7Zj8YpnXlbvP5tib
 C9mf1POQnk77espmRb6v4JsD18aMit873DHvIhTKteFOHQ81pPTsoWw9mio37jrvSx0hMdaJL0
 TlZN1NckBVPQ7Frgm1nJDJvRO2n1PRssDOphjyaTKbRBF2DXMc/VlxprEEmV6feRi4a1awZE2Q
 //r4aq76UI63H6kh+9/orxhp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:24 -0700
IronPort-SDR: A2skzo8YiMqKPxtfUQJ9xPDwk6Nc7d8NKMe4JkFcWI9YGrxojj7oFCuT0v2ZQJCVtnvRFMtWnj
 iIKJnlblZJPYQlWyaeuvsb6Abc7/w586h4UUPkNuYZJVtHnG9yqlFVHSET3mnDMey4w8hHiPsL
 CRbLWw11FF21oWxuGoJQsNpZp7MId/OD4jBjV6LsCRLpYw/0K0c4xEsZnN0Qy2tc/qvroKDzjq
 SMhyJqDVGGDOLV3gcpo8QbREMfOYcMSliyc0FQpQlcvGA/TuIzdFsWzoX8OaY6KpyT3m8bRpz7
 +qM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:42:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 1/9] libata: fix ata_host_alloc_pinfo()
Date:   Fri,  6 Aug 2021 16:42:44 +0900
Message-Id: <20210806074252.398482-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806074252.398482-1-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid a potential NULL pointer dereference by testing that the ATA port
info variable "pi".

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..ea8b91297f12 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5458,7 +5458,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 		ap->link.flags |= pi->link_flags;
 		ap->ops = pi->port_ops;
 
-		if (!host->ops && (pi->port_ops != &ata_dummy_port_ops))
+		if (!host->ops && pi && pi->port_ops != &ata_dummy_port_ops)
 			host->ops = pi->port_ops;
 	}
 
-- 
2.31.1

