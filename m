Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAC432C94A
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787684615; cv=none; b=Fi7JBsfA5HMkGAHXEYnDHyfSH+O0GTje0pM2kOm+T03wzqBvYypwqQM0FY5auGRPtUoQUwkg8RKbuV4ms3f1GDgUsgNumNG1O1D4T1UNN5/IrkMDYyH+I2a9VoDxO5S4Pu+wsA+I1/1XHAKZKGKtOvX3+9Wsqiygw/z8h4bL5RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787684615; c=relaxed/simple;
	bh=QYF5uF3Vl1iS+OyS3+D6NNm8vJt9UNAu7zBDXx++BPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2pS8mjo2QdPwZtT3IBgJtdCIRX73hzp4a3wf99WzPa63/+fRPdSIhRMeRU+5pBFk6DRw21Mf0zqfEvQYw1hnPXD68s6EQb8npKaOx898N79N3Ueydiw4Q5PAjwWFi/kvWUlxLgK8Kd+olR+UIPTM330SXiFGwnGwoYmJb0Yr98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPZIg3D8; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPZIg3D8"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1bcdb3c4cso70841a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787684614; x=1788289414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zwcXhvyPT1tBtC5NGFSifAncLVOGQowjSK8iEIDHZl8=;
        b=CPZIg3D8Lkrp+9ETLGiMsBWR5wIIBvFPc+TMqtI8fqKRcl+r35Ez2EMOwm7+J4vxfG
         UGTnU3CPqwqWBtBLTkzs7b/fQ/alXsRheFD1yN0sEbj53FAvOWm2XCiokJEMD3lxYAiF
         rzw/997BaDSnQorcyfmAlr6VyJ+vWCXQOLvvWkulgRiwQrBan3cgruPOz1xsptDoCzjG
         H6ra24v4g4qaplhprSovW+NCNpr/6+MQx9BpwqtJr9yMDM52i8SSeTChiB27xdw3KOzI
         uZOhEdfpCu/2MNTbZUlDpmfAVHJCRuIS4PdJAe7cyWE4+VMY8uK3IrflyIW4xtA0vpYt
         Pi8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787684614; x=1788289414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zwcXhvyPT1tBtC5NGFSifAncLVOGQowjSK8iEIDHZl8=;
        b=YIOmVJxeg882OefqKVdkXOCV8VBEqjOIBM0RQPBsygIOvNmFNKBtcYbQdk9xhgqSAA
         mzwU1zSRoS+LuOXAnJtp4tKJG4uSUXgmqQg8DfDbstE6UWd5YbmuH2rElwddWpO2Nwiu
         KNcEj4+GfYSLVLmGW6krf8rqQkwMkJmJURl2v6TuBkPeF+wISgUfoOZB9paUrIuq7jex
         7GtJC4MCvHepkQ6T9wXKBk7djiFQds+u55bwcZR7sQ09kq9a6tN/qWT26QEwajewGQGp
         8P4oM3I6pK+w+m9tfMpEfZaeUKxOIAyhmBwyJNKpEH7LRzk6YNSUNA3pzeJ8bi3cb9wY
         kTfw==
X-Forwarded-Encrypted: i=1; AHgh+Rpqnjlcgp9TAMlW/aXCAEM8MYl5X44XoOiWh1Nnv9Q27xt5/oguh8JljDcXZKCpbalgfohSmVXfbxOG@vger.kernel.org
X-Gm-Message-State: AFuF++kconG+9xkqXwk/LVRW17Qp7MgxOq/nJConsDpuhEOJAsF/PJdw
	7bBzC9lfty7jIo+wwHnfbkSoCuGm4S4Z1c+osNwXFHr57NlkE7A1zRzw
X-Gm-Gg: AR+sD12L6bt9VNOp9RRN8CThYZcUrTFhCHHQzy+QMeffSwvDs6J0kv/SAg5Ud2ph3to
	L31Pq9Hh8C87/ahiY62nrwhZXGXth/tFQpXNa04jxcQcYpcZIxShh2q7N2oktnB7C19m4BFv73b
	M6HzdqODRp2NMrHOEQNZAPLOuMx0KO9zF36BkD2ZxhZWdzDU5GuGIwxrkdrHVY9OtEB+7ogWU41
	ANHSwl1qESlCk1S43WgQWulzhymb2FLToA2n5hxumtK6vFbyPAA6fFPTvfSMkXm+J3sUaTobqaj
	NHSvsv0XFbgoSAm3Sr4yqensQyPODIPoLwPFApKqBdsjrMxyT9I3/2OKQovi3+rbgwWDPaHtyaT
	8tltoGEsglj9uq+8o3/Nmnx/rMbSec6LK6603yT+XIwT/YP2HxC4GDKhR+4L7r/umtTfgxv20Gh
	ncfym16ZNlVqCSftYzXP88FL9fxMrkw4sMHstlBcct7/Y6UHzd3fgsEA==
X-Received: by 2002:a17:90b:54cb:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-3966d5b7c62mr2572909a91.7.1787684613337;
        Tue, 25 Aug 2026 12:03:33 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3966875e5c3sm788271a91.7.2026.08.25.12.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 12:03:31 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	johannes.thumshirn@wdc.com,
	john.g.garry@oracle.com,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH v2] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()
Date: Tue, 25 Aug 2026 13:03:13 -0600
Message-ID: <20260825190313.24013-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817221300.43286-1-skunkolee@gmail.com>
References: <20260817221300.43286-1-skunkolee@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
topology information for the PCI device, such as single-socket
boards that don't expose device-to-node affinity. Passing -1
directly into cpumask_of_node() indexes node_to_cpumask_map[-1],
an out-of-bounds array read caught by UBSAN:

  UBSAN: array-index-out-of-bounds in arch/x86/include/asm/topology.h:72:28
  index -1 is out of range for type 'cpumask *[1024]'

Fall back to cpu_online_mask when no NUMA node is available, rather
than assuming dev_to_node() always returns a valid node index.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221294
Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Fixes: 728bbc6cbff7 ("scsi: mpt3sas: Affinity high iops queues IRQs to local node")
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 Changes in v2:
- Drop superfluous parentheses around dev_to_node() call.
- Split overly long ternary assignment line.
- Add Fixes: tag per checkpatch --strict suggestion.
- Link to v1: https://lore.kernel.org/r/20260817221300.43286-1-skunkolee@gmail.com

 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..ce5a5882acc8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3238,7 +3238,10 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
+			int node = dev_to_node(&ioc->pdev->dev);
+
+			mask = (node == NUMA_NO_NODE) ?
+				cpu_online_mask : cpumask_of_node(node);
 			for (index = 0; index < ioc->high_iops_queues;
 			    index++) {
 				irq = pci_irq_vector(ioc->pdev, index);
-- 
2.55.0

