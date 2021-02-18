Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2261CC4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E029164EB8
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhBRQ57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:57:59 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6594 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhBRN0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:26:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654800; x=1645190800;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QOa5ixnCqhM+bPFADmmyHuxCKbAUkxZT3eEhoaKInYk=;
  b=b5xq42UoA314eb/uTcfJz1bqFRAOv96FYuWiMPzKmLEq8GDN7KlPrJxk
   ga7gSl0Mr2PaqicF56G5ohURnL9HJlQbhXSsli+r+//CILQs54hECtqxU
   wId+GXu9z8RSgxtgnCGeho7PM0kqz2WSLQeijjhyDM3IzgQWl5jiNESQS
   RPPnKcY7yiej7xrPMws0M8IZrLjPJJ7DIeVcXbCmIfOymORaHZIEuioiZ
   PtRjJnbzYJK42A0ZB2J5oPxaJv8GbihTcb1OwwVxtvvPsScUeMavBUILb
   qM9QjxVdGvGfgwprJjUQhKHDuhOazL3J+IhDAonEv/kWmJVRzUSHIqtsv
   Q==;
IronPort-SDR: X46HlWzErCdvNWPs+XPdZWxlMH8cyXiWxte/BEWI7PeQADLfnj7mk8HmjHGQ8pbz45gdMJ/qeG
 qRwAbhbHDJmrDIeiZaR9V57+S363MAU6NQXhtaRvXTnudHNvNaQmnaYW7b9bHM5lmxFi+NGrdT
 31q9RKyDkPGubLiapamT3iNjmLeyj8rhl0tYySqKqnvNRnOx4S5ir475CZ1wgwK/uSd8Ng+/Ah
 8hNYti/KrHz5yLALDLSjYNFSD4n+NFPIyZU0vKzD2/UX3Q4dPXh87ePsPRKS8ZGn+ylQTNd6kw
 hUU=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="160250962"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:19:57 +0800
IronPort-SDR: ATupfsGKPT0ahy+Me/FxNfV86nWNr81VTcdD8qhuIy4jx3ma847DDAWaRbquUzdOBDqYNQX6Dm
 eRo4Yuhn0fL/fHP0stA6ps62p27vhp2hC2SrWFnSgZaYQ2ZeO3nZR2JcwtaTUG2W4afN6fRC2N
 rPHvuDiVvthXRlVnk0FUu3PHUlPCmlDSq89iV4TI/DYtxg7eCgM3h1j3102uFndOTVrpQuOaQd
 oqBRuAgZir9fF+BWiOtEMjRLlR8ZontWZb9p2T5yuBBkRbVrTYpVEfn7FmxqpvhrUH55ZeLXbb
 oTTXZ1jzjVOBwKWGb5wRuE7D
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:03:23 -0800
IronPort-SDR: gSCr7VWBZIOQvlXl3GZOaGP3SpEDzYSbkcArpL0kzinwgyLyN6HXW8si945P3HEwkfMOnNzbts
 fvw6GUYqC0i/L6Um+pCDlQoh4rlgMFKPOpRA+ypGU8lmVJCfnl4mDMH/B4j+2HyRSk8caIIi5K
 k1SBXSM2YUM7AFPDPbmibYK7hVwjO9i1qOLX78wGlDkEURctBRAXv22PGFzptH4f4unrzePS1l
 G/1aVezA6WpYR/S8UJYFGmWSmt5f38qP7g/OMZrxXQSZ/N6PM97PIkqRW3H1DNndWOBuRwb7Fq
 6wE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:19:53 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/9] Add Host control mode to HPB
Date:   Thu, 18 Feb 2021 15:19:23 +0200
Message-Id: <20210218131932.106997-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3:
 - Attend Greg's and Can's comments
 - rebase on Daejun's v21

v1 -> v2:
 - attend Greg's and Daejun's comments
 - add patch 9 making host mode parameters configurable
 - rebase on Daejun's v19


The HPB spec defines 2 control modes - device control mode and host
control mode. In oppose to device control mode, in which the host obey
to whatever recommendation received from the device - In host control
mode, the host uses its own algorithms to decide which regions should
be activated or inactivated.

We kept the host managed heuristic simple and concise.

Aside from adding a by-spec functionality, host control mode entails
some further potential benefits: makes the hpb logic transparent and
readable, while allow tuning / scaling its various parameters, and
utilize system-wide info to optimize HPB potential.

This series is based on Samsung's V19 device-control HPB2.0 driver, see
msg-id: 20210218090853epcms2p8ccac0b5611dec22afd04ecc06e74498e@epcms2p8
in lore.kernel.org. The patches are also available in wdc ufs repo:
https://github.com/westerndigitalcorporation/WDC-UFS-REPO/tree/hpb-v21

This version was tested on Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri

Avri Altman (9):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Add region's reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Add support for host control mode
  scsi: ufshpb: Make host mode parameters configurable

 Documentation/ABI/testing/sysfs-driver-ufs |  68 +++
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 622 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  44 +-
 4 files changed, 691 insertions(+), 45 deletions(-)

-- 
2.25.1

