Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A6FC63797
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjALOH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjALOGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:06:38 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A0555870;
        Thu, 12 Jan 2023 06:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532270; x=1705068270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vXjbAsivCptBqGfobKyamSaEPiil8gDg9M1lnUQl7dI=;
  b=I0ipD01fEJURSUHs0qqCMZ2FqmBePM4OE43ZM0va7OSBMG/iTEvfEBzn
   UYiIUrcJT/VXxJhZFoHQCRQd2vrKU08kcP8vvVGV8zLuQ7ndVg4k4msX3
   ZSksnV4Du2LJD1JF1rAdZKoNrBmiLQmqDctTPwNGSkb3BDV7J36TuNNIL
   pU3Y9oZ9LkzxffYvgc8aQ8AcxbwNAi1LopmrFliOqV4j1ytOhOFIBzkkr
   o0GmgCz7i8JYIzsUjoi1UGzzhRKD5bd6kL8gojauoI+3VmpFIRTPgXTcD
   g2LWvmSWrZK09DhQZi2cq7LwKvAUOYgTbQO8slHN77xrBme+HIbCWCUs5
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632668"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:29 +0800
IronPort-SDR: l8A+raCaDnl2JvBM7tUf+O+pZByX7lCpwWRGhblBLLXigseMYyag1oXX3g0N2EhYLFQK+HfgJx
 E+Ec0sc+oYWLIwx23TY4em+u/VduftqFuOwbPWL54kIs28LA9W9bh35389LNYfR47hMyj2J1s4
 T2OPaiGZE4FmKja0LrwEbVggc8WtuRCqRRynI+LnHvdnKg99Ig10DMbY4wV/xkbWGVqM5ytGB1
 x7NGyF29QE8K8edotvjZBHhcRZ+nW31h9mt/294TSTECaa9dHQIl/J3RGXTDTUfmj4i16Yw5rh
 SfM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:32 -0800
IronPort-SDR: AF9gdHCDV2EoJHxs9oYkf+GCiA3c7YvN0bBJjrGSm0wb6s6IFrVyBIYth8mKBngJ7eP+4RecYU
 vIzTPJC1ooOoS6kcFO9yO6ZM+ZskRUJwvgLNE6Rou2JMmnuYfY8RxcqRmJC8pvfoukH57HazMu
 wiSg7lkXdbokZvoSoxr3VOiqZSc3s/bfTTaJ5P7D8NBXmaCEaw8cHfJq4cvwqnC9FjKRrHAsFD
 FaWFp3YoT4PpBQmhX2rY3hiE32USZzyb6mU5IFZMUI4En0VpipZZNY4zmthKImkeSN5vSStwJQ
 byM=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:28 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 04/18] scsi: rename and move get_scsi_ml_byte()
Date:   Thu, 12 Jan 2023 15:03:53 +0100
Message-Id: <20230112140412.667308-5-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
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

Additionally, move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c
and scsi_error.c will need to use this helper in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/scsi_lib.c  | 7 +------
 drivers/scsi/scsi_priv.h | 5 +++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ed1ebcb7443..6630a36b873e 100644
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
@@ -596,7 +591,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
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
2.39.0

