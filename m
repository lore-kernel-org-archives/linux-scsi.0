Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82DCC4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960A76101D
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhHHJA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Aug 2021 05:00:56 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50631 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhHHJAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Aug 2021 05:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628413234; x=1659949234;
  h=from:to:cc:subject:date:message-id;
  bh=jR26YLBvlhKg/hguwFntiNL8kCbXJxE4Lbn+k+oiwH4=;
  b=jiEInb9FnimMBOrM/ODdOQe3VI/sdG9X4WsUrEbiOcOxgRTymOMrhC90
   bBANQ/dhznQVdMMajqQK2kfHNtCi/JIly5H8yXNuoSz+SWaScIb/tVEoC
   ZBuVvUHH/pp1YNLGkkcKN9mzBBR3318Hi3r/gwvUXvGucvHkVUaNJCC02
   YH8RltJH5iaJyrNG5TtelSFcgFV/U8TutTV+jWeVbUxsYGCmXps3rshkq
   0Hk+nzMo3e7l18thHJkutltb95vduKfECbi/FMhwN0HTag++WHdO9J/y0
   ItsMD3aI9udR9x/VFR1KpaVgLwCeQLKU0CKqoQ/5/CoS5clc5iLhHszt6
   A==;
X-IronPort-AV: E=Sophos;i="5.84,305,1620662400"; 
   d="scan'208";a="288167957"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2021 17:00:34 +0800
IronPort-SDR: orBRabjdoY1kMP+w5t5dXOMO8xxYAByFsZ3+1OjDlCPmXzlcHaNmp31qcXqCUj7hWIqMN4BkhC
 dWfujPcNEv8ND1BDylAH4ceF11oIJsQxWdOI+VSUnmWKjDR9SNcYCq/AlPo91cSulBeqCY+M0u
 OrTwe/P40vwtuszvhejlZRZTh6YC9JayI8KN6hcJh3j3td5U+DclXRDUg9IwxWe+rMy3o69CM9
 /mrB6TLyFvEFnZxXSKThSrdzm9HXaxrVCXCgyQfonigit0MqUA6O52my15k0QzGXahtvOt37Q5
 VJF/XnCeYGAJxs7m+/aDrsPq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 01:36:08 -0700
IronPort-SDR: +Au7qnkbpvwrSWQ4451C3mEIbU11vVCzlc6SuKhy/pCh4Yv3faO8clSCK1x4OgjRH6liiX6MGY
 LrGnDy3kp76ICSJWAi/kUwsCmqeUdAeJxU+gYe5klZ+5ZkflUhlk0AhnHHzhez6SSRldZwOCm3
 aSkGkbh0KMJD6UeY7MQfGy6ijMSNZ0HT1n/VLEpyf+/v9GW5e3YZT3PmExthhSqVTv1UbmdXB/
 4EfRu5gtNNz2JAyjno7u+sLsvsZYSDpTl42DJXoYOnnLEz/hLEkPsjeHgOfkZVED4yakyJypWE
 els=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2021 02:00:32 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/4] scsi: ufs: Few HPB fixes
Date:   Sun,  8 Aug 2021 12:00:20 +0300
Message-Id: <20210808090024.21721-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series include several hpb fixes, most of them host mode.
Please consider this patch series for kernel v5.15.

Thanks,
Avri

Avri Altman (4):
  scsi: ufshpb: re-wind the read timeout on every read
  scsi: ufshpb: Use a correct max multi chunk
  scsi: ufshpb: Verify that num_inflight_map_req is non-negative
  scsi: ufshpb: Do not report victim error in HCM

 drivers/scsi/ufs/ufshpb.c | 29 +++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshpb.h |  6 ++++--
 2 files changed, 29 insertions(+), 6 deletions(-)

-- 
2.17.1

