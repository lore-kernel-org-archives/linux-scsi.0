Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D246FC00145
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 00:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiLMAxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 19:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiLMAw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 19:52:58 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43461835D
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 16:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670892769; x=1702428769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4PK7nvRMaWEcQvAKNkN0dpGBS7mYjwV4UHTvedImHPw=;
  b=FG8UCKyLuHwt9FC+iXjlEwAphbG6YNbPd8CCcg5hPx7HmAijZ+E2zV1o
   rF4Nk/pVCUcfy07B9LVhaHdS8kR3vGTAYTCBtbdi0uXU/nc35OFkziVlM
   xBo3C2nrSeCyAPEc+xLYhggB6L3BbT6r4grv8V8yoOdPfVgXHQ5VSQb7R
   ggpyJ8SdzlJlWWYjAw1q/r5U7GaRnF2CuFCOFQvriv/7icppcaCd5FR8A
   r1XBK1wFJMWXRUPJQTHrCgcvUmVTJjzJygRm+ebCWMaZ2lQjPMcBjaV1x
   rm5pwTThYVf/622iAC0FGcZRPRQx3wfJ0KFCdTj1Q1amsAsAU04QMbQy2
   g==;
X-IronPort-AV: E=Sophos;i="5.96,239,1665417600"; 
   d="scan'208";a="223646017"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2022 08:52:49 +0800
IronPort-SDR: ty6vr798cR8TJqlhJFTsj3/Sf/le3UVMk13DQl5VVZA47QgiYsjtRSf81lkACK9bMqsTcywnHT
 qhIvOieOwtJ/FdTwjdYj6Utl7CPghrVYRLwn2g8iqilwGaLacq0qH2JWWwiPl+slA/V4VOLEwv
 jvhOgT+D2nMsBNXIeeK8flV5Nx734lPoqLZKgv/yGL0EMpk0WdNps+NCh0A8HZ73rP08mQHCXo
 5omEi5GZ0fvJyZespiMM9lt4b7sbmiy1ZxMQy0WgNhVRZBrFUdNT8Q0/b3FoU8qT0KZymcXEcL
 tOo=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2022 16:11:13 -0800
IronPort-SDR: QX5yya+1cR/b1FB90eQ/rbmIuSuygW3snM0fk05tp3np0Uf9dd8G/laYyuTeUDkkt725CdXOzx
 R4ZpdXALn+T7OWyn3ukJ3Longsk/6MMtNIPTF2lGWWgKVQCPdQ6qaJ/qUHRCFdNNY5AcHvqcIS
 72JzKiYMnBPScyWM9cRcIyBVJ944uPEoKptRUTvK3D11HB8OfRqYPZ4S/rCZUrafpyhf91Nype
 nJ9fJrVJYwv65v3GHFii+glBbbkc/AsyCZCZzln0ExUKhddiw/uS8VQXaP+YNZBazOpqewWVdA
 to0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Dec 2022 16:52:49 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/3] scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization
Date:   Tue, 13 Dec 2022 09:52:43 +0900
Message-Id: <20221213005243.2727877-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
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

