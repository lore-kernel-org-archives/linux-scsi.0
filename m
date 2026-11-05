Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793922098;
	b=b3ln7wUauQPZSfPBwsYptHJnJmuiaZ+hYpXCd4y2ihde+OlNfdVvzhORm9RNkCM+Kngt
	 WtMPkb8rOv8TOQnnsXu/PTs/hzFodoGBWGqNnb/N02rvr2jV+peQGgFp2ryO9pHd1DJWD
	 jc+vJHJxDzzn1Hz6jhRM8af/yl7E36xd8An7f70rXuZ6Bt4lZTJ04sBxeNU+4wVCOzR45
	 UFby8W18t//E3bcsrupEu9ubSCT11Uw8B/kx4tY2p2zBi7pWuogX22af6igHUgfsN6NcK
	 q5aFi7B/p/Ge5JC+4CumGAv8H0TMSCMXsi5AWFCaqolTxWs5qI8NUBb8Sidh7P0I5VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793922098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=1t4oMgaRT6mgZXiIEaDJhWQ4zq5lVHTVEOJcT/t2rnc=;
	b=QJ4Z8BkMNSSBenr5vmHM2npur5FluEbfFdUdGgJotv0bc7bE84S2aMvgQgr5fL8OyI+G
	 AnqmeT7iRBtbSJJUseIjvLKeQoyWW9Xta4O38sxi/3Jl9r8G7RZut0SqhMY9X9DsQtftl
	 VkAIxRPiRrzp3/mjdrOqDJQxH3tsEiygeXihyVUWz/0MjnHkS6EyisxpRt4sycLEJ0m8u
	 mQs6Y4kvDeFcpbe9vV+kTRwMNMAk9klx/CYR3rUnol/MjYyEd0QBZf5kXD0kWSLgZG98v
	 Cwjb0NQwNBSk77KaXaYZDlGssC8n820ZqdzsFPybvxaBwTaLldt+wUFYn9Mko3fBvMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l2mc4+y/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A33606A326;
	Thu,  5 Nov 2026 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2mc4+y/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35521F0089F;
	Thu,  5 Nov 2026 23:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793922097;
	bh=1t4oMgaRT6mgZXiIEaDJhWQ4zq5lVHTVEOJcT/t2rnc=;
	h=From:To:Cc:Subject:Date;
	b=l2mc4+y/0vQkzpDyUTR0WK7i1EGo8pLSgySRIa3NAWyTslN8pUX9H2HWB2UMtvW5M
	 fYtLQ7NG5qW69qPDWgfSyKsRCKT9OJO2jWwbrfrNtuPD/QfkiYHF3bp0jzxyp+/moK
	 AJhZzYNJxRNEyAvJuNizpxvvfegSAjv0HGX5S34Diik6eyp8ncmt/uR+wWLzcimgyO
	 hhSYPsIDkqBKP+U/cEjT0fnEKUrriZPlorIXZVCNH8rf+I3K7xnZS6DFSaqA/yxHG8
	 3KTYPoZ3xFxs9Cbpi2HFn/DLbOqij2cBPWwW+evpgOUtrhKC3TiRPifzhd0hjVSdjO
	 4QMZ+j2Rfqe5g==
From: Thorsten Blum <blum@kernel.org>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Use isdigit() in lpfc_wwn_set()
Date: Fri,  6 Nov 2026 00:40:58 +0100
Message-ID: <20261105234057.455716-3-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=745; i=blum@kernel.org; h=from:subject; bh=E5Q8dG4/rG+6CaHxBFzT2OmHNhJ+NwFe0oEbzxSJ5iU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlvRTi1k8qyTjT7fpGb2FPe8PaQY9Cd6NikVfWHlp6Rm HlA59fKjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIhizD/0CjRr+1Mg3+DRWe ms7zpm7y8d0Q+ene3wmsqr9uveLfN5eRYaHauapjzbcX6a8OYCx+fvvY6TVHy1KFd906xbk0mHO KAgMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use isdigit() to replace the open-coded implementation.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index bb5c84f0b787..4ae113002af4 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3082,7 +3082,7 @@ lpfc_wwn_set(const char *buf, size_t cnt, char wwn[])
 			j = ((j << 4) | ((*buf++ - 'a') + 10));
 		else if ((*buf >= 'A') && (*buf <= 'F'))
 			j = ((j << 4) | ((*buf++ - 'A') + 10));
-		else if ((*buf >= '0') && (*buf <= '9'))
+		else if (isdigit(*buf))
 			j = ((j << 4) | (*buf++ - '0'));
 		else
 			return -EINVAL;
