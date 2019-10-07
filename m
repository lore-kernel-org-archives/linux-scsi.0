Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8056FC47404
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D7E6206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfJGWbU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:31:20 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28978 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:31:20 -0400
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: xCzj/EH2wIi2beRmlls8kDfDw4tEzranqeeXSFQqTAeOde+e/EreZTtrxASiMaEiWUopBuZD6p
 dID1s5azIpjoXOVQ5zJLEDU9ngcWlilj9QzM+dp2HXNlSa0G8FmOdBJ1vXaz8/sbc0YRFvvgUe
 jomRNRfbhQxvnrQvrOd7fRwwNfO/+X2BElMui+y9MrJUa2tCOOyHHXIhadajEadNjOleQPGn2d
 LOq7kXRT57c3/Hw6qQ9y7LZbPFmCzYoRjszcV5y/cLREUyD9Wga2E7auPTT5nQNZwQxaCd60Cq
 Nww=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="52063884"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:31:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:31:17 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:31:16 -0700
Subject: [PATCH 00/10] smartpqi updates
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:31:17 -0500
Message-ID: <157048745695.11757.6602264644727193780.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
smartpqi-fix-controller-lockup-observed-during-force-reboot
 - correct issue with reboot -f
smartpqi-fix-call-trace-in-device-discovery
 - correct tear down of sas transport devices.
smartpqi-add-inquiry-timeouts
 - add support for timeout in pqi RAID IUs.
smartpqi-fix-LUN-reset-when-fw-bkgnd-thread-is-hung
 - add timeouts to device resets.
smartpqi-change-TMF-timeout-from-60-to-30-seconds
 - decrease timeout for resets, resets are retried.
smartpqi-correct-syntax-issue
 - correct if statement.
smartpqi-fix-problem-with-unique-ID-for-physical-device
 - stop getting unique id from VPD page 0x83
smartpqi-remove-unused-manifest-constants
 - remove unused constants
smartpqi-align-driver-syntax-with-oob
 - format changes, no functional changes.
 - bring kernel.org driver format in-line with out
   of box driver.
smartpqi-bump-version

---

Don Brace (1):
      smartpqi: bump version

Kevin Barnett (6):
      smartpqi: fix controller lockup observed during force reboot
      smartpqi: change TMF timeout from 60 to 30 seconds
      smartpqi: correct syntax issue
      smartpqi: fix problem with unique ID for physical device
      smartpqi: remove unused manifest constants
      smartpqi-align-driver-syntax-with-oob

Murthy Bhat (2):
      smartpqi: fix call trace in device discovery
      smartpqi: fix LUN reset when fw bkgnd thread is hung

koshyaji (1):
      smartpqi: add inquiry timeouts


 drivers/scsi/smartpqi/smartpqi.h               |   77 ++--
 drivers/scsi/smartpqi/smartpqi_init.c          |  429 ++++++++++++++----------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |   22 -
 3 files changed, 289 insertions(+), 239 deletions(-)

--
Signature
