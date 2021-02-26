Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D537C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC4D964EE7
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhBZIe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:34:57 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:39220 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhBZIen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:34:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328483; x=1645864483;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0pGRZXLb1+wtT643DBu0cIFZ+O3AdUvJpqIxwaTZzaE=;
  b=GCCwgrQ+PImN4LhQjZOzSOqBXMxOHbP9CeNqgWLi/KpQDQumzOGM4e3x
   FKCeUuddmA85pCorVecGRiAPvcAUe0n7a6CBZcjvDGlOOE2Dvr7IYp8cc
   LvJDUrvPDEBtUTmhV4mbhYPwHUP6wmLufBWFTIhYm9uJNBKz2XRdaXlx2
   gauVG56Ok7njBisR34myJZHdC/+b7SXa5AyvGKhnYsjsLOU+8b/wMk+ZF
   f/T5B+5+yf3rj1IperNyA+wY8tO4H/U9tk2itf6OfqP9+JY4XQ8gVs4x1
   QJuH+hhwSTGqmmyT/4ManIKGr0Kl8/e3+x2HLTlMPDw29R0U3JyLPVtuP
   Q==;
IronPort-SDR: baVBaYXnsGKwdw19dU+OEknaD26lQqO6xT+2o4GDEtRMj8wx2HVBa8YiQwWb9/HMMDleBTOlKI
 dEtjqyHD9ilen6btuawDj8AviKY3V77r05Z8/0jxxwDcDpIQEKKhXRTDfkHxZusqyiqaKmLH5k
 GpYTFvWFzA0Hkw2VEEYDvrUkEBBjRzmWgo2bt29mJvpY6EREyIcRM8I//5Mo//qxvecEIFvKyj
 wUzbMbM3jPSNgZuNKk82z5rJgoftLaeZD9Gy+sU5rXTEMuOVrdlRF089FOhZNfYunGNmWAec8N
 LuQ=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="162040897"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:33:28 +0800
IronPort-SDR: 2eLVfA/RdUlBn+ygwwUndp3w3wFRyMqdKznU3aodnu0pbb5ohv/jqwvW9SAvC6cFbXC1d96btJ
 Hs7NSMeqHQ+Pd76P7fsaFHwvzCtiVweR0+6/HUhxj7fZbpqXNRRP8Rz9jgL6siufvxM0/91qui
 0rtwCuvYM6GHtYsa33x5bFM6gLBYl62NMezEjMz8A4tmrB0cvEWuVVhYtqygNnw62uPf0Wl6BM
 5nSvQh9qBffqfCZHhSNl9W7FUb4t/dNFIDhV7WPA72dYkBi4WAmnVF0l/PMhWfdjl1k4Gazoro
 8z0BQt5kxMtFp8OpDgoOK+am
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:16:41 -0800
IronPort-SDR: qsDd5HE+VLFeOkkbmI31DBIEi0LuuvYscolgNBXRMcpMSVmq5WJl+CZ/oB/9W9MX7rIC/K+L+J
 hzgEKYDFf3YljLHkAQ8ibEWVa7HJ1kk1v0jasbXpQrvwM5IH5Z4vI4+DO4xaCxm5fJhgftCLtG
 am0rgZCwIrZmn1jn5ZWYioCZ7sAc6PjsvxGEI58Oa7TgkPlUaGX3ZR2L4NV0j8DJBXc/WYqFyq
 6kGQNpvzFZfpQa7ZJb5c0jFIM/4az/3C5XQyX1e3OAn5Hr9qi9Fbi5G/tit2RU6cjw6ZIg24e5
 FyQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:33:24 -0800
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
Subject: [PATCH v4 0/9] Add Host control mode to HPB
Date:   Fri, 26 Feb 2021 10:32:51 +0200
Message-Id: <20210226083300.30934-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v3 -> v4:
 - rebase on Daejun's v25

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

This series is based on Samsung's V25 device-control HPB2.0 driver, see
msg-id: 20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8
in lore.kernel.org.

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

 Documentation/ABI/testing/sysfs-driver-ufs |  67 +++
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 528 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  40 ++
 4 files changed, 613 insertions(+), 24 deletions(-)

-- 
2.25.1

