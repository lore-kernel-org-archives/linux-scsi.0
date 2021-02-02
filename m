Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC10C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C34264ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhBBIbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:31:32 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42108 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhBBIba (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612254690; x=1643790690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OCdpwgqTjdpm1vlos+hHl6mfuQuYzHnv5sqBXpqxmSo=;
  b=j6x7OTz/+E/YU5L412MBW7v97bH/oxZOBsub/uycRJExXa4Cyqt9CLG+
   SLwl94Tl9J+46wAfXO+XXXc0FVmpWn78wdL4BqHiZ6pP1fq3jTH6/IcA5
   qaH9M800KJw1CBsxP1mSGcbadFXgGJAAGfkGUiCVFLvVvvlQLqXJjzwsB
   p2EcVTfA8ag9Cq0k+XXVKD824sPJXHji8Ld6qDw9KEkbEnVgOIY5j24ve
   3tvjeHSnkxPLvfT20qm7yZMFjpkYP0H1R126wtAl3wyeeisGBmPDhm/0f
   2gHauFU07shiuPoQOE+PvyXsNFndHnR8RZ6TEVITx6eHtPlyJhhhnkE4F
   w==;
IronPort-SDR: wqKg/QFIzArnUEoKi8p0fRYhJpnAVRZvACxjMmW9DdOCClARZdmkV1Mu8zQpBx7eAQxsuiGgMW
 8Kr4I/R/f+YliWlA2psDf1AMruKySzlYLInbtRInbJc8txOvlKwJn6ibTdEDFn9tii6PcHZ2Ao
 H1mUbEmj+IVIQ7YYw80pGZrUaotGTKwVLa90j9sNLVq6ZZijGFI6gHSb+b0GIKzby/cet5IuEp
 yYQRHMqBg76vagH156LCL+cA/rKHIUu/RpJ7HmiGc6P3Wlo/lWAWlCoNasRwkL4Dj3HfVFEAER
 D+Y=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="160083458"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:30:20 +0800
IronPort-SDR: KfGVjQcUVVcYlFXGsuizdapaM6AMtG7iEQ2F2F5CjTmWqw/5Jp2tTD10mpUv/uQfJR2vmxRUMC
 yJ3sD0WKN4PXp1sO4mWlnn5zIehAJEkias02c/5qDHzTgjpEr3LbNbesJR28TifFXo2inVsWRN
 x/mUOTAAJzbnQB02TKv9G3NZGzoPqk+CAfX30w2nenRrW96/dnO+btXzgyUDQ88GfbR9Q2Bthi
 P7NDyQ5AJpr8bFdf84+zqXLrm7+WY/BWeL83FtupKDOhJACOZ7mbfvl4RJyDvZdwk281xe2otF
 hSA3ZP24xVpFNuzlkDAi2lSI
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:14:29 -0800
IronPort-SDR: gu3FR2BzrMtWzyiw24YhkIMG7b3CBCFYLfyNTfo7AT4m1Xp4slKrm5SC+nOSGH8FH5KF5WG9Jk
 myjb+32azyYXUzklhENsGHjwYX5U/DBzUpQ0otwFXUNaPh1LFsjRZUYpE3GnBYzIGyDpuzCnuy
 gogexgC//WM49sP6/8GN1UA1bKplPhewk6WjXyPA5FssxdY5e5g2QJnCCRFqdIGtISx5quGJuA
 P8pourcFBdeVS4mwlDxwgLhIllGkZ20pMcFu0UO+bP6f+3lQQwgbIvyxQUqmdJRJR31oh1iAZU
 guY=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:30:17 -0800
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
Subject: [PATCH v2 0/9] Add Host control mode to HPB
Date:   Tue,  2 Feb 2021 10:29:58 +0200
Message-Id: <20210202083007.104050-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

This series is based on Samsung's V19 device-control HPB1.0 driver, see
msg-id: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6
in lore.kernel.org. The patches are also available in wdc ufs repo:
https://github.com/westerndigitalcorporation/WDC-UFS-REPO/tree/hpb-v19

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

 drivers/scsi/ufs/ufshcd.c |   1 +
 drivers/scsi/ufs/ufshcd.h |   2 +
 drivers/scsi/ufs/ufshpb.c | 697 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  47 +++
 4 files changed, 697 insertions(+), 50 deletions(-)

-- 
2.25.1

