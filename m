Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCDCC47084
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D17611CE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhEXLU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:20:57 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:17150 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhEXLU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855169; x=1653391169;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NXYWtokr+CxgFDtN639TdqkIJeHGAEFWzR4HgTguM6M=;
  b=pf47XvKWcfXrAcG1/3/4/DuvkyXr8h9bY8YcfA8kh7mLSkbafmM74yAW
   x1uDtK5GpwUpv3yWlTRZ+Vv/BltRxrZLQTYex1hWK7rGMjRlR4wUPWLCg
   CpcOH8R0l3ryhIlZBI/qTWv3Gl6gI8E7eAmtamwdSaE3nypSyWWXzWW+5
   QhVKu90/GBqyhM0IPxHB8hE3OrXghKWgYgZGTdbXE5P8/bgJ+wrSjDgh3
   iwK3BU7MwLk4uHrzGQHdDpylaWa41svNnU4OgvLHiaiVP/6i7OUY8fQ8c
   AomHWtidIAlb9uRoBCxtqf0YPP9wphbCVYT/Hb4SGaS0bcvXXaXyVyp9w
   w==;
IronPort-SDR: KVIDEgqEk1HEP3G+p36NsA8o7YhIJWBZGXYyz5fdfLZr+r0ByZlw1/amuwANqHUZm+fTHaOz5O
 O3xNrOIey9Jrv1ptouwwu6iRG9JD+te8aK5lnvcJpb3XA5xK/HKYGPLmGnuLu+GYdJdUnxhYRA
 xj8WXhX49i/OhZROPswVQDF4/2hqNsLUU5zW5ynGV7bCXCt7e/WQultSTUXh9wdrZr2EHiIL2U
 o/29LJdUN92swC6YqjFctElqjksTSc7uhs61/NsMByR7TRc8nqwmCjpIX1YdOEDINm9aSDFCdS
 Bw8=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="168540009"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:19:26 +0800
IronPort-SDR: j3GCPzrnKa6bWcxI+Ok2WwiKAbSoJwIqt8WDL39ZH8SD1p4YrPp2sMoX0k2UOvqTwVu9xZ1XmN
 7NpOLmMiMb1Mg5g3nYdZkoaKa3sDKpQFyLwBDzN9q6VwJ+h4g6v6IMLJgTSlF5juOegR4o1J7T
 HXKHR38jx/c0zrH7eH1nFY+Ale14cq36A1MQzbRFulWSuvNZnu1aiUfu4v0tyXm7T3zk0HhjIy
 3I4+FmMSiGsIhxJagydKeZSSMw7lACWIIQBdTZQrcEusfPPWSWXhp5WiY/LhKw/kINWikEtjLv
 Gspc70gnhRxB1P9+FmHU4yQP
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 03:57:41 -0700
IronPort-SDR: YQhTYhB3H0aDpw3wpvbYNngLiahI8H3jFW2nyVG/sjq6iZy6plRyh698lFuWIQMrk0PC5zw9t+
 P0BxHc7cSqrgekAq3AtuSamGNa7h7KPlk1rzBes20hvyITRIqx4JHDzGqoKiG0zhJA0GvdMiRc
 muQc7b4LstZC+b6wSsAfpClFukEfNFaApckPg4AXFR74E31ZBzODj12FKyh8c2RY7s5IyNhaEL
 4WdJh1jICXvWTeorX0buNW8NVTInC0uANiW1VGXkyf8hmwkS0Rwtf+TGjeffASldE0hsSCv6+I
 Hd8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:19:22 -0700
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
Subject: [PATCH v9 00/12] Add Host control mode to HPB
Date:   Mon, 24 May 2021 14:19:01 +0300
Message-Id: <20210524111913.61303-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v8 -> v9:
 - Add one more patch: do not send unmap_all in host mode
 - rebase on Daejun's v35
 - tested on one more platform - Galaxy S21

v7 -> v8:
 - restore Daejun atomic argument to ufshpb_get_req (v31)
 - Add Daejun's Reviewed-by tag

v6 -> v7:
 - attend CanG's comments
 - add one more patch to transform set_dirty to iterate_rgn
 - rebase on Daejun's v32

v5 -> v6:
 - attend CanG's comments
 - rebase on Daejun's v29

v4 -> v5:
 - attend Daejun's comments
 - Control the number of inflight map requests

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

This series is based on Samsung's device-control HPB2.0 driver

This version was tested on Galaxy S21, Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri

Avri Altman (12):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Transform set_dirty to iterate_rgn
  scsi: ufshpb: Add reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Limit the number of inflight map requests
  scsi: ufshpb: Do not send umap_all in host control mode
  scsi: ufshpb: Add support for host control mode
  scsi: ufshpb: Make host mode parameters configurable

 Documentation/ABI/testing/sysfs-driver-ufs |  84 ++-
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 582 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  44 ++
 4 files changed, 673 insertions(+), 39 deletions(-)

-- 
2.25.1

