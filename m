Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C60EC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiDHIHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiDHIHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:07:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D15525E87
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649405130; x=1680941130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vBIUiDrlOuILYoEAbEOWlb8YdiNzwcMYnbSfPEhUi9U=;
  b=mVncy3piF6bUmJok1yqNWJafnhhnWSIm+2DZHuf49aGlbAmDD8O5S2YQ
   /YbUZvjyyQvk22RqgEamWYyHaHtlZBdC9gIOuYUuhrKg/INBzGpRv4RmX
   o940cECrLnW2sMVhRm55KbtMwlnTtWkdzprL0/Ny2TNuqdrf3e0PG+pCy
   8oFKAMlWqx1GfMJh2qGHRKBUyEHakk9q2/Z+6DRXXSbNvlZog9fe7J/uV
   tWb7d5p8z8MdUokE7y44ru6J5wxu7cvhbV4utBqmfSa5XvGTcWJpcgcEg
   1mg+8R/st1mwpAS/4NUCcABbekqglxFs50v5eLf3ZkI1oQn/j/3P4Qzkj
   g==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="159404700"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 01:05:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 01:05:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Apr 2022 01:05:21 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v3 0/2] pm80xx updates
Date:   Fri, 8 Apr 2022 13:35:36 +0530
Message-ID: <20220408080538.278707-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes bugfixes for pm80xx driver

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

 drivers/scsi/pm8001/pm80xx_hwi.c | 36 +++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

-- 
2.31.1

