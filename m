Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3C0C43219
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 10:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbiDEKzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 06:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345021AbiDEJmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 05:42:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEF7BF94D
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 02:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649150900; x=1680686900;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m/MR6Ydh/2OCNeWg0xga0xQ0DEr3C8HDUeH3uTHRrCU=;
  b=sR/dloa/tj0q9Jo7opavRakeCkgU5Gg+QEcY8Pmd99y7Reo3j+cU269a
   vGfT/nrQW2Z5bnQ0NLjeRZhof51CWU0JwOo/nWv1QESgaVQI1gKqZFW4y
   3xXeMYhIz5LlpXmzBR/UKsCPe8RECSOic6DhLu7q+B+KXSN2VjcP2UuTf
   ShnqSLcvZTx6PdIoUoPeSnsfLw7HWskqZLcgkc07SuUCIwDQiNJrGlxbu
   le2TmO93kEa5AwCaVRF8Egp9U48N/aJoc/yywQ7ZUAt1h57F2y5s3CDJc
   fheqyjtd59HskB495VYMS57tkUMryHcC1i1NpkQVvgeCafm6FqyQNcfUx
   g==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="154410406"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 02:28:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 02:28:18 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 02:28:18 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 0/2] pm80xx updates
Date:   Tue, 5 Apr 2022 05:28:31 -0400
Message-ID: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes bugfixes for pm80xx driver

Changes from v1 to v2:
	- For upper interrupt vectors patch
		- Removed unrequired casts u32
		- Removed '& 0xFFFFFFFF' operation
		- Removed 'vec_u' variable
		- Added 'Fixes' tag.
	- For upper inbound outbound queues patch
		- Removed brackets
		- Removed comments about msleep
		- Added 'Fixes' tag.

Ajish Koshy (2):
  scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
  scsi: pm80xx: enable upper inbound, outbound queues

 drivers/scsi/pm8001/pm80xx_hwi.c | 37 ++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

-- 
2.31.1

