Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51D351A722;
	Thu, 15 Oct 2026 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792076822; cv=none; b=YoyufmHEAN9CePSvu62eDmhXlp/PfilNhIN8I9CUCB6hhfOOZ3onnPqkSjir7CDkJrKcX4Jk30MP2SKPX2CkpYHlv7GCLeD/qqfJvTrJc10hzcPt3DObkOw+0BPMEih84wn31G2o3CAroT3xHRCHdNNE31xo9AXOVIExxNUY3bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792076822; c=relaxed/simple;
	bh=jbwpni8DQVnPQ40L0zQKb7nfA47hHROG10pvhcLssdg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NMitqwwwyowCagk2kDOuvTBuKoDtueJnH8y0He+TGvAXrWw0+yq7TtkFokuirof40NKFIB7gSUHkQ6oFMGgGnyxvkBs56JAxCZyL7uG/JSLMhDPs7BxIIfnb7RyY8mk7/uFbpIoR2XOGfe6f20xlykiPqV2S/FXt9yAj3muLObc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mll0Yt4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mll0Yt4x"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A4E0C2BCFC;
	Thu, 15 Oct 2026 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792076822;
	bh=jbwpni8DQVnPQ40L0zQKb7nfA47hHROG10pvhcLssdg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mll0Yt4x1NMNERBAsUNb1L1FoOyfIsXqjqgAqfCaTmTYqEK0mVazzCNQOHoZHXcZM
	 GXtlxlLMpNkbxWpvULem0yKvWx66i1b1S40VPjt0kXSy0ALZkXuSRukKRt1IOcOoHu
	 evWzqip3YYtxzTMIpaPGPgQwHDFlxMb25AEEkRH63vpql1JzfwZQgqvroVGWf6GjJp
	 1IkKO+iJM1O17HedlsLsBZa7Y6byuq/Zi4LzO0hp+aYJInHgt7QocxODpvgOX9DJXB
	 Va+nnJg65eW3M0aCMpTaEUl8pnj6ai04T9ubzMX7wMe1WFDlCh0tMrjcfmN7Oa32GT
	 alzNOW26vyChQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4A1CC6B3D;
	Thu, 15 Oct 2026 15:07:02 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 15 Oct 2026 10:07:01 -0500
Subject: [PATCH v14 02/11] scsi: ibmvfc: fix potential clobbering of rc
 after failed irq setup
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-ibmvfc-fpin-support-v14-2-a0b063b8d825@linux.ibm.com>
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
In-Reply-To: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792076820; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=nvE9rGLbRD6+mhvHw9wBWLEiRdGSv55IfTVTSl/45g0=;
 b=GAF17DVzJP+O1SxvPpmfQlvk1sYIZIhcZc/l+TUz1qpa4hfj9jhLxQnrLvDCFCmT6I3vqUT9a
 7bT2KqF6hJ/ADRESuCS0kOQ+McFs+S4SukoASUsc57xKNJVnblfvu2s
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Tyrel Datwyler <tyreld@linux.ibm.com>

Fix a variable-shadowing bug in ibmvfc_register_channel() where the
irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
clobbering the error code returned to the caller.

Introduce hcall_rc for the cleanup loop instead.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7818838669ae..145d559041f1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6391,6 +6391,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	struct vio_dev *vdev = to_vio_dev(dev);
 	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	int rc = -ENOMEM;
+	int hcall_rc;
 
 	ENTER;
 
@@ -6446,8 +6447,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;

-- 
2.56.0


