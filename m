Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43A13957E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716754; cv=none; b=gj/b45GY7uJIu0tqyToAj6ZMnsE/gIdGRPZ5K4hXQUc1O6oII3HtazPy4269WBEkmMejQEL0bZOcR52OUl580Rfe6LyVntg2ZF3Lad7YaDY0pSMQ2tsc5WcDq8WKwaAXCruKYdWNy/OqegnORZUYXVmQ/D2tuO0PVjJOX8QgbjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716754; c=relaxed/simple;
	bh=Vh2qaKGBVoAC06si2ANXIPbbBpN5Uf2SY/kAfMaFS0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=diILhJhBUxXmBWFjzJ44LYM/xLuVPPt6B3N1ZX2w7gqZJzu3kZpCLxf46O6oOKdX6/lyB5MCEu6xpg/sTo+ydNpTlKG8xEWTTX3DRwvsgWF7LbgUPtdzLdja6uqkhSKYKDWU5MKY67vZYIPQaUfcGUOwXzbK8OFxRCEhBLJZ0IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUOUm9T9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUOUm9T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAFEC4CEF4;
	Mon,  6 Oct 2025 02:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716753;
	bh=Vh2qaKGBVoAC06si2ANXIPbbBpN5Uf2SY/kAfMaFS0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qUOUm9T9CLjHbmA6jt7XnZeAIQPil2nQr6ns9MZwAVHM78vW9tQiokPvz7TBe/7sS
	 GB9OYjpMmhSGOQ+pxvVmvMlmLOdtHPPx4UdLHAuGEngbO/3I4+eLjUU5Lvjkrl1SR/
	 8s3IqnsBIVlFEpGXN+YxrbK/P69p5lBy+cODpHgC+vedDNxCreemnvpfaA3rQ/EK9o
	 D0d8HVe6+lKcSFmhKqlDj1YsantPDus+CLfmBXyU9xM31YFhX5wzmNV76JjFgyFH9x
	 SeD6mDn5Qiqtikf3d5CzA0Gxh8avbgGcq68BQz3XzykeD1LCUPYUzo6wjza7Vlg8Mx
	 xVmSbwGvkS5Ig==
Message-ID: <8f043755-89d3-480a-95a6-22ee7c68ea50@kernel.org>
Date: Mon, 6 Oct 2025 11:12:31 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] scsi: scsi_debug: Add "only_once" module option to
 inject an error one time
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-10-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-10-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> The "every_nth" module option allows either periodic injection of errors
> every N commands, or injection of errors on all commands after N commands.
> It does not allow injection of a single error after N commands, which is
> useful for testing things like code in the device probe path.
> 
> Add a new "only_once" module option that allows injection of a single error.
> The "every_nth" module options are still used to control when the error
> is injected, to simplify the code.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks OK to me. One nit below.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


> +static ssize_t only_once_store(struct device_driver *ddp, const char *buf,
> +			       size_t count)
> +{
> +	int n;
> +
> +	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {

Please drop the inner parentheses.

-- 
Damien Le Moal
Western Digital Research
