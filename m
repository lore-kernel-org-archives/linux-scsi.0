Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE39E1A23A6;
	Fri, 14 Aug 2026 03:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786678739; cv=none; b=MSQey8iC3HV20Rlzo1gJYtbESkni2cmhmow/9i2sGwRDq64uzTT6xl6EBw0DC2BCeXylRhz45HxSwCc1QgHxHkvvoDet+MlEgR/SNyy0tG6LnWMZSQ1ElrJtAMVQHHmsj2uy3QR1moEavHBvFygRy6M75HOQGzI4qg+ocJPAGEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786678739; c=relaxed/simple;
	bh=SrE7YDD7pAjRlyTy+h0CGvXJ+h0xhBZyFrqY4y006Io=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FNWGnOiqe0XWooISzpSgrrq8kCva2+cH2cleXd0nNbiMj32hVjAkd1ZJM0yEArEuo42YxuxdXOglZkn7Yl7hQ8p/V7g9vmibZZB52HkJMHSjKVy4b8kuvYMo+8cN+yPqemx+JpknTC6Ft+GD/iYT138iS40nomGp5puh6wf+o+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: aa52f6f4979111f1aa26b74ffac11d73-20260814
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ee26f309-d226-4197-8c85-46a6f8df6622,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:84c54f0f26de821902d52cc6dcbdb61f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aa52f6f4979111f1aa26b74ffac11d73-20260814
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1537011027; Fri, 14 Aug 2026 11:38:50 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH v3 0/2] scsi: leapraid: fix firmware log mmap lifetime
Date: Fri, 14 Aug 2026 11:38:43 +0800
Message-Id: <20260814033845.2971706-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The firmware log mmap path has two related lifetime issues.  VMA clones
drop Scsi_Host references that they never acquired, and device removal
can free the coherent log buffer while mmap is still setting up a VMA.

Patch 1 gives each VMA its own host device reference.  Patch 2 claims a
temporary mmap activity reference under the adapter-list lock so teardown
cannot miss an in-progress mapping.

Patch 2 depends on patch 1: patch 1 keeps adapter non-NULL on the
successful mmap path, allowing patch 2 to drop the temporary mmap
reference at out_put.  Applied alone, patch 2 would leak that reference
and make teardown wait indefinitely.

Neither patch has been tested on hardware; both are derived from the
reference counting and locking in the code.

Changes in v3:
- 2/2: wrap the leapraid_ctl_lookup_adapter() declaration before
  bool track_mmap, aligned with int adapter_id, to stay within 80
  columns, matching leapraid_ctl_validate_sge_offset() (Dongdong Hao)
- 1/2: unchanged

Changes in v2:
- 2/2: keep the return type and function name on the same line
  (Dongdong Hao)
- 1/2: unchanged

v1: https://lore.kernel.org/all/20260811112001.1158587-1-lilinmao@kylinos.cn/
v2: https://lore.kernel.org/all/20260813072614.1387555-1-lilinmao@kylinos.cn/

Linmao Li (2):
  scsi: leapraid: balance host references for firmware log VMAs
  scsi: leapraid: serialize firmware log mmap with teardown

 drivers/scsi/leapraid/leapraid_app.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


base-commit: 376a3960e5efe85ff765abfb5b5b7e4655ad6aed
-- 
2.25.1

