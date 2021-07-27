Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A01FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F31A60F51
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhG0MgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:36:00 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:7240 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhG0Mf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 08:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627389358; x=1658925358;
  h=from:to:cc:subject:date:message-id;
  bh=KhgM0oQkde706gYvYCh0yOxx8aEOCcj81ltr1Ja0QeM=;
  b=aUoCe7aZ7ZnMtijX4X03ZgaGh/dt399yC5cdhPEYNJ9MIFcqZv1Q8A05
   x1KbsWl/CF6186rfd1V4QQ585g8gZalXyvev30fpQUKWaVDhEeZ6z3RGz
   GAjv6/aUQhmnKGap1EnA767aV4jbPQkiZKux3N9GeUFbr+j2TwueGpqyv
   3iq1ZH86yuqJ3J6vYwxcBPlRrZtwuvneFtisWJSViN3nZmLOn/mGizo3c
   oKPMkqEhn/nGzFtBnDELpoUNzzxx+zf4sWK5UjaKanE25vEtaI3IOeOD3
   BfS6t+r5JyLBzN6xa5S293pX/uB6vSpuqOLjJ5C+8LYtxOpV+fkemFXe/
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,273,1620662400"; 
   d="scan'208";a="180410831"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 20:35:58 +0800
IronPort-SDR: 9wdRZ+QaH5cvF/GxVZjPoXPDQPZf9BjKphI8fZZDKgC44kXZEteFLi51VT2Oep/WBah9iJ368l
 mHLdUPmz8Dz74NQnOVYFI3YxkduVb2U5Csa7KGS16iY8qX47g1we/c6OBachodZDqFtNeaLKIw
 Svu2BHFcWo4zEi9xpFNX54SdRzq8cdKqkU1/VL1m+0etKnLLS+x0k8PGliTwNNrrOBTAU+jGqZ
 TEf2eguMP8X0bBzno8XQChHrG7/wgWYJyQ3g1lLdzG0VIklBiY9RA3C8+/I5ccOZdvV4XWf0ib
 JfpXJOxi1sZeRmbflqSmJqbp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 05:13:42 -0700
IronPort-SDR: AMX8hAcB1MQMnHrSu4xahtJCNC4ej7Ff1JWlvuuvK8uq0rbldYfDkKwlLw8hqj7v8dS8D3VTpd
 lIZCW9/wItTL/ibkExEQiVufe2oy3KOO04C8WJF5qgWyIopwWqc58oHGBhKTL9hvRUXCqWE/Yi
 G3/MNbQeFSxgqEcvwH2vg+vvcfls/BvjqI3UpM/7paIqWWh45Mk18FAxaGn1fb/TU6n/4kKWix
 HyiRROaEZzpVOv7hjlFMTYTqCnI9N49QTHAuq9Lst81o9q5Aw62gj+UOXMacuAd1b/ohB+mJH2
 PUU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jul 2021 05:35:58 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/3] Log correct rpmb unit descriptor size
Date:   Tue, 27 Jul 2021 15:35:43 +0300
Message-Id: <20210727123546.17228-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For the rpmb unit descriptor, if the field offset is larger than 0x23,
it may trigger a stack corruption because a) we do not log properly the
rpmb unit descriptor size,  and b) ufs_is_valid_unit_desc_lun() test for
specific wb offset case, and does not verify that the requested field
does not exceed the descriptor size.

Fix both issues.

Reported-by: Bart Van Assche <bvanassche@google.com>

Avri Altman (3):
  scsi: ufs: Remove redundant define
  scsi: ufs: Map the correct size to the rpmb unit descriptor
  scsi: ufs: Generalize ufs_is_valid_unit_desc_lun()

 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufs.h       | 21 +--------------------
 drivers/scsi/ufs/ufs_bsg.c   |  3 ++-
 drivers/scsi/ufs/ufshcd.c    | 19 ++++++++++++-------
 drivers/scsi/ufs/ufshcd.h    | 27 ++++++++++++++++++++++++++-
 5 files changed, 42 insertions(+), 30 deletions(-)

-- 
2.17.1

