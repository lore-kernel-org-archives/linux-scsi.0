Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8AF36B908;
	Fri, 21 Aug 2026 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787328879; cv=none; b=AOCuUhfjaKwaoO5fPIPh+tYe4K78QfAD62J17WmMIU6iNT4HxpsOESwl4UiTJQmlgEW8LYiHuc2V/8Ls/EkdtAV/HJigsCWyUgGLTDGPnX8UWXd9QiLnDIEhoAKx+zQBLcH/iXDA1uQucKpVIs/M2CrQGfOUvNxTMYE4nBNEbwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787328879; c=relaxed/simple;
	bh=5HQ6LKMAfYJOcaRPpNVwXNgm7nStCMcmJUbjgtK+j+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJx2O8gNhrZqx1M1GMCz+sF5WMUTpOx5pyQo4paNKX3FGi4XitcdKq8u9h1PkPQgR4Qp0HqWSY0YoQS0tpMaKhJKkSsad10srJ87Fc6emU2mzITW+wNHN0nvPn0NjFW6u21igGmDjh2WiQHlfi4uaClA/CYTS81XI7tQ0h6z77k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Yl6tLHTE; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Yl6tLHTE"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hRQP926zDzlfq9x;
	Fri, 21 Aug 2026 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787328873; x=1789920874; bh=8pfpPXTgOfF4lURELYBCo77Q
	gdRT2xOc5dBqD1JjLNA=; b=Yl6tLHTEVCztXQf1GvEG0WhmBlKR1A48LX150JrW
	5nqa/hHQgMtGtM+qCIhVjjdkNlfzah3Q6hRKCC2yy7EG19k0d7IFKCYKhSFIUIOw
	IZraebTOuAugrjYGO06WAWXk7uTKEVTcrr4k1jbrp5eTVMZ97gt0Ac7ddNPU+57G
	A82MS8RzXa/cfzj6lS++rELOt+ziS3yTMSZRgFtgJpRVP3MrPEaMKODeS06s5PI4
	oEWkc9jCBNI06tmqvyFedg6ns41WhUpyl2gQ19oRN4UdraGF4b4ZsaiJo2cex44C
	CiiTgSW1bjAazgM+hZs9ZnN6FtxZVX44wTIbKgQadVwj3Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hIJGUDIfx9oc; Fri, 21 Aug 2026 16:14:33 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hRQP33LKvzlfvpS;
	Fri, 21 Aug 2026 16:14:30 +0000 (UTC)
Message-ID: <23760489-a45c-4b00-8500-9e8f4c9189df@acm.org>
Date: Fri, 21 Aug 2026 09:14:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] common/scsi_debug: don't slow down I/O
To: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>,
 Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-2-hch@lst.de>
 <d3289f5b-7b4c-44ce-99ba-c7ff0f59404d@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d3289f5b-7b4c-44ce-99ba-c7ff0f59404d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/26 12:41 AM, John Garry wrote:
> On 21/08/2026 06:11, Christoph Hellwig wrote:
>> scsi_debug by defaults delays I/O 
> 
> Maybe we can just make delay=0 default for that driver. Or use ndelay > 0.

I'm in favor of changing the default delay to zero. It's what most users
need and it's easy to forget to specify delay=0 when loading scsi_debug.

Thanks,

Bart.
