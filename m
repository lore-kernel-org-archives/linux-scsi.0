Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E48468
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 12:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740746890; cv=none; b=UV9lwYifFcIm9M9Ohj5QdmVfmK/JuUtVTOH55c5gTCnph4IPKG7Vut7dbZZGKrchj4rg4SJexEQ8JG0ikO7Rz4+XK7hYsd2idXys1q6yHaD5rgZ5rQMhhQ0biHVkq9UGxwvh1uMfFR1uHhQtaqD9HEeTlq3F/AiZ5KzI2SqVE9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740746890; c=relaxed/simple;
	bh=9cZBkjbOzXA9w4oD50XiYfddbW57vZlI9+NDJfcbiOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ToULHcGvMBNbQFe4/pxUI6itJyQn/SSL/uKJJx2mCAouz71PNnPzZyq0/Vss+PWu1z96O4kTHTXgtMUmkglxFs5j2VN6FCs9L7mId2r/LVAKF72I6M8ctsDzmqSj8E7U3y0/PsOU4LwFa0NJ8lOv4LGJcyGI5LTg/Qv2XLMineY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=bkDCm5Fj; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="bkDCm5Fj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=a/w0mrK/Uk0AbHYVvSYbEwC6m7aQ8xTf7yxIMHyuQUM=;
	b=bkDCm5Fj2wr35aYIXTUouOIE5uKI8TDrXTvIs3GPx32RM6VOyT3+FwznnRMnJ1D0f1cL7cs8il1C/
	 uIVVUnEMKG1TBJxdzZapqqLd2K8sh7QMgX+rfeT/N55OnsKbsOTvpOg7sYUXzGYeznUU7m8S+ims23
	 h65rcZHITue1iQHxGXhiiHLyhpx6IreWF1UaWCfaRm5cawQOzESI+638pPuClev2siKpVER3krVHxs
	 C/sZJh9rtCpljfeG5EWRIyDmfk3GsHASGeqWkglf4/IbfZpQ9hVFKLVdVbSc1Ob9kJnYwBOD9PtB/U
	 pbUh9jrIucfF4L5vWoHh9Nwv+ihkZ/A==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 0e9ed153-f5d2-11ef-a2a5-005056bdfda7;
	Fri, 28 Feb 2025 14:46:40 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/4] scsi: scsi_debug: Fix two typos in command definitions
Date: Fri, 28 Feb 2025 14:46:23 +0200
Message-ID: <20250228124627.177873-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
References: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix two command definitions:
- flags and service action reversed in SEND DIAGNOSTIC
- ATOMIC WRITE missing opcode

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2208dcba346e..4bc0c8350b99 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -817,7 +817,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0x1d, F_D_OUT, 0, NULL, NULL,	/* SEND DIAGNOSTIC */
+	{0, 0x1d, 0, F_D_OUT, NULL, NULL,	/* SEND DIAGNOSTIC */
 	    {6,  0xf7, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x42, 0, F_D_OUT | FF_MEDIA_IO, resp_unmap, NULL, /* UNMAP */
 	    {10,  0x1, 0, 0, 0, 0, 0x3f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
@@ -852,7 +852,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
 /* 32 */
-	{0, 0x0, 0x0, F_D_OUT | FF_MEDIA_IO,
+	{0, 0x9c, 0x0, F_D_OUT | FF_MEDIA_IO,
 	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
 		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff} },
-- 
2.43.0

