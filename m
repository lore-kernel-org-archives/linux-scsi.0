Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379BF156960
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 06:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455532; cv=none; b=j2RXnm+P6IB/44UqsX+jyhN0UZ1hgrTcA3MtOZZuT4voF2CrSZLm/piPrisZTa4pUqFrAGokkoW8ZtUCFyJmn6FAu4/55Rt1BymRlrkXCIKzWdh2BeAIbriGVuYT3xec6IiMz8BfNVHy+eRv/FTcEbhvTo6phA4KYxsY2fHfvfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455532; c=relaxed/simple;
	bh=R0gUvxwSv1A4XoB1T5evhfuqxPVo1TkeJSTpTi9sPuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kz1SP75h3K/85bpxWbik0eKsxyqppE+/e9LAyO6XA2IRDQeBO+h4nRGBQVfUHrR/Tz4TMoNzuBtqGMS0zTvIFdr4tAEtTWEtOI0+siXBv7h16T8e8PBM4Kbwdoec2AnOmu+b3cgkd/l7HzeMXnrsE1SfPy5ExIFA80CXU86w1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OctRa8PT; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OctRa8PT"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c5b9d2195eso9029823a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2024 23:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728455528; x=1729060328; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xrlBK00E06m+Xyn4M4YQ83K424bss7id65740TmKjwY=;
        b=OctRa8PTv+N5PrEGsbmRkCoqe/HGQMGRuAWDLrLN/PDHX1dQhgKwSZedLFutRo6Uu0
         STUiqEcy+UVTtKIK0AGn42OUp4ewtPrWnZt8Z78BSSUZvWeRaWwEGf53Mr8AslnwFgp0
         kJyU8j9kafVX/uzdMXhkgES25ZCMFM6yXPa1+qlXkfiXFctNQ1IKNT63qyiuZFORI8rp
         xDNZsAgTXSrRK5UkECmp/38y7QxuBaaAciFtDxtYjyKVnT7Vw+Qgev+Pu2uYTnC8yXwQ
         JxXf6PIEd6siJ9hvzDv+Nnm5SdVJMDkMOO8NpqZLQS0idhCgZUzZsQdCMdg+yZP9/GfV
         /r2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728455528; x=1729060328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xrlBK00E06m+Xyn4M4YQ83K424bss7id65740TmKjwY=;
        b=ipzK/sxR69Qd3nPxU5UzaahtmYkJraGQqJlJw+smItBmpiDmp5lGA/SK4pdwiChQzM
         EaC6xQ4/wWZKycsxC40MHVU976mJsUFVIRHTrdylEAhT0vRukQx3xs8xxllYGDPuZ52k
         yKMbsbIfSDK0sk1m1V/ihZFVdbni2+7FGRymiGzB5e6plzWTvXLqTQcIP9/13Tt3a0RV
         okOui00g225PmAFXMVtdral+OV4sqw2/ijK1H1DLjibcTsovzPFRYrvpTPnFZHjY5WqL
         57ugfRBla+EaZhvpPNFK99D8EImYjJI/3UpfFobQnaL4ZX9VOPFzK4N5i2kk5NLFh8fP
         22hg==
X-Forwarded-Encrypted: i=1; AJvYcCW0azo+1TlZb+w3mAbwNR06G+vpKjjwJdE5bCuNb77F/sdU1B4vfKBZ4PyTiYjRStMy4Dee7YgmnNSr@vger.kernel.org
X-Gm-Message-State: AOJu0YyHuGMZYTJX1wcGBjz6fTvarVIn/DEOTpX2U2S/WTHKQr/2A0Mp
	de1DMAgtMoirjZclTcaIasldjbLpq7zavX9opXex2/g2lRw6nSV4tAnTVR0aGK8=
X-Google-Smtp-Source: AGHT+IF1ch/zlHLFvZnA537gd6NerYD1w+UTbuG6UhIr+ue/n1LS9w7GlBYhfU0kWo9/NodgFhvh3g==
X-Received: by 2002:a17:907:e20c:b0:a99:49b0:e5b2 with SMTP id a640c23a62f3a-a998d117e39mr117766366b.3.1728455528147;
        Tue, 08 Oct 2024 23:32:08 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8? ([2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9936bc91f4sm578785466b.56.2024.10.08.23.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:32:07 -0700 (PDT)
Message-ID: <3b57fcc4-919f-4e50-80a4-04da24f61857@suse.com>
Date: Wed, 9 Oct 2024 08:32:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: qla2xxx: make target send correct LOGO
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, quinn.tran@cavium.com, nab@linux-iscsi.org,
 himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux@yadro.com
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
 <20241008132402.26164-3-a.kovaleva@yadro.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20241008132402.26164-3-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/8/24 15:24, Anastasia Kovaleva wrote:
> Upon removing the ACL from the target, it sends a LOGO command to the
> initiator to break the connection. But HBA fills port_name and port_id
> of the LOGO command with all zeroes, which is not valid. The initiator
> sends a reject for this command, but it is not being processed on the
> target, since it assumes LOGO can never fail. This leaves a system in a
> state where the initiator thinks it is still logged in to the target and
> can send commands to it, but the target ignores all incoming commands
> from this initiator.
> 
> If, in such a situation, the initiator sends some command (e.g. during a
> scan), after not receiving a response for a timeout duration, it sends
> ABORT for the command. After a timeout on receiving an ABORT response,
> the initiator sends LOGO to the target. Only after that, the initiator
> can successfully relogin to the target and restore the connection. In
> the end, this whole situation hangs the system for approximately a
> minute.
> 
> By default, the driver sends a LOGO command to HBA filling only port_id,
> expecting HBA to match port_id with the correct port_name from it's
> internal table. HBA doesn't do that, instead filling these fields with
> all zeroes.
> 
> This patch makes the driver send a LOGO command to HBA with port_name
> and port_id in the I/O PARMETER fields. HBA then copies these values to
> corresponding fields in the LOGO command frame.
> 
> Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/scsi/qla2xxx/qla_iocb.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 0b41e8a06602..90026fca14dc 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2486,6 +2486,17 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
>   	logio->port_id[1] = sp->fcport->d_id.b.area;
>   	logio->port_id[2] = sp->fcport->d_id.b.domain;
>   	logio->vp_index = sp->vha->vp_idx;
> +	logio->io_parameter[0] = cpu_to_le32(sp->vha->d_id.b.al_pa |
> +				 sp->vha->d_id.b.area << 8 |
> +				 sp->vha->d_id.b.domain << 16);
> +	logio->io_parameter[1] = cpu_to_le32(sp->vha->port_name[3] |
> +				 sp->vha->port_name[2] << 8 |
> +				 sp->vha->port_name[1] << 16 |
> +				 sp->vha->port_name[0] << 24);
> +	logio->io_parameter[2] = cpu_to_le32(sp->vha->port_name[7] |
> +				 sp->vha->port_name[6] << 8 |
> +				 sp->vha->port_name[5] << 16 |
> +				 sp->vha->port_name[4] << 24);
>   }
>   
>   static void

Now that looks like serious debugging. Well done.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

