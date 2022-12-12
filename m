Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12DBC001B2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 01:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiLLB5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLLB5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2022 20:57:12 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31598D2C7
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 17:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670810232; x=1702346232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EpdEUJl6nz+zW8X/0RWo4f/OCEPf/35qKa0MwPVGiwA=;
  b=ldOUsDMz1wguv2tfxGs7U0s2qt74Y2d/yxdIZEyg16fkxoXU9um1hm+b
   FkNn/9lLcbFjkAolfdwRyOCcTPpGQE4jHLNj84kJQ3zm/8qJWtUF1PUlD
   vwL/We9gezo64lVW+V3Igx93eHy+aoSMX++45SgcaE8qOsmBmphRLZNml
   GXBIqSd++d5O30Fkb9F+3ZJ6/jmeJH/Z/QTsdo9TqXV2iY5vfoYvoCShO
   bbtys2ZSpdHJVKlKSmfy0d9oLqd3B2nJDgG6QKP5Ju1mSfiD6LnN3Ka/g
   aHublsrduNcL0PiDClyQMXZtD3i++Ire/hlUY11Uj6G0bLXaiE3KCV35N
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="218660150"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 09:57:11 +0800
IronPort-SDR: J7VAdjzmr4sngAm9xErIvLRrob5v/JIJYMJ+TcFete1DmtHzUKnfS3NisfXjIeNKKYJjF6jiJk
 B7rN1VJr+ZQvN2uVV2+e7q923c2udCZDYRRmQ+fpu82cu4JPWSbOtKV4y04gTeHyFmdM4na+Ai
 f+YzoHSiM/VPCqxIvu9nrVm3vDR66BijeZJ7kVVEg+QjDb/YaUodJhcdJwhmasjLgX4jZpGvvr
 5Hus8Ef+pWPhMY/guUAImCVPAZj7xQ9FITlgKeneiIvpv9aqG/LbK7KV2rkavWTfzjcnEX8fkC
 Y5w=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 17:15:37 -0800
IronPort-SDR: A7tZExKW4ZLkW47BjBeYaAaCE484+7WhAYcK1+PuQn/JJIIeVRlo3BxXIQmF8DiXU1XHi+oDHw
 rGXmmSggYjiIOOgdRc6acZB/TLFoNY1LYSW/BH4KaKhnlZPsTVePW/GCDX7BJOLHEnKvqPeByK
 JNSVI7pOfLODN66C9ctF9V+X4rnnoW3xtwm6q1Bg1k2OX0DWSbRAm5F9R/OCcvbRjVHxbqTQv3
 Zab51/t7CVV+neRZINIFeGg0zuhi0Yhc6bDDwxFUngPHqBArKGhVW+M3FzcFHoqP4Y0jrNMB6B
 DmU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Dec 2022 17:57:11 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 3/3] scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization
Date:   Mon, 12 Dec 2022 10:57:06 +0900
Message-Id: <20221212015706.2609544-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
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
2.37.1

