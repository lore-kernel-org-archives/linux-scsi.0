Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222934399E6
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787916628; cv=pass; b=nyVXdfOQde9X37QPBXF4mJ/r+OUq3AXfsmAiuJiIo4V/AJp7Mzcf5/QjPTEzwpaeHKKF6i7ysnfoQn6QTHyfXulUVFUgnomDWWskC4Y+EsmVOq20fqtVnJRoQ0bRiUh+QDYqXiT9OXMbg86wgRHd9qUjND2D+DQbMy2sfErG8Ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787916628; c=relaxed/simple;
	bh=E9IzD8tLZ4atOCJiLq5vH4xKm19d5mbqDq35ouwu4+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9xB1S6/qs2+y5KwmvTdrBdx1o6rc8BvvHjAdGIZYRdnb40YEtuadShDiVa2y+qe4vfGsIyQo/eIDNRMKdwHVQZJBo0VCR/Zbl1WCQaeeHaQ29sWhy4Ga9g8MvHRp13AcnbG3IDLmtS4L+YdrFmu+luxfKh1A2iupI7M1au023o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=ib2v5/GZ; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ib2v5/GZ"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1f1f5631f8so9631966b.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 04:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787916624; cv=none;
        d=google.com; s=arc-20260327;
        b=XPgHxR9Czg7h0SF1CyJFYSdRd97JSrN6YjIH/IYjXUO1LBetsss1DLzZGWBf3pyxmI
         8z4A2v26tPuv0dQLBafowmWa6zwIdz+BjFHuk3otiyIAxALfPG6QxfGApX6qzVG34iBh
         kcFuoX0B6f5VjtUwU7Eget0vjBs6lRrxDCbi0dGI6TT5qtV2qEePCQWrXZDIjsZmoW/1
         vkM3dIQblubhwhP68l0X7y1asNRMoF9VDcFfKUmIwl1AbC5njZnE7N/hAmM7yaM6moqs
         SWo71UYN2zl0f9E9YsqIt+EIHcMbJZje35tXORwHMRykKMA8UuMXWbLsCHFRRDFwYa8T
         4IvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UKuFtJJZMcXxiN1w0UPs9tMckP3rl1Ohl3fu+26vt3I=;
        fh=bKPlO4gQFPbMLkeGQ2PbobsodyoU9hcboVmr3BbqsW8=;
        b=iNQHnwMzelWHzMWFLmzGNBg7vezEjHBGIBImv2CB2t43q0fdNQd9gfxv2nJ8PFCXbA
         RwVvTCcEXOpY9hhwdu16aZtvNp26vX2eQBFanP8Dz10HZ731ze5FWPzIW90E/PwTf9oJ
         L5RQXXebduLFu6X+yqNmkx3Cf80wNB97wcT6FM1a2B8y3uEaY9jqzmlpMXsXSYBze9MT
         hcEUj3WvS7trpP2NwPuW1OzwgExcCwlzOQA/aXNKby56BtwCbn1MnoWRe3T0iIZi1HzG
         iJpFLyr7mns29Sgc6Dnq0oKdTHV92dJJVNB6ZGvrPQ4mkyKW3uGfGGGpLPW8hKVcULh9
         auhg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1787916624; x=1788521424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UKuFtJJZMcXxiN1w0UPs9tMckP3rl1Ohl3fu+26vt3I=;
        b=ib2v5/GZ1Nc8t4VSX612fiUJ9J7pMQnTsQbSZBUiEKsFkltv2vQ3Mq1Mwgv69RB8v/
         vExjnTI1VuWgqqm4BSYCnwghluDAGxwRfcHAtrnvBGeOlpR7Hrs3j69ow9EsM/fmtClu
         1wZ6COw7PfuKTZEQIguRnfG48iA3qYXsbZB88ZEekaoqJcY+mNSjQmMSBeb1g7luQICk
         7o1/EAepOckYegGruuoI1lM47MuoOutDhVtOnFBhK32DbturOW+R7MHi31MHANAUHtkZ
         PYotkYMwk85d5Rgnv+gh4yLYaMpM3fDKtTIWJL8/9Pf2PsEQOb0/x0l5lqJUBhtdHcvQ
         V+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787916624; x=1788521424;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UKuFtJJZMcXxiN1w0UPs9tMckP3rl1Ohl3fu+26vt3I=;
        b=mjTrsCzKr84iV0dHvCbVd5oCbzx4FrbMCGWFXGkH8M68r8PI880QrxB+4jBVPbsIet
         f4LVxMvJ/PFD3ogg2c9TqR+T5NyCKWu02417IP6zd5oAII8N5FqaGLFYMwhKd9AQKQjw
         ZKQO5vq4xS8DJjW9JewDxrxTI/Zm+4fP9i7K9H643sDOdMoLdrOLRv9DdhSf1LNUa5Yb
         FB8zgCRcCUr1MeZE2OoqhCPzsijSXv9/MpNTrLfSOL9E6DqU+ooZ4fU29dU2TxXI25Ie
         TNKNiEh1FXdyvFSBTEnYZpq3OjiVDRKzQ2pk5/cvBYeEQS6xDcxvL3dmZzfYG1pugnwj
         aO1A==
X-Forwarded-Encrypted: i=1; AHgh+RqnHgBVWS1qZ4mkGEvKQ27TTpsxYMlqI0lje+ywKyRmeVVgs5KlxqeepeGdg9hZpyW6lUKO/WOxyBDY@vger.kernel.org
X-Gm-Message-State: AFuF++mReKk9taRfkH4yEYO9HSqIQZ6wqeikChTRrvWKddeUyKAnSj1A
	nim9DLFFyfbfdLfX0OCy/OkWHy/CHf8RWbZoPulCESmldVYiJ4YLsAv3EavkkHsX7G/bZXtWC0G
	uPkC5ZBNZwlaInXt5MN2OunE6luNqSM6fTafVtj4tQg==
X-Gm-Gg: AR+sD13J5wLqFNOzcLmwBPMXq/RTtlisVHSfOqx43gGBDxAf181eE8FU1aHAx04v8A6
	LmQ81b1Lp79sJkYQIDnWABmhWr30ploLDVWf57wqgwZfJugoYdweGfvuUIUwB5njP2yLT6kE7W2
	BpglWSajtWumNsnNqxTaI0Ag80bSR6qU4WPpf7oVMRUzTFw3Vg+gBeYuRGAfvbe/Mg7LYZgWb1b
	DYMQLJ+Y4OCw1In4dAf1U6V0Prlzy/QoZj+RpDEVyeRXgeG+2ywQD8pJI5eJDZLu9mqLcXguVTz
	oVng/SU63KE2+o3KIPYb7b1c14MXI+WTUQ2vnMpe7Hd4+D8DrAPAarAno+3TufCT4iFmhXRVC7G
	8jA==
X-Received: by 2002:a17:906:ef05:b0:c12:732a:fe52 with SMTP id
 a640c23a62f3a-c2557464543mr209561966b.4.1787916624371; Fri, 28 Aug 2026
 04:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
In-Reply-To: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Fri, 28 Aug 2026 13:30:13 +0200
X-Gm-Features: AcwNN1Xb1tEMQdHfmnOobPQMaAG_j21-E4c60KKb3LfDE3LUDihv3S84LK9hgZM
Message-ID: <CAMGffEkZNCjOskmQ+0gXs3Ezw-q3jAxiBeaJUN2t4nhrnUHw4w@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: use rollback index when freeing MSI-X vectors
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 1:36=E2=80=AFPM Runyu Xiao <runyu.xiao@seu.edu.cn> =
wrote:
>
> pm8001_request_msix() unwinds previously registered handlers with
> free_irq() when request_irq() fails. The rollback loop uses the
> failing index i for every iteration instead of the already
> registered vector index j.
>
> That passes the wrong IRQ/dev_id pair to free_irq() and leaves the
> earlier handlers installed. Use j for both pci_irq_vector() and the
> matching irq_vector entry in the rollback loop.
>
> Fixes: a76037ff3479 ("scsi: pm8001: switch to pci_irq_alloc_vectors")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:GPT-5
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index e93ea76b565e..21419e46c16d 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1029,8 +1029,8 @@ static u32 pm8001_request_msix(struct pm8001_hba_in=
fo *pm8001_ha)
>                         &(pm8001_ha->irq_vector[i]));
>                 if (rc) {
>                         for (j =3D 0; j < i; j++) {
> -                               free_irq(pci_irq_vector(pm8001_ha->pdev, =
i),
> -                                       &(pm8001_ha->irq_vector[i]));
> +                               free_irq(pci_irq_vector(pm8001_ha->pdev, =
j),
> +                                        &pm8001_ha->irq_vector[j]);
>                         }
>                         pci_free_irq_vectors(pm8001_ha->pdev);
>                         break;
> --
> 2.34.1
