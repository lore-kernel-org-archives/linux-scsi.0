Received: from mail-lj1-f196.google.com (mail-lj1-f196.google.com [209.85.208.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B57619922D;
	Thu, 28 Aug 2025 04:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756356320; cv=none; b=U+YWxd175T2B9dPgFC3U5IPT1YK2s13vO1hiOuAyyhS3HzfT+hEhoCiwJ53IpVoufWwQqjL34KwqfqnfJe1D6Zuj+5sYkS6hyvl9XK1j2cf7XIpUIWwwSGPgOi6hTX7zLJ9jqqAK0szBKrjug89pfUjevtmdx5yZmrz3GXrlb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756356320; c=relaxed/simple;
	bh=YLS508mVWTsT/D3g6kh9JKPmdvC/h8hUKzxQ6bBVWC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KCnW+lFUfo6vrAPftejgfk5eWYKk4WJVABczCiBrAYnwatrorH0MGifMjKbLV4pJo8DwUM7Q+D4jLbM2f5GP0C51w1CcAIl8f6OUpQbSWHEYbeZH6Cw6eQNUSJCnFosbLuCNzQVuKAgbofWATq3+Gn3XjWTncit36N8u9tPwyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mc73iyRx; arc=none smtp.client-ip=209.85.208.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mc73iyRx"
Received: by mail-lj1-f196.google.com with SMTP id 38308e7fff4ca-33663b68b06so3460631fa.1;
        Wed, 27 Aug 2025 21:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756356314; x=1756961114; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TW2LCh1WvnZ5P58uALb2z2Cr9x1c3WZEgUUjYSPNKZ4=;
        b=Mc73iyRxfT/aZcXlCex608wMXdGQ7ja1edLD5CgvU+3uump8FZu8SFuFcUsY8HXJzk
         Ua1OSue9zSQ5ysd03EVsR917CSjfIIKVhIHwKF46fAW1HYcS5JytGR2ESvHYvi6GpRvR
         UjsuAbMRCJ1DlifiIohIIdQuJjpRt/pIUXI0ZmKG2hpmz2ZtXnGut3rHKosNR9UQLu4L
         S4fY3okFViNwdqjVtlhXWKkAdoPkK0J+mnmGSUkhq4W9sUCKDfLY7hrWWteptLT+K4a4
         SzhOc93cGqoCKzmXzQO9mQcQBkii0uYUkqt1bXxSAxv/qBD90oYMU9f29WoHo8quLe2g
         d5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756356314; x=1756961114;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TW2LCh1WvnZ5P58uALb2z2Cr9x1c3WZEgUUjYSPNKZ4=;
        b=DDU7to8H1e25hxlIJf2Ui95ilL1lyHbp5FpPLNHIIHt0sZM77Bims5sN/xd3xSpltB
         oZqTHGAL7smYP3oql7YlJqbpg7iCXeQxH8ci2AGXO2T2WHgOiPTLsuX+z4b2ngnYxRZc
         ml+rTORNKxXPr06QD8K4sWnnk0pLfBOoFHz+MOLO1HORO8PtrOIQZJymAwtmWk9DqkfY
         40sL96Fz+c2cqk69VIwz7VBNcnKRF1ARQBAm0tC6e4xnbhbxHc2t/3dXTzJgybmyfsLx
         CAPwuuKX5sPojP1J6NhpCG22i3gGVBLN3/Zx+lT2ex3cXYZI6AerOxTSt81V9FEMySKE
         2XeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUop8nxhhsJSbftVtIz0CTO6Dq55aPiXFxtd6GmRCIxherx57P7gMTWcP5wPjLW0kEJXW1KH1MK1IffTA==@vger.kernel.org, AJvYcCVmkkJfgNwyp38ymnRL3+psunVVxHmBGJ1aWHm6s2IyaviC84nHGKrlgk3+uTJUuWorknVAYl5f@vger.kernel.org, AJvYcCXdt/+Ud9TaCgrLWdy4cBAjkhOE2/C0O1VVbjBloanFtnpM+mjCsDxedafHzSL5uFktK4HBwY+8KcxIkBw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq9xi2tCM54b1SPt0YlJY9fao8emEFDtfxMH7sJfYEJv4Lct5v
	646s40ZGJibX+OipWpHpTtQSFu2mIAmnFBEn18NbpMyqRlN9j1hBAvHqKI6DqAk0GNrtPPRN/wJ
	+8bcvAHv/iCV3372GTvvEA04Yt1sOrAyM0TgzM6ZRiA==
X-Gm-Gg: ASbGncuUG3jG2DsVf9UCk4lfTeGirSy6xBUrhjNkV7QB5GCYQRHCasZUjK8LWjYATJy
	zO5XqlH8nx2bghQb2RkU5ypYLGoOvOXRd7ptdKS/XOF7CA4gdjC4TZuTBBeVMTHk135CagKuhW1
	YEJxL5kFONr3ASb/8/jR6WZ2JcBlXcMIGOc7UyKAdrZzO/DwHG96zVXPyRO9nF58tdADmNh8bMg
	MH2Kho=
X-Google-Smtp-Source: AGHT+IG/OTsAVkVqEVSN5NY9I7qR3hRb0xLl8BHkU+CG/v5H+rASJogWghm4vYVXgr+z1r3NP8KxjfluEYR0lIHy9oQ=
X-Received: by 2002:a05:651c:23c8:20b0:32a:7122:58c9 with SMTP id
 38308e7fff4ca-33650d769f5mr46248021fa.5.1756356314158; Wed, 27 Aug 2025
 21:45:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826195645.720-1-evans1210144@gmail.com> <CABPRKS_bKK-6ph1ETQ1pLsY_KPPQBnCyBsqfd9V2JrOQXHQT7Q@mail.gmail.com>
 <CA+KyXhKX1n6fsjfRE_ocu5rKsP3Yp4UoEGVyq_=TZwftnWLdkw@mail.gmail.com> <CABPRKS-DZ9hY99QfVKuHNEt3m3AF2iLb7TP8j6+gPsGMux+Xdg@mail.gmail.com>
In-Reply-To: <CABPRKS-DZ9hY99QfVKuHNEt3m3AF2iLb7TP8j6+gPsGMux+Xdg@mail.gmail.com>
From: John Evans <evans1210144@gmail.com>
Date: Thu, 28 Aug 2025 12:45:03 +0800
X-Gm-Features: Ac12FXyFJ-bZN-b8MhJcS6txrefzqXCHV3gGVDgz3pDgYphBlPIDSbiXNB0ucMc
Message-ID: <CA+KyXhJh3sGb9rzY7jPEAkSpjvhAV+DG_qRzDdBs4q7BZWAV0Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix buffer free/clear order in deferred
 receive path
To: Justin Tee <justintee8345@gmail.com>
Cc: james.smart@broadcom.com, Justin Tee <justin.tee@broadcom.com>, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Hi John,
>
> Ah okay, then how about moving where we take the ctxp->ctxlock?
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index fba2e62027b7..3d8ab456ced5 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -1243,7 +1243,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
>         struct lpfc_nvmet_tgtport *tgtp;
>         struct lpfc_async_xchg_ctx *ctxp =
>                 container_of(rsp, struct lpfc_async_xchg_ctx, hdlrctx.fcp_req);
> -       struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
> +       struct rqb_dmabuf *nvmebuf;
>         struct lpfc_hba *phba = ctxp->phba;
>         unsigned long iflag;
>
> @@ -1251,11 +1251,14 @@ lpfc_nvmet_defer_rcv(struct
> nvmet_fc_target_port *tgtport,
>         lpfc_nvmeio_data(phba, "NVMET DEFERRCV: xri x%x sz %d CPU %02x\n",
>                          ctxp->oxid, ctxp->size, raw_smp_processor_id());
>
> +       spin_lock_irqsave(&ctxp->ctxlock, iflag);
> +       nvmebuf = ctxp->rqb_buffer;
>         if (!nvmebuf) {
>                 lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
>                                 "6425 Defer rcv: no buffer oxid x%x: "
>                                 "flg %x ste %x\n",
>                                 ctxp->oxid, ctxp->flag, ctxp->state);
> +               spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
>                 return;
>         }
>
> @@ -1264,10 +1267,9 @@ lpfc_nvmet_defer_rcv(struct
> nvmet_fc_target_port *tgtport,
>                 atomic_inc(&tgtp->rcv_fcp_cmd_defer);
>
>         /* Free the nvmebuf since a new buffer already replaced it */
> -       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
> -       spin_lock_irqsave(&ctxp->ctxlock, iflag);
>         ctxp->rqb_buffer = NULL;
>         spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
> +       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
>  }
>
> Regards,
> Justin
Hi Justin,

Fixed in the patch v2.
Thanks!

Regards,
John
