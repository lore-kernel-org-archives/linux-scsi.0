Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF96CC636CC
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBNAua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBNAu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:50:28 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB8FC163
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676335827; x=1707871827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wwgi/uZojQdoU960vU0INDs+Sie4OQagy/lnzIu0eXg=;
  b=aIE8Dv6hqRswGYe4RLuKcc/A3/YfUWrbCLsM3+bzJO71ur3DJcbEPa9L
   olqkRRD9zQBtm9q9jrpDoMI6KCVYTfQBytyblvxnDootwKhyD3VMYjFbX
   7L+vch+HPdVQl9riEdWzOdtoIkcbD4Ug7mbHX+IZOVAeHjfkmkE4vDJbW
   9qXER2EhQ5uII7m7/qXZi30DgNe6yq900iHzjsq+uQB/S62EDYyiyXYOy
   J4gvw3Q0k7Uh8kD6IG302V7DSBorKUP7e/jxvZ+f9IcL2uwLDh4SdODHO
   WkkpeJS1aHt2d3ezbuIFspWlHhNTNRxQPz7NFUJPE+NsxET15Q4yoifCZ
   g==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="228193163"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:50:27 +0800
IronPort-SDR: hlP+E1ywC0kJW7UrG+4ddgc4prMqIeTDDQQU0ram8hRxh2lqPPEdjTfdtWymjKuDPhycYAus1v
 X/gj2t41Ty6p2gkpgPkh7VZuu5K4EE5ihZSVy2zWVkUGm932xksXviFOmGr1tPc79qDqNpuIaj
 liA3tVfPLuABss/8QqFfUKUTY4Wri6OPBoZOrJ8aYw9MMeweeetYhWGl8mUCwDVAoBtC4TmNVK
 FJVVEGsTYhsasTCtbXdVLZTbAj5Hc/sYdJuMsjKjabX8a3xAK9BPt4cRO/Bbpz/7UtW3iGH5CP
 1sI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 16:07:36 -0800
IronPort-SDR: aTDmwBlPvMCBkexdkNWNvYR8yr9fOKcb64JRAxYfMVPSUWThGjqiLH0jpX+9BcUP1jYrmzx2o/
 l+PqTvNOsIB/4kWEo94oWOhLVE5XuQCCXGo4zK+uSrqeURQyOQHs7z/u88/juVwGJIpypxWXq+
 1e+efKLvD1wvLb2S8RKICYNA9qBurdCIi0A9IOcrNTPfVyeV4RWYEO09kjNN8vl4r5ls91jys/
 KPdVhGHCZw6FNxXheL+RPNu/bVfThhtPSxjlN7Z0X7P7t5LzVFeNYsmNIF9b3bpL7DZgEIPun2
 Jyg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Feb 2023 16:50:26 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 4/4] scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization
Date:   Tue, 14 Feb 2023 09:50:19 +0900
Message-Id: <20230214005019.1897251-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
References: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
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

