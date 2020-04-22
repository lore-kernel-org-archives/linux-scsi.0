Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99658C55186
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A73A20656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="idoqdcZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgDVKnH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:43:07 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22889 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731741AbgDVKmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552143; x=1619088143;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QubTP+unc8Z3+EyBN9AchL+VXItpLJCAI2qP6lRVFbs=;
  b=idoqdcZWBb/QNkYmVWi5GrOSqxip0oPzvoRBIMAEqEXUFHn/xySyYeSH
   qU2sgUE9Gyyc2Wd+yrScCDyY4yPSwNLXvhUHXUtt8L/4ZpZfi+o/AnRP+
   XYcY+7CfbDBEPO4+jD0B17kH0ZdrpoBm+pejHn54l/mYC4e6duWXsJP3T
   E+GW0AkzWGMq+WWNXYBPaEoIV5gWCAx0MU1TbEoh7+0JEN/Qpf/y1/YDB
   1p9c2nhln+J4sGSEJlqawhGr6lutPdjPXmZbzglYF87q5DksQY6IkJCUW
   RIFQIAVX+tPAe4tBVO/8Udnb7cQrbCT0+i9u/yVizSwhzVjUu6hyjl/7Y
   A==;
IronPort-SDR: gx6f5SbwlKLGoZMCOHWfstZpAsfCYw3P5Ar0GH3NDBI+ia9lBe04l8LtfrBLpNCPZMIDqXzWv1
 W9tsog8/xDmwBMYBnTI/vE8XFMjkRgNz7zKDsxoMNpaIbVUPtV0Cj2XIVbFMyLCE6KIDk8LkJe
 7q/I1WPfR9oBfk+z6n0WTZPzHEQDvVZ9PqflQhakSZrqvoEEyfAEkVl8vwc1ZlqtZFcMDxIv4h
 Le8qUy9mnH4hPI5SmvvbRuJgXXFUMLyIqj16ztR8VfHNniDRAuzrQ3U9oAeCmesdytNqRTtQY5
 fGs=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230017"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:23 +0800
IronPort-SDR: 2kHXPhNCvToAedQ8Z9O9vmus5Cwwv4vTUOtxetHM+d7pIatcbSRaGf2XVp1tN+KSptUfZSOV/q
 DSmPp5uI1HtnEJ7qfjD+4PjlFpY/eOnKA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:12 -0700
IronPort-SDR: GAt+pDGQAozB+wIyqJwDap8xZwvJoRED21jPldw2WjqZAp0sNX1L13waHJMHji1Ty8Ml8ToeVt
 iBg/GMaHYBhA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:21 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 0/7] scsi_debug: Add ZBC support
Date:   Wed, 22 Apr 2020 19:42:14 +0900
Message-Id: <20200422104221.378203-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the second part of the scsi_debug updates implementing ZBC
support on top of Doug "per_host_store+random parameters, compare" patch
series.

The ZBC emulation implemented allows to emulate both host-managed and
host-aware disks with configurable zone size, number of conventional
zones znd maximum number of open zones. One feature missing is the
emulation of ZBC RC_BASIS which changes the behavior of the READ
CAPACITY command. This is however not a critical point for testing as,
to my knowledge, there are no disks using RC_BASIS on the market today.
RC_BASIS emulation can thus be added as a later patch.

The emulated devices, both host-aware and host-managed, pass libzbc ZBC
conformance tests (SG interface) as well as zonefs tests (block layer
interface).

Damien Le Moal (4):
  scsi_debug: add zone_max_open module parameter
  scsi_debug: add zone_nr_conv module parameter
  scsi_debug: add zone_size_mb module parameter
  scsi_debug: implement zbc host-aware emulation

Douglas Gilbert (3):
  scsi_debug: add zbc mode and VPD pages
  scsi_debug: add zbc zone commands
  scsi_debug: add zbc module parameter

 drivers/scsi/scsi_debug.c | 1016 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 993 insertions(+), 23 deletions(-)

-- 
2.25.3

