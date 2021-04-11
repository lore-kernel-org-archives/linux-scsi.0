Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C99C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16B9611F0
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhDKG2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37415 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbhDKG2U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122485; x=1649658485;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cDgcFgdNfqAAPl0YGQrnLQzdkprNtFk3ycK2ciXghnE=;
  b=L5agACOnqZXceXzHSOAfYQw5G/qhY6WaRVCbltKYHcHz3heyiSnQ9EMl
   s/dEDe30UmLFatGuAAbmDTEXdsM+SUeGVttVmwFQPNOWh0ec/F0zfnXBL
   blHwZ3l5hWTLqfPjd+u509UDCIq0XKrMp+7l7PCtynSAjNqt9eYR0Er/S
   igZeoX54iikkRCjEoiOzAJyS0uhhfAQHpIwV3fMQ0aLiN8GtXFksOrZRF
   ZGObR6gx9HmaYb3k4x5rKnN9XKkBEq/iVQJUlAHyL/ro4yU23RWYK18qt
   PxmBf6IS7N9DACqHL3ynwEFDHk37NM+YyWgO42H+nA78w3MxcLhY+SA45
   g==;
IronPort-SDR: lOy1YnCcsK5fbfCcjjxzJWfeUpZ11OD0pR8RqfCC4bkKuJaPbuJkm9WcAq0T0U/4jrDSKR8Nuo
 gaPB+5YYJTiC1q5Nrk8qnb0Dsb5oWG1dG7wkPK9pNE9rQjIUKRJq15CFJtkpnb1qTZUpd4dVyQ
 bl6nIby8k7aLDO7E+4HAc5o+gBm8q8AA/k/XQbzPqrp4PvIZLWU5MFu4x2EkqsbdFnSN7u455X
 K+6cyiVMDh9+sRNlp8/ljVk76MdbgXl0IeoOJDmarM3cHRnRARpJnepMEIt/x5dh/JuqnOtnJO
 kcg=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="165243134"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:27:45 +0800
IronPort-SDR: agD7e+kdb4qPGVLzzRJuCLUuuNoSxWOAWP49u7gBs+HaWk30hEFyWbPff/5IVqRPFpNjojjuk4
 BZ1WM7Qw6JUFQ+5D+T1Yo60JmIiJxcKRCiN03vQHG0BlE1z55w1gZugq1DpViWI7pMFjy8AFvq
 E0e9y+qous7Mq0f8cFHymBPvIm/o7Cj2BVzFyRzC5qe+yuHYjn/G2JrmYWiuzei694Dcq14vAA
 6i5Eye5SHClfVtlrHnboCxbiMvulF8lIlx3tyjYm8ZD9zqwtkJw4pk8toEp7XMYfR0a3cnQxEz
 Z5rpNx6Sa/Hz4aEIpNPNn3gz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:08:43 -0700
IronPort-SDR: /CqJo/Niae9YZ7duTp0J5aNzpNnd8YbF0CHpcjVf4TnVMh96jhXwOWYkfyC/qinNeLNTjYsOh7
 qxEr5gmkfD4wfy1IItO25LIRUikORJd5z39RPCcakKez2EJzXUdU9OJ1jpqbwDn6bISk6rOcG/
 LkE+aTksgMJ4VEmAOpmwSPGBIMyL1LNdOLiy+AUjNl7XVCkTf1irkpz3iLxPK0+yRHvQc/z+L+
 uUthB9Qx78CKE58mbl5JyyqSq+ZM9FH7gSgpzdf/BBkGS539HfGeBZuWGHgiVIV8dxAmMCipS3
 ojs=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:27:31 -0700
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
Subject: [PATCH v8 00/11] Add Host control mode to HPB
Date:   Sun, 11 Apr 2021 09:27:10 +0300
Message-Id: <20210411062721.10099-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 drivers/scsi/ufs/ufshpb.c                  | 566 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  44 ++
 4 files changed, 661 insertions(+), 35 deletions(-)

-- 
2.25.1

