Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E3BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 18:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 582FB20870
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 18:19:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZY+GL/Rm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGBSTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:19:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23401 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGBSTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 14:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593713985; x=1625249985;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kaofhYnEjFP3lo+xOFaqTZIKdftbO3b5N4EGAllPI2s=;
  b=ZY+GL/Rm8RuSC9w0Qc+9U8WJcZ9Ess3ik9ZwTfYc1E3jI1epaTd2pXDA
   /bMsCnjEc9FpBPrE0Mv0hn/mlWzmyG/wVN3nHcqVLeKtTnErYJlGFEX9s
   Pu/lf0CIeguLDGbVo1fReZHOXw7xbmN3Ha0IwcClBUN039JiVSbnYi2PD
   RHtgt4prt2fiCwTRr1NK17KNKxbU8hOsXfmMa8r4eS9qtGZ8OVttxnc5t
   Z62B6cjw91o5cRP9cLFTm6tC+OkkF5dZgXsih6Pl8Av/QYi5tziwKgWpq
   YWMuevXzJaRGmuN/Gxj/gshj+lF0Yfnbtol2fURWAgVHPDDIaLUEAJ5S9
   w==;
IronPort-SDR: ad/jl1w7OGIDaF71IAnfAhfyns68EbYgwL+Z38N1IkEMalZuWNkzC7PtxPNeoj+h5ozyFE+Aqt
 +nl4HmyejW9e9Z3mpv5VecJbHOAZb4osJT1bpD9qSR3lATuoPZSPBN2L+xcZmpdW6/KoCtIjpd
 fKlc0U5al2tn155kj3gnM5ZN0mt4oVz+jhPtMGsOacYz9Cd+AzwdJ/6fx92WtPFAy58uZ5Aw/G
 pHKVUc6STAjJrsGuB/LntP4D/nWJfFxEwpgbyhtwCz9QNOoqHZw/1/HdPnLw13lk8ZCFq/6C+H
 g5c=
X-IronPort-AV: E=Sophos;i="5.75,305,1589212800"; 
   d="scan'208";a="142854296"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 02:19:45 +0800
IronPort-SDR: NSPBQXlbP7gQwWw5lR1JxQthNFp4QoSFwRhGuDfk0PH6UwGCy7BzGTTPjSS11pCpuxNrkP4Zdr
 dfME74CVab0F2zOGhRklHeLI0ePqAX68s=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 11:08:32 -0700
IronPort-SDR: 8F+GWDrALYAMncJ4kzkXRhtyvKSoOfqJw1w2evNh1U+HuqCi7+BZszvO2GN5Q7dz84aRoGKV/e
 TyGqZMigUMFQ==
WDCIronportException: Internal
Received: from caiyi-lt.ad.shared (HELO localhost.hgst.com) ([10.86.58.119])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Jul 2020 11:19:40 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/2] Export max open zones and max active zones to sysfs
Date:   Thu,  2 Jul 2020 20:19:20 +0200
Message-Id: <20200702181922.24190-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export max open zones and max active zones to sysfs.

Since this patch series depends on the Zoned Namespace Command Set series
that has been picked up in the nvme-5.9 branch in the nvme git tree,
I have based this series upon nvme-5.9.

Jens, Christoph, I don't know how you usually sync stuff,
perhaps the nvme-5.9 branch could be merged into
linux-block/for-next, once now, and once later (like usual),
to ease with integration patches like this, that changes
code belonging to the block layer, but depending on commits
in the nvme tree. I have a feeling that this series will not
be the one series depending on the ZNS patches for this coming
merge window.



All zoned block devices in the kernel utilize the "zoned block device
support" (CONFIG_BLK_DEV_ZONED).

The Zoned Namespace Command Set Specification defines two different
resource limits: Max Open Resources and Max Active Resources.

The ZAC and ZBC standards define a MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE
REQUIRED ZONES field.


Since the ZNS Max Open Resources field has the same purpose as the ZAC/ZBC
field, (the ZNS field is 0's based, the ZAC/ZBC field isn't), create a
common "max_open_zones" definition in the sysfs documentation, and export
both the ZNS field and the ZAC/ZBC field according to this new common
definition.

The ZNS Max Active Resources field does not have an equivalent field in
ZAC/ZBC, however, since both ZAC/ZBC and ZNS utilize the "zoned block
device support" in the kernel, create a "max_active_zones" definition in
the sysfs documentation, similar to "max_open_zones", and export it
according to this new definition. For ZAC/ZBC devices, this field will be
exported as 0, meaning "no limit".

Changes since v1:
-Picked up Javier's Reviewed-by tags.
-Reworded commit message (Damien).
-Dropped unused stubs for setting MAR/MOR when building without
 CONFIG_BLK_DEV_ZONED (Damien).

Niklas Cassel (2):
  block: add max_open_zones to blk-sysfs
  block: add max_active_zones to blk-sysfs

 Documentation/block/queue-sysfs.rst | 14 +++++++++++++
 block/blk-sysfs.c                   | 27 ++++++++++++++++++++++++
 drivers/nvme/host/zns.c             |  2 ++
 drivers/scsi/sd_zbc.c               |  5 +++++
 include/linux/blkdev.h              | 32 +++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+)

-- 
2.26.2

