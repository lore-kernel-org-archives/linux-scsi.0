Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3700C6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjCIV4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjCIVzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:53 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200F3EFF56;
        Thu,  9 Mar 2023 13:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398940; x=1709934940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q4unhQS+exbmqBVmGkQor8xAT5EXcmccRGFkmsH65G4=;
  b=UG+B9R7nSTXhPBOVKJS2b/leqS4o2wu/aUreCP2OCLpYNtBU7tcMIMcZ
   bWoT5GXbpG3jyToEb/h0bncGwWbfJPO5uXdY7pSbFBVo9A8eHvB9vt0tM
   EmiYlSvNiEE4aSLq7wT0N9orRbM2fupB7r2WvPL6jZImpvp2ciHFGv2GL
   yM+3kLQR4m4DGfuEPrforDv4efBdCDtcI46a6Ymv28F8KBznaJjOO8K5F
   SitVdK0RnQNW36fCTRd6wpKxDWDPjzft/+ga40csp79uxVV8G7zU/MoTr
   for2LwjBNn9lZRpARrzIoDNu1+s+Y8h405v/y4n2Ib1pZhmFhxOnzdghh
   w==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225270961"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:39 +0800
IronPort-SDR: pZ6dTxooT1b0yznLiBu3GypXme70zcnmdkCe4ZdJIi2AyLvOrVwuF+0S0xWyB7DZSZcIbDkfI/
 RurFxfcg58Hjkx4Hvruob44qMhd0OKpvU3ttBAlJjEwJPe0h7FSANo3w/V/IEuOSuIZ7sccaDo
 FqLrQAUCznDRLnUIVGb8UNbF6F429lfvwgIPOF4ChM0DCkdiw0VO+FlbdFqoJYAea2LzPZzzAq
 P7UXpK+1UUqVSuvChr3QLkQMIQOct5//nSrnoe007wMi5XgWshRPI5sYiZwZJWF3VAB4HF+7mj
 BAQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:33 -0800
IronPort-SDR: tLpnnmDSXFd5JJt2g44ISlMQVK2Ci7YHs1yv0+4gvJankwXcwMrmvkWnNqb5wX/L9sXzXhKT2Q
 ib471drrs+dyNFDzu1m/E1P4nqi8TH2qkbzPF8tOegMJIT2MRYs2nW9QnzMuY1sKqsFAZbJ4LA
 +RXxZqlMvHeqk2tkIsdFa1hZBXO5ZWV/915nexhPla+U7JwEm+0wPNRnUbuq+SVfFiOR3Y0AfW
 tAhniIxMesnTzcj5k7J42pf20IbOxzSKdDlFcC5GAKHJYOOeTkWCj2MnALyVDql3YFQgczyhPI
 Yls=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:38 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 05/19] scsi: rename and move get_scsi_ml_byte()
Date:   Thu,  9 Mar 2023 22:54:57 +0100
Message-Id: <20230309215516.3800571-6-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI has two different getters:
- get_XXX_byte() (in scsi_cmnd.h) which takes a struct scsi_cmnd *, and
- XXX_byte() (in scsi.h) which takes a scmd->result.
The proper name for get_scsi_ml_byte() should thus be without the get_
prefix, as it takes a scmd->result. Rename the function to rectify this.
(This change was suggested by Mike Christie.)

Additionally, move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c
and scsi_error.c will need to use this helper in a follow-up patch.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 7 +------
 drivers/scsi/scsi_priv.h | 5 +++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..fac9c31161d2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -578,11 +578,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
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
@@ -595,7 +590,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 	 * Check the scsi-ml byte first in case we converted a host or status
 	 * byte.
 	 */
-	switch (get_scsi_ml_byte(result)) {
+	switch (scsi_ml_byte(result)) {
 	case SCSIML_STAT_OK:
 		break;
 	case SCSIML_STAT_RESV_CONFLICT:
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 96284a0e13fe..74324fba4281 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,6 +29,11 @@ enum scsi_ml_status {
 	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
 };
 
+static inline u8 scsi_ml_byte(int result)
+{
+	return (result >> 8) & 0xff;
+}
+
 /*
  * Scsi Error Handler Flags
  */
-- 
2.39.2

