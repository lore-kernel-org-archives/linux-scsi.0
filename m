Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773E7C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50525208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgGaVBJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:09 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:50806 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgGaVBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:08 -0400
IronPort-SDR: XYa4mTAC8UyauP0C23ifIpZWrQsNmA6hMhUcnxow3EYt4BqBRDLKk7z9wO+nMfz9SlilE6DQY7
 CqJBXqsoROXioB8/TtFgaZZmF+93C0rEI8Hy4dxsP/nxPG4mqp9Jeg+5yA2gms34WczfFuWvRg
 YHjPSLkhoAakutP1ql6Iz/Cq2aXPBdHr04ox4VWQKGAqV86YJEtNTwCoJp/dk/wydVpCkJWHp9
 /+U4M+AfVIZaB8kFVUhgAXB9L84/IO4oBU2x7GyS73W5LgIKo1ZN9NmCueKNWQAUjr5fQAOuFb
 J7s=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="81993159"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:02 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:01 -0700
Subject: [PATCH 0/7] smartpqi updates
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:05 -0500
Message-ID: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
smartpqi-identify-physical-devices-without-issuing-INQUIRY
 - eliminate sending INQUIRYs to physical devices
smartpqi-add-id-support-for-smartRAID-3152-8i
 - add support for a new controller
smartpqi-update-logical-volume-size-after-expansion
 - update volume size in OS after expansion.
smartpqi-avoid-crashing-kernel-for-controller-issues
 - remove BUG calls for rare cases when controller returns
   bad responses.
smartpqi-support-device-deletion-via-sysfs
 - handle device removal using sysfs file
   /sys/block/sd<X>/device/delete where X is device name is a, b, ...
smartpqi-add-RAID-bypass-counter
 - aid to identify when RAID bypass is in use.
smartpqi-bump-version-to-1.2.16-010

---

Don Brace (1):
      smartpqi: bump version to 1.2.16-010

Kevin Barnett (4):
      smartpqi identify physical devices without issuing INQUIRY
      smartpqi: avoid crashing kernel for controller issues
      smartpqi: support device deletion via sysfs
      smartpqi: add RAID bypass counter

Mahesh Rajashekhara (2):
      smartpqi: add id support for SmartRAID 3152-8i
      smartpqi: update logical volume size after expansion


 drivers/scsi/smartpqi/smartpqi.h      |   4 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 301 ++++++++++++++++----------
 2 files changed, 189 insertions(+), 116 deletions(-)

--
Signature
