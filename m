Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70C6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 06:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbiDKGsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 02:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245120AbiDKGr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 02:47:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EC818361
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 23:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649659546; x=1681195546;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=462Gfp0cMrVNDiabsDMCnP35w8YBvHPTQC1wB0OhUbI=;
  b=IObYOHwmbvWb0fgV7kXYYOFplik/0uvOpJKXDaOAx+gGCWjPulOj5lqj
   ZNwu+xhnFa6DXGWIhHds0GeJWGVq8RfBw/DueyUA70jrSCvb8udMHMAip
   7AfCOMleZXUZoTM/BJ32w0PTmkbs9Y/IChg0RpYLdFMXDHmZwozE8UcR2
   4/pUu1x0jMMYiuAkfggcc5wkzInaUZELgLmH81kH8V+K4tJo8jS8myvPc
   Rl6MJiVpGMlSTik/pOE2eMihxcGe9pSdMJvl3fMTIKXvSBCe6JWV3eo5M
   OYvxyD3YE8zdYcNkzNT2dt2IXkOhwA7HlDwCk9nqsmjK3DW0PntyM548f
   w==;
X-IronPort-AV: E=Sophos;i="5.90,251,1643698800"; 
   d="scan'208";a="169136727"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Apr 2022 23:45:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 10 Apr 2022 23:45:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sun, 10 Apr 2022 23:45:44 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v4 0/2] pm80xx updates
Date:   Mon, 11 Apr 2022 12:16:01 +0530
Message-ID: <20220411064603.668448-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes bugfixes for pm80xx driver

Changes from v3 to v4:
	- For upper interrupt vector patch
		- Removed unrequired comments
	- For upper inbound outbound patch
		- Added comments for msleep(500)  

Changes from v2 to v3:
        - For upper interrupt vector patch
                - Removed 'mask' and 'vec' variables
        - For upper inbound outbound queues patch
                - Added a space before '*/'

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

 drivers/scsi/pm8001/pm80xx_hwi.c | 33 +++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

-- 
2.31.1

