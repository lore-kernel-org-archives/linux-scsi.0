Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490DE28C869;
	Sun, 12 Apr 2026 07:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775978756; cv=none; b=G4N4I9qqKWLgj/76h0rmoasiGkZ7LduMxSH7cARS2fPntywm/AoIHwqiuab0cpjKu+pGlvwu/H1a5AJZNGZE/HlSSH/ooTYjq+HHvO0qeJD9TrhAcdw9Bwr7v1N4N0q3oz209tklGZiekBV4u4USd3tYsDYqZngEeNihYCrqslk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775978756; c=relaxed/simple;
	bh=0WbEcNq/78bW8NvZHsxdK3QJE/W0As0Y7hwTYFhizPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AbN6iqgLpCXvMgZcxdlBwgMWJ550HzbkeJv36ADQYUB+qQgJQjQNFOHHFSbSo0aklTL2S8FY2c+swTPEAD4T+tnq61lxNDntEkGXZ/Luwr3yA8emsUIll4rLRp90ohw97ox9prXHlGt+PuyAmBWBAciOaskIElk/R7xDymhh4Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6Cj3A44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6Cj3A44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689AEC19424;
	Sun, 12 Apr 2026 07:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775978756;
	bh=0WbEcNq/78bW8NvZHsxdK3QJE/W0As0Y7hwTYFhizPc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f6Cj3A44PSduP4qRxwo/j53MfDweQIGckUH9tCmHk9KAmZxYa7hoRoq0vekgdU6I/
	 xcrEdKAa4fcREppS9vWETzKN70Sr0ljWJsvTOcJkXZlrH/H8JMy2OEPqZlfzOFndmb
	 7M25JgeyHzlE5YObCnJ17o2Rz6Uay32EiXWbKbliKAczFIDZIj1XX/SrKkjdx171d+
	 Ilrm/gjuzet1kF9+XCSzfs+HMUoVJNMwfGhB6bG6TjMd+iIic6sC60opqZ2NhaXCjm
	 98/RfAfgKf9LA1oBxLBh8QVhdf65UvkvedeQ9RyVoP3kms28Fw1FI7pljr7AHJAFEI
	 EisnMzIPQVKMQ==
Message-ID: <7b526c07-ef87-424d-acae-6875f62d6f65@kernel.org>
Date: Sun, 12 Apr 2026 09:25:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI
 device quirk
To: Phil Pemberton <philpem@philpem.me.uk>, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-2-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260409210559.155864-2-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/26 23:05, Phil Pemberton wrote:
> The Compaq-branded variant of the Panasonic/Matsushita LF-1195C PD/CD
> combo drive is a multi-LUN ATAPI device that exposes the CD-ROM on
> LUN 0 and a PD optical drive on LUN 1.
> 
> An entry already exists for the "MATSHITA PD-1" variant with OEM
> firmware.
> 
> Add the Compaq-branded variant with the same BLIST_FORCELUN |
> BLIST_SINGLELUN flags so that additional LUNs are scanned and commands
> are serialised, matching the existing entries.

Hmmm, since the following patches actually enable multi-LUN scanning, it feels
like this patch should come last in the series.

> 
> Assisted-by: Claude:claude-opus-4-6

Let's stay neutral vis-a-vis commercial software/tools and drop this please.

> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/scsi/scsi_devinfo.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 68a992494b12..06b211b93567 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -150,6 +150,7 @@ static struct {
>  	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>  	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>  	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
> +	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
>  	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>  	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},


-- 
Damien Le Moal
Western Digital Research
