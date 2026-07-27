Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017242A82;
	Mon, 27 Jul 2026 07:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785137695; cv=none; b=IvclLu3NW4JJjO0qy61NPWuIOGvLpHWnu8KnIJ4HynhXxvCjKSIAxgjctgwfJvnYxzXyubCX/GvT3xrbS8SNPtim05dlFO5WRTe927rhIxIXOTnR651cKu6uwbEzIn/EEbMHpohoDl2GdT5UR5MC2DA1QgZbAoSuDUSQrceVlUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785137695; c=relaxed/simple;
	bh=HCtBSGVp5MKeWLbLlTVEqO6iyMtQrZkLtTD108SPBR8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMq16G7MIyprmPnX81BKh+5apFD2gY6KfFBp0QBYcFkNd72bD7LnDYnYaQpK7FXkOv8ILYgi9Q7SBnMEyuUyi8lUAMJd3SkBRqQyB4yuROWxDzTnXSnixJZ0KdL75QnVgUdIAvAF6395l5jbTKGRbf+21RhPccIkcDHTilzUQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a2241c04898d11f1aa26b74ffac11d73-20260727
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:18dce990-af35-485a-bae8-30d7127116ce,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:c029aa3a90ece931ac087231fdf0bfa7,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a2241c04898d11f1aa26b74ffac11d73-20260727
X-User: chenchangcheng@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <chenchangcheng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 852732050; Mon, 27 Jul 2026 15:34:42 +0800
From: Chen Changcheng <chenchangcheng@kylinos.cn>
To: kartilak@cisco.com,
	nmusini@cisco.com,
	sebaddel@cisco.com,
	ames.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ccc194101@163.com,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation failure
Date: Mon, 27 Jul 2026 15:34:38 +0800
Message-Id: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In snic_add_host(), if scsi_add_host() succeeds but
alloc_ordered_workqueue() fails, the function returns -ENOMEM
with shost->work_q left as NULL. The caller's error path then
calls snic_del_host(), which returns early when !shost->work_q
without calling scsi_remove_host(). The Scsi_Host remains
registered in sysfs as a zombie device even after the probe
has failed. This causes:

 - The leaked host remains visible in /sys/class/scsi_host/
   after probe failure, with state "running".
 - Subsequent SCSI host numbering is permanently shifted
   (the leaked host ID from ida_alloc() is never reclaimed).
 - Memory leak: the Scsi_Host allocation can never be freed
   because device_add() took a reference that can only be
   released by device_del() inside scsi_remove_host().

Fix by adding scsi_remove_host() in the workqueue allocation
failure path inside snic_add_host(), undoing the successful
scsi_add_host() before returning the error. This is cleaner
than modifying snic_del_host() because snic_del_host() is
called from a shared error label that also serves paths where
snic_add_host() was never invoked.

Reproducer (requires no real SNIC hardware):
 - Build CONFIG_SCSI_SNIC=y (built-in)
 - Add snic.test_mode=1 snic.inject_wq_fail=1 to kernel cmdline
 - Boot with a PCI device matching the snic driver (e.g. QEMU
   edu device, PCI ID 0x1234:0x11e8, temporarily added to the
   driver's PCI ID table)

Before the fix:
  # /sys/class/scsi_host/ contains a zombie host0:
  $ cat /sys/class/scsi_host/host0/proc_name
  snic_scsi
  $ cat /sys/class/scsi_host/host0/state
  running
  # ata_piix gets host1, host2 (host0 stuck):
  scsi host1: ata_piix
  scsi host2: ata_piix

After the fix:
  # host0 is properly freed and reused by ata_piix:
  scsi host0: ata_piix
  scsi host1: ata_piix
  # No zombie host in /sys/class/scsi_host/

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
---
 drivers/scsi/snic/snic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 82953e6a0915..cd638b4a4d7b 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -305,6 +305,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
 
+		scsi_remove_host(shost);
 		ret = -ENOMEM;
 	}
 
-- 
2.25.1

