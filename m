Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0D33BBA05
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866173; cv=none; b=Ur8X2hP0xcBgXvafhfsOrlQM2Vj8W9K+SKSAetufduc4HFjEzssMXuotj3xjF+J46PXzOreiIHgUoCfvXcKkB+CPc0rW6gNBrmf78eJqFBj3TlWfHSymr14gizzHVvNU65Gp8E8RmEheNUCTF/C0XJmK8WlCLPVNhubnx/YZCCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866173; c=relaxed/simple;
	bh=/qF3159P4k+KCwscKFXe4RsahgDg7G+kEkjN1IG5PEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HayhV07yu8P4N4R0DHzwD4LZoaDm9wz0JLNblSwo9Zli+x3UST2jW//2Tc4nx9fXBqTu42g17oFyztY8J+K6nOxT9RllfcKkoGQgHRvt5O5Ym+G/skP7ubSD+KW49a8plLOux+fsapiwOP+zWwhjiXEUlcstqZMahVf5nfb2Vhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HO4dclFd; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HO4dclFd"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hF1SC30SFz1XM30j;
	Tue,  4 Aug 2026 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785866167; x=1788458168; bh=dQ5MR7LS4Wg5dz6OgKdSkodj
	06VJQyrxXJqqOsCbIJk=; b=HO4dclFd8yp7OIkH0gM3ZCFMNR+dlxUjQpIXcCKg
	uMWIVwYGdrTFgeYGvQpzJrSLsdXJz7QM1RCCHbNSPBeM6Ecn8VxPJvCGQy9XJbq0
	hwCYyCCkwuRBsVtjkaCGQsPJ5alAvSWzmTbzYzLYcY83Q3yvZAYFPsQxp0ExRVfb
	pFEvWcyoxmL7u+LqkpE7GUU7cU2xz7zHEYUvQg0A/jlPhCkWPKs+gjYKmpw6jPHw
	SDcp3XP2rWrFb3zNQ5FEETAqYeX4fUzq6j/4k6EMoa6BduerccIZGzyjZMhuaY9X
	eqpyndycKaMUqICfm3+i6d480pB645MkMe95FZoktwEn2w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 31_AFMrvKAqH; Tue,  4 Aug 2026 17:56:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hF1S60Vx3z1XM4Tl;
	Tue,  4 Aug 2026 17:56:05 +0000 (UTC)
Message-ID: <0695887d-a8f9-4e61-9eb1-c2428d68ed72@acm.org>
Date: Tue, 4 Aug 2026 10:56:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: alua: Use access state macros
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 hare@suse.com
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260804111615.2368927-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260804111615.2368927-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 4:16 AM, John Garry wrote:
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 80ab0ff921d43..4258c48d93339 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -693,8 +693,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
>   					struct alua_dh_data *h;
>   
> -					tmp_pg->state = desc[0] & 0x0f;
> -					tmp_pg->pref = desc[0] >> 7;
> +					tmp_pg->state = desc[0] & SCSI_ACCESS_STATE_MASK;
> +					tmp_pg->pref = desc[0] >> __fls(SCSI_ACCESS_STATE_PREFERRED);
>   					rcu_read_lock();
>   					list_for_each_entry_rcu(h,
>   						&tmp_pg->dh_list, node) {

Please use FIELD_GET() instead of open-coding this macro.

Thanks,

Bart.
