Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7B2FE04B;
	Tue, 26 Aug 2025 23:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756250098; cv=none; b=n7XtzyF5kmXqwC5aglg2Mrlgi044liUr3o4SHP2s+lAIBX4+w7/q8ZCX0Q+b4b0MJ80M4ptd5zBtNGNobcRNBVEZOp483SMyAMjBNTZ08G42ZJB2V/RoZFEDHeCPbbxnbxB+Cn+Uao0fdzOC9rckV5fbystSdY9x/qCL+/rRcp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756250098; c=relaxed/simple;
	bh=0mjq+wGRx76lc4+Ib1RSaVtbOPEeN5Up8R/ODNc/ONM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IsMQYEAnPl3bYvhyPdKopZA7pMmpcxTRkdGp7+oR4Oji+Po32F8gmscLi2WoAoDH4pjYDaPIzxj2jbrc6l9ZJn6sOjsJjK9/0X3n3tZ2nnBbN9lRnHBcUjA8Faw+wEjsuqHpUhXetxKoSB1Fb3ylc1eSreVvv++kaQerM+4uDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8LqNVE3; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8LqNVE3"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d601859f5so47753457b3.0;
        Tue, 26 Aug 2025 16:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756250095; x=1756854895; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A+EFGwnFQ0zaBF7IhihKwTXTzSktVRC7dTsbkkQBCco=;
        b=H8LqNVE3e5glwN4rfjlw0So9b/zIh8hhbn7qbpkChnVDo8pcWPVfQglTxRV4yk76Zi
         2ZzYNgYQaTnMofQAiarzn8iHBZ3QV7QhtS0u0GKbP41bStw377OVr4UuFPX3tKZymTSD
         ViAEu7Ytzk7OxHdx+LBu1vuGOuP4icPcNN8P6GOnAErweUOg7For85qZ+fsx6zISDiEt
         iwQtIYbDF2q/Mr11faXkTPPHOQ+X4WhXiZEL2R+ALp+cJRJHQmUvYwL3g8VaGIth1jkM
         pRNh1Chpr1L6MUC/9F6SwDsCdIFwJIRFMEjf7SxKNLDcB2ElsbcehCZb1I1vlF9FtZBf
         X2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756250095; x=1756854895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+EFGwnFQ0zaBF7IhihKwTXTzSktVRC7dTsbkkQBCco=;
        b=kUvGB0kv0dAg+MknPSIkUvujEcJ2x2JtpfYBIky7B8xopv8+BEHz9RicwUYlLFigEk
         NdchUgUA/6C/st3r6BqLy+t7dYUucaGqLlDcfkdoYRxNzolGyZTYgT71vqbkcSbJa/6t
         x74jtXm8xziaOA0KM+zPpqnirzPJ+l5AtPtxrejiHvRs/rt5gq5sTSHe4TbB/Pc+GxMY
         0gGo+DuRkjMf8G6RHRgK+m4yl48eUIKkaubqzmeRa2QCGQAik35JB4ZPR761Wg/WTzMz
         mk5ggXiEue5W8orI990zfOE0xdeQDvpe5TNXJD2dJ30dbpwoC+U1Mo/2FZwe56w04nx8
         JtDg==
X-Forwarded-Encrypted: i=1; AJvYcCUWBewWQHot8HFtSgBERa2w6bZy6qYO7dlifV/i2Bc3GNoCi0cI1E0UGDf6Jd3EOQ4OKkMyZVVoDLniIgU=@vger.kernel.org, AJvYcCUt0Ok9SAhG+I9yhBWEAbrojy8ZhLa8OA/uIytxbKFltxC1nZXyoRAm/5wWHwpAfPkDYHaKc7ou6aJ4Uw==@vger.kernel.org, AJvYcCWAilv10UqRMw67zHHj2fLiePbcMRt0XELBitEvHyh+xcQV7FuZMMDdNlcwNE3fNwEVD1CnhXZq@vger.kernel.org
X-Gm-Message-State: AOJu0YwJjGcfU6XzhgNExC1ppjUbH3qql2Ih7MlJZBubQ7nRkrD34XPj
	YyxkI56WBUSJkSKG0xqGSbrnLIZw5Ec15X6vqGq9+WN543+hsS06zEbxUFno5KnbL14l2Ild+q8
	zamNjDwyuzipL70YqoyVXtmh2p6PsVbY/aV8C
X-Gm-Gg: ASbGncu5eZWNqvwb6Wt2d0KhzKKCEcX2qAS0QQotTik8SavjzYCUNwF2twb4q2w6X9f
	EWFeEslPGExatl0KMpjv6qQMEEhQZFHGcivAFxB1kfFksDcLS6usQdx/sHzlqe6rZPQ4naE71y+
	pQP2Sppm7dVg6fe+zyL/fv9AA+20I7ZIdE6m2IDzwWZADI39kUx3QlBSVElz2p5B/g4J3wy+I+V
	rCkgltd7/usKE1J8lY=
X-Google-Smtp-Source: AGHT+IHRhiuDXAJL4fwVjOJfXYiK9ILV/CWlaTxpOiILiMB1tVJbT6akcH2yFIfNsYRAnBvMa0fbcdad1KWgireB250=
X-Received: by 2002:a05:690c:680c:b0:71c:e6ff:3236 with SMTP id
 00721157ae682-71fdc560610mr200912877b3.37.1756250095435; Tue, 26 Aug 2025
 16:14:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826195645.720-1-evans1210144@gmail.com>
In-Reply-To: <20250826195645.720-1-evans1210144@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 26 Aug 2025 16:14:34 -0700
X-Gm-Features: Ac12FXxsfrKwbToWOjAlHaF_eg4heEL8Xuz4AynQE3ic7BPc-ny2pfUiWwKJA0I
Message-ID: <CABPRKS_bKK-6ph1ETQ1pLsY_KPPQBnCyBsqfd9V2JrOQXHQT7Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix buffer free/clear order in deferred
 receive path
To: John Evans <evans1210144@gmail.com>
Cc: james.smart@broadcom.com, Justin Tee <justin.tee@broadcom.com>, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi John,

nvmebuf NULL ptr check is already performed earlier in this routine.

Maybe this patch should rather look like:

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fba2e62027b7..cd527324eae7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1264,10 +1264,10 @@ lpfc_nvmet_defer_rcv(struct
nvmet_fc_target_port *tgtport,
                atomic_inc(&tgtp->rcv_fcp_cmd_defer);

        /* Free the nvmebuf since a new buffer already replaced it */
-       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
        spin_lock_irqsave(&ctxp->ctxlock, iflag);
        ctxp->rqb_buffer = NULL;
        spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
+       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
 }

Regards,
Justin Tee
