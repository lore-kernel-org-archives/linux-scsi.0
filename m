Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2981E3DBD4E
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787829692; cv=none; b=Q2YLJdUFh4tEGKKPt8oe/MZx/O1yyDKE2sdHNqKgdgRnqdxAINQxdmM2OgvPoZAQFHaZVcMOXywx6GwS98M42tnqbPfK36plO45fuvCdgZNxPAU4jTI2y7bswReFBZ+Z/XjJVcsRt9HuLL1eEpw6ZSa+/EI21OfkFgc48Qa69Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787829692; c=relaxed/simple;
	bh=jAJCUoDhgJdImNIePC7j08N47hwd3t2WfQxePgjwS3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baSU/qYGtfN0GhPt5dFZWw1IaBl3jV0p8qyqhigyw/6b+4jDOtIz65na4U10iXLcSFdo6JYmcpXeKCn+G3pg5Xui6S6iHr+mXEXQCNsypknGZeVu00OoL1l30Ox3/5NmgQL62AX5KftxGO1mLvfSMFdnBjgoOdk7l4vUI2Hi7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mViux1bY; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mViux1bY"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-39652a6e963so804135a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 04:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787829686; x=1788434486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6AQl5RP9TxXn81ZgXLlb05Y9y6XA1JA2H2ttGtX56P8=;
        b=mViux1bYxGTC+ThorwbYBWpDwOYm0/6QXKtKgdDK5vyjlVjS0R1+dPWEYg570CRFAD
         XKHI87iyRxzJ2W+QvLy/0GPOiXTmSK7L/9e95XmSMvvxYMhBb5YfqWk1YxsHVeorlAFu
         Vod0Y5EBYdNs+obYp8XSonZc/TozJ0LgOjSYUqMZc0RkhGovtXeSht18DiFgUzxACC1c
         5aI/fv9pq3gH38zWr3tbiKp0BbxKbjzslBbLhBM738gFrFBJx0jMunybuAEyX5ZGxmqg
         iHHElr5OxKhdLmQVXLd/A/8gFL2v1Y72xzAiwiLdfARkV6eNrfEkEc04sNApSYu7xqw5
         iALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787829686; x=1788434486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6AQl5RP9TxXn81ZgXLlb05Y9y6XA1JA2H2ttGtX56P8=;
        b=XVTXxXnyYlhmW42JXHQwBBLmu+7r3FOFlyNNZTPEfkSC0FMu7muc70p1baVg7uKng+
         /zVlSueYK++wcip85AClqu65li8cMrrFaQpE6128IUnCOL+gUAtNYZSr4Fqj/LjePEVz
         dECrIdZ3SzGZw525ZMl1FVp+vYWeh8PIyjvLQrP/LbyaJ6r3eBv8x5JuIs92bBHIYr0J
         NO1A+4qTwmDgqnxcv9vM5qfZRasZoPoCpNAVX/wwbGLag5qQq3iO5awR2DD9i6Ek8RYN
         +ZAVRLXfTB5mANuv2HXBx+CYXOu2KrUNDfSYqNxEwiiqVWRLJMe9re8y6ARRqaV+g7p8
         qwtw==
X-Gm-Message-State: AFuF++mzBmB1MaGun8vCHfH1T+2j7/IfLK+XrbSxwVP79YW41vF0Y2s4
	AgcpnDiqCt3TNsVWOXSEh+PBxRcCnHQ4RMEHsAbCBOGCkniMLsjf8JJe
X-Gm-Gg: AR+sD13eRPF9UvhA9PFuWA8j74ArtvrIK3fBG9Mw0YaSdLETjG6Dva8UBbD8muxhqwc
	0ljxFoRXvMtk/BVLpVI8YnQVTicpjA8ZQmSzUFYmcrRuF0Kl7GSIyQRbFhff57Yf3RVHHEnkZFX
	KTCJHdlVTOnt3iOLOKyBBcZO3C2m83l/X89I/1TISWzQgR/BK18iMDXLVmUNxCUuQZZexfp3ZtO
	55bSh94K3YMUVE3J1dztXRVTimy5IUMvf4HXwYz5bfUlc42UVy1PtbP7C9TyNQ8z87ZV+LNgcij
	0gjodIttHVAzyHXJsjHvQRo8nAVeA09+R5HEm9DMhgo+MeG/7bnMWt+ZFexkgibKj6oioUVk6Xz
	WWQ5sba8NHibnJpJTSFJPsOoMCHU2jVd1pxmc0c7At+diZaji0sFnPzQ1mPjQtujJzrlJb1i725
	ROzsNct0v8A+p/kVbN1+hLgzS/whcksqvGa8JqncfBR2/VGcRjzOKoKxsS4OX88xyZv6cZ5p+8U
	eitZgvBoN8zw6bjf+mEIW90ICs/x4lc1Tl27Gw=
X-Received: by 2002:a17:90a:e70f:b0:38f:cfe2:fd3a with SMTP id 98e67ed59e1d1-3969bc5054dmr8099705a91.15.1787829686419;
        Thu, 27 Aug 2026 04:21:26 -0700 (PDT)
Received: from baaz.tail58d41.ts.net ([2401:4900:8853:c223:d8cf:ffee:2034:18a5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8f20095sm16423327c88.6.2026.08.27.04.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 04:21:25 -0700 (PDT)
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/2] scsi: ibmvfc: document protocol parameter of ibmvfc_alloc_target()
Date: Thu, 27 Aug 2026 16:50:38 +0530
Message-ID: <b073968ae020b6ae0240e91341a92f428587ebd9.1787828961.git.falakreyaz@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 249313b3f7b5 ("scsi: ibmvfc: allocate targets based on protocol")
added a protocol parameter to ibmvfc_alloc_target() but did not describe
it in the function's kernel-doc comment, so a W=1 build warns:

  drivers/scsi/ibmvscsi/ibmvfc-core.c:4996: warning: Function parameter
  or struct member 'protocol' not described in 'ibmvfc_alloc_target'

Add the missing parameter description.

Fixes: 249313b3f7b5 ("scsi: ibmvfc: allocate targets based on protocol")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608270829.lHI1FAdO-lkp@intel.com/
Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index d1956552698e0..6fd4c601f978c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4987,6 +4987,7 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
  * ibmvfc_alloc_target - Allocate and initialize an ibmvfc target
  * @vhost:		ibmvfc host struct
  * @target:		Holds SCSI ID to allocate target forand the WWPN
+ * @protocol:		protocol of the target to allocate
  *
  * Returns:
  *	0 on success / other on failure
-- 
2.55.0

