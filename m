Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521233EC
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305804; cv=none; b=iYKnppIacIPDcipI6sXUyv4kIdGRchcS1uQkaOgFQYRBSyHv+YVZZeXHMM1GqKf4wXGjR0vQnNZ3m85dPgnwbdWWXiYnBrxAT2u4RfbKqFh2LCNH2qXN2CYVBG5mF7iM5DGWlU1CFAlVS5E6efGQNdTIH6SbsS5omeRUXTOqwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305804; c=relaxed/simple;
	bh=lUJ3UwiQ4p5XfymxS6J6g/D0pCoBwpWiHA3+1uN1IkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CtPJEn+39WDmzofwx+GsQxOTSH7Z80W3vNEhLWcorbFzNrAISnTcrt5E7YqzRANoddYydJRbp81r9oWN52yviaQN1KbitbqdQyMpDZ5fsUjRMAFUvFV4t+eo5eJuGyNSX0SbdcVP1i3KyuDewqGA/RI4aT26oCpr7+TC540WGjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLEkxqJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLEkxqJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C09C4CEEB;
	Sat, 16 Aug 2025 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305804;
	bh=lUJ3UwiQ4p5XfymxS6J6g/D0pCoBwpWiHA3+1uN1IkA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NLEkxqJNxxK6wwrsY7dCyIRrI9fIpUwu8fHvBDXqys5QSV+JzJFQ+cNAVMsy0XFXc
	 61zAdPF3xVLGxFzzEuuMrW07Iw4ijzUFBChyNAGawhcdhZQ8Jz27RcnlY1pFyJ8q0B
	 ohzb6QknWCBcIH9bAvnZj+8uIpjV4E8fbfvYW8CTjLLcIkTzYBy6US9/yPWHkaaY3R
	 u2r7KTbR3TTO8ThKmNjismEhTE7i/OSV0Ss8wsRM32y3E2Tchg4pOaRmrJicjQaaPj
	 +eG9k45HovkJuV5sCVFW2SK4QRk3tFAIOIRG/LcUBPbfev5yJDsdfhhEjC4GD/lnCS
	 KhS2up/CcHxXw==
Message-ID: <f5c0ea37-0e2c-403e-b2e2-da3b394f3638@kernel.org>
Date: Sat, 16 Aug 2025 09:56:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] scsi: Simplify nested if conditional in
 scsi_probe_lun()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-8-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-8-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> Make code congruent with similar code in read_capacity_16()/read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index c754b1d566e0..9527b8fc5262 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -717,14 +717,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  				"scsi scan: INQUIRY %s with code 0x%x\n",
>  				result ? "failed" : "successful", result));
>  
> -		if (result == 0) {
> +		if (result == 0 && resid == try_inquiry_len) {
>  			/*
>  			 * if nothing was transferred, we try
>  			 * again. It's a workaround for some USB
>  			 * devices.
>  			 */
> -			if (resid == try_inquiry_len)
> -				continue;
> +			continue;
>  		}

Maybe make this:

		/*
		 * If nothing was transferred, we try again. It is a workaround
		 * for some buggy USB devices.
		 */
		if (result == 0 && resid == try_inquiry_len)
			continue;

With that,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
