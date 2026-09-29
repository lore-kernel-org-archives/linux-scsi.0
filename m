Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B848F346771;
	Tue, 29 Sep 2026 13:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688142; cv=none; b=IntreIWtSrERRd4HsN32SvCLjm6DcgDPR/49T4sKYBqcbglmtsipXz1jcy/u5O8mqPlV43D7oJAMENFXfDDZHzO2iIiVbUEOGXDaxB4kr3lbsGBNzhuNi66IBOzOq8XSRmVZYzOP1Re61FOZ3VrbzHzBao78WBH/cXgRJA9jR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688142; c=relaxed/simple;
	bh=B28/ND2+77BBCEJCFz/Z+urqTKNctk+dhoBEPvE0erE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPelx1Fq2PULgmdzkHSErAtj2rAQqjQeGoGNI960JrPjoFYymhkjpK4fEU4WvISIToPqBIzVgGENoCxgZD0x1JVHBkvNZi4yfYOl6sb1MaToaLQAXP4GbdoucS9OpyBVhuBuF7+d/VdFXDeXLPED4S9YGbLm1TrUX1Z8YUcIXx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4zi8KWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4zi8KWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A5A1F000FF;
	Tue, 29 Sep 2026 13:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790688141;
	bh=fV7Jx4QtHgF4XC3FydqjndiVgq0ti6TZtjZzCV5JJTc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k4zi8KWyHeZg4OWtzO3J3KWmz3zjDZzxvO4CdRQaRtOAMBqAgv6H2C/bijgkrp27K
	 x7xkpVzO+8gohY69zKRco7c8esxDW41D+rUO9cXuamAZT3/Anc0zFhAQKqqFVmwTZR
	 /L8NlCMXBO2dxgzfzcCUUnr2xV8Zp7jd8WwkwSqMeArVRR+VLOhQJDRF1oy7kDm5YK
	 Xc7p5OO1/Aag9EThlpHfKEPHls7SOCAR2AyLlECEGO2GnmzsIuonyPQQfTJSqASyDZ
	 N6hz0JbZYtW0Ma1u5irf5IJAzcss8hFV4MG/eAHgFnNZ0CgIf7KUsAoyEI2OrWqul8
	 QDmZQDzC2fupw==
Message-ID: <898ed3e7-1636-4f17-bb5d-fcb9f6de1d24@kernel.org>
Date: Tue, 29 Sep 2026 15:22:17 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry
To: Stanley Jhu <stanleyjhu@google.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
 Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260929031352.1355691-1-stanleyjhu@google.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260929031352.1355691-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/29 5:13, Stanley Jhu wrote:
> A merge conflict resolution dropped SCMD_FAILURE_ASCQ_ANY from the
> retry added by commit a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on
> UNIT ATTENTION on the RPMB WLUN"), so only 29h/00h is retried, not
> the other 29h ASCQs.
> 
> Link: https://lore.kernel.org/linux-scsi/yq1jyo4onqe.fsf@mail.kernel.org/
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> Tested in QEMU on top of "scsi: ufs: rpmb: Drop the unregistered
> ufs_rpmb bus" (RPMB v5 3/3).
> 
>  drivers/ufs/core/ufs-rpmb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 50ef63afd528..7b9b59c9e968 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -47,7 +47,8 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
>  		{
>  			.sense_key = UNIT_ATTENTION,
>  			.sense_code =
> -				POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
> +				POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED |
> +				SCMD_FAILURE_ASCQ_ANY,

While that leads to the correct value, I think it is better to use:

	.sense_code =
		scsi_sense_code(ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
				SCMD_FAILURE_ASCQ_ANY),

>  			.allowed = UFS_RPMB_UA_RETRIES,
>  			.result = SAM_STAT_CHECK_CONDITION,
>  		},
> 
> base-commit: f09d2c7485b32adb82336d0d748935c8237a649e


-- 
Damien Le Moal
Western Digital Research
