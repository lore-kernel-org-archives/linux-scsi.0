Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AAC363
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660502; cv=none; b=NasBAvm6i2oeukqDOdV/ZcqrHsd9VYwmYrYNSyB/YBObt1E89exfL5+/d+c5taMR+DJRalWOvc4tCZ0ZWitePc+HLjxwnD3ZiyuoX63oQcIwajIR9AZByi5p3ZLpxIRiiO2IUYOjTirC0ViGjiRxv/bzb06qVtN/cDvXXa5Modc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660502; c=relaxed/simple;
	bh=+WqancjfyH3kQ6JkvjEygr+/D2TfGrT9yzFBb7GdWMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JoTj98lf18ontVIuwPSbwc89iJbZ7JjvZYobgDiaaX3acp4TLfawZre9aYbThZkSE4wqduizNtVgZSQXuO2zRwXcZqLRC/N9Q1V8R6CHcgOsYZUTlGP2nM5lqp89CKEscbSfSt3vXLWFsvv8t8nFA2RTVkquFmkYsGZIJLlmnNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlxe/dKo; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlxe/dKo"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7cc2ffdda1cso677983241.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660499; x=1707265299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImZlimw8NaPW2DOOZyyfAZCoKws77h59LDy1/yw9qqg=;
        b=jlxe/dKojBA3O7iZoPFe5ukP9JGauFgQbq12fu4NWu5LJNld88UM3qfcwnJ6Iil9E+
         9KMQZmMFWbU5MZ5aFJjjH6F4FirCj4dGj5W9X1GfmCcoz+3vpTwha4tfdEM6P08g6Eel
         lr/RIixixbXo/Bg4toVXhqx5CJg1ykHQRYztdArkxJoAktfy3g0kvtR5fGO5Gu21EkNw
         ILZIy83oZUz4L4b6nwDMJMY78Z8dAlo8X7J+18cZgzYUD2w1Ocf8FE8T0Bk7Ll4cfnRa
         DpnrXdvGlgDtk4I1rWI0OdoMAwPehRnzK05YG0sBq5jl4CaBy4zcd3UtWX6O5BdWyieg
         FwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660499; x=1707265299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ImZlimw8NaPW2DOOZyyfAZCoKws77h59LDy1/yw9qqg=;
        b=qChVAsgQl0FAeGWqTR7vPaLMDjdfXKXf+RJshs2F+C2MmY7zCHuKWgS0aMqbFv3gtZ
         UysSeocuiqRa+eWHx0+kVFjEiiq5xD2O06PXhYuBm4e3S3Ww1CqxDDLOg0nrh9z9ddNO
         qLAZfq1mZfDXptKegm3nej+4LYwQa7eq44/gyAYNBm1XFAAOItiFQwVCThDH7sJzle30
         4lPQ5B33HqFEy9b8WUdd4w49lEmZ4j/vUcnqv1i1iQMAK7gS+O1fKYMjl4vUceoNhcPe
         RY5d49TXRbXwZ7m6ZDCXUkGPWsDzF/Ka8kFRz6HCL7byl3WwJb8C9jgqfeC8xyG1wePi
         hlOQ==
X-Gm-Message-State: AOJu0YwVbxYMCv1768XZWSJomZvypizbyTl5x1xQIUL1uTVc9JTNCsen
	0sW12Ni1VmovvWqiKuoBuTNhhUW6/SoAkqoJwUF56W0b/Fk2YPhLCd3HfOPP
X-Google-Smtp-Source: AGHT+IFtZD9SjM+rUNcBxYXf3f1R9tTl/cpDxx9qd9HfQH68ywsXqQe6kt42QYobfnKf5BVTcenxyA==
X-Received: by 2002:a67:fd15:0:b0:46b:3008:e612 with SMTP id f21-20020a67fd15000000b0046b3008e612mr14353vsr.1.1706660499244;
        Tue, 30 Jan 2024 16:21:39 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:39 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/17] lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list
Date: Tue, 30 Jan 2024 16:35:33 -0800
Message-Id: <20240131003549.147784-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A static code analyzer tool indicates that the local variable called status
in the lpfc_sli4_repost_sgl_list routine could be used to print garbage
uninitialized values in the routine's log message.

Fix by initializing to zero.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 706985358c6a..c7a2f565e2c2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7582,7 +7582,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
 	struct lpfc_sglq *sglq_entry = NULL;
 	struct lpfc_sglq *sglq_entry_next = NULL;
 	struct lpfc_sglq *sglq_entry_first = NULL;
-	int status, total_cnt;
+	int status = 0, total_cnt;
 	int post_cnt = 0, num_posted = 0, block_cnt = 0;
 	int last_xritag = NO_XRI;
 	LIST_HEAD(prep_sgl_list);
-- 
2.38.0

