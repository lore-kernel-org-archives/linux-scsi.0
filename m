Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D250CC61DA7
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 06:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjA0GfN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 01:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjA0GfL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 01:35:11 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDA93EC7F
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 22:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674801310; x=1706337310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wwgi/uZojQdoU960vU0INDs+Sie4OQagy/lnzIu0eXg=;
  b=I596feJ0DBOO1jEBT6Tr/PmRgpcsy+XQJNpJkUU/M7GyEKdbPqdPQHtP
   dvRqusxvEqpj+gT8IxCTGHOIinWOU3LNHBQtps57HGiL4va6s0xvx8ojg
   3xqd3NoOW6s7JFrfTgGuWU4+y0TQhFm+t+faandnIcpkasrpxlKc/X8O+
   Bcktq63t9T2IVjLCrV4utaTKaZLScVU92icxQ4xreOFeYyMXPAyIyHt7F
   k0Vxx05GGj7brEzA0DmKanW8EOEgwCGT0DCT5AUPt6I33DYYrs5DJ65lL
   6iFNG4St915q/zSFZoRs+t9IBpwMuyV9r8uIAAJ0bBUkxPzpHNGdK+DmY
   w==;
X-IronPort-AV: E=Sophos;i="5.97,250,1669046400"; 
   d="scan'208";a="221935012"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2023 14:35:10 +0800
IronPort-SDR: 87VKGEYBWfjGTEtxghsRrmXCQXq4qkxFkNQDzbcCCN0zibrx7G+tyZOHX7dXiTunF3rt430hP2
 wIRHqaXTnGqvZj2y5hbz5YiI2B1YEkNe9gvfW6+QU9xb/QppGRQoyY6gBZBgHMFWpP/9qlO3xB
 WTBVP4KK9hZwHm6oq69PiP2trhM07+7zC/F/sAyemcIJNGzc8JYI9PF634v6eP8+8lxQfeynWC
 1oqO9bDyGrSe+T8efolQ6IcGwJ9UC3qwmwSXnFwy5eksSKqU7C9iy4OMHL82CG2CYz1RbV1lqj
 wG4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Jan 2023 21:46:55 -0800
IronPort-SDR: 6gGTvNOfHm0/xgerVNeuAmvS1UzmIRk+U5oqIz/Cj/59klTRKxDtQ2f1K6glpEYt8pACc1cFuF
 I7AKUK1+fjXc0E+/I1VJCRKcFnLVMpIpk1SfwJZLEMTUuUpy0uQpRo480CAHJgEJOvlyZHnE1S
 HYHal2ANWVVr0/qFcxHoAmbGuOdL8XXXV8yvrOa8HeIYD8y3J3jiF0V87B8H1WpGXchs8hdGys
 b2B94n4Mnz7OvK//F5IFfJ0psZ4JOjLi6pVijO4SmaCrP8fFjFoiqXctXXEDXYEA3etv2+UTH0
 TKI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jan 2023 22:35:09 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 5/5] scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization
Date:   Fri, 27 Jan 2023 15:35:00 +0900
Message-Id: <20230127063500.1278068-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
introduced an array mrioc->evtack_cmds. But initialization of the array
elements was missed. They are just zero cleared. The function
mpi3mr_complete_evt_ack refers host_tag field of the elements. Due to
zero value of the host_tag field, the functions calls clear_bit for
mrico->evtack_cmds_bitmap with wrong bit index. This results in memory
access to invalid address and "BUG: KASAN: use-after-free". This BUG was
observed at eHBA-9600 firmware update to version 8.3.1.0. To fix it, add
the missing initialization of mrioc->evtack_cmds.

Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3306de7170f6..6eaeba41072c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4952,6 +4952,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
 		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
 
+	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
+		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
+				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
+
 	if (pdev->revision)
 		mrioc->enable_segqueue = true;
 
-- 
2.38.1

