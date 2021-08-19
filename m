Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C6CC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839FD6112D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhHSHi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 03:38:28 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:65406 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbhHSHi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 03:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629358672; x=1660894672;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+OYJapIpYr9yOVnqBgzkwtKZzGmKfbn8et9B/HUyo9M=;
  b=FR9SZbzcQQnLZHjuGXibpbiRtqW0weOD9tGvNOwQoThpJuX7iEK57Won
   ecCZWFHqhZ0zdE/VSDt0YLdihcVfnn8/qoQtSNesKfqeKbhxBW/00y7tn
   cVJb2LFa3Q3JSHeHEM4RKdf0UoprYrITzQjSADVvDnDILGd2D7c5xquy7
   oG+f1bGo/L2haoBwb5c1MuiTi9wo4ryvCwzVZvJh4r6jXWJ8AdPTDY/kn
   PyssQ4ezmiJjTBCX/ZqSFxakoHDpWw5fGHQK7JAA6K3JwGlEdN+kI5gg+
   3U72wVSjJ/j75+UiJ69vezSBqMw3J6UwL1TX++gf5qw7zX5Y9WRKCWCPa
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,334,1620662400"; 
   d="scan'208";a="281559229"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Aug 2021 15:37:51 +0800
IronPort-SDR: MNCiUbYq0CZCFLqSEO180fslMmSMhfjw5a3/UrZ4DNeEIE3/NHi68WR2RSOnJuSrHrgX7uxhdH
 VtrVB/xI4N10eQvsxlH2v/bgvcxaygCtq5XkKnD2lAoo/hb02ueGX1uAYsIRr7IHTMKNCKRNHl
 kvBJ/LhiplDWvhMlgt8ASizzyhZY1yjm7vP4RjKNKCOkaLjuTxXCkVvXNcW0pyWElMd7/SbQ6u
 8QKpNf8+ntiURsGOx/Rv6ojDYWymxcr0mWuy0pMSi0BHjtpY9H2AkEEKs7jlWBU//9scmu0DQT
 qDnmB+6R+99w5jQ7ApXZkuDi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 00:13:13 -0700
IronPort-SDR: 2F0bIJpA3OVfvpKQykGpjsgQ8p1fQm1STcIcy623HJXIddZfA2qA/fMy1C9Mt8nqDzyAoJhfiw
 oJZWz0AHLzJ+SRMKRfzD16iVOMm4FTaCjvHH8XuwnyoWpB7OhlJbT0iX18xCAzNa7RZ6NqxZO6
 jxoEvsa7+ge+jMhy71//o27yXpiC8JS6EqKKdbZdTBFEQTFIrM2Xhc7t4jRim3VXvpWbALcajR
 QdEBHOSCl4zQfVlJS/OFz8QwbrGA28p/42SKLjx+/sLKV7jkjGIYvFuSXcnjOAL3NEaCBPmom7
 zDM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Aug 2021 00:37:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: fix scsi_mode_sense()
Date:   Thu, 19 Aug 2021 16:37:50 +0900
Message-Id: <20210819073750.132601-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The allocation length field of the MODE SENSE 10 command is 16-bits,
occupying bytes 7 and 8 of the CDB. With this command, access to mode
pages larger than 255 bytes is thus possible. Make sure that
scsi_mode_sense() code reflects this by initializing the allocation
length field using put_unaligned_be16() instead of directly setting
only byte 8 of the CDB with the buffer length.

While at it, also fix the folowing:
* use get_unaligned_be16() to retrieve the mode data length and block
  descriptor length fields of the mode sense reply header instead of
  using an open coded calculation.
* Fix the kdoc dbd argument explanation: the DBD bit stands for
  Disable Block Descriptor, which is the opposite of what the dbd
  argument description was.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7456a26aef51..92db00d81733 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2070,7 +2070,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
 /**
  *	scsi_mode_sense - issue a mode sense, falling back from 10 to six bytes if necessary.
  *	@sdev:	SCSI device to be queried
- *	@dbd:	set if mode sense will allow block descriptors to be returned
+ *	@dbd:	set to prevent mode sense from returning block descriptors
  *	@modepage: mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
@@ -2112,7 +2112,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			len = 8;
 
 		cmd[0] = MODE_SENSE_10;
-		cmd[8] = len;
+		put_unaligned_be16(len, &cmd[7]);
 		header_length = 8;
 	} else {
 		if (len < 4)
@@ -2166,12 +2166,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		data->longlba = 0;
 		data->block_descriptor_length = 0;
 	} else if (use_10_for_ms) {
-		data->length = buffer[0]*256 + buffer[1] + 2;
+		data->length = get_unaligned_be16(&buffer[0]) + 2;
 		data->medium_type = buffer[2];
 		data->device_specific = buffer[3];
 		data->longlba = buffer[4] & 0x01;
-		data->block_descriptor_length = buffer[6]*256
-			+ buffer[7];
+		data->block_descriptor_length = get_unaligned_be16(&buffer[6]);
 	} else {
 		data->length = buffer[0] + 1;
 		data->medium_type = buffer[1];
-- 
2.31.1

