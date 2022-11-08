Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984B2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKHThR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHThP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:37:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2878169DF2
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667936234; x=1699472234;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X5+6FqdY24s99yFdGuTfWrG1kHj9HtQbdchdDvA2N+0=;
  b=eTpYHmJlWLhQxKE/SoqmQoJ/SRTX0Vl3xUk5DpzrtPkRMTiJB9jI+/+P
   HfDZ4kiYYTbxihpAN53i7PyKX1lLMOJuqNz28PzZIqzKm71MiSR/gzXEs
   TY7d96gcvHHYis7JR2IwyVdPV/9GDzUFRYWwAKLQ3VflMYTlIENxBxX+/
   XB8WoADZFAVL5843muy//Mw75pxZh45hKadxmV7x+N5pUktwFULmaFqYi
   7VS0l7v7Q6Feea+1+aPSf1a4W8EZVk1XOLK2WCe4d6pn/2GKr0YWFMMBn
   nREalDSWsWuWRVYAVfqDBWXSJIUQ00Aw0NiwBrhgzJ7O0CidSkhkIRJtY
   w==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="198950529"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:37:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:37:14 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:37:14 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8Je6Np323941;
        Tue, 8 Nov 2022 13:40:06 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JJvVA322379;
        Tue, 8 Nov 2022 13:19:57 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 0/8] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:19:57 -0600
Message-ID: <166793515034.322300.10163320550137997010.stgit@brunhilda>
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
