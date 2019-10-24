Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7C5CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFFE2166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KGayhq4O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437801AbfJXGuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 02:50:09 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35887 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437797AbfJXGuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 02:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571899809; x=1603435809;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GeEIYszQu7uSHw7692Bp5i/0xZP21LB0jX69It9X2dE=;
  b=KGayhq4OKwiA39i8/IBHMNjKSiLj/d9zwsXm1TN7dtaWMxsIzR77Mk3U
   Lvk7lmWzRAny0mc5vs0LJi5JYXaOqEnZpnd/wRYaZqvH6r0swSDlWO47O
   g1nsRgiyLOnVOXigEuaIZ70pr70k+3pY7k/nKZY4zVU6OD1S1L6cC752h
   ZGuXMlgUOvqaeRE+wJRN3oFrnhrddOSj7BevyHVatVpHB9ajSVI8xwD1w
   YmPjv/bcnz9MOIR8LPRtR4kb68+d44A/KLDN/qNqcdbOqsEVr6TRTLIWk
   S8DytaZNDADXH/MQskWydRIUJU75Cja7VuKhxVwRxGnUSkRBnkRePUuSs
   w==;
IronPort-SDR: VaYatDSQDyJfY0lEBNS/0ZhgjvbfO8JhfOtk4t6pGmOLL5VTPnHBlm4WWkCnw1afnc2ycgij2T
 mh0055fxiXXTZLrUZUtnDSjDgtnwS7sBVrALomuQ2REAtJAzH82BeweXu8UsbvpBjaKBx8BH2H
 tY9bfDtFlMEb9fOeGXxsh88+nfZ6qxTvJXo34+BYG8o8XgVS7Lg0y94vmQG6GdxHF0YTlkBLMi
 fGshAyFiEkVJ8IwWRzXCYHzHd2ZBcaiIU63FNeCeyHCIRhUHPJTh7GrvSSwXGcXMt3x2pvgscl
 CSU=
X-IronPort-AV: E=Sophos;i="5.68,223,1569254400"; 
   d="scan'208";a="125647239"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2019 14:50:09 +0800
IronPort-SDR: PBZkC5q0A60h+wyGX/38vkuH9xHBVgwFnac+guoBML0Siu563dpDrtIA600DwO1gMf23uv3Xli
 PmOvRpWZJK+G/H5+tyt2vSqMX8C9PKbhdfOFfd46pN4b63Zar/qwpPAxNwYXODcp9+86UTKyBl
 RkwgA3/eR3yC3DfxOfD83tjxWeCAM9f41nf5Tnr4sNElq8qOy42KdsLjAOqqE+j/Yp0vqAN79Q
 NHJHKJGEXf1ZyowOnUKsJFTg/Ba0Y3vIAHcWWDLUIvtyk4PcRs0U8Ko/3T3PnryabGzyO0iNqY
 KaiigEI1B9OyYPer8MrImkc+
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 23:45:42 -0700
IronPort-SDR: z+VWTacWY9yax5Jn5lpu1A8gHjm/99wY+Sk0dn57pCL3QsHFOlw07IHg2JZUABdXbKCTLR5QwW
 RoMIF3BsW1KSaICNuicq9HByueB0FWp+SbzoDcI8lJxXvmN8b982rEOrdXHkqIQwXICd3sl/y6
 CUwJIhD8OjEoSFA1q/p/HmKTc2LL/UJEPOAWY32lo5ojX0DIZH6DkW4L4CX5tS0QNW1Bd8h51o
 fQBoC8POs7d/5QyKw5GINoxaVUcdGMQxe1YSBSEJdKeFZZi9bag604ZwRhm4wuf01AUMRa9i5Y
 qZk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 23 Oct 2019 23:50:08 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/4] zoned block device report zones enhancements
Date:   Thu, 24 Oct 2019 15:50:02 +0900
Message-Id: <20191024065006.8684-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series of patches improve the handling and execution of report
zones operations for zoned block devices.

The first patch enhances device revalidation by moving zone information
checks from the low level driver into the block layer. The second patch
remove some unnecessary code. The last two patches introduce generic
allocation of report zones command buffer, further enhancing zoned disk
revalidation.

As always, comments are welcome.

Damien Le Moal (4):
  block: Enhance blk_revalidate_disk_zones()
  block: Simplify report zones execution
  block: Introduce report zones queue limits
  block: Generically handle report zones buffer

 block/blk-settings.c           |   3 +
 block/blk-zoned.c              | 178 +++++++++++++++++----------
 drivers/block/null_blk.h       |   6 +-
 drivers/block/null_blk_zoned.c |   3 +-
 drivers/md/dm.c                |   9 +-
 drivers/scsi/sd.h              |   3 +-
 drivers/scsi/sd_zbc.c          | 212 +++++++++------------------------
 include/linux/blkdev.h         |  12 +-
 8 files changed, 193 insertions(+), 233 deletions(-)

-- 
2.21.0

