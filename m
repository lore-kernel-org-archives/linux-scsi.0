Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405603A1B5
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 00:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723403; cv=none; b=HsE1mpEF1fsyQMblIlFiY8u/JAfXujEigPxXJx+mlo0f5P6hsucgiqm8lIReSCBmTp5/HM3kURJzTvt+mHCFv7RSxgoFnHC9b36WDcQIvWx0v0gtHObTY9UXlVimPbKtPtLEg0XwbIKNCXTfraypwKkk85zPLUYmRwSX3TuQmV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723403; c=relaxed/simple;
	bh=CWzbTiHz7zTG+K7+boLZHaLei5opXpRaXIYqqiwOBHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IY1FX105yZIQ63txuI9cOF3OLpGbGVnJFgwunA42HcYVx0+KjFaGDIGo3FiS/zCc3DSmSt+uoYwyj9vjfT+klmpvLOf0BXjEpSXzlotlSQ9Iat3I9uYJGauisFFKuL8cTzoQlsAELEK772MsGuvSLJHSfAnoftHdpwhv0phLPus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-640f2c9cc72so5652841d50.3
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 16:56:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764723400; x=1765328200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S+nufjPxLL1cIVMD0kPrg2zi4C0QxcA77/87khD8BlM=;
        b=IYZLTZu9bgI5jBMmnv1uBHufACaq3vMUzEVu14EYR/zEhq0GUczqHoOC7TUeC+FujA
         ABUfUxBQx0ZxE5Ir5+FyAucpG4I7g/8T8Z1dL3FyRbAMiOt+C97BNwQjNp8D9eWfLjxR
         vpl3jGo0GvXfgWIyVG0nvqpgAChKw85ZQn6SwyPvAyAyGkHGIJ8UhgDm9IcSOEQHtldX
         8eut+LWAdgMreJVhhcnrfgxJOEEGLdAKkHPciYywL4Ug/HSsDH9ukxzoRDpVbTvnC5KT
         LVdkq10kw7gp2NJTcr/6CQ7B5opwqfMHT9/sKup2FEV3d14g08eE1d+/c6x8EGTO45DB
         zOkg==
X-Forwarded-Encrypted: i=1; AJvYcCXK05b4LDNh+ztR2Kha3n4SG1lqkjiVC/kz/7ZRgAME9sKa+z5dFsPz2zGNr5qhUwhNb2MEpsm1B+RD@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1a427gx77OZbgYi7nuJz5DpDFk0+Fbz/hPFUcK38NO8joxx8w
	XPLkEnkjn87K7ftwdoQRuGKZ+WjQ5GTwh1YpYVwzt6EeKLuUxMKV+gCTFmM/3w==
X-Gm-Gg: ASbGncuH74BoIeZ5izjramcSEACYBYsjM517nMt53wFwbY61/5pQ810ioiZ/sfwbcKu
	eBLdtTbaXOM3aD37wUoF8JSUZYIg6uRSoF2Xa8EnUaQILRutnagJovJ0pOZovBGeLuRk0RTtiVZ
	8c1WcxY7b87fDoPAisQ8Tjzr/wFbVtR6t6+/yvt9JfUGO/kz1obOo28BiIFiywDv2YtQ2urpwQr
	Gokf4ojur5vY6PeO0OZmWMhxEGSyqfVeAv3N5jBiPVzgxXEl2rp07Fl71o9DWY6OU+0p9RwqJK6
	BLWFI4vTiWevTuPISV/pF07eqPSswuEhLY57E6LsTLgsdQwefkaLpNc1gOgzF+wwivu3au69opj
	RZ5s4xX0SDFynTKVEB891h0IMPQdY3Ww21+J/nXH1a5nsBQeARVpEP9Pkgm7he9G4GrUVB+APs+
	CLrXHA4GmQZ8vIYCLl6b5uAj2qHX3DArNHrT53gAd/Hw==
X-Google-Smtp-Source: AGHT+IF6gdCaiUN4TnHnK/YDv9DAaHVGy3Y5b//XvRoolMZCmI00DO/Mcp/XgxMp5ugM36gUbJN4Xg==
X-Received: by 2002:a05:690c:7245:b0:787:f2c3:7164 with SMTP id 00721157ae682-78c0bcbaf4cmr11946497b3.0.1764723399998;
        Tue, 02 Dec 2025 16:56:39 -0800 (PST)
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com. [74.125.224.48])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad100d3a1sm68603727b3.37.2025.12.02.16.56.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 16:56:38 -0800 (PST)
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-642fcb9c16aso5029349d50.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 16:56:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWnLKvPS3IrqtDY+6V2JgUB6tYzib+yiB58vvYtq2jFYBrnjD+lHnWI2udzBxkeHXtou72nGqePz1VP@vger.kernel.org
X-Received: by 2002:a05:690c:6611:b0:787:c849:6554 with SMTP id
 00721157ae682-78c0bf59e06mr11996967b3.13.1764723398466; Tue, 02 Dec 2025
 16:56:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031204029.2883185-1-bvanassche@acm.org> <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org> <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org> <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org> <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
In-Reply-To: <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
From: Roger Shimizu <rosh@debian.org>
Date: Tue, 2 Dec 2025 16:56:27 -0800
X-Gmail-Original-Message-ID: <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkAOygLeZzrgvTDoKqo9DtnYNpkD5wYlC7bA2Eplx6qm3xyJjYecHlL3l4
Message-ID: <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved request
To: Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the patch, and detailed procedure to bisecting!

On Tue, Dec 2, 2025 at 8:03=E2=80=AFAM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> On 12/1/25 10:51 PM, Manivannan Sadhasivam wrote:
> > Please share a fix on top of scsi-next or next/master.
> Before a fix can be developed, the root cause needs to be identified.
> We just learned that commit 1d0af94ffb5d ("scsi: ufs: core: Make the
> reserved slot a reserved request") is not the root cause of the boot
> hang.
>
> Can you please help with the following:
> * Verify whether or not Martin's for-next branch boots fine on the
>    Qcom RB3Gen2 board (I expect this not to be the case). Martin's
>    Linux kernel git repository is available at
>    git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git.

No, same boot issue for mkp/for-next branch.

> * If Martin's for-next branch boots fine, bisect linux-next.
> * If the boot hang is reproducible with Martin's for-next branch,
>    bisect that branch. After every bisection step, apply the patch
>    below to work around bisectability issues in this patch series.
>    If any part of that patch fails to apply, ignore the failures.
>    We already know that the boot hang does not occur with commit
>    1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
>    request"). There are only 35 UFS patches on Martin's for-next branch
>    past that commit:
>    $ git log 1d0af94ffb5d..mkp-scsi/for-next */ufs|grep -c ^commit
>    35

First I want to clarify 1d0af94ffb5d ("scsi: ufs: core: Make the
reserved slot a reserved request")
has boot issue.
But applying for the debugging patch from your email, it boots fine.
So the bisecting start from here.

Bisecting result is:
08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()") is
the first bad commit.

And this commit can apply the debugging patch (below) without any conflict.
Hope it helps, and thank you!
-Roger

> Thanks,
>
> Bart.
>
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 1b3fbd328277..ef7d6969ef06 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -231,12 +231,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost,
> struct device *dev,
>                 goto fail;
>         }
>
> -       if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
> -               shost_printk(KERN_ERR, shost,
> -                            "nr_reserved_cmds set but no method to queue=
\n");
> -               goto fail;
> -       }
> -
>         /* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX =
*/
>         shost->cmd_per_lun =3D min_t(int, shost->cmd_per_lun,
>                                    shost->can_queue);
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index 7d6d19361af9..4259f499382f 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -374,7 +374,12 @@ static inline bool
> ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info, u8
>    */
>   static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba,
> u32 tag)
>   {
> -       struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags;
> +       /*
> +        * Host-wide tags are enabled in MCQ mode only. See also the
> +        * host->host_tagset assignment in ufs-mcq.c.
> +        */
> +       struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags ?:
> +                                          hba->host->tag_set.tags[0];
>         struct request *rq =3D blk_mq_tag_to_rq(tags, tag);
>
>         if (WARN_ON_ONCE(!rq))
>
