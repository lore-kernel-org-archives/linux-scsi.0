Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045F4C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8139619B9
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhCaHkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:40:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2908 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbhCaHkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176419; x=1648712419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q9muD9swngxzi75zG1ym5i7MkoMhiYejzyzTSKaRXU0=;
  b=BBBdOhskJqLTQZBLSllZfJ2motmmA1A7ayvNJD+gNZMEJb6ASNb3Sq6y
   hGYdzX3kG+jHPcQ4OeIaALRDhvzQyik1wBdpnX+EtMHnyPiptkhzayVLY
   foGkoYCktqrOrup4HyWuRui98K9CzFUAZ3cmuDN+SReVOjYVcU4v5GLOl
   2z0KL8emc/JDFsCiEGVQ0DQbUf8QpO0GB9Squ50ZBG0nhW7npvz/16kwC
   4VKo7ihrJyrZ0W/r42PVQMedZU8jQAE94O2lZH59vrQZn+ODo9zatH1rx
   t0j9y/78NyJsWPKyehCNOKrsOTZ0F5aTeUOGuPuSEWLT9oBpm7ujwV1S6
   w==;
IronPort-SDR: GUkXIJM3mkchZDfH9F+RWfBOhp+7E8rwWw6eCe32nyYqv4Zy8eJ6v1fX3GRFOUg+w88IDx2mfG
 YEt8x8QKkZ3db0YYKNCy/xPjf3EdKX7Nja7+24SuI0iUo9PADc46nGVXEEnA1812iyOBHbml0b
 T+2lJ2BjnmMlbymcMGujvwHbqUHNT3mqc3swJ5zVa5vWmTiljZmwv1EkSwcA/YEbbFRsrZy8H/
 teQHRra5nHD0WVRIkNILbxNi93zBOvhyEJPAyQTMfK896IQZTunjZy56M4KMNEcc+jKMSQbwL9
 MVk=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="164474606"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:40:07 +0800
IronPort-SDR: 9GAV4CF6YMvdhypyV/QochEJ/i7wkYujJyWsIPcci1wygSNEUGNyw2WAsstPKE5MBYuPmMgiba
 IXYKNrBy+LVWgaSqWaaPhUy0QroLLKDM4P1EjJSqMxLjfPI+zVxtqchWuSjQNCIj6X6FQrVFNU
 6jsSv1z54bEMHG/fBOHLVOrBCLJS1zlorKS1rc+0o1M1RuT0bt6uWhYd0ttzWMg/s3W4PO1Azj
 t4MZyVYitgLSkjVd+duOMPlyN6jpCvwtsZM9PNw9SOioG/Rg4ONOsw99Htj2w3LziRQSz7WtPi
 t1FEjmwe7hKOd3yCju3c4lh3
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:20:13 -0700
IronPort-SDR: fHsyatfGYepCRUdBScKIoHYbCjjPL+0HJ/+9kBJ2Mhqy2IADHy6LuS6Ddbng/+fC+ulMfzuaqz
 XRnTVANAT8EeuKXvP4+rwZUgHgg5meIDaJD4/Hnbyh1zceJPEzzgbBD+sOmA+rDnRKpLbByYj/
 N4LYuWP5DHZmZFhyGOLZtve9m3CGg2Jnic5KI8DNWiXeqZSzigWre0nfD89ynD22IXSfkELefI
 tpu0Qnj8ZSfvPTimwkyyduD+WL5F3cmEt7iJU3DmmKTJdy0SYZ60Q6kD4FdqaOrETfEbOL5ERn
 Ukk=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:39:57 -0700
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
Subject: [PATCH v7 00/11] Add Host control mode to HPB
Date:   Wed, 31 Mar 2021 10:39:41 +0300
Message-Id: <20210331073952.102162-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

This series is based on Samsung's V32 device-control HPB2.0 driver

This version was tested on Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri


Avri Altman (11):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Transform set_dirty to iterate_rgn
  scsi: ufshpb: Add reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Limit the number of inflight map requests
  scsi: ufshpb: Add support for host control mode
  scsi: ufshpb: Make host mode parameters configurable

 Documentation/ABI/testing/sysfs-driver-ufs |  84 ++-
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 568 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  44 ++
 4 files changed, 663 insertions(+), 35 deletions(-)

-- 
2.25.1

