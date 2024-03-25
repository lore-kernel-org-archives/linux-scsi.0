Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633C59B52;
	Mon, 25 Mar 2024 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711399405; cv=none; b=piAKwx3nIKpOimT/9k8jupENpy3yh++1ntaAd7PTCe7wekTvK9B6zWqDpAg59BilvVmIlMyiSQdINbMjo2QfY05mIRV/PNi7eHdRlJJIWWiCdUf1fRES+PmS2/Kaerr9nz0oDJS+uD7O0c03uCL1bmPoQqDHcHnFVkaJ4BI3dJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711399405; c=relaxed/simple;
	bh=xo7k7hDsTyfLL74N8EfEIPZVnqI9jotrbYjW/qdNPR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2+7xnsHt/skIL+q75a+lUJlz39H0WQJy+3kCK4kTK9DuyhavPBk081JgadmDi4W9qZ+FwEuu2n9Jq8ZzqIZ8vlMaqkH8VgQUqqtuN7l4JKc5oAhZYJzPHgwpYh/vG1RvXjQgZHyl9onCl0hjpXWdkxVvWgXa4RUjQQH7j5/b8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=o60GYQbr; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="o60GYQbr"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V3Pyz27FSz6Cnk9M;
	Mon, 25 Mar 2024 20:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711399393; x=1713991394; bh=xo7k7hDsTyfLL74N8EfEIPZV
	nqI9jotrbYjW/qdNPR0=; b=o60GYQbro3mGD48I7cJDe7MEkILqnw0OHLbLLU5h
	QZz4GSarlDlo5vzg7D0NaEA4HaVjHoJ0L/RCa5g8sGFdDRjYotswrcxsNTfjwq5+
	lPYQME3QntfnzvhgkGX1Txb/mg5F7hemRsrfKnT52Qug7GFnbAZDkOtQp5qju+66
	vIkMeq7ISnv5PpUTmnTcPMILiJPDzMxsQceXKCzfruZySOKfhDZa7zyljOIdaK3s
	cZgE+u109DSzJXlU4ERd2eIrZgwnsLWjfe7p7keak962me4TW4r3fEAMzXKwDDCk
	5FTdHQJ7ho4x2SvYjZXFbonj5AAAqlaU49FvPVnqqrWLPA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RyVx3gHqWiUV; Mon, 25 Mar 2024 20:43:13 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V3PyZ5tBkz6Cnk9J;
	Mon, 25 Mar 2024 20:43:02 +0000 (UTC)
Message-ID: <d64f697b-7349-4592-814a-00124afb6737@acm.org>
Date: Mon, 25 Mar 2024 13:43:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/23] block: remove now unused queue limits helpers
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-24-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240324235448.2039074-24-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
