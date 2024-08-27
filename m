Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5CA17BEB4
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724795532; cv=none; b=MB+SlOAhjqMdGfWYZ2LNXFfdr/8aXzZhw6YpiVNYADnhGVhhBCmRyMu2jgOT6Qc0d65a81aXCgqIzmPPbHrDZ0OQ2ia53KwStT/egG5XirGtf7u5uBPc4xiEnXawMczY6I8b9REKX4h6Gq+/W4sjtdHphiQfh3wistrSelCJRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724795532; c=relaxed/simple;
	bh=VbwPCdN6XbObSCiE3IjJNM/6fozNRRjTpPDqS7UBwRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+RatEjUZjJ+UxaP6uE9QXmjQxZx/ON22U0DPgo5A9Ot8CjDs5bfwU52DZdLbarfvp+6SoRXnLFkMGT9TC8VRD9WgFaFKV4cr+PdSUnA0CXWv8s6lN9+XkEz23JbAUQWZ6g5OQLaCoR+we3g0doDN1u3o4aL2STjHB8qfqkxzp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DMqfsHn0; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DMqfsHn0"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wth8p4KJ8zlgTWP;
	Tue, 27 Aug 2024 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724795529; x=1727387530; bh=VbwPCdN6XbObSCiE3IjJNM/6
	fozNRRjTpPDqS7UBwRE=; b=DMqfsHn0AgLGkJSSynWjP2ndwUj+t+I/8ihtodyp
	jRpEcfohI0g4J78NhTbV7ZVF6gkirpernBNTf3LkdZAPJwyCI/arGVzdxKNFRQWl
	AenWtxfaNEl/Vh2V5FZzWg+lxBHd9wouypfwrLV7XUQxNuur2CF9oAzTm78LNpyi
	p3DpKH6eOUvKTq5TXZXcFPTkIVeNnRb2IJt2GWPg1UCnStN9w2lKYAIdPiAD1Z6b
	l9Od92EOC0GjpwpjPOHbuT7d+kiTLIr9cWx593JTu0lFdf0+ZRjI+UKXt/FHdwLO
	WtO1uKzrV+xrV5EJgW4QllsfujC+VkKEtjHBS0KfJPP9zw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id krHPnAKG_JMy; Tue, 27 Aug 2024 21:52:09 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wth8m26knzlgTWM;
	Tue, 27 Aug 2024 21:52:07 +0000 (UTC)
Message-ID: <41cb0805-d79c-477b-8e58-9bcdb83e7a9a@acm.org>
Date: Tue, 27 Aug 2024 17:52:06 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] scsi: core: Remove obsoleted declaration for
 scsi_driverbyte_string
To: Gaosheng Cui <cuigaosheng1@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20240826032005.4007834-1-cuigaosheng1@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240826032005.4007834-1-cuigaosheng1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 11:20 PM, Gaosheng Cui wrote:
> The scsi_driverbyte_string() have been removed since
> commit 54c29086195f ("scsi: core: Drop the now obsolete driver_byte
> definitions"), and now it is useless, so remove it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
