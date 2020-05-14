Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0132C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 08:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D242065D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 08:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fXnMnOxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgENIT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 04:19:56 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22158 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgENITz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 04:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589444395; x=1620980395;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FPz9BqtoLVDe3Qvnd6i5kB1gkUZszsYxGzyxcvWye3A=;
  b=fXnMnOxXZFv50cJHSoGkSBpml55+seCIUwo0c6AEMYzNql0M7oiz9ss1
   /hHPyDHMw6dFVom7SLT8pl7DTUjdW59ID0412Vkwl/I0ZCugD3iFD0xMj
   RU9X/zYd/pE48BGWQ9e1G+fEEGDd2neMLZQ3rwSk77ocVqqnXpEVpbW7g
   sHtVnBm24lG2aoGuULkrEmZ8wNDNQZu3JTqkTrkINE0yRuMuE9rh0JikR
   ZbW3F/DLQWWO31Oz0liiTfeC5zZq9lbvhh/Do9EmSjJ4zyv2cSOl8Bdi0
   r1tRFIkgC0dW52AM5/DBzbr6+eAE5/XqR6YxUzlrRC/cLag7JiIFWXWVK
   A==;
IronPort-SDR: oh+q4nxHXByMB0hSQ3HG8ISkOESSx+26Fdq6xjFAcf8LkW2RUdjFBFbG/VC8VTXCfaGEaf38YP
 zKrpgAn2L5PqnYnvR+xBVQJvFRjMuFC+bV9mPSJoq2q4TPdFEkhHZUNqyL6Q3vxeZONqvvZ2IS
 jXFxnPPx/WXvGSMYtZge4ZQLZ/2oOHGRg5/7zshV7xpMRk4SGx0lzqKbA02P8EcP9D5NJOKtfK
 VQn2/DstP3weryraKrtlDERiIDHzRKhjHLZrNLnIA5M4U9LdGWMpjIGatE0kle8i2Ro7RAZKXI
 Z64=
X-IronPort-AV: E=Sophos;i="5.73,390,1583164800"; 
   d="scan'208";a="246607744"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2020 16:19:54 +0800
IronPort-SDR: MVdUtHrNzQs2Gjm02bTqV5HhIn5cW0JtzdTHQRn01fCluwoCvLMEE1z9zRkWx2YEzXkeyzzJhZ
 mvXvZ4DBq66XhiAhN64AFXnLRbYMfVqJg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:10:07 -0700
IronPort-SDR: GY/JVi/Mtfqn8YRxkR36GuBWrQGLil4wlNF3zXrvSwf62CZ7DJYVpGIcYfRZ9FYB8SlWWbMvnE
 /bn7t4+v4TOg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 May 2020 01:19:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Signal drive managed SMR disks
Date:   Thu, 14 May 2020 17:19:53 +0900
Message-Id: <20200514081953.1252087-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Print a message indicating that a disk is a drive-managed SMR model when
such drive is found using the ZONED filed of the Block Device
Characteristics VPD page (IDENTIFY data on ATA side).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a793cb08d025..8929e178c6f8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2955,6 +2955,9 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 			 * with partitions as regular block devices.
 			 */
 			q->limits.zoned = BLK_ZONED_NONE;
+			if (sdkp->zoned == 2 && sdkp->first_scan)
+				sd_printk(KERN_NOTICE, sdkp,
+					  "Drive-managed SMR disk\n");
 		}
 	}
 	if (blk_queue_is_zoned(q) && sdkp->first_scan)
-- 
2.25.4

