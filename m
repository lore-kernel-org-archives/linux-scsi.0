Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CF134DCC8;
	Thu, 13 Aug 2026 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786605989; cv=none; b=G9nQ8eaqRf7kVQsVrbkF10Ce9inj+s3m9DPRum4fEclV8JpJwKHkSR+lXQ6ID7PLClHyxU7d1/oruvharkx1AcuYMnezRiOltBWbKwz7LOra8OwthATdYlFKSPue6Y494HgfxIA4/RLUWg6IPHcqQuQipnYK+Y6YyJoePWKgyGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786605989; c=relaxed/simple;
	bh=G3YqbQSNHyjlvlanpee6Zhybu52v7m7gu0fvRS040zI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TBoSS8cXFdfp8Jxi7vNZsDPptOlAryYwIi3fAqR63+Kioha+4XlLHsBw2ngCiHmPhjr2XRVmK6cZo0RxMpe+6yw+rkbbzpNAx88L9RXU4qK3yilvObdIXI2QD9GXkrLsjUteU3bz5qQvTwP8FqOgaqt78yyw93dQlkChOUwIFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4727813496e811f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:baf3e0b5-994f-449d-bd6d-460546f9fd66,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:3f5f3b9dc8a73451549fe07ec5dee745,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4727813496e811f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1253019186; Thu, 13 Aug 2026 15:26:19 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH v2 0/2] scsi: leapraid: fix firmware log mmap lifetime
Date: Thu, 13 Aug 2026 15:26:12 +0800
Message-Id: <20260813072614.1387555-1-lilinmao@kylinos.cn>
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

Changes in v2:
- 2/2: keep the return type and function name of
  leapraid_ctl_lookup_adapter() on one line, the declaration fits in
  the line-length limit (Dongdong Hao)
- 1/2: unchanged

v1: https://lore.kernel.org/all/20260811112001.1158587-1-lilinmao@kylinos.cn/

Linmao Li (2):
  scsi: leapraid: balance host references for firmware log VMAs
  scsi: leapraid: serialize firmware log mmap with teardown

 drivers/scsi/leapraid/leapraid_app.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


base-commit: 376a3960e5efe85ff765abfb5b5b7e4655ad6aed
-- 
2.25.1

