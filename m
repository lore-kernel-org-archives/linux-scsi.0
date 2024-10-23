Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D698513B7BE;
	Wed, 23 Oct 2024 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729722367; cv=none; b=lSrylirz4HZe5cMtYKiQKCij7QotDFTZWgIxwjadAchaH/lIJ3RQ+DGLzYQNph1vOc9sk4uGEba1rjEfb/N2ezvf2LqB70i7nDjk3Tq4lwrlenfw557HfSbTZEYAD0JYih2cnuS7oEJbwC+APJsagQ83E0pZKKMvx3LsrGt5BME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729722367; c=relaxed/simple;
	bh=NUZDyRpafdrTHYY+TdNYMLOsYCnLmCKOhSnQEvicWhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZV9OcScZJHKPnrmK7fjrVYXkyWyX/4IqkyUGbbbpXlyr8WW9HJncmSx9srAP4kvGhMgnGOzMEF0kvyt+sJwosXyKUJQMjnH1T5sSAiI6EOVLBrAZnpxkKKlVFkZR/w2PbeAc+hl13HAanbllBVhJLe3691FP+LJkQ3rjpuhs54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LzIQA+jN; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LzIQA+jN"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XYkCb21hcz6ClY96;
	Wed, 23 Oct 2024 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729722360; x=1732314361; bh=uXOJL0mtJVKcEgFBIwqq6c43
	DJi21LRRMqX8IOftEUA=; b=LzIQA+jNotU5+4Kyo9J9F1AGImEMb68JRI+LRVgf
	lF3elQkGg+vPk5tbfabb74ZxY/OjEXmA+jSoCKpy1pPLNhUuIQLBUQdaCVzc+QMa
	MMcr/2VtYnUJzdlbNK5amu8rTjHtm0R+rb+ZA+j3t1+iR4mNJA+0BKq02VvLXyi7
	hsuN61H440oBITWOcoh+ualbC/cYYzNrIbDQoCpC9Ut48M9Qf5IG2NAYMaNGZ6+E
	/0qXsznrU1z73RGMK1FMgvtzbHMc6K+2xlb9rlTforYsE0jMzKNSVYHNGd6nsMoJ
	BoWiMMHgJNLW9rWRwq57zWN5x0qJMl9L+nZOAU7tGeDtwg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tHlLI3-A0q3M; Wed, 23 Oct 2024 22:26:00 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XYkCW6ftFz6ClY94;
	Wed, 23 Oct 2024 22:25:59 +0000 (UTC)
Message-ID: <9ca3fb4b-85d9-493c-8b90-5210f5530e7f@acm.org>
Date: Wed, 23 Oct 2024 15:25:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the
 end of structures
To: Mirsad Todorovac <mtodorovac69@gmail.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20241023221700.220063-2-mtodorovac69@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241023221700.220063-2-mtodorovac69@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 3:17 PM, Mirsad Todorovac wrote:
> Fixes: 21038b0900d1b ("scsi: qla2xxx: Fix endianness annotations in header files")

The "Fixes:" tag is wrong. The one-element arrays were introduced long
before I fixed the endianness annotations.

> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index 54f0a412226f..ca9304df484b 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -31,7 +31,7 @@ struct qla2300_fw_dump {
>   	__be16 fpm_b1_reg[64];
>   	__be16 risc_ram[0xf800];
>   	__be16 stack_ram[0x1000];
> -	__be16 data_ram[1];
> +	__be16 data_ram[];
>   };
>   

How has this patch been tested? Has it even been compile-tested? This
patch probably breaks at least the following statement:

	BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);

Thanks,

Bart.
