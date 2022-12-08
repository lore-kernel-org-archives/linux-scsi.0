Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7554C6377E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiLHLDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiLHLCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:40 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC24B1A832
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 03:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497268; x=1702033268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1yJjVrTjEzab2VnGecsAuFT78Y4qRfR29S6StL8QqBU=;
  b=IOX/FcEYYUyIekaM7856v5WuvRsdUGxDMhQkGgXhZnP0I/SPZdOyNs2W
   qr6qO6jfQK6YfQW5kI1/cM2q9/bV2SHnR1FI0PjsazKYcZtApqigO/Mvr
   Y57yuVCf4iDROILLNHNZ+jvVa4lN/sdnZ3cRYwNAaqIU4QPGJ4mm4vC9Y
   2wTJxeYWhEdg4sRqh9sj68k6vgezrFwjtFklP+IO2+z3ApNajXVz4PY9y
   NunAA57wsxrm95euq5P/uFhm3eXGmFvVsYuFBWLGWhfOjXXakazcfLnPB
   piQ3b9CtA/UgDGubcOcQVfLUpk7sm/rCjbkCofEVvo0B/0Yn11buymNT0
   A==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333394"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:08 +0800
IronPort-SDR: rK5MtyWWdclb6Ag0UUr+xTaBhoZkW8C0PuPCDfAymUW/KqvcA49St0apzW/89H4uTnL+IdGsrC
 W0fbO9bzBXMiI/3FmlTftcgaOb5MpuJ9u1YRh3t1HBlyfaDP8Xk8ronIHNOa9AQHdVj4+t4bmc
 HTZGiE7klkNbENFaWMBMKYjhAieyM8Fg6QdVekX7DEQxkZm0XVxhy/L9dBg9EOLBt0OqahLPHt
 FSPdgyybbIseYnys9mYT7mYYwXhI4bsh9CTjDBx/TmhVJTjnm4FJicQ7g43LTWuukJiEXf0dE5
 EqA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:53 -0800
IronPort-SDR: nA9FqdtM2Za3pgJl07RKaqIx310f20LOp+1VS+NvUt+qfMtZBVq3BmZz3aEimK06837Z1cms77
 DfYtj3ODKDjm7fI1JXRXC009rqwuUoP5z9r+P3b1xBySnt+AJRt8JE4QAN1dMr2obY/U77oz5+
 gRLv4oCtPr12OSETek3dhvlBXVagkq7JybC57Tyf/diV0mGj+KeQefcZp2+6prhvOAw9YW7b/p
 HTqePEZ1HUW6eBoJVHksHg9JKtSwoFKMoj7Pkjz6Atdj9a6srt3ydIsJl4HDUbdMbOafJBeJt5
 Ju4=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:08 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
Date:   Thu,  8 Dec 2022 11:59:27 +0100
Message-Id: <20221208105947.2399894-12-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c and
scsi_error.c will need to use this helper in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/scsi_lib.c  | 5 -----
 drivers/scsi/scsi_priv.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ed1ebcb7443..d243ebc5ad54 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -579,11 +579,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	return false;
 }
 
-static inline u8 get_scsi_ml_byte(int result)
-{
-	return (result >> 8) & 0xff;
-}
-
 /**
  * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
  * @result:	scsi error code
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 96284a0e13fe..4f97e126c6fb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,6 +29,11 @@ enum scsi_ml_status {
 	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
 };
 
+static inline u8 get_scsi_ml_byte(int result)
+{
+	return (result >> 8) & 0xff;
+}
+
 /*
  * Scsi Error Handler Flags
  */
-- 
2.38.1

