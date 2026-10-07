Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C174E2F22;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401147; cv=none; b=s8uGUbqCJEzUHfQeT1add769P2uhzXnV45A7QtFdO4IhSykpo0NnNSaPqPRJKzWhHwXaaU52M4qc1sJhPXvMkPFjlp70yzEjW+Fq5xAJ/5vYufaJpWCUuUf00L9URf3O/0j0+2O9qhquuMW7244vbOOPJMVeyS082PpQA81PPIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401147; c=relaxed/simple;
	bh=ZyJf78hC/Cj23Umog/FT5PwsBfYYkk/FQUAsVJq89GA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eaVyhwcjvq3iHZ2dgQ3e6DMc4whFYIARsH0E7BLmk4GiA7ta77fUq/4QHhl6snC+6O07HPL8VOSZFcfaS/cu+V12JsAiOTO447MgQeBvWkLd50ygMKIrwbKOComIoK8N6M/KxIl4urtNIdskxsdHMR+pMsN85hlUMnqp95B9AOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFFC3BcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFFC3BcG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 686B9C2BCFB;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791401147;
	bh=ZyJf78hC/Cj23Umog/FT5PwsBfYYkk/FQUAsVJq89GA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oFFC3BcGTEAQLTdgqbMAbLSrmIucZyQ2ONXDdbadhKVDULespDr3eBeiz9rNXGwFF
	 RoWgYx9JCgNVslI79N1ULAP/de7SE2J1T0XIPdXnNtvYshAoIiuUNm85LCspODrIY+
	 yST/yb8qW4ZEH9DTsMRK1ygDVQ9dSkUy19NTcdS6zflRsqmT76Gag4VtY6Hn32sm5K
	 eLo7moce79d/WXQndDt+MkEt9c9sq0cRAa0lDBk/9V1+68rNOCJpGxB0u1gG2+2FNu
	 krUgtrm1M+v+jLqyvpq8kQ+w160BHs5VGZ9Qmq03kWCYzWAwUn3LNCJW+IjqP28A/m
	 Yfx1qsRAFEupA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B77CA6004;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 07 Oct 2026 14:25:46 -0500
Subject: [PATCH v13 02/11] scsi: ibmvfc: fix potential clobbering of rc
 after failed irq setup
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-ibmvfc-fpin-support-v13-2-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791401146; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=w2CDvNH7dM6OhRhnXDK5aEwQCEM6J20otVjA78cYJrg=;
 b=BknT+Z7VOTIYGhCYMXf6HrykWlfizo6dMI0uCbyz9uLxrDHURfC2uHUoCOyE5+SPcUDIr8/fi
 fJqK6vQ31PMDv5QNRpVc+4R+XNuS+26dhssOA56juLMi3SzcyvAh8zz
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
2.55.0


