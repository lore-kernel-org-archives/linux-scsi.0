Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8641BC54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 06:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjA0GfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 01:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjA0GfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 01:35:08 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0181C3A593
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 22:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674801306; x=1706337306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v5Xt+po7LZdWIuZYCJrdn2EF5CVXD3fPWmy8X37nPy8=;
  b=EYL+/3WAcJO000IvcCVnq4AndGUtQ7gzwmCZeb0SSYZmiS2N/MKqROag
   4kPxnxjbICE8xa7wNO2WXF7L7KEfJ3mruKe21WQYANAFxfYPRTi8g4981
   VOMLxQfu+/y/7DyDI+TrbB4OsvwmQljkHgLZh/vQjFZH/DWKEEcZ+yUt7
   HBQxoD+PWIHHE61tFPkzyqvI0/lkcTvux9UKGyFF6RJOeQvtd3eaKvhr9
   ByPf7SRO7kB1Kv87oxDhh34ISlRNoAhSEF2lG59W8cbexfC/MoZ9TKNhE
   8165TwzFKNquSgc3cjMQpdgQeUFtx00LyIaNAZYtL2JkTcT10Z1cU47ap
   w==;
X-IronPort-AV: E=Sophos;i="5.97,250,1669046400"; 
   d="scan'208";a="221934999"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2023 14:35:05 +0800
IronPort-SDR: DvKJdEEkFMD0wPvzTA+2mMA6h0zyYRA3e9fS7gYs4hqMYpqughdrcdCZqmEM0L72Et5qx1u+05
 kxBBX99Xvh6idIP2RNa4ta9JlFxjjMeSRNQt+QrUh0wiWGTJEXtTutD/PiN4EcNpoomAm/N7W2
 RlmhaRcz/gvpJRf0aQP1MPbCqzmspPCqktT2AvQE4pal7UIUguxavrp7knYKTjwXIY6SFbr7M1
 Mea84sWxUoaVBqnLdXkfaAls/w7xW/dCbmHMQTNTCzCFeN7LQ3aqT5Ut7kzsJWMpsIbGDS5iq9
 eck=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Jan 2023 21:46:50 -0800
IronPort-SDR: AReLcv8HXiiDW4bb1/WJcms5nI8pc1KMKiOFHwgwLzIXktOg6iZViNOiC4FL3MDycr8tBX+XP5
 uoTdSGZi62a00oiyYl8K5AfxKwg6WVwbuFwChPL4CZ3h06RozgSxb/QUefKu5WGn3ukRL/mU/j
 cu9gBXJ5CYpiulaN2JiXPxrgx/wQfdmkoRsN5WjQjbMLeUhCCU5AyEm5QTZi/IPd9qLo2Ch3X9
 rpVhMzKZaXFINHgWfrIVvgxZpWpxhfwZMhc8SxQiGjL00wZFtWF6VoOES3xejaazf1CZYR3y/S
 pCI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jan 2023 22:35:04 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 2/5] scsi: mpi3mr: fix alltgt_info copy size
Date:   Fri, 27 Jan 2023 15:34:57 +0900
Message-Id: <20230127063500.1278068-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpi3mr_get_all_tgt_info calculates min_entrylen which holds
the valid entry length in alltgt_info. However, it does not refer
min_entrylen when it calls sg_copy_from_buffer to copy the valid entries
from alltgt_info to job->request_payload. Instead, it specifies the
payload length which is larger than the alltgt_info size, then it causes
"BUG: KASAN: slab-out-of-bounds". Fix the BUG by specifying the correct
length referring the calculated min_entrylen.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 49916ae617e5..7fb9505723cf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -359,7 +359,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
-			    alltgt_info, job->request_payload.payload_len);
+			    alltgt_info, sizeof(*alltgt_info) + min_entrylen);
 	rval = 0;
 out:
 	kfree(alltgt_info);
-- 
2.38.1

