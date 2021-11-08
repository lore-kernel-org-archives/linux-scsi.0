Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8B9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 12:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E91611C0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 12:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbhKHMLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 07:11:02 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18520 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237547AbhKHMLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 07:11:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636373298; x=1667909298;
  h=from:to:cc:subject:date:message-id;
  bh=eH1Gb+IA5IdkGUdWJHRt8g479OQztDnYXIbbY5QfhYg=;
  b=pgTIKRqaZR8Ap0b6zJDLOV6jHJW4aOPMYG15ArdxCcQ2I3bD/9scosIJ
   rMabctw3jC6P3bGmshM1TkNwK1pnBc57SLpCkyUIhUHJyW7WCyfLVzt6P
   W8if/XC9diSS14C1pHEuDHUONSWso+7cYOG3U9+rpXsTZwO823G0FIpH3
   YM3063ZfTLkNjjnJ0Di5TfA6ARo5Uh7EylOgCvLvtO2kVR8BWYZRbaZVc
   BsLpKvp+xEy4Fg+ORzy2trhKM/PdKiQaXVvrskfGUEJXv66Udiv3m6iwq
   d+Y+EcLBvFBVlVL46P6oBcCK5jBEYEfZgFudi4NSRiSVMgrCiuhyyaF/i
   g==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="186004958"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2021 20:08:17 +0800
IronPort-SDR: 9fnoYJTcQdP/ADpzCZ9HHZbqeoYRJ4WvpPu1pOBeP5/3qjmo4NUuUUdOMJoa9kG0wfI8xdODGj
 d0mjtTWmQmkfsVzoAWGJNORaTGWr1opsepJVHyhl7RD2V6d8lGtG3ozDcOPnS6v5ZvfYo+Ie0q
 tEgK9tYmpFICurHxrT4FE+g9tvYuqHIfzLl7vOkVAe6TnU4k2pQjm2x9mjIrIlf1Og6YN/NHt4
 G5ZW2p/i1cuY0L88J233MUJFU5sZLH53Y+hPfikc/ZxYvZM81b1g07aao5TnyrFpVD441sWop0
 9PEpHhcRPhDWlZqq97VDpg8i
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 03:43:30 -0800
IronPort-SDR: rPP9i10Vnmm1XrcC92owDvVUUgR34rO5YwqKyhcwNmCKGoyzD1kV1U36YH+pbWyGW8lYOM8p9k
 f/96aPHJXq7wa7qTvF9crfII5q5pkhZuG/CxZ39ntHPf+zILiFdNarw15B0vfsunY47P2GH0aZ
 cLTwIGnGJpflOZbvscRbXdh4MYZ2jV91AVuSBfp5QHwbp4xfoNA9V5aT7btpISUOW8F3iuSm3i
 frFI7uiKTYNU/GjiWBpPhX6M9FiotIZeySXF8u9v8b2EU27OYlE44GDymKDf+L6lnAgbk7CPNX
 mS0=
WDCIronportException: Internal
Received: from c8jqy33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.157])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2021 04:08:14 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/2] scsi: ufs: Block user-space access if eh-in-progress
Date:   Mon,  8 Nov 2021 14:08:02 +0200
Message-Id: <20211108120804.10405-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If error handling is in-progress, keep things simple and do not allow
user-space access until we are operational again.

Avri Altman (2):
  scsi: ufs: Inline eh-in-progress states
  scsi: ufs: Return a bsg request immediatley if eh-in-progress

 drivers/scsi/ufs/ufshcd.c | 15 +++------------
 drivers/scsi/ufs/ufshcd.h | 26 +++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 13 deletions(-)

-- 
2.17.1

