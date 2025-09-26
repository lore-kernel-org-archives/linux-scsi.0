Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052862641CA
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 20:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916915; cv=none; b=gVuxNlBMWPAhBoCzT29q9zeQpLA9qrKt2fL5jfiCEGh9Kyl335HTDcJAWdTYrMM2cK+KqmobjPQXkFACrDZB/EJ4u1ecufiBEjFJrwgCxvAG4lMx4mbT/jA4pflTW9PHqfpcPqw4Pu6p09/FPy9Ah2jpHHXZfvlxLLAoOOYcwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916915; c=relaxed/simple;
	bh=k2SdFSRfpvdKXtzgXXlV9eo0kzJ0C7cJQOvNCE/8Mus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e4pYjqYYuQNNJfskUX0G2yl/lwLC58CaOVrrroe++O9u6QqAOZE/4/wOXjnU4NgV2dbjwz6gV8XEVmhPSQexdgZbHlIx9eUQiiv9AKvd5dDbtYGV+GoG8AbZe3ki7fFLCCUGTWzZ2GGakvRaBfcsuO6WWVcLdW+85WzHbHVbpA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zoNipqbG; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zoNipqbG"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cYM153XM7zm0yTN;
	Fri, 26 Sep 2025 20:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758916904; x=1761508905; bh=uUyePSZBvSkDDaexrK9XJqXT
	ZPECYv/+p2ztGEO6OMM=; b=zoNipqbGp9vcADxs7wUeC5J73v2ock5eU5wjUH95
	yMYLBoSepR5T+SEZdjAyhfavpEmicMCHJ3ZP4T14Sy98w8T5EO/vsiX8kglkbBAY
	hJ/27renpgsZ3Xq6wXWgOnXQzD9Fm9okPeBc9+Dr3Nu0dP8QA4wM0ZSZdYAtDV5G
	STLZIAprjh0rk0WhCpZYWR5CIoxqLlONPwkixSJptL4Xd0G1go6mp4/k7wg/LNz3
	ntmtbjwx+FueDiPa4Q7W7NksnsjnZJRZkUoqZuOLJANesdNK/PN8cPQfKh97OfX6
	qylI9TrR2Y+9ULwgc/7mNGAiWWrUZWBUAUBtErZ4mq56UA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nVXepCdd4CFu; Fri, 26 Sep 2025 20:01:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cYM0z4z4Yzm0pKN;
	Fri, 26 Sep 2025 20:01:38 +0000 (UTC)
Message-ID: <25157f6b-3508-4393-9439-6905d7f950d2@acm.org>
Date: Fri, 26 Sep 2025 13:01:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/28] scsi: core: Support allocating a pseudo SCSI
 device
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-5-bvanassche@acm.org>
 <bf28fcc4-4a5a-4a14-bfd3-8d72015b9b0a@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bf28fcc4-4a5a-4a14-bfd3-8d72015b9b0a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/25 12:14 AM, John Garry wrote:
>> +bool scsi_device_is_pseudo_dev(struct scsi_device *sdev);
> 
> this is defined in scsi_device.h - why also have a prototype here?

When I changed scsi_device_is_pseudo_dev() from an exported function
into an inline function I overlooked that the above line should be
removed. I will remove the above declaration before I repost this patch
series.

Thanks,

Bart.
