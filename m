Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D63C1EEA55
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755226255; cv=none; b=h8gDZ+ZtrfQ7DVaLWlkDDfLHHLZuw4o3Ml+ecqGlLi1fq9WdkDXNPoIM7/UjGs1HXzbPrfg9Zwi3XfSnX28XgSDyETq/ge6Gl56qBctP5JGW6f23/3DOSHQKATw+ouraF4ohe7dycpkyJmyE4jlctq9xBlEJ1PiQQJjdeSj5sBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755226255; c=relaxed/simple;
	bh=tIWaVagz/8KflWLCcuH7SbBLgElgfHPadzAn8U/YeRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PnlISqugJmXQmJEjK+kLb+sWyfsBeKXd2qwmsGPeGNY41Ei42ZjLUxiG7nEPGOklTOt2j97aFJD4BoecJ+OFNqB8UnRM5tU+vylVEVWswfnYC4HXjNLfM5ZhWKtaLgrTgYWZfTq9MiAQVCSUF80pdxmcLNRdH7gwGLiO55w5JaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4NKmmNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4NKmmNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B74C4CEED;
	Fri, 15 Aug 2025 02:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755226254;
	bh=tIWaVagz/8KflWLCcuH7SbBLgElgfHPadzAn8U/YeRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M4NKmmNUYHWCuKhCVXmjp3c6ZHDKeJXmt/IGmo0SUt8IOe/7iN6UemYbkRq2hkH+o
	 LEADkbOgxZI5/zxqYOfS4bLrdOs6MQs2oGz1/81Dixz6JfuOl5H0tKgBVRBxSJEsOP
	 G076zKtJWnYcxhCaaOPE33pW3u+p8LcJgW03S1zFelzpu2O8Z8qF/XEjwmbpIXVR01
	 guzLtHTaG5XoXFkOYVij/YEgsfwbHpqGeSSzKFRSC/n6EDbG6BM97lIBaJaqc4szM9
	 SBVX9vVrogPsQeIJ3NsbmIemrlZvtp8Co1t+Rbzr9KbETjKdAgqwrZq5ml/zMbNqpE
	 oK0tzS4WlkbEw==
Message-ID: <6a86060f-a077-4681-9787-679b493b2bb1@kernel.org>
Date: Fri, 15 Aug 2025 11:50:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] scsi: Simplify nested if conditional in
 scsi_probe_lun()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-9-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814182907.1501213-9-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 03:29, Ewan D. Milne wrote:
> Make code congruent with similar code in read_capacity_16()/read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index c754b1d566e0..1346a52f55c4 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -717,14 +717,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  				"scsi scan: INQUIRY %s with code 0x%x\n",
>  				result ? "failed" : "successful", result));
>  
> -		if (result == 0) {
> +		if ((result == 0) && (resid == try_inquiry_len)) {

No need for the inner parenthesis.

>  			/*
>  			 * if nothing was transferred, we try
>  			 * again. It's a workaround for some USB
>  			 * devices.
>  			 */
> -			if (resid == try_inquiry_len)
> -				continue;
> +			continue;
>  		}
>  		break;
>  	}


-- 
Damien Le Moal
Western Digital Research
