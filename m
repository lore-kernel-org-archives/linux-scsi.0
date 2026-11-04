Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793774954;
	b=bPYSp46DXFizxbHiv6RhAn7XIgGrPQRtLsbvKaXNHn/P0qO7jVdat5ViJwRdsribFWPI
	 b0NqFlCFBdb+GcPoQCi/y9Q4ZpF8zM4e2ksfVTUhD1T6DClHUpRA8drIzcyOF8dQW/tkx
	 ynMVDYeTW8asMYf3/bR7d6MIGtdZMFJ/Dw/mcroIpBvGQCVapl/nK/iXLEqtuFm5erBLC
	 vChq1Y9lkQ4vPBZ5v3/LFx2VtOof+oNyiTf6SzK6n0A69K8uxJDap7tc0wIXX4YmlG4hV
	 LfigQbwWgQ7+anelZWwer1mo80ngKYB7lY0qv00g58T0unNpEKYG3b0ZBhIITglElzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793774954;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=EpQhE75YVAvBdui3HModYSzYsbjHI0aCHbluMxfA5v0=;
	b=cCc4O16bwzIy0xBhw2o/GgQzNJyrhMW6RywNXx2odRdbT1/Yc5oiDLsLeWbnq8BoAz+5
	 l86yL+K3hqME70QmWvUu5sU4bbGfjCt/7urF4bIVmVBUCXszjqtH+UsK/qAOF0RLCLesy
	 PS1eGN9pCcs1/scfDZenHuyX1fjw+rWB5zjzhA/aEkx3loxBq/dlTSV2dEf8FqvqjszGw
	 zKbX6t+IOTDsw/xh4rnTIilIyGqHjstozwnmzJceeIyi1TbJdrpxsLlMs/D4ljeJBkMko
	 MXfBc3FiZ+ORbk4mJSlOeQZ2upst2Ta+n4PztF/8hMyIWKafqtFO6dOr7sItQ68cvXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cux0FP78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F43606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 06:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cux0FP78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BA11F000C1;
	Wed,  4 Nov 2026 06:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793774953;
	bh=EpQhE75YVAvBdui3HModYSzYsbjHI0aCHbluMxfA5v0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cux0FP78i0us0LOgJg3o4y/+6nV3voVrSLISBMAn95fQp4js6nYh195V+O85HlRMW
	 iwRUU/1s1y6D5GZrNTQBLKt/vEdEq0ReSiyWfuE+7l6hIX2NEb5vyiAu4srgs3GowV
	 QA/9RwbaV5liismuAnkFQmdHVVkY4n6WJm1CxP+B0y0acrd6KgbWeCwDMpkqdU22wS
	 SI4ZJLv9DcRnIPkZnyNfxEH6lXoIeP3XoScm6gP/7A6AvoRv6dbwapmpsLjRrU2yYL
	 HUyMb1+mBSx7Lytd0iqGkOcWpsiG0cH2oXSK6udArG2T0tM0uUmWzY5frpmBN7S+Fs
	 AfVPwET7VvjjA==
Message-ID: <a161c75d-c8a2-4e44-8e33-30298622fc0c@kernel.org>
Date: Wed, 4 Nov 2026 15:49:11 +0900
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: leapraid: Fix init_cmd_priv error handling
To: Dongdong Hao <doubled@leap-io-kernel.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: hare@kernel.org, hare@suse.de, yjzhang@leap-io-kernel.com,
 kezijie@leap-io-kernel.com, jzzhang@leap-io-kernel.com,
 baikefan@leap-io-kernel.com, linux-scsi@vger.kernel.org
References: <20261104031823.198733-1-doubled@leap-io-kernel.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261104031823.198733-1-doubled@leap-io-kernel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/26 12:18, Dongdong Hao wrote:
> leapraid_init_cmd_priv() ignores the return value of
> leapraid_internal_init_cmd_priv() and always returns success. If
> dma_pool_alloc() fails, io_tracker->chain remains NULL, but the SCSI
> midlayer considers the command successfully initialized.
> 
> A subsequent I/O requiring more than LEAPRAID_SGL_INLINE_THRESHOLD
> DMA-mapped scatter-gather entries dereferences the NULL chain buffer
> while building the chained SGL, causing a kernel crash.
> 
> Return the result of leapraid_internal_init_cmd_priv() so that allocation
> failures propagate to the SCSI midlayer and abort initialization of the
> affected request.
> 
> Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
> ---
>  drivers/scsi/leapraid/leapraid_os.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
> index da597eb99377..0f3219c4f438 100644
> --- a/drivers/scsi/leapraid/leapraid_os.c
> +++ b/drivers/scsi/leapraid/leapraid_os.c
> @@ -938,9 +938,8 @@ static int leapraid_init_cmd_priv(struct Scsi_Host *shost,
>  	struct leapraid_io_req_tracker *io_tracker;
>  
>  	io_tracker = scsi_cmd_priv(scmd);
> -	leapraid_internal_init_cmd_priv(adapter, io_tracker);
>  
> -	return 0;
> +	return leapraid_internal_init_cmd_priv(adapter, io_tracker);

	return leapraid_internal_init_cmd_priv(adapter, scsi_cmd_priv(scmd));

and you can remove the io_tracker local variable.

With that,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Note: when I sent out the SCSI ASC/ASCQ series rework, Sashiko had comments
about pre-existing issues in the leapraid driver. See:

https://sashiko.dev/#/message/20260831021810.235281F000E9%40smtp.kernel.org

You may want to check that.


-- 
Damien Le Moal
Western Digital Research
