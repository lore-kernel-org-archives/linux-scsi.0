Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3BC16A956;
	Tue, 19 Nov 2024 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732050723; cv=none; b=lCpfZzQLSmJ39YCjqe8NhF4aksn1H9PB/HaxQDimElGvbng9RhSVUi509UvioeA54uFI4vjvBTeEB7BmkiRuqtpkrLv7AD1fBTpE+KVrUhmXxrTpCm7KIPuydjmaUHpCoq29Q7wB1WUG0uj10Ah3XoQV796sJDYNJSTZl95CIng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732050723; c=relaxed/simple;
	bh=hElO3Eami2tXcCeXfgAaMWIisyTwSiMdoAbK4rlt49Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LoMQjy2a5LGQQBGaPhaycBj+9MIiq+5WT0t54mfkSKFwSdzrVtiUO+4QvHQJ+yCeT2GfdgZop9VGWKJSOZgT0pg3inxtNlt22SsgFY6mYiERhoWUvA+peKHOTxy4ljj/S9nIlS9XGWol3fI0ke7sbJ1TQ/ZxEx7zKqG6yPB4meM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3ejQjOuS; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3ejQjOuS"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XtHHh6gFpz6CmM6V;
	Tue, 19 Nov 2024 21:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732050717; x=1734642718; bh=2cAWXsenU3MWlOkB7wfvWGNu
	hdBmarS9m0cTE5CyWEY=; b=3ejQjOuSsTbFAaCR1IdvwRDpthVWk3cTNaMAYCWG
	E7rI7DqjpfiGK3bP4c15coUto7GOVeh/Ug8btBfxWGuMI3QqjYMObPhuT2GpR6CF
	Nvaty62jLo0dJaQoFymvOIU4NxlHFVyTTNh0YwYvc0MU+214xyBNh1a+ekAQdOol
	R/DJNf/pU6PUW9Tu02+6S9mEidmOG8aW1Nyoy1JNlC6MC3Ezixqwf6FvXF/P7nOc
	gC/c4+kupvprxd3M+fO2a51iDTzcT9P6LA5Am4oPPiXmenDSvWwaNFLnU/0gkbbD
	vE9yPM/wOtXfFMbOvcOAwlLwGO0/v1MSEIBhnbovWUpsKA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BbEdehUhaQOg; Tue, 19 Nov 2024 21:11:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XtHHc59hZz6CmQwP;
	Tue, 19 Nov 2024 21:11:56 +0000 (UTC)
Message-ID: <6a2c8a3b-18f1-4713-b07d-2f4275964d46@acm.org>
Date: Tue, 19 Nov 2024 13:11:55 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/26] mq-deadline: Remove a local variable
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-10-bvanassche@acm.org>
 <8b81c0df-bb29-4db8-99c1-8436c55106bc@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8b81c0df-bb29-4db8-99c1-8436c55106bc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/18/24 11:38 PM, Damien Le Moal wrote:
> On 11/19/24 09:27, Bart Van Assche wrote:
>> Since commit fde02699c242 ("block: mq-deadline: Remove support for zone
>> write locking"), the local variable 'insert_before' is assigned once and
>> is used once. Hence remove this local variable.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Looks good.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> This patch can be sent separately from this series I think. It does not really
> belong here, no ?

Thanks for the review. There is another mq-deadline change in this
series that depends on this change ("blk-mq: Restore the zoned write
order when requeuing"). This is why I included this patch in this
series.

Bart.
