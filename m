Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734D2C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C23620715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pHphaCH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgGFMdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:46 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37661 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038826; x=1625574826;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t4Oqg9DW0k2pDuoAwlZv0is7Kv9ts5WRK2pV12M6WEE=;
  b=pHphaCH4yv71Yr+GCIuujprMWp5ZXIzkc6HDLz5PEMvLkKMK+F+bZenI
   T16CnFSq04TtE4hKGDbPs1aP7yxPBMurGydx8toubK6zR5jUivIEeLvsb
   N3w3YEW9AOvAtadEteGtv92e4WWbncEgBRRUqDvA7QJ7k2ofcVSnHgHkq
   mwzaFUlorq66qxNB67lmupBS/0zz4WdbrbhIFcACLpWSssFzymD0///Ql
   AxV7Tq/sau8D8CAiwXNEqx2EekJr2KYv0elhXaAL5ZzdR2fhFLMwAYkzp
   QCm+3HnmK1DBVa5w7ysSjXV0zu6Q3RQmSPrM9TejB/iElvROHQa3jVT9t
   A==;
IronPort-SDR: NscJ0Q9yPv3YDijy+ip3P/Ukpl2DXJ9cxgLmHb6OK3VdrDfOerziVfk1i39ISDxVzvU/2tzizg
 KQNn9ovucpIZRqzF9xXZL/7uVkqtASHkZOMcSLWM3+6Z0qQvgi9S2ZSC2cnLBdfyCYboAPTK/u
 w72nDpUOiDuudnCLkZQG3SSeZ3oMB5PmYnwtie1kEIfPAqSRV7l9lRP+tzrvdgCViJDxWs3RhE
 sbGXvek2asSCBchDLnQ78JXOiRfyjobPZaNNnqh8PlfQARqqToaqUzaGVHhlTt0GGbgyhpuFpV
 6OA=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052055"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:45 +0800
IronPort-SDR: ci4TW0dMz9dcf86WdIx+ssQUkq0uUKuKL//F+qpun6nK2039I/xcdEfLCqgTu7efA56MUm07EW
 LffZ1Vp46xwlHtpah8g5G/EzD2OU+iaS0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:21:53 -0700
IronPort-SDR: axoPsQUtkDgHXUMMU7qIP69dHTQC0LNzya7KQ8h7RYh26DklL2ARWO2hvZBlk7TnQvnzajgM6Y
 RBfpVwwmYSfg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:44 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 00/10] Fix compilation warnings
Date:   Mon,  6 Jul 2020 21:33:44 +0900
Message-Id: <20200706123344.451738-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches fix various compilation warnings showing with W=1 for
the megaraid and mpt3sas drivers as well as sd and sd_zbc drivers.
The warnings are mostly due to incorrectly formatted kdoc comments.
Some "set but unused variable" warnings are also fixed.

Overall, there is no functional change introduced by these patches.

Damien Le Moal (10):
  scsi: megaraid: Fix kdoc comments format
  scsi: megaraid: Fix compilation warnings
  scsi: megaraid: Remove set but unused variable
  scsi: megaraid: Remove set but unused variable
  scsi: megaraid: Fix set but unused variable
  scsi: megaraid: Remove set but unused variable
  scsi: sd: Fix kdoc comment format
  scsi: sd_zbc: Fix kdoc comment format
  scsi: mpt3sas: Fix set but unused variable
  scsi: mpt3sas: Fix kdoc comments format

 drivers/scsi/megaraid.c                     | 222 ++++++++++----------
 drivers/scsi/megaraid/megaraid_mbox.c       |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c         |   1 -
 drivers/scsi/megaraid/megaraid_sas.h        |  20 ++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 175 ++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  11 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  93 ++++----
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  14 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   7 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  16 +-
 drivers/scsi/sd.c                           |   2 +-
 drivers/scsi/sd_zbc.c                       |   2 +-
 12 files changed, 304 insertions(+), 263 deletions(-)

-- 
2.26.2

