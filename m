Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B35D22D4DD;
	Wed, 31 Dec 2025 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767199843; cv=none; b=plWsOagdvImef0oObaiDJ+PlQJ+MvUZYmNchmuYyzPdeeyfUbfgAZC+XAn9IIbp/v30EKpCvG2htQnmQ/gU6+khfgBJIIlaSGRndOzwWEsVeNYNJ7b2kkXdP4WpcSTYnj13hdB/EX3Y5rZ3/53UOVCoaHAxpE9Q3C9D53Qr33/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767199843; c=relaxed/simple;
	bh=WQ8BrBsinOFxt46qm7pPAjx8g3KCua4o32G0Epagvow=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EmJ20mrfzZKGTbdCrCbmNXTOzTi5ejSfDRRE1jRIuUoLFXJ0cdUOCxtNk615LJIDuWIHbJaeIpGmu6/jdSPnT53wL9XYcpQogtyA38f11BoqCB+2ode05f+L4VQ1PtxwBcJz77rPv6CuytZgR4DTCrhVAF8mjhXKKfpAGL1ZU0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=HFoHFXj+; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="HFoHFXj+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dUKjPBbq3cPlqpwowmr+5ApDkJGVfiK0ZhYX02k47wg=;
  b=HFoHFXj+W8kQC1SqC7ZMSVrgK5+/IO4OJT9Rz2KyedJiEMA5a/xk3JB9
   68x89TMqzft2hH2vcB/5J4BpZCBOUP+1y5Y/cH/mB2lLO6EPh/isbAs4c
   2vZirZgS7ZDppLs35z5WIayfPMsfarqydbNrKWraggSBfqo39qX7/9DsD
   0=;
X-CSE-ConnectionGUID: b3bLRKKuQIC3k7kEZMLQcA==
X-CSE-MsgGUID: xJAbtGOtT/m5r0DyFnPMgQ==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.21,192,1763420400"; 
   d="scan'208";a="256476537"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.102.196])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2025 17:50:32 +0100
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: yunbolyu@smu.edu.sg,
	kexinsun@smail.nju.edu.cn,
	ratnadiraw@smu.edu.sg,
	xutong.ma@inria.fr,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bfa: update outdated comment
Date: Wed, 31 Dec 2025 17:50:27 +0100
Message-Id: <20251231165027.142443-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function bfa_lps_is_brcd_fabric() was eliminated, being a one-line
function, in commit f7f73812e950 ("[SCSI] bfa: clean up one line
functions").  Replace the call in the comment by its inlined
counterpart, referring to the parameter of the subsequent function.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/scsi/bfa/bfa_fcs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index e52ce9b01f49..9b57312f43f5 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -1169,7 +1169,7 @@ bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn)
  *         This function should be used only if there is any requirement
 *          to check for FOS version below 6.3.
  *         To check if the attached fabric is a brocade fabric, use
- *         bfa_lps_is_brcd_fabric() which works for FOS versions 6.3
+ *         fabric->lps->brcd_switch which works for FOS versions 6.3
  *         or above only.
  */
 

