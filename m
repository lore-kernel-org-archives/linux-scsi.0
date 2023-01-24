Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7150C54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjAXTDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbjAXTDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:31 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA9F4C6F3;
        Tue, 24 Jan 2023 11:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587009; x=1706123009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=udGgt0VZGVaV1F90mGCYD9DD4Pho2abcG3HITsaVOEY=;
  b=i56xwrPdPsK/GcgL0rZZ8QsryNLIF2vpsCOY/4WAKYWyVV97smw8nqni
   h3pcqZzTL90m0rgHQptOdcMeW93hv7gRY32sye0Qjg6nMYN6PbNNjiOup
   PwtEv99vGNJMVpBHXd5FiwwpeIC4bnBhJuXa8J78keyj+8dEF6LBJpcSA
   l3PTFIAeK4P3ZF7riR5OsQYovpDcy/4v9CvUlw442pXPojI397ZidjtYR
   tC0ZMGvx+QK+Y8gOpO6maCIP2nM6JgrMVxfMPCSmlU39PW/WG2NkKA5q5
   a6RvCTlTFMMqQcdtbyIuwM4F24+NC2MZ3TzxKRMQpJZMDSmzzII5giDHL
   w==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472935"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:28 +0800
IronPort-SDR: fzIj+0hRMJK9Pf/ZWdhBf4P2OYCQ9d4CQfJC4vjOl7eJvTv3dXeBC/F8/wVi0rLzCS9cGi1HTx
 WUkPhf6kpLohJpxUQvDeCGegSqP7s7m1Ia7nY7K2GbKBsfdZW5EZsMWNiWkBHhVwjPQyBYlXth
 irasXtNUiTzem5ZE4lKHg9G7ecnGaXeXu5NSo1ukyIwuoC9LIOl1MaJp/u8OP2H5Vg7U45N+rm
 f/7htRk8BDcyg+BfI4NEMjQzkm6k1bwbiAHKbpYp0pItvwRxeMA1XYYRr3j2RDifSMoIwcqMUW
 0XM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:17 -0800
IronPort-SDR: mw6e2Em107+OhxI0epu9UaZcQajJNodr/WotN84GeDRGOnV16qOEuHOcY0qqZ1rszIvHTbON/Q
 fJFmuTVF59/S25zjoGqsga4CC6A4LHH04YTyPIu52I696iA+8hUwXjHgSEH1ExT7uAz3xnBmhV
 FzFKirpQrVlqCNSQdktqlInUrUV771BRPW4N9iyh5C5/HyL/EXEKwtI+J+roRgsrBYRcZdoR4r
 3TmQgkhRLyE4L6BL/0E0WtGcKDglp04RQHwM6+yaFV6DUAZQ4Max0/Y26zPdhvzUaTslB1y7cf
 r4s=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:26 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 04/18] scsi: rename and move get_scsi_ml_byte()
Date:   Tue, 24 Jan 2023 20:02:50 +0100
Message-Id: <20230124190308.127318-5-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
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
---
 drivers/scsi/scsi_lib.c  | 7 +------
 drivers/scsi/scsi_priv.h | 5 +++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index abe93ec8b7d0..b1dcd7eb831e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -577,11 +577,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
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
@@ -594,7 +589,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
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
2.39.1

