Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F469239562
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 19:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778874589; cv=none; b=Md2AmKsAdeLw7Nyn6wPgKAecMuDVmfxLNrhtUrjqWcGBbx2ZSXglmW/3CI+gBYwuMpdkwc/jQUBovjAPds5iH3i/2vkWfgZX2eBTzbvHdYr35+t8Jsbl9wSVNoPdsUvZW5qWDMZX/OiTW5ST1uXIQk5YjyS0IvnwMZ4W5ENkliU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778874589; c=relaxed/simple;
	bh=l5aAa03HWwI7pQtcoM5J+KHfO8QfZn/sq7aYJxT2iG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JLVbdxw/WxproTUCWV4uEvIaYLSDFJVdBw5YVql42pW7PqS2i2/mSLE5IfJAYtC+NCX8PN1cYNPcGw+uUkdxeltwUB4gX7JLwVqN308FnTwIy5dv18AtIy6WiBPRTT1TRHnUG/vNcC76tQvMB4ZqUxjOPNtwC6uadqvgWYV6yCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Wa4S0kMW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Wa4S0kMW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gHHpg3SGLz1XM6Jh;
	Fri, 15 May 2026 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778874585; x=1781466586; bh=iQpU50CqJrLrpxbtelK37hqc
	RYfZHHtXqcvYlmWPPhA=; b=Wa4S0kMWO/vj7dSxzbkv24DSWrlLxLeVGNpAI/O7
	kWS28URMQDnjvTeb14VoiuaiRyDwo6XctqXtLuPmBlBLdmohUSYpcrfoS6aV0dAf
	hT54wx+k1Ejv7wGDfU/dNz1SSMBiUsi+O10lQ8gj2dE6WAl2Pu0qMLXWR+S/JUp0
	U4BLe8CsLkVBqa7iqyo4eQnnYRnIS8/45LYSruMD+H/qlhMrFaghpqNnpr/p7ch2
	X91fEhU3JzTlCbs5Btn3E3wlDKXKKli/owLde6lRDP2JWTFsT27V3P2uY1DL/SL4
	Byl4PHNTpaUSu2ZBPEhAnqnfEf9fcQhk0GffN7o2TxACKA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R4T8ArMrtULN; Fri, 15 May 2026 19:49:45 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gHHpb6fkxz1XM5kt;
	Fri, 15 May 2026 19:49:43 +0000 (UTC)
Message-ID: <d1e6f470-fc06-4c7a-9c6e-31f41b7c38cf@acm.org>
Date: Fri, 15 May 2026 12:49:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: run queues for all non-SDEV_DEL devices
 from scsi_run_host_queues
To: David Jeffery <djeffery@redhat.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260515180941.9698-1-djeffery@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260515180941.9698-1-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 11:09 AM, David Jeffery wrote:
> While a scsi host is in a recovery state, scsi_mq_requeue_cmd will not set
> the requeue list for a requeued command to be kicked in the future. The
> expectation is a call to scsi_run_host_queues will kick all scsi devices
> once the recovery state is cleared.
> 
> However, scsi_run_host_queues uses shost_for_each_device which uses
> scsi_device_get and so will ignore devices in a partially removed state like
> SDEV_CANCEL. But these devices may also have requeued requests, leaving
> their requests stuck from not being kicked and causing the removal process
> of the device to hang.
> 
> scsi_run_host_queues needs to run against more devices than the macro
> shost_for_each_device allows. Instead of using the too limiting
> scsi_device_get state checks, only ignore devices in SDEV_DEL state or
> when unable to acquire a reference. Attempt to run the queues for all other
> devices when scsi_run_host_queues is called.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
