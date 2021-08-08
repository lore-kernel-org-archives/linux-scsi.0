Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53004C4320A
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A0160E9B
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhHHJBP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Aug 2021 05:01:15 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50653 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhHHJBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Aug 2021 05:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628413256; x=1659949256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=6B2CQU5+UkLRTV6KdGFECN3I7kOpqa+xwRhIgxF3D9A=;
  b=UD0mWTLsDGf3USg/2QJ+Qu9B4Nl+y4M854sCSv3iW2vly0pjqwmnNDCw
   LMqM9ik/wFfpmamtg5AyG7ovaRvlz/JvdN4ff8Asg71cA78O9ank049pY
   YlTXdN95EJeOFVO9sV6u3FpRJn/gCfJVQDIHYX+PN3wr7guEH2lPb8vHi
   RiCB+L3AvofGwpVDyx7m5b0jW7N4cTDKUMUVLRmxpwv8eJg5BeRG/c00U
   ahSPk7/CakbeieeaNVj38ltju7jkZLfVo9gYydDWhn3MoUoXzu9PcpJPt
   YH4XkJvq10hktDMQAT8uoPwytGZlcosQDjZUo8ngduxiKrNvcIPNoaLRC
   w==;
X-IronPort-AV: E=Sophos;i="5.84,305,1620662400"; 
   d="scan'208";a="288168028"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2021 17:00:55 +0800
IronPort-SDR: SjiJLIpTnTJwNxyaB4twf/JhkPMUq6C7qruGg3GJgP0z+gx04xi96wi2kGT3AVvMllWiemZTJs
 eKBhJitmVxNgoOZm2ZfR6DgADAi5GDmeB8qEJih+nWOgRwAV/obMjDl95IjUBbMO+YpEsWK9Bk
 Wn5LqRId18wqBAKDfeSk9ERJYPYN1N/qGjLzsA8FGjLLHh+PXMnyX1bwstkYMKEEBJ5Y8WznWn
 qP6gjdo16+1UPglmiAcB60Z6/m7YAJgbvh0jz18I2R6C5eXKZi7jKxOzzrlmZw3WSIh+mud3lP
 +YEpbybqXMT3B+6hItpTTuog
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 01:36:30 -0700
IronPort-SDR: 07lasYtr7CfWz+iI2OWhYHfFO0K7Qt7DVXzowy6cK9b/esIEbwoqSwJhIT+1Z/d5bYo6pvwgKf
 AK7mSAtJptbxr92CITg8VT1+saIy6eRHKsOwELek7l++Tdvb+ar/C1UFESueg0+8jGUH3O4Z83
 QzQU4fL1tO12sndpr+C7YYft3blQhp1ucVpOhKEG6+fNaEVdN4HuJrAv/UyWKTJPPon8GG4iRH
 5sauHDsxLAb+xH+D+ydZ/JnX5KEXDhNEquEFHufe1EHMxQpVhOvQwyTbsATosJMnHGgR7d/4XM
 3eQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2021 02:00:54 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/4] scsi: ufshpb: Use a correct max multi chunk
Date:   Sun,  8 Aug 2021 12:00:22 +0300
Message-Id: <20210808090024.21721-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808090024.21721-1-avri.altman@wdc.com>
References: <20210808090024.21721-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In HPB2.0, if pre_req_min_tr_len < transfer_len < pre_req_max_tr_len
the driver is expected to send a HPB-WRITE-BUFFER companion to HPB-READ.

The upper bound should fit into a single byte, regardless of
bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD which being an attribute (u32) can
be significantly larger.

To further illustrate the issue let us consider the following scenario:
 - SCSI_DEFAULT_MAX_SECTORS is 1024 limiting the IO chunks to 512KB
 - The OEM changes scsi_host_template .max_sectors to be 2048, which
   allows a 1M requests: transfer_len = 256
 - pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH = 256
 - ufshpb_is_supported_chunk returns true (256 <= 256)
 - WARN_ON_ONCE(256 > 256) doesn't warn
 - ufshpb_set_hpb_read_to_upiu cast transfer_len to u8: transfer_len = 0
 - the command is failing with illegal request

Fixes: 41d8a9333cc9 (scsi: ufs: ufshpb: Add HPB 2.0 support)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index c74a6c35a446..6df317dfe034 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -32,7 +32,7 @@
 /* hpb support chunk size */
 #define HPB_LEGACY_CHUNK_HIGH			1
 #define HPB_MULTI_CHUNK_LOW			7
-#define HPB_MULTI_CHUNK_HIGH			256
+#define HPB_MULTI_CHUNK_HIGH			255
 
 /* hpb vender defined opcode */
 #define UFSHPB_READ				0xF8
-- 
2.17.1

