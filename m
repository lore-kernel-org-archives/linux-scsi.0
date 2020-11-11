Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF2FC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 890A8208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="eWaBNKCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKKUYl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 15:24:41 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2470 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKUYl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 15:24:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605126280; x=1636662280;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QIO4Dl1nqCOI2HNhvcJRK4KIpK1xjWxZMWuxV/nGJno=;
  b=eWaBNKCzAweZxa7Y4k9i4l3CChnsaf0oY/iFwK+qPFsxeEEylPNBK9ld
   W4mkE81EmuJWH2qmcZBJtxZQZv0Di6N4QmuAiVdomiPe26dPrlHNZX+sw
   GsZfDZXApHLxlEIha7vkeoaeEMzaQbZ72RAidNDeWEDRyPBa7e77eFp1G
   DvJxUJL6KkPw7vsIUh/Pr6lUr5foXzYbgmVtRTvZoTdwhGrwe+ex4OFmy
   19OfPCLWI8ZrzrU70C8jMCqrA07TYYEdDL4oPEGu5+gaH6VFc6dft1mmJ
   uPbujeyi4ztHAdwdlOPbVDwgnl4Ax9WgLaj9TnwShZ7AFgeeqe5AtUYph
   A==;
IronPort-SDR: VkT9Z/oOVeSjwWjE30IUG09sXM+VIqEezw4GY4ernqLOS1oJHWSiuRG697gccJehJ35Y/WouSF
 uFNVWvT4QdYgAhAVb8Ep/33d6fDhfGd2xkvmY3kzJt/ofm8wDG6T8fAz9tpfCIbNwLlZL22dwU
 pYYSk37YQ9YaW1MMVcRyhwckZhg/0dqp7Ul/4f7muyDiWgwefppMY2SvW44+ERWG6ZpzpFRIc1
 F/418hIFADCinHMhuTotTXBg3GqJANVZWDXVBf4mCgIptV1uS3vGkq96QadDThcMgZpXuLxZLg
 yG8=
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="95973052"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 13:24:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 13:24:39 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 11 Nov 2020 13:24:39 -0700
Subject: [PATCH 1/3] smartpqi: correct driver removal with HBA disks
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 11 Nov 2020 14:24:39 -0600
Message-ID: <160512627928.2359.10698615071827614781.stgit@brunhilda>
In-Reply-To: <160512621964.2359.14416010917893813538.stgit@brunhilda>
References: <160512621964.2359.14416010917893813538.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Don Brace <dbrace@redhat.com>

* Correct rmmod hangs when using HBA disks with
  write cache enabled.
  Do not set controller flag "in_shutdown" during rmmod.
    * SCSI SYNCHRONIZE CACHE(10) and SCSI SYNCHRONIZE CACHE(16)
      requests were blocked with SCSI_MLQUEUE_HOST_BUSY.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9d0229656681..531f10853f03 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -345,10 +345,9 @@ static inline void pqi_device_remove_start(struct pqi_scsi_dev *device)
 	device->in_remove = true;
 }
 
-static inline bool pqi_device_in_remove(struct pqi_ctrl_info *ctrl_info,
-					struct pqi_scsi_dev *device)
+static inline bool pqi_device_in_remove(struct pqi_scsi_dev *device)
 {
-	return device->in_remove && !ctrl_info->in_shutdown;
+	return device->in_remove;
 }
 
 static inline void pqi_ctrl_shutdown_start(struct pqi_ctrl_info *ctrl_info)
@@ -5347,8 +5346,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 
 	atomic_inc(&device->scsi_cmds_outstanding);
 
-	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(ctrl_info,
-								device)) {
+	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(device)) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		pqi_scsi_done(scmd);
 		return 0;
@@ -8031,8 +8029,6 @@ static void pqi_pci_remove(struct pci_dev *pci_dev)
 	if (!ctrl_info)
 		return;
 
-	ctrl_info->in_shutdown = true;
-
 	pqi_remove_ctrl(ctrl_info);
 }
 

