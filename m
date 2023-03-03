Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B92AC678D4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 01:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCCBo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 20:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCCBoZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 20:44:25 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95B815C98
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 17:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677807864; x=1709343864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dju/5ieNg8sXQxg35JibWtV8IK1fa+onJ24Smf8YDZ8=;
  b=gVtQAZ0b/eKLwvSqx4a+jycGzHG0Fypx6WkkjL6tD+ym8KWc5bjXs20u
   1S5JYYo98syA6LyV7KAT9pBW1jXKTIogvFj0jfP9tgd+jsLCP+awJt54N
   AkXOtWaOpV/xh3xEkaKu/AXOzRg5wJqT8jUyU3Mc/BgTp434hWLAWWVTA
   S4dQZTZFs87LJG3UcTzw0wkI/flkLrUP4geEKmmeh/da9fPGD0YmKJAxE
   YTXilamOWMgRSW8sY0WTbhM+/vc/eq044EC5uBqe7CBIr88tKVVxBi0fV
   WQnmAlSKLJSrBAG+IXYOsV+tlhqDmtY/SQfoXKWrGn+n4sBZ7G7tmi0zx
   g==;
X-IronPort-AV: E=Sophos;i="5.98,229,1673884800"; 
   d="scan'208";a="229650326"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 09:44:24 +0800
IronPort-SDR: 9+vwJSt3k2g2NH8G67oPxFdytNXx12zYKnDPdxM0DdPpM9FqwFbkLuJtTB2efsH6r5RNgAgX3v
 pKd+Vq2FF1kNjg9ZZN740FDjchKPDEHel9BDo4DS9eRokkLfITFghBM/hrL1pl1DTXanQdtSjX
 0EvGZcVA45I8Z4D6O28D8583TAWcAS+ZYVEqlpLrM1DKb6GUnO5Z2THM/WLNrs7DVIGAwqjVqS
 asCkVkn0BJ5GPtdZZqv6vkhaHbdmcnYJ65vdmYchmz34s3PA81HbuuKaBYL9aHeOCVzifzSvVS
 MW8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 17:01:12 -0800
IronPort-SDR: QRdkIwM1k3L4nac3kJs+QfWuhq/FiHn9PihPLeNDmQBPorn2+4oPcbPbq7CLpBPgH5o4QSn6se
 VHbmlmXD/GhAwT0LZHaH9MF0//eK+EyLhA5rh+5G0uoKqz+EGQopeGIE8N8EghTSKL+NmaWsTe
 xUIBjY3KlKyO1ChJy2++rzzq7uGb9WbMYcS/n0CSThAwAt2JMy0QnwDxxXVbIBTFjqEhnRm4S4
 xr8VwKaR0UwuCzybuiKXHzKjF+NqQGwTqwUMKGd2eWNYZgwqJG/98GDeTru4XHGLMrGcKNHJEB
 KJ0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2023 17:44:24 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] scsi: sd: Fix physical block size issues of host-managed zoned disks
Date:   Fri,  3 Mar 2023 10:44:20 +0900
Message-Id: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In general, writes to SCSI disks are required to align to the logical block
size. On the other hand, ZBC and ZAC specifications require that the writes to
sequential write required zones to align to the physical block size. When
ZBC/ZAC host-managed zoned disks have the physical block size different from the
logical block size, writes aligned to the logical block size fail. The sysfs
attribute zone_write_granularity was introduced so that userland programs can
tell what is the alignment size for sequential write required zones. As for
ZBC/ZAC host-managed zoned disks, zone_write_granularity shows the physical
block size.

However, there are two issues related to this requirement of the physical block
size alignment. The first issue is unclear failure report. On the write fail,
the disks return the unaligned write command error, which may happen for other
causes other than the physical block size alignment. The second issue is wrong
value of zone_write_granularity sysfs attribute. In most cases, it shows
correct values. But during revalidate of the disks, it shows wrong values. The
two patches in this series address the two issues.

Shin'ichiro Kawasaki (2):
  scsi: sd: Check physical sector alignment of sequential zone writes
  scsi: sd: Fix wrong zone_write_granularity value at revalidate

 drivers/scsi/sd.c     | 17 ++++++++++++++++-
 drivers/scsi/sd_zbc.c |  8 --------
 2 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.38.1

