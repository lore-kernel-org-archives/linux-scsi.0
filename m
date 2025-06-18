Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2A52EA724
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750259876; cv=none; b=E93Uouo9a9o7L0AsjddplebQnFyhiocWq6szL9zPcs7PfZEgAuH0yBWW8/F3XNnd+znP0TagSkThBqlniWe+0Kq2bJjq2SHrnRauSOTFDbQlrHgWWfRlEPm0jYY1LrEgIiXkG5SWTsBDhYBwBq5KcYF+zKwEnWorMEzbP0uPA8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750259876; c=relaxed/simple;
	bh=wCEXTVWKezWRe3+kvueBmdTlFjLcqbpodEztZ3pmC0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SEs7l1CYAW28mZ8qI26fN6S25gcPf7JZ0c0tHzgibppEoHHi4WHhyAqOMknEMAfRjTC6A65Ctew1t/vv+6cG53i+QSLoNJL+3AJJQlaeqEzVt2FyGg92UR0cVspoMe0G2UgXGbOBoW16sU5bGXwXlVXR2Mal3CMSJphaxyby7vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=ckYva8Ce; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="ckYva8Ce"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6071ac68636so1398899a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 08:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1750259871; x=1750864671; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqtCpc28xpA4VZWWsqjDW7hxuFsc37md0v7DTHRyNBY=;
        b=ckYva8Ce01oU5cO9EQ5nWRo5GxR+5/Oq7wS//pyMASo+ikIT+chHPRD5eu4dIo9Khf
         UTyZgusQnyBfDnz2bYoSOZkzOGtvJ9Ioqj5iG/srMgWtX1hxiMsj0q9kXHDeMvytbpzi
         /06e+UE8N6U+mJZ4/sp+r+H4SpyorkB57EUgnyoUwqpJcV50YW8YAT++qeR/3nLHeOqz
         8mMfCbq76IA7XbEGZjGcnBLWGxgNhYRbf//BgTS4ZHMzWQzBNlqmeHSztRtOUEtbQ5It
         9252KR8VmI7NR6mOba7Cyi+ng2YWdzZQ0/jfiOUYqSL/IwTXNjp5mto92/5nIOk3ku+7
         giyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750259871; x=1750864671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GqtCpc28xpA4VZWWsqjDW7hxuFsc37md0v7DTHRyNBY=;
        b=lKw5o3cU+PNNTIVaFm2gvDiykRbE/tEFjF05c1EsUVQ9BwQUja4MVGpxIlCPJXhWQe
         eG2ThBsp+EMLHLszcenBbV104AxfDJc3557u6k9aLi6LDRKHmFgbd78hzwvJQiFXc31K
         UFK1gxUgZxDa5i512YULBw6ml304lr4KigAxa5f92r8BQ/F9QmGaOGLG6rn+oxjKvePg
         eXerjkk75DCdPDtoHA8zzciON3S+MJ4qw7U5nYzvxoPEFANx9xd4BspUMquuS6tiHijg
         cagARgJ9DRmQZMC/GOb1VFgjVyG/Zargf5Cefm6d0QRsmTPRufnNajebUimR12ekdiCY
         QsXA==
X-Forwarded-Encrypted: i=1; AJvYcCVgnlYHhfZd36DI9HqEAtHcj2Tty5uNC/9Q5lgpRt4zE8XqoqOLTk5vDt7kxRRrKNzwl7G4amdMPfgs@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq6w7M71ag90TuQK3M799RP5Ob8pcAPiRvjoUwJAAjR0dQCCTB
	8bV6V+gXrOIgGjlfJlo9OXVOsEN/X6u3pUQXqR1KQSf4rYWrmqRg30qyC7tFsnh4ogA22t113uA
	VctiyiLep1LxLDQUbR6KhgCA0GlGwxE/26tjiBqw1FQ==
X-Gm-Gg: ASbGncu1VCGp9YWmm49/IJiCF1y/8+F9PnXdwsgRT6W9Ll6vu0OtNGx5DU+XGKujvvH
	fbL8nDH6fZ0aqEyNxIif9Io36wipQJJIzEnWKQMrZrvvCsHW4zQNvnSAPpR/aH5hJwzm7PogHIY
	xpAdzfq3onS0puNs6chqrHV/VMg35zKgzCAeb/QHkoFrz/R44TFJENK/mNCLHvgJKmCW6e9Xn1M
	73yz0NcVYi8fbc=
X-Google-Smtp-Source: AGHT+IGL55qHTnc/YF0chjzSE+oRyofOafjvA8Omq0cOKVVelFnONtLs6G4uzE4r7qfErywKZs3NDgaXyI3JhSekK1A=
X-Received: by 2002:a17:907:7f89:b0:ad8:9b93:8579 with SMTP id
 a640c23a62f3a-adfad01eb84mr574368966b.0.1750259870793; Wed, 18 Jun 2025
 08:17:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617210443.989058-1-frankramirez@google.com>
In-Reply-To: <20250617210443.989058-1-frankramirez@google.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 18 Jun 2025 17:17:40 +0200
X-Gm-Features: AX0GCFtFmbz6rbvhamkWddwvHsnhfjVvpjmxiqJOa-d9vJV2Nx-qOPfFoMBpFt0
Message-ID: <CAMGffEnbCe1y78O69GpT-gUqY5m5jNLsHbBue8EBMFc-wgcoYw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Free allocated tags after failure
To: Francisco Gutierrez <frankramirez@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 11:05=E2=80=AFPM Francisco Gutierrez
<frankramirez@google.com> wrote:
>
> This change frees resources after an error is detected.
>
> Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
lgtm.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 5b373c53c0369..c4074f062d931 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4677,8 +4677,12 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *=
pm8001_ha, u8 phy_id)
>                 &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
>         payload.sas_identify.phy_id =3D phy_id;
>
> -       return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
> +       ret =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
>                                     sizeof(payload), 0);
> +       if (ret < 0)
> +               pm8001_tag_free(pm8001_ha, tag);
> +
> +       return ret;
>  }
>
>  /**
> @@ -4704,8 +4708,12 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_=
hba_info *pm8001_ha,
>         payload.tag =3D cpu_to_le32(tag);
>         payload.phy_id =3D cpu_to_le32(phy_id);
>
> -       return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
> +       ret =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
>                                     sizeof(payload), 0);
> +       if (ret < 0)
> +               pm8001_tag_free(pm8001_ha, tag);
> +
> +       return ret;
>  }
>
>  /*
> --
> 2.50.0.rc2.696.g1fc2a0284f-goog
>
