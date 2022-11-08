Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE49C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKHTTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiKHTSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:18:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2347542985
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935123; x=1699471123;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X5+6FqdY24s99yFdGuTfWrG1kHj9HtQbdchdDvA2N+0=;
  b=HIvRyoEC/bkbokAtDUlZkvIlOpeRPPrjYgL7PiWeyyqlWhdAqj2eczp4
   RM1wzfOfq5ppV7NZqLcZoLCn7cPabBernl4dy+V9JeXJTSkPQ5+wfr5qa
   Fqs/V1ecdwavOtWx4ZszKErylMZEAVKrKCsqx1RrB46ePp2zXmpgViPwW
   xP99UZqL4m35nKVjkerJQ9jjqRbUwc8xVjKjYZqW+NL2mUv+dJHrkOn0q
   t0Hf/tzZnmL4HLnxuGuyteGi61qRY7EyoOhNpFfNuU70CKF8cs44FKqBL
   fm6Nz7cV7mXTIm6v1UYiVDalxy9UHYFWTpxqyWwq8kKV5HdI/g8jeCS6K
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="198948980"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:18:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:18:41 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:18:41 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JLXD1322567;
        Tue, 8 Nov 2022 13:21:33 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JLWIk322566;
        Tue, 8 Nov 2022 13:21:32 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 0/8] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:21:32 -0600
Message-ID: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 6.2/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.2/scsi-queue

This set of changes consists of:
 * Add support for host_tagset.
   Originally proposed by Hannes Reinecke here:
   Link: https://lore.kernel.org/linux-block/20191126131009.71726-8-hare@suse
   At the time, we wanted to fully test multipath failover before
   accepting his patch. There have been a few changes in our queuing layer
   since his patch, so I'm applying it with the required updates.
   We moved the reserved command section to the end of the command pool,
   eliminating some math in the submission threads.
 * Add PCI-IDs for new storage devices.
 * Corrects maximum LUN number for multi-actuator devices. This update
   is more cosmetic. No bugs have been filed.
 * Change the sysfs "raid_level" entry to "N/A" for controller devices.
 * Correct a rare kernel Oops when removing the smartpqi driver managing
   multi-actuator devices.
 * Add in a controller cache flush during driver removal. 
 * Initialize our feature_section structures to 0. More of an alignment
   with our in-house driver.
 * Bump the driver version to 2.1.20-035

---

Don Brace (3):
      smartpqi: convert to host_tagset
      smartpqi: initialize feature section info
      smartpqi: change version to 2.1.20-035

Gilbert Wu (1):
      smartpqi: add controller cache flush during rmmod

Kevin Barnett (2):
      smartpqi: correct max lun number
      smartpqi: change sysfs raid_level attribute to N/A for controllers

Kumar Meiyappan (1):
      smartpqi: correct device removal for multiactuator devices

Mike McGowen (1):
      smartpqi: Add new controller PCI IDs


 drivers/scsi/smartpqi/smartpqi.h      |   5 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 164 +++++++++++++++++++-------
 2 files changed, 125 insertions(+), 44 deletions(-)

--
Signature
