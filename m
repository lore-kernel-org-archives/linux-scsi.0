Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4945C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87FCD23134
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbhASOkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:40:37 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:37693 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392968AbhASNS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 08:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611062336; x=1642598336;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gi5ViTFKpBsj3fxRrg2EwEQkEQSXyFAtVoTUeweHPR4=;
  b=FUGx8Wh6R6M/HA9JzKDJd+qg/bJq3kzRv0b7VaUIHbEP+uUTYLOfxBEX
   Nz0xE2zUL2/DtSMn0hiwtiEkbg1ZKQSQjW5Wnn0V8svI910MzgtBJrWsa
   Wx8gr+9yJPdQveSZudLzMC5t2mdf9RMGm8w/UcvAArvTQkuG48mnFOU8W
   NtA28HxackUtcE0uYY8qDb3OHDtFoMEpfUIMdlTJ6THgWc4XJWDJW30W9
   I9ukwCvijQ3UcHn9Afa2phc3xVw/iKApIUV5ZU+QV6MrOKeFyuFBSVKJx
   HFhWOa3Wlsk7qViLyKVhHX2yYC1sCwqGzrt1zv1SACzr5CL4QS++NOUmh
   g==;
IronPort-SDR: LLisiyLdLTlOxxMiTuIptBVxir/yFtHUG5c8kiNwxsI2HdtzrWPUwBdG0YcuPSdmpQgNtSjJxt
 a1WpNw59DBoj5mcGu7zPQxzRlnWeQbIIui940/ft3wS7IaZ13jiO6lCFZMjbz72d/Ellk4A7nl
 +05dmrL6/F7cHfed3V+Tjc2IMZBwDff7GdBciLRg051qGyplxpWq0VdE+quzSfALH6Hm3Sr9um
 SetBID1hqQcALKs+NNKur3tF81XSMDEtBhon7f3CVRGclagrHs/Uyt0zZZKBSK4D+B28iCgc+V
 BqA=
X-IronPort-AV: E=Sophos;i="5.79,358,1602518400"; 
   d="scan'208";a="157798227"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 21:17:25 +0800
IronPort-SDR: ojGxuCoDvC7JJ8WtSb9hkSRkuUDmL2Qc8eG36DyNGHtp9lKwZmArzVqimXKr92klGMDnXPE9JV
 Ha+kzsv/wOXHxOvHnnNVfKMVoTVnOV+q8MdBk5XetFldb32p+9qpYleTsoCPDYPALKkCdDvj8Q
 kYHGbDIaky6BXayWz+LBo5sj4mlG2tprp0WSlCTO+fh9m0YPH7AsGR+F277oG0+Q4ieHFWeH+M
 Ftal48pcCANRgXgsEiInoufo5R4OtZ8/E/D4RtejRS+pu7pVDEmWGQggCNy13kH8wCZd8UwVF9
 erkFDkwjE46bUzb3Q0fDtwW6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 05:00:00 -0800
IronPort-SDR: iCSGPLzWpqlW+qM6lkwgwZ1SveYNRIo/+8VeOgcrOnefP9BD5qlLJ1VC/OkvF5hd7XOyUBdwn4
 MN7vN8UZzQIhOknav8jiRTwUMl+NeliOhvQCj5gObUoxlIxv8aZbemGjYsWbEBL9WeZp2PEefi
 q6WjrU3EUAde0jkKUM0mjfIrNXCmNsLHNpdGBBLrZa3f6fvpAObIy//7yh2KYKNVe9+H6QcTrP
 30ThSv4Bc8vNWJ66+vUrmMzg0ahXvYeV21Ac208Hjd41WXH7yoWWJ/pijnmE7SndQ+sUuKD+/a
 vDc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jan 2021 05:17:25 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: [PATCH v2 0/2] block: add zone write granularity limit
Date:   Tue, 19 Jan 2021 22:17:21 +0900
Message-Id: <20210119131723.1637853-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

(resending as I forgot to add nvme and scsi lists and their
maintainers. My apologies for the noise)

The first patch in this series introduces the zone write granularity
queue limit to indicate the alignment constraint for write operations
into sequential zones of zoned block devices.

The second patch fixes adds the missing documentation for
zone_append_max_bytes to the sysfs block documentation.

Changes form v1:
* Fixed typo in patch 2

Damien Le Moal (2):
  block: introduce zone_write_granularity limit
  block: document zone_append_max_bytes attribute

 Documentation/block/queue-sysfs.rst | 13 +++++++++++++
 block/blk-settings.c                | 28 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  7 +++++++
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               | 10 ++++++++++
 include/linux/blkdev.h              |  3 +++
 6 files changed, 62 insertions(+)

-- 
2.29.2

