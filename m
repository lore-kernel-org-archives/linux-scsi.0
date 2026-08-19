Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090562DE6F8;
	Wed, 19 Aug 2026 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139779; cv=none; b=Aw8heag9l3SJ5MwDi7/1qS/npVtYeFUiGC+a6PSWoDXTq4Yf1z2dHEjPF3+Ex3FSgj5hfY/ceKjAGj1asOhGEw/JPp/nMJFwiD30WTSXjS8unQMlDqvv2BB8PJBe6OTAAP+szj6yM6+Q0N9qMRH+FRByjH3V8VIJvWTa1n1CgM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139779; c=relaxed/simple;
	bh=nyEz9qyWLCJEFSvjhgS/04JKSkgHVMNTxAtofNoROGs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LGYqDcTuXXKual93CbchWvsUBH26JhjmYrLxJdKJEY76dv+CVefHZBK9tmhYSmgfVBXUjqYBQSC92mJ7j+InMC07nOiNrTQJ4JCBqSTmGu0vm0P1EEA/TFILcUyi0Bqv9If5qCqmM5pWbjHb0n84jTVD8viIl6XdsdkMuhW7BhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 199793149bc311f19a56ed5b684f684d-20260819
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ffe35c04-71d1-4b4f-a318-5bee73abca0d,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:c079dca72ed37e67654abce35560a85e,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 199793149bc311f19a56ed5b684f684d-20260819
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 721095833; Wed, 19 Aug 2026 19:42:47 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 0/2] scsi: fnic: fix NVMe/FC local port setup and teardown
Date: Wed, 19 Aug 2026 19:42:40 +0800
Message-Id: <20260819114242.3598034-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two small fixes to the NVMe/FC transport path added in commit 5efdd5cf9281
("scsi: fnic: Add the NVMe/FC transport path"), both found by reading the
code rather than by hitting them on hardware.  They apply to
scsi/for-next, since that code is not in mainline yet.

Patch 1 initializes struct nvme_fc_port_info in nvfnic_add_lport().
dev_loss_tmo is currently left uninitialized on the stack.  The transport
does not read it for a local port, so this is hygiene rather than a
behaviour fix, and it carries no Fixes tag; nvfnic_add_tport() right below
already memsets its own copy.

Patch 2 moves the kfree() of iport->nv_tmpl out of nvfnic_nvme_unload()
and into nvfnic_local_port_delete().  The template is what the transport
stores in lport->ops, and nvme_fc_unregister_localport() only calls
->localport_delete() inline when no active remote ports are left;
otherwise the call is deferred to nvme_fc_rport_inactive_on_lport(),
which dereferences lport->ops after the unregister has returned.  Today
the driver frees the template even when the removal wait times out, which
leaves the transport with a dangling ->ops.

Note that patch 2 only narrows that one use-after-free.  The rest of the
timeout path still tears the fnic down while the transport holds
lport->private == iport, so that path may deserve a wider look; I did not
want to fold that into a fix.

Patch 2's reasoning rests on the NVMe/FC transport's lifetime rules, so
linux-nvme and the FC transport maintainers are copied for a second
opinion on that argument.

Compile-tested only (allmodconfig, W=1, drivers/scsi/fnic/ clean).  I do
not have Cisco VIC hardware, so neither patch has been tested on a live
adapter.

Linmao Li (2):
  scsi: fnic: initialize the NVMe local port info before registering
  scsi: fnic: free the NVMe port template from the delete callback

 drivers/scsi/fnic/fnic_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


base-commit: 30733f28c0347d237ffb5333fdfab7a9a2d4ed34
-- 
2.25.1

