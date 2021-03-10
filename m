Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA71CC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF3A64FCA
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCJUD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:03:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38591 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhCJUDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406633; x=1646942633;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HPln9O+o7p3/hcf1cmk5vW8bhq6qVklnIYzgolN2b/g=;
  b=IfqJ7W6UMCtQPEcf80lR24AU33hxxnPYdyCsQtLDxXCyXRf+8A1anjUj
   38czDp527swQT4wNxuzEKn1BvSd7KPB1S35scMvYj4Q9ENQO6VYwlP8pr
   sdL/oN3figF3cOzL/75Hdo9iBJY96CyQkJ9nPvsg8BhDfFnT6GiSzYlKA
   ItgPVMsvPLqu95s0STpqzPjLY9MZq3s2ZeZtVba99lY8vEcuam1u2E1d6
   q9Mcw83xXgrrrSZQx3wcaXf27lqdPk61KRoVuSm/1wNZj4p6nEsljz9b4
   XDR9njKl0c2s6yv0IkS61r7JkixzNWnfwFGPx2PcFD7AtUxH5LjHRvrTf
   g==;
IronPort-SDR: i6yj9Mip19Hl4g8sgotkiqTe04ekwcHYQbGk4nYyFIgdUpiwXGYq+6KdGrKW+MkLwXr1sB9mWN
 5BqaQM3pFSt6ZCJ1YzeSr2c4a16NtdP9VDcPqgy8SPzHH/rSrZR/UIQIx6RZkjZfpFE1jHmobj
 yEAGrBMIykt6zabD+Rht+emmHRHWnXIPwh6AcgopJcZMIi+W1u1jgQsGWvcQBMyt6E2o4v9M0L
 NQn9JLh2ujrnLHLgCI8PgNEm7xzdMVM9zi5bIrGi0qPdUOTIp71t2Y27IbqKQ5WRfk/qXBnhQs
 4IQ=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="106699617"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:29 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:03:28 -0700
Subject: [PATCH V4 28/31] smartpqi: update enclosure identifier in sysfs
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:03:28 -0600
Message-ID: <161540660870.19430.4765319979291713825.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Update enclosure identifier field corresponding to
physical devices in lsscsi/sysfs.

During device add, the scsi devtype is filled in during
slave_configure.

But when pqi_scsi_update_device runs (REGNEWD):
  * The f/w returns zero for the scsi devtype field,
    and valid devtype is overwritten by zero.
  * Due to this lsscsi output shows wrong values.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 198d171c368f..330688c32808 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1840,7 +1840,6 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	struct pqi_scsi_dev *new_device)
 {
-	existing_device->devtype = new_device->devtype;
 	existing_device->device_type = new_device->device_type;
 	existing_device->bus = new_device->bus;
 	if (new_device->target_lun_valid) {

