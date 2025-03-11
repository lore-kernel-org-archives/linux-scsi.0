Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC09253F05
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741692380; cv=none; b=X4WkaPiFRA/ijr7to6e/6tOMAq8r+8Xn6BjWHhV1M1aiSAka8xWWQnB70WfG19PD5tOerrbAqtpEtPpKvBROjYwN0Uue5tXTEOikDASW6ieA4w95bs4dLqiFcN7GHK9viEkeejtBSwpoAME5VW3ym+RQUTP/FutTNEWZg5F/KMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741692380; c=relaxed/simple;
	bh=nNNInvU5LCaGyKmG/XrX/dfSKu3Ro8XXVW0J3ZgDLKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9hmBEBu4lyO07vPGbw34QDVlYGvAApl4rJiUmF+lC+uy3o6aCz6SidQJXO1QtRdQDdU5fLbXuEMvctIifncZjR9HGhqVDkO8cYj089aVl3mJ1DRyTNey/v/QMqxdeurrUnEbPeIYoaJ1fN/CxRg3ElChS2pRvrhQP6kt08xD7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=NO/vasxU; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="NO/vasxU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=IxOVwi1rbMMGKQgPAkLY6jhtz1sGP+SiE6L7UrVIer8=;
	b=NO/vasxUEL3Dy/UTOOrpXAxiMNKFHs+VfYinMruYVeM1yxHqgtcjkrpQDV2WM42KsIYftmJW8X5tC
	 L4QYnhVkdvUuPtiwjmr5AkLYO/7JuqEXWTE09eHmer6T6yjGo0+/9+45NTG0bWIRu0eLLxiW+eD4P9
	 pk8Qj95k41HubL0QoNVvxYVomsdOPrG72/YM7wkrA2HiLRw9SOsXAjTTErHZz5n5K/U8oqPqkVrlV7
	 q/oXWbkir95lqk6NdXB3ICZuF4yZZ1lvt8wvZEfP3yUeCbjz+BinoQUuyRpwgubQYtaoRmOITpQzxz
	 +Xw3/S80syXKcWmlhhYsAFv1iYrtVMw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id a3ccd664-fe6b-11ef-83bd-005056bdf889;
	Tue, 11 Mar 2025 13:26:13 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 3/3] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Tue, 11 Mar 2025 13:25:16 +0200
Message-ID: <20250311112516.5548-4-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
References: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In the days when SCSI-2 was emerging, some drives did claim SCSI-2
but did not correctly implement it. The st driver first tries MODE
SELECT with the page format bit set to set the block descriptor.
If not successful, the non-page format is tried.

The test only tests the sense code and this triggers also from
illegal parameter in the parameter list. The test is limited to
"old" devices and made more strict to remove false alarms.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 55809f8a62d3..c33c0f2045b7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3104,7 +3104,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			   cmd_in == MTSETDRVBUFFER ||
 			   cmd_in == SET_DENS_AND_BLK) {
 			if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
-			    !(STp->use_pf & PF_TESTED)) {
+				cmdstatp->sense_hdr.asc == 0x24 &&
+				(STp->device)->scsi_level <= SCSI_2 &&
+				!(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
-- 
2.43.0

