Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com [209.85.208.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5552310A1E;
	Wed, 27 Aug 2025 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756257544; cv=none; b=a1CulNeLgz8mRciGa5AfW9a9D2WoC5CwS2JuSgNfuIV0SFC7QLUh6cSju8OmtwNsw5H7w90FaOeXVd708bbPD2xM1azyMCWEMRL6eVpNICmulx5faATP1uEh0RuQHbVuQEheF5Gxh61e3xxX4aRgZEq2tZVW41hpcuiNK4inIVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756257544; c=relaxed/simple;
	bh=XkIpS9jmFSp2XPU3dfCBPvEyI7d4WFf9GJrCvQv9Gms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUxqXF2e5KiUPVxJwXkdg191jIYJmh99FYY4IsGqTPK5ilotEs6sjVqEW27j3U2j23QUqUYrFk2eoLVL5EhHXT9iQusMRusxLJHOdfp99L5eEJ8mPX5sleWbVxqQ5OxNHwuvc/QS2h7h7z2wPZQhyIlmH8Fpz6961V3+9SznM4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nV5DdB4Y; arc=none smtp.client-ip=209.85.208.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nV5DdB4Y"
Received: by mail-lj1-f194.google.com with SMTP id 38308e7fff4ca-3366de457a5so24339001fa.0;
        Tue, 26 Aug 2025 18:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756257540; x=1756862340; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=feUF4wDtJdaAfDQqTVAJaY0VWM8phmnNRRFhgiYvkpo=;
        b=nV5DdB4Yz2D8wNhbb4ltjlOeaT+eJp//pTTOQCQxxzm2LvOBmvLbunMS+gi5bVlVtJ
         rIwpkd8LshqkgTaJE6Xh0rYAhXXSNqwrmlDHeS9V7vvVkQ58+BsI5FOo8OuH6k70lZRE
         7H1T5hhFkYyjajT/NU+Qq9WtX70FbNLUNUXVW9RTUWh2FUMcXWS0GxNGmOiYmHwqCPhp
         iaWyXm3h9brIQiX6aGtqJi/j6Dck2iIMn28A9I/k12EJA19+wKxuYSZPI11u93OISqus
         9IpRUPiHVmVDCrdR9B5csUmANT8+rZRaljp1RgWwdeD7g+uQZRKlOSDmaM3E8LEcGpot
         2yJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756257540; x=1756862340;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=feUF4wDtJdaAfDQqTVAJaY0VWM8phmnNRRFhgiYvkpo=;
        b=p71raLnY0w0MsAzDgQ00RhbMmwYkPK35lSvqAjkINrPnvffkLSfLoevfm8v0b/5+oX
         C6fBNmNax//uRDeSnaJTnlP01enMfuw1tVKm6OVWwKymSrMj7/PlSZf4C7bcI2Bkkaug
         NKIvD+7WRrmXt5GlPEQYwH8wQK8gYrGZ6zqcQDDJsthqMS//7caUbnmcS5jaR01xrjDB
         xAe23b3pVq9iP2SzhohWQUfHGCej5Bi3sq0zNiGwaoEG23SKH4IQiAIzKxUCmMS3gSvJ
         chxd1IiU2YhxF4BOirJAedeDEbLmVwlC5JgB3s5+qk4ohJkyZTGASoHSr7ybnckZhaKE
         f7mA==
X-Forwarded-Encrypted: i=1; AJvYcCU3sUmlAJj5mntHe+Xd/zvlSfr6NhgW8WXHYifo+vlDo/TZtBX7IPW9/5UIfUbzeznEjPMBw+nxSwbJROo=@vger.kernel.org, AJvYcCUML9kG9eK38RfMN6Z9BwJmjXMhog3/rTsGMAYjezRou9acqEWKKoKxqgd7L0BddmpKZG+b98ht@vger.kernel.org, AJvYcCX44eiBcb8XytOKUHhOt7pQ2JNyowHGT6G0i58JOoqFjE07OAKfy04dgouo9yHs3tmwmg7fea/Kh9QtNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxAc+vPIc6dSKDRwxgdz21yIu5wgrHK2nHuh2w3KHN7l/cwpNT
	4U4c0+eXkHhYevOt5sCbtV883lrm72U0vVhY2YdoJ9sUVEF6HtwBNszOiF+sORHoDzGRGatiprN
	3ZTmLQJzBQpK3LUo4xEN1vNdF2PJAEgM=
X-Gm-Gg: ASbGncvfHJfDQFRob6jllOkgpebBK4g38HHkPhgeb7wz9QHaUN9trllDaXUlBBx8eOs
	QG2GeWLcFCnmZvQ+LyigEf3J1Tw8Vz8wTv4bL1bllSeOtyOmk1lkNsuAg8KNe/s+LoFXkfgpu5a
	XiI34zXVozQ/C2vjxY/Jlse5prOldHKzU+BeQYpVp2wgX3C8863CcaZAKY+ZszCR5sNB4BqgSDS
	ru74vH1
X-Google-Smtp-Source: AGHT+IFMwf3Ig/oqUxG/ejOb7rDoVZrWytBh2EPEvYRCi19itGVP4uaFuhILtwsBpOkfFAQsQ3wbLVtGNc9yuKhtnkg=
X-Received: by 2002:a05:651c:2353:20b0:32b:a7d2:a8b1 with SMTP id
 38308e7fff4ca-33650db0a9fmr39089341fa.12.1756257540071; Tue, 26 Aug 2025
 18:19:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826195645.720-1-evans1210144@gmail.com> <CABPRKS_bKK-6ph1ETQ1pLsY_KPPQBnCyBsqfd9V2JrOQXHQT7Q@mail.gmail.com>
In-Reply-To: <CABPRKS_bKK-6ph1ETQ1pLsY_KPPQBnCyBsqfd9V2JrOQXHQT7Q@mail.gmail.com>
From: John Evans <evans1210144@gmail.com>
Date: Wed, 27 Aug 2025 09:18:48 +0800
X-Gm-Features: Ac12FXzAS7v7uOA4fSZrQ2GHotIWL9wdBR49O5QhiveInl3aiSKtotmLRM-E_xQ
Message-ID: <CA+KyXhKX1n6fsjfRE_ocu5rKsP3Yp4UoEGVyq_=TZwftnWLdkw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix buffer free/clear order in deferred
 receive path
To: Justin Tee <justintee8345@gmail.com>
Cc: james.smart@broadcom.com, Justin Tee <justin.tee@broadcom.com>, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> nvmebuf NULL ptr check is already performed earlier in this routine.
>
> Maybe this patch should rather look like:
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index fba2e62027b7..cd527324eae7 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -1264,10 +1264,10 @@ lpfc_nvmet_defer_rcv(struct
> nvmet_fc_target_port *tgtport,
>                 atomic_inc(&tgtp->rcv_fcp_cmd_defer);
>
>         /* Free the nvmebuf since a new buffer already replaced it */
> -       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
>         spin_lock_irqsave(&ctxp->ctxlock, iflag);
>         ctxp->rqb_buffer = NULL;
>         spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
> +       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
>  }
>
> Regards,
> Justin Tee

Hi Justin,

Moving free() after clearing is necessary but not sufficient.

The race is between the load of ctxp->rqb_buffer and the clear under
ctxp->ctxlock. If we load nvmebuf without the lock, another path
can free+NULL it before we take the lock:

T1 (defer_rcv):   nvmebuf = ctxp->rqb_buffer;   // no lock
T2 (ctxbuf_post): [lock] nvmebuf' = ctxp->rqb_buffer; ctxp->rqb_buffer
= NULL; free(nvmebuf'); [unlock]
T1 (defer_rcv):   [lock] ctxp->rqb_buffer = NULL; [unlock];
free(nvmebuf);   // UAF/double free
