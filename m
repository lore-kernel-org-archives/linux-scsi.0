Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A61CC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F45F6121D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhFGGQE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:16:04 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10189 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGGQE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046455; x=1654582455;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vuaswDbaidKLYaIA+Zp2XtKHg8qhzvV9cfCPWEkQu9E=;
  b=JphTXmqku5dD0Fqh5etEpZt5mYidUboQv/tn/GpXgTrLyQ4sFnYY7rud
   /CejpKdoKXrZmgnd35L4F1mnc/y67GleJEYLFpf9Bpg45/VUkWcH6t+BA
   oJd/WwDVVA3kElxC8PnjdUzbYKgpccLF2cuAHBlxz3Y+IBchxby3vV/IH
   xmEx/+xfdI6/5hLdy8/bWsZZRMOK6SW1XqbwOPhfuiglCBDW6Z2tcul8V
   lwdYBXOsqonoy+kxHoDbDql25IQydcuzr+qTGEuX2hx1dfbY0TXOydsfk
   jgW1838uI0VOtdYiid41hfq2deUzLvU8i1E4DK5NLb90SYMGdPid9TGpN
   w==;
IronPort-SDR: lPTetB8ep/HLWBqQ5KruA3hAeC4e7ZaVEsUr5l+mKBjD51P3xkIwWOMryy02Mh1piNy7V4AwF/
 jrBWLoDZ0xMIIt+ayRKrqLyXiJEaqio8u9WuQ12TIAWCTMJea66D/t4FXj+8zrh6tSTC/j2KI/
 m5mYnzDe/hRIzLj9J7hdLONprU0neIZ0U9gSk5E/Q6OqilmArhLQIcFyoqu9NWSJGdjRuGutDE
 20J3Hvxu9LO78tleTtSOLLgzGTlznlXpFdZyNLVcmZlM2sAwmi7cDvuUV6BjO4NCbkQFsNXlyy
 YYk=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="274818136"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:14:14 +0800
IronPort-SDR: JRDkid2HDwpawKSyPMJF0uY5BZp9n3S8GXXWlhERJW8Sv2lLmEfJWpHSP27LgdVddQqAOaEOt7
 OGp6Arw9/0/3Ko8ZwUUJ71VTbvNo8zIbY6uI+6r2xS6JjbJRaDkEZe5r7u2dOD5cJMZFkn2mbT
 GRF9xdJKUmM2diygGkrIvhIcsNMjMZZk8BuefbL5QuMJwf0WZCj8TFDOpdIMzGwsoxn3/Wylgb
 bo8wSAIFpWKGES71mo6j1ATJuz8miXmhgfA902PRGUcXpK8+Ontcw89/GjIrQ83B1AfYuYp7VX
 mwiEizmtaZlFUtlpE4r19qnz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:51:55 -0700
IronPort-SDR: hqujrADHr8iicKa59l6VT3ScbLqzMFVWfLbMaCHMzxXwjtbwPztvs/wiznphqgTZlaORHuXgk4
 s3hCT6q/QWlRxJaW4uhLHQ+r39Q/F4TEvOR3jMLKOIT1JC+Knwai7rCzP6GqacNcbLcAufH/IJ
 j+/FfCb3BOnDvB4cpIYXuiNHSauiQSizVmbknn3IjONKzqzd3qYZynd6S2CoIdP6vtufbA11QM
 5IP1yUtctQdKD5MUJ4sG9mCiMfWfvCbVXbbhvPTJ0eTGvX1XAPtu7fEZlAbsFIAK1dtPfSvrmn
 4Iw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:14:09 -0700
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
Subject: [PATCH v10 00/12] Add Host control mode to HPB 
Date:   Mon,  7 Jun 2021 09:13:49 +0300
Message-Id: <20210607061401.58884-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v9 -> v10:
 - rebase on Daejun's v36

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

 Documentation/ABI/testing/sysfs-driver-ufs |  76 ++-
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 582 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  44 ++
 4 files changed, 675 insertions(+), 29 deletions(-)

-- 
2.25.1

