Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2509B372EE4;
	Thu, 17 Sep 2026 23:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.182.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789687289; cv=pass; b=WhGXvxNys2QDLBWT9b/K02dhTV2dcMnI7fmq2Uz1fKEfhICZImSODDBQYMB92AuKqRegP+SxsYVw0ocaZVmcn58rY3c9KpxGk2dGghdiPjl10UHPNP+ESw2Gd/+EW1TZxlH2Bgm0fo+0bKJCNHVHcGGmO109oWfYghItM11d9Ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789687289; c=relaxed/simple;
	bh=LkK2pFSWkVKdoqi6VQoP7k8BLHvLrWGp7jYouKvh8Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PVz7tMaBfeC97YxqpLOOLkEp22mvhwzw1+NdSc0zWSiX5ugfl8qvxvo3rAp2gxpUkb+EVHE1xRi4wJlTU+O/BHHEEMLsFdd6yl+0bnBW9c57wnSC0NqFQWo/ViXRF/K12QQaB6npJcNBJtLVvjgPCfEv5XbtXqKdGlXrxIYkSM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chanakanlabs.com; spf=pass smtp.mailfrom=chanakanlabs.com; dkim=pass (1024-bit key) header.d=chanakanlabs.com header.i=me@chanakanlabs.com header.b=N7ngPiSM; arc=pass smtp.client-ip=165.173.182.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chanakanlabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chanakanlabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chanakanlabs.com header.i=me@chanakanlabs.com header.b="N7ngPiSM"
ARC-Seal: i=1; a=rsa-sha256; t=1789687275; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=LFiIhtm4oPVKXTty5qLjk9Q2X8cwuWje0rIU3q+mf5LqfjRB+oK541E7Lb4eKH5j8X1dwnU3i/wDN6QwgDauvRSk9M6iPqdGgZ1BS2S1mID/86EtXWGSCoBPD83hfjPQR61WBtuKvEWdg0uWSGajrvKq36BkP5VIFv5OUWtCh7Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1789687275; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QFWV3MLLCIO5BlrPbqnOm469lr1dLRDnafWCOeZnAPs=; 
	b=kxiF4oYVs10mDgRt/qe3Vme6a0UigG0W+Om8EBmdG6yamHNMg8S55MqSP81hmLqlw78GGn4pgaZfhBbViFxYvnuUtx2M27umUNXlIyeFSp2LSKKhIR6PGJzXHZ0u1qvU4GsLBqF3t5ub1RJwd3edSxn+o2OyIxbz+2FvPiMUa6E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=chanakanlabs.com;
	spf=pass  smtp.mailfrom=me@chanakanlabs.com;
	dmarc=pass header.from=<me@chanakanlabs.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1789687275;
	s=zmail; d=chanakanlabs.com; i=me@chanakanlabs.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=QFWV3MLLCIO5BlrPbqnOm469lr1dLRDnafWCOeZnAPs=;
	b=N7ngPiSM/c0A+lItT5o/wYI0ecpUl/lX/47L5Obn6iOv89lBYdNt3jYvJiSWS6HY
	3IC+KQRf9H2WQz7DWgV7LCg/DrPiFdzBXIHO7uyU9cBtsApoRF4IWnhVQnWQP0MNdne
	8CdxQdwYbxpsAbdHroRzrTGRtaeSOOftV04g2law=
Received: by smtp.zohomail.com with SMTPS id 1789687272578948.040234208764;
	Thu, 17 Sep 2026 16:21:12 -0700 (PDT)
From: Chanakan Moongthin <me@chanakanlabs.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	johannes.thumshirn@wdc.com,
	bvanassche@acm.org,
	Chanakan Moongthin <me@chanakanlabs.com>
Subject: [PATCH] scsi: Honor TRY_VPD_PAGES during initial scan
Date: Fri, 18 Sep 2026 06:20:27 +0700
Message-ID: <20260917232027.4265-1-me@chanakanlabs.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

The scsi_device_supports_vpd() helper treats try_vpd_pages as an
explicit override for the device SCSI level. However, scsi_add_lun()
only calls scsi_attach_vpd() when the reported SCSI level is at least
SCSI_3.

This prevents VPD pages from being cached during initial discovery for
devices that report SCSI-2 but are explicitly flagged with
TRY_VPD_PAGES. The sd driver then cannot read the cached Block Device
Characteristics VPD page, leaving such disks marked rotational until a
manual SCSI rescan.

Call scsi_attach_vpd() unconditionally from scsi_add_lun(). The existing
scsi_device_supports_vpd() check remains responsible for deciding whether
VPD pages may be queried.

On a VMware PVSCSI guest with
scsi_mod.default_dev_flags=0x10000000, the baseline kernel reported
rotational=1 at boot and changed to rotational=0 after rescan. With this
change, rotational=0 was reported during initial discovery.

Fixes: 7fb019c46eee ("scsi: sd: Switch to using scsi_device VPD pages")
Assisted-by: LLM
Signed-off-by: Chanakan Moongthin <me@chanakanlabs.com>
---
 drivers/scsi/scsi_scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0f0f243c2561..a9264a3acaf1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1122,8 +1122,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (hostt->sdev_configure)
 		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
 
-	if (sdev->scsi_level >= SCSI_3)
-		scsi_attach_vpd(sdev);
+	scsi_attach_vpd(sdev);
 
 	scsi_cdl_check(sdev);
 

base-commit: 238650ef6c7c7cca08e032527329424c9fbd70e5
-- 
2.47.3

