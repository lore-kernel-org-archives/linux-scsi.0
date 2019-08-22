Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0325C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2C923402
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389477AbfHVUi4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:38:56 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2786 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfHVUi4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 16:38:56 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: fEmNpDzaJuEzobUoEEXlNDeyZGEzhKpPm828+1ahN37lT5F+QVpiVJ/xA917mh8nrUpm7rGn6t
 HevkS+k6kv5nj7pwwNRfkrwSN70WKDm3G+RcYnPMZ4AW8DMsB6jCUC+ZGtmGYifGtShFmC/+Ij
 ZuGYIxXyOBGQ42xPcnTNpvbQt/azHp0JdOgLcUTdTGwyQVnC1Hb4CaD19SZDxVBtPGenZqIX/G
 tsvQTTZ81ApY0vDyrBi1C28cJ0omC21vzKq5nFgrY34ctArHndQTTJLPmnzzTM0HsKqwVo9uTm
 RlE=
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="44671230"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2019 13:38:56 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:38:53 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:38:52 -0700
Received: from [127.0.1.1] (10.238.32.34) by avmbx3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 22 Aug 2019 13:38:51 -0700
Subject: [PATCH 00/11] smartpqi updates
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 22 Aug 2019 15:38:51 -0500
Message-ID: <156650628375.18562.9889154437665249418.stgit@brunhilda>
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
smartpqi-add-module-param-for-exposure-order
 - allow LDs first
smartpqi-add-pci-ids-for-fiberhome-controller
 - add in new controller support
smartpqi-add-module-param-to-hide-vsep
 - allow driver to not expose the vsep device.
smartpqi-add-sysfs-entries
 - add in vendor, model, and serial number of controller
   devices.
smartpqi-add-bay-identifier
 - add in bay and enclosure identifiers.
smartpqi-correct-hang-when-deleting-32-lds
 - only allow one pending rescan at a time.
smartpqi-add-gigabyte-controller
 - add in new controller support
smartpqi-correct-regnewd-return-value
 - tell applications that a rescan is currently in progress.
smartpqi-add-new-pci-ids
 - add in new controller support
smartpqi-update-copyright
smartpqi-bump-version

---

Dave Carroll (1):
      smartpqi: add module param to hide vsep

Don Brace (2):
      smartpqi: update copyright
      smartpqi: bump version

Gilbert Wu (5):
      smartpqi: add module param for exposure order
      smartpqi: add pci ids for fiberhome controller
      smartpqi: add bay identifier
      smartpqi: add gigabyte controller
      smartpqi: add new pci ids

Mahesh Rajashekhara (1):
      smartpqi: correct hang when deleting 32 lds

Murthy Bhat (2):
      smartpqi: add sysfs entries
      smartpqi: correct REGNEWD return status


 drivers/scsi/smartpqi/Kconfig                  |    2 
 drivers/scsi/smartpqi/smartpqi.h               |   20 ++
 drivers/scsi/smartpqi/smartpqi_init.c          |  236 +++++++++++++++++++++---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  102 ++++++++++
 4 files changed, 325 insertions(+), 35 deletions(-)

--
Signature
