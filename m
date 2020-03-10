Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0900C18E5C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B91B2467F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xx37JvBu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgCJJrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:14 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833635; x=1615369635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EvmkpZ0dKDsiRcbVAy5MDx85HPrJ0hxuLDJvq95gdds=;
  b=Xx37JvBuYj6msVP4tRzMaUpnJUAGkTXrj1qqst2PgikzfxjS5yZFEs7f
   boc1ds9/ZE3OglqnegxvVIu+UVVmvBz+wiw5NOQCm3F1HPIOzosSHCAAc
   VcFYHn2cCZM1r1TN1vrN1KSRapB4NFOIb6KM5WWAL7+S/QMed8LnX+4em
   QuucGC2Zg9CsFTG2SprVWDNQFnXXLmjg4lTcYN0N2Vg7cysWdWauTgxXT
   xzlTetoenqqDvGdYLMfccFYAl88K2xRWl4+KO3BCPMZORN0vkjpfSqGBf
   T5hmERLSW6SoC8dKjccWPEXT3sTY32e+TapEkwNM+vUsbaieOSM40r/pm
   w==;
IronPort-SDR: Z4EKzVB1wzkRDt4fMDjLtwiYsfNFqS42ElsjgzLoeJEyroSNOOSaeGz576M2BS3o1ezYvNdIH7
 YGL1ZKhF5GcQPmanpU5W+kgM7teyGSz5QpPrdoi0R6bFCwmL8Fj/+/DbmGeu/WAw5zysHW6bsx
 ovgUK+I/DJzC+jxlGEd1c15WvHdlmX5Z/DPOhnFF8aOvL64A0r6Z5GCIW9NS9CFBdCSIFy9GhK
 0tUYA4HdaXl3wCy1FpbKDOwoNzCW2fFrDIcPSsf/EzDIMpktNf+B84Rg6IE3igiKntaVTTwdR4
 KVs=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082775"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:15 +0800
IronPort-SDR: oUDjsJwN+PtUE1M/mx++v3GgRS8xtMT1lVqamJ0oBkTeTYCPZUsYaDcyPLDistca4HLPV6966U
 rkckPKMyyEy+IMz397AJ/jM99qqebj2CQP9MkA8CyaO2T52tvpzf1njzblzo8hAJNy2uFtbYCd
 wEIx8HuAPUDyf2Hx2dOroKA1K0JcWKunIKcLAzcYLEzjJ2Z3BGbGcEXOmHvBNzJxELzFw8c1Px
 2QBT6Oo/IveJC4LSpvFAXLJ53RUhE8sgS3ffLq9Qvo8yJFt/NyKBc4yXqwguapx8rCjcac4IkM
 pIzjweywNMqGAuXCFEiKozNZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:38:53 -0700
IronPort-SDR: OJkPzBjmqtMowgja8M3BwZgm06g8lb1sJw9LHtcFglRsL8I68bdigWTjR4+yEu8U23TaN6IxmF
 FiGKkirxif9pcBuXUtUfxzfKTW7xDrvJDQ3vw8IH8C6wZQNVoRDyIEVtyu2kZ+irxXqBpFyi3R
 4D5LyhjjoggXw9uoq5Ddx3bsSKOohyRqmocUMkwwpwuiOqBNQ0fQUwIpcw805uWC3/NBxz4hhL
 Syik36q3YU+o5EK7bOgabC6MeSozbAeNr3ZEVKb186TDehH9usHX11d4Lwh6CVf/YSl0jRc5jM
 t38=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:12 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/11] block: provide fallbacks for blk_queue_zone_is_seq and blk_queue_zone_no
Date:   Tue, 10 Mar 2020 18:46:43 +0900
Message-Id: <20200310094653.33257-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_queue_zone_is_seq() and blk_queue_zone_no() have not been called with
CONFIG_BLK_DEV_ZONED disabled until now.

The introduction of REQ_OP_ZONE_APPEND will change this, so we need to
provide noop fallbacks for the !CONFIG_BLK_DEV_ZONED case.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/blkdev.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f629d40c645c..25b63f714619 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -729,6 +729,16 @@ static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
 	return 0;
 }
+static inline bool blk_queue_zone_is_seq(struct request_queue *q,
+					 sector_t sector)
+{
+	return false;
+}
+static inline unsigned int blk_queue_zone_no(struct request_queue *q,
+					     sector_t sector)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
-- 
2.24.1

