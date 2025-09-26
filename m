Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EA3281526
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 22:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758925328; cv=none; b=PZk4qszzk6IkWyvoclyuStbhR+olwKVye0Ex2IrMwjFw7Ny7wYlg61wuumyXX8CgMkz3ks5Q23FHgUB7VreSmyaN0IVMBt6dQ5xKOqbEXkF3Hr73txEean/+r60Pgirm4rjTTJSX16jg3WVH3iIbjiCLCmXGIo6UyUmn2dCApoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758925328; c=relaxed/simple;
	bh=Zwukybwie+hOjcVkkij6YjbzMgXpmbTEunbr3XXyMEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffb1J7JWLPRxLhVyngZi1Wsyr9xtmOFEP1Jlik4ofHQkszzaLA4z6DKO2hOwJVHSFu2DsRVw9CtAp4JFLO/tMjfWsnOaVAnFJvfigVaZJG3Lc9xHwvM0RFPi/RsjtsvgWae+nPC1cs+ddrUwSC1gC0xilDs+bRXkmnONthz6jmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DnvGSsjw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DnvGSsjw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cYQ712mTyzm0ySN;
	Fri, 26 Sep 2025 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758925324; x=1761517325; bh=pO2AVqyLcrMdnOKXoWZ6ztZm
	sYNi8JOH9Yw4XvxagkA=; b=DnvGSsjwyGvp3xc+friz+9bltWhI5hujjMjLSppz
	v3jz5Gi3MAirJT9VayARDZcjzjMTiOF+l4GTQ7h/pmNjIa5Itm8z8hbINOfG7fID
	UbIkm6JiInBrHKMddt+MEPq6l2vYVsy4do1kBjeIN+Zmv5XJO25a+VF4capmUM14
	g2U+x7J6kIm8Wt9LiyPM/aLB4Gpr9XG8yUKkU285T52ozOQhzbwlqNElca8FWwVk
	tVzeJgDlhjguwwXPLOXevvX1wrrGncpoYU2xeiu3/XipiWPpdihY3z/H/bel0zps
	wCIvF7q0U1hJdSgMa4uD41emvttAMpyk628fzNTGU57vdA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4b5Bog147RmO; Fri, 26 Sep 2025 22:22:04 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cYQ6x2ZxTzm0pJt;
	Fri, 26 Sep 2025 22:22:00 +0000 (UTC)
Message-ID: <c9087789-73b9-4322-9d8f-7416907c5679@acm.org>
Date: Fri, 26 Sep 2025 15:21:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/28] scsi: core: Support allocating a pseudo SCSI
 device
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-5-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/25 1:30 PM, Bart Van Assche wrote:
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 9bb7f0114763..986586bf67dc 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -307,6 +307,14 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (error)
>   		goto out_del_dev;
>   
> +	if (sht->nr_reserved_cmds) {
> +		shost->pseudo_sdev = scsi_get_pseudo_dev(shost);
> +		if (!shost->pseudo_sdev) {
> +			error = -ENOMEM;
> +			goto out_del_dev;
> +		}
> +	}

(replying to my own email)

Unless anyone objects I will change sht->nr_reserved_cmds into
shost->nr_reserved_cmds in the above code.

Bart.
