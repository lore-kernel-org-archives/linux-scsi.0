Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FA1C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016EB207B0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhA0POG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:14:06 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30681 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343745AbhA0PNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:13:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760423; x=1643296423;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cs+pTXz7SUNQuOGw5qtZD6Wu/SDnaXgmW3BV9okxO9Y=;
  b=h5iG2mQBEDlyB3u1PXQdKP97nR8Cp/k4gBol+bwqlQ4pJ7R3JFZXiHFM
   u/dUihXx/N2K9tQP74LaGWl3SyiQ/jI2FkFs5wY3VUq591ZLtK2ZOISfF
   l0sB1A/duIIq4ZXaKa9DL78b3zzIBhaFonV0kcAiDZYpzAC+9d/fYTrii
   QHAVAFzGcfVYopE1AfavdA30zlCqioIu0zg2pRfG2Vz4m9DWo8vYamUV5
   dedlUHtuYs9c+uTJde6aIzHe8I/a8Qf30fUUTWh81LBAh5F4iS0wTxifR
   b9+ZfpC9mZJLQFZ8DCyG4CQyCTFnn43NYFLme0g0xXxCcL8tpJOtAd/Gu
   g==;
IronPort-SDR: yt5I8pYSBZDPgQ4PhwEusCd4zx6qf7J+3IaQN5SDPc3jU9lKPBh9FVGfJHilhPLlYulYMYfOXe
 b83+z66z05w5xlaCuczYk62mkhPDuyDfo+wxyLno+f/OkAzyXsenCi1CasueH5/jEP/ck+nuKS
 u6sG2SNuxW5gK7tKjfMDAAm23UzP/pZec3nwHDr9FqsSlPVSWg+S+9W0M/83JhmOWzqKxD87Yh
 ml1jJk4t5xV7J9Ve2u4dhm7EwvNU0zlk9LTuo8HcK08C+rdCz3rkUq5Cq/dtgdnM8foBqYQzQI
 GmE=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="158454180"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:12:38 +0800
IronPort-SDR: G35u0EhCeayDmEiUDxnJMs3P0jcha64DLj8o5UzBxFkpEIc9HB9DZcA6roejzPtWBoYY7IACCa
 ej1DhORmn5KEpoSz0wxhtZGlo+Yaqi1+aWVpXQd+eXuoK8xWxEqq2aOmD6AVZROCrEjkAZlkDZ
 l8A4f3IMCPjIqzX0QzAO1hf07EKWE5gyeRLBabvmjy+tcHQJNJ+qJsmAbiYl87C0BUIl31KB6h
 03Uc5sZdykbHTuC6v4xNZaak/aUPvBxSzg/xbiouOZQCwePjNi+ifuffVSN4d8yXrxPOB9YTc5
 N60tYvCFHbK6zx/WIGbA3D8S
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:56:59 -0800
IronPort-SDR: lhhlUqcQtSw94TjPLC+KIW883fojWPhE+GuLNzaCkbobT4YpBvXAB+mlMqz2oxHWPeICLkdGLH
 cPWxyxc1cS8+oydpjgkVGedboXcV4nZ8n/G9m4cmuNR/poTLe6THJGOGGDxEIlavumY+tLKi1q
 kitC7FhILl3Y/2i7K+gPbDjqfhIqkmIMgdJx7qI+ZugSuSxpvWh0PwsOh6t5bgYwDJLvQT4Q29
 TXHfNxpi8D8gDvAb8houp7PfgA7tK6wEgUTkQZ0j8lFk71v59dA9z23yknwym+tSD8Um8Xq8hZ
 WnM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:12:34 -0800
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
Subject: [PATCH 0/8] Add Host control mode to HPB
Date:   Wed, 27 Jan 2021 17:12:09 +0200
Message-Id: <20210127151217.24760-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

This series is based on Samsung's V18 device-control HPB1.0 driver, see
msg-id: 20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6
in lore.kernel.org. The patches are also available in wdc ufs repo:
https://github.com/westerndigitalcorporation/WDC-UFS-REPO/tree/hpb-v18

This version was tested on Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri

Avri Altman (8):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Add region's reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Add support for host control mode

 drivers/scsi/ufs/ufshpb.c | 430 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshpb.h |  23 ++
 2 files changed, 406 insertions(+), 47 deletions(-)

-- 
2.25.1

