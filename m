Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8973CECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CB47217F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfJOGSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:18:17 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49190 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfJOGSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2019 02:18:17 -0400
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=balsundar.p@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  balsundar.p@microsemi.com designates 208.19.100.23 as
  permitted sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="balsundar.p@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: NP81oVLqlf5PrXyL0i3fwHTzx46540wy5iz3kzcUDVDbFD99+LvuFLIJcpDxRm+Vlqe9weTBDy
 wl1lk4GyZqr34VI09HgXhLogblXi0+hXV7+5joCbQGqNiTm/FE9StJvDHgJ8rSWsPBqvGwMgug
 vyRwwnIPpUyQaYuRLPVSCzNHKflPylsyE164VIi5owDu8jdUuxe5KFVpESV7INFy5CuGuFVpN/
 ss7i7h0zfbcKd22p6b/I9Eib4dxTkqJiahW4/NBP1kXYbu9yNBwgZUzfhgAAnd7ujXk8ESI8PX
 eis=
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="52970447"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2019 23:18:10 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 14 Oct
 2019 23:18:09 -0700
Received: from localhost (10.41.130.77) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1713.5 via Frontend Transport; Mon, 14 Oct
 2019 23:18:08 -0700
From:   <balsundar.p@microsemi.com>
To:     <linux-scsi@vger.kernel.org>, <jejb@linux.vnet.ibm.com>
CC:     <aacraid@microsemi.com>
Subject: [PATCH 0/7] scsi: aacraid updates
Date:   Tue, 15 Oct 2019 11:51:57 +0530
Message-ID: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microsemi.com>

These patch are based on scsi misc tree

Balsundar P (7):
  scsi: aacraid: Fix illegal data read or write beyond last LBA
  scsi: aacraid: Fixed failure to check IO response and report IO error
  scsi: aacraid: Fixed basecode assert when IOP reset is sent by driver
  scsi: aacraid: setting different timeout for src and thor
  scsi: aacraid: check adapter health before processing IOCTL
  scsi: aacraid: Issued AIF request command after IOP RESET
  scsi: aacraid: Update driver version to 50983

 drivers/scsi/aacraid/aachba.c   | 11 ++++++-----
 drivers/scsi/aacraid/aacraid.h  | 23 ++++++++++++++++------
 drivers/scsi/aacraid/comminit.c |  5 +++++
 drivers/scsi/aacraid/commsup.c  | 21 +++++++++++++++++++-
 drivers/scsi/aacraid/linit.c    | 35 +++++++++++++++++++++++++++------
 drivers/scsi/aacraid/src.c      | 10 ++++++++++
 6 files changed, 87 insertions(+), 18 deletions(-)

-- 
2.18.1

