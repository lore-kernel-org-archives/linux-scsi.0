Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AD843CE6C;
	Tue, 11 Aug 2026 11:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447216; cv=none; b=NodLQk6MqsHZIdNKZQtyCZQQV4vXaVCqxiVzypidHd69XZ1Wf73v+F7VfHXrgfcNNsbxWiOaTgd4E6WHnl/9qti/yFfiHFqveN9Dp7yFPIHtKUEmaGWK2Hp/g3yWdyFJspsWSTuM3HLeoaNokL0mQaSJX2FnIx5w/7pcu4Q6m40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447216; c=relaxed/simple;
	bh=Kmo+jdg8QA3S6PlSJj/O4ofgGLOYdcqI/bMOkLSw67o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MZmTuRSTETbSvQV7dvp4HZfcjT3zeUHjWaePcBrJQxWWhVoq1JQirFZy4Gm40I4MUxlkd0d/lUDWKIN+37qo20rKt1+b4eZ8f1cFnAGc9qyqRnW8FJicc2PfC3B3KhSDwVtW1JgZ7LQ1gFOzW6KUmlJVB4avqSW8nkdAU8WeTcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9ada50cc957611f1aa26b74ffac11d73-20260811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9ba2fb4f-4dca-41f0-87c4-71d6e6500438,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:791facc52a79c246628bed1d2d0fa81d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9ada50cc957611f1aa26b74ffac11d73-20260811
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1625204435; Tue, 11 Aug 2026 19:20:06 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 0/2] scsi: leapraid: fix firmware log mmap lifetime
Date: Tue, 11 Aug 2026 19:19:59 +0800
Message-Id: <20260811112001.1158587-1-lilinmao@kylinos.cn>
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

Linmao Li (2):
  scsi: leapraid: balance host references for firmware log VMAs
  scsi: leapraid: serialize firmware log mmap with teardown

 drivers/scsi/leapraid/leapraid_app.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


base-commit: 376a3960e5efe85ff765abfb5b5b7e4655ad6aed
-- 
2.25.1

