Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD10E33471A
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532694; cv=none; b=iN3wulZhJuRVGqoXl2wAoeT0D9xOHKHqS/uDiISI8as3bl77PfWAR+Iz0pkHtRfk2eWJozbZqAUyXY/lVf5oLVo9oniGmeezJ8YStl15+jsNCo66TGKMIG+vt0Ezz2d/FnJupUc/D21V1zwb27Tdsl11h1Q/0/QtfzqnwBaCr4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532694; c=relaxed/simple;
	bh=ds/VUaPe3KYeOqmj9twJN2LBINOMT4eW/PSElzjQUq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UW7QHZb7DmzgkJnY0eLqYYrhBcYLunWgEZQ5bk47AYpT3sUFVnqZ/x9uJX7CBTinmMTIlFYXwU7KdcxuaUTvzM52PPotUUCsXXTX1+OJnuH4vR1pwcpuQWQae20IeMOCyJt1jMcUdu0mDyl3OhjwmIxYe/+tLlvbqv3eZFzb+rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qxT10j4y; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qxT10j4y"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5HS35k5Pzlgqyh;
	Mon, 18 Aug 2025 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755532690; x=1758124691; bh=7NUIy60zvzt2USxbXRdga+Xd
	HLPhgRF7wvnV8nUdSQ4=; b=qxT10j4yp1wD52HPuf/QgH593csVBI9uWXGz8gF7
	Il0+M0JL+cSzJhTkZ94rxjrLa5KO3Y02BMcN3AnKt17bhj26iYYTJIp7E9SXHu2c
	Z/AQ2xZpyyg7OS9RJbc7iet6VFVB4omHjlK7XgdpLf6+vLWWjCy5NkW16FTP9glG
	GZ4qFU4xI6JjdzkUcGZFhQJq07RppT19V53D4G2TjjLGKLA9GeetIeAisa6KoORE
	56S3Qm7DV9STe0BksivVCWYf1eGllERwQ2iIF4ysdBPzcLWaetjz6vLUWWb2PvCs
	GsEF7yfkXLP4eTZvZ6aqpSP1u4VRVFvLflMYKRPu6q1Wwg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i6NW5GYA7wd8; Mon, 18 Aug 2025 15:58:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5HRy4pfrzlgqxq;
	Mon, 18 Aug 2025 15:58:05 +0000 (UTC)
Message-ID: <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
Date: Mon, 18 Aug 2025 08:58:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
 <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 6:21 AM, Hannes Reinecke wrote:
> On 8/18/25 15:16, John Garry wrote:
>> JFYI, when I attempted this previously, I put the check in the blk-mq 
>> code, like here https://lore.kernel.org/linux- 
>> scsi/1666693096-180008-2- git-send-email-john.garry@huawei.com/
>>
>> Not needing budget for reserved tags seems a common blk-mq feature. 
>> But then only SCSI implements the budget CBs ...
>>
> Yeah, that is a far better approach.
I do not agree. Only the SCSI core can know whether or not a budget
should be allocated for reserved requests. The block layer core can't
know whether or not it should allocate a budget for reserved requests.
The block layer core can't know whether the SCSI core is allocating a
reserved request to guarantee forward progress or whether it is
allocating a request that should not be counted against the cmd_per_lun
limit. Hence, the decision whether or not to allocate a budget for a
reserved request should be taken by the SCSI core.

Bart.
