Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673AA13CF86;
	Fri, 29 Mar 2024 20:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745456; cv=none; b=UtxOgH5b/Xr2OcbAlWDA645dJdgJnqjwCmkq4+XXQ97poU5MXqP0fgizO6GrGQwYlmS9Q74DaWjRqmnRUmP4ew/nkm1YfAdbwYB2N//1IvN7My2Hjgk2NIlJdFIPBwFkXl87QJCehxj1f2ko7bX8p45lO6gWLojH8XtAPyR/MUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745456; c=relaxed/simple;
	bh=jMLgFwpxBdFq0TFc0DHNHDX6cPOMxB7QBIM6UOuMfPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fLUCrVHjvsSr7+60hsCGaNRZd/U40yyR2LX/PBnuZXYf+G5RIYkYwtqj+Kqi4NGOKC4hqg1FFV8m2CZePGA3qX65R49LgNDpvdZU1pteK2YqZytb2W28b84hBdvwJeygg06mtxc7AwLG572UeP5kCTxPWa1Vike0+HpcrwjlRDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UqnpTApg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UqnpTApg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5sxm5xVhzlgTGW;
	Fri, 29 Mar 2024 20:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711745450; x=1714337451; bh=jMLgFwpxBdFq0TFc0DHNHDX6
	cPOMxB7QBIM6UOuMfPI=; b=UqnpTApglH539cBh1pI5bWpp6+banvNYVn7WUBhK
	rZZTP45cT2KgZSi4cX8iWLD9+nlzvqYgnyaZc9YqdX5sDNUZd7g6t4pclARv+gMw
	P2sv1icCXZUEDbTqkDlZrC9L2EicIb+/zTwLN/g9Mj91O1MaaocEgc6QFXWX4Z6a
	kkKFJb3A5eES5ET6vBQ8x8ASXjhweerDce18kjj8hzaQOaZZNrQheVPUtektnuUk
	+BeM7DPHMCq8UMXzR/t4ib51znpdCFx+EhtwkebI51kSOiDeZ2CoVd1i0/N9OO9m
	7PD2k5dsCpOwWT+A5bH/TugqQoT0x8twaXUeQEj1c7ibyQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id eb5u15kDXwiH; Fri, 29 Mar 2024 20:50:50 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5sxg553dzlgTHp;
	Fri, 29 Mar 2024 20:50:47 +0000 (UTC)
Message-ID: <38c6905b-85fe-49b9-b5d4-92ca233c1656@acm.org>
Date: Fri, 29 Mar 2024 13:50:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/30] block: Allow zero value of
 max_zone_append_sectors queue limit
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-12-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> In preparation for adding a generic zone append emulation using zone
> write plugging, allow device drivers supporting zoned block device to
> set a the max_zone_append_sectors queue limit of a device to 0 to
> indicate the lack of native support for zone append operations and that
> the block layer should emulate these operations using regular write
> operations.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


