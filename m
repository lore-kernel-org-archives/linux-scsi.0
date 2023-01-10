Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940C4C54EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 01:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbjAJBzy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbjAJBzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 20:55:48 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226CC13FBD
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 17:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673315747; x=1704851747;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Sk1KzQf3MXLeqmOmnpE3ihCiIwWfhiOm/7AuwYLKJA=;
  b=ZohIOwp3VSUGJjUcDY1U41opDLcIgjn2qJ2YJlOAgaJLx9h83m7ieh9b
   DrmwbNxQgDvmbMPBuRjXvWKh61QpQ5obwpBAuQAbRhl9bL1KrBbHs3qGN
   Rk8woH6JYN0LnPOG/UAnKzOflb9q+yI9g3q1/7yrvu8VErBFMVN9lZGwa
   jnyMkukK9Y+atcSehcKcFh8kwNcyeV/l6B9ZgS74A2zWBzEc07/QB43M0
   CoZ4n4UIGw/9qWIej/Mbpy7xbOF1wEAKPQ5y0VIqnvKN1C1nq8lUX1vx9
   Is3aaaM5AAi3wHjG/TbzY/LqLl7JyfTi5g/SyUIYmZNu9cf+lrxunUj36
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698292"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 09:55:47 +0800
IronPort-SDR: isqYYZcBmy7Mv9wzgBHQU1FkYoElqys70MQos/s6Czc8vHmhr4uAJl9x8XAGcMIGcWTkGqzMcI
 LrhpkwfVS1xZG77T1BAz30LaWI3RetyHtp5vYGkJ/yTxAbQpkSYt+w1HKBsyPSwKTdn5B7kV7z
 ECxE7iLFz5cGRORhp044q3B71rVuKyJqNLoztcrDw6DwKdL1Mnn3Lj2dAm7+bnBAEAHAxq1WD5
 ey5W7Msoha6NgeBrnLfYG2TxaCjrKaL1wLeNNQk/vhgYUQCSy+dFouqBnEveZjvDpAWmV6Cf47
 RYw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2023 17:07:52 -0800
IronPort-SDR: Q4ASEkSVrvvP05kocg5ybFIGw/nJ3DFeAskBN2uZHvuUhG/nK0sDUQzSCRkvovhAJSKlqnI/O2
 4lhtwOIciwLC1SNDGy1v+Ly86O749Gn3DtG3mgH5+F/UHiReQQL8sTnwx2CldXeqnL6M4CkCHY
 LZ3IWVFi/liQhrvW0rvy/TiG9JfamXGicFfKhrZGAEcwncidIQbN0ahWZXBBhH590PhZxo8Ja/
 uvEmEBUDthFrXLIx5S5+U99qZEWo+VxVglvNggG7X3CYfFVf8RMxdRzhvTCKIdTbucAaz/2gYi
 DL8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Jan 2023 17:55:46 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 5/5] scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization
Date:   Tue, 10 Jan 2023 10:55:38 +0900
Message-Id: <20230110015538.201332-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
References: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
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
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
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

