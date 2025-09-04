Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C504225E469
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 19:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757014908; cv=none; b=QR0pUGnbCIHmllKdFaSD2xVCtWdrFWS2ZTX/k5SFFVWGe+CVrdR16PX45dFXOgWrj50Y63HkR8Mxpyk9crwb9JSDFf5I4iY/1ZdvdMZKLg90Z9n4aqA+WIpUUnBtjHB3Qdi0FsC18zSvQwEX/B/zIXZInaDVUooeq6LX8tc1Umo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757014908; c=relaxed/simple;
	bh=QJ9Mt/N6eh5HbTf+5ouoZXczd2teHAUGBmnaRW17Wgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tV7pyRMnOniz2HbQ2GKHdAB4mui5TCyUy1EjcjyrvJssvOdEUwrp+CfU0thlxP4SbCYOxP+lQkMdvh0BA/8ekumz1kcdM6ONB14VNBdYiGhuhaFFhC71VExPCfAI8qN7C8q61zoGJTCcb/a0ppC/JEYtcrqOe44qErDRxC4cs1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jg3ht1Rr; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jg3ht1Rr"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cHqc84HVvzlgqVG;
	Thu,  4 Sep 2025 19:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757014901; x=1759606902; bh=44v9q6WMqWPV2qOL47kE8QvT
	oioRL7BnPVAOtzLA9P8=; b=jg3ht1RrpxsfGVO+UPsdhjrD4PhynmyY0/O8CDAx
	lhjYaa6c41uvoBXVrw1dFnQd5b4qS9v6TGaiTzb1vDJ+r9m1WcuL3vPWwxFWaA8q
	qt3VhFbdy3orQxqQSuSDQqFJmZPHrqWsO4wZ2qtg1qK5/F12TqXUxohAp0PGeSAq
	CmrhuzTOAnDKjbIrH1ud8KqWeNlgeE2iyUdBcOexHG70dA9a//SlafAQsjEQ0dkU
	A1d/zpSpeW443KQrHpQnm06w2b4mnXkuAIWuDZ0XbERocPMd8b90sjmQnQwz/9jP
	Tjtt+AWhQA9BZUOzERtU3q2JjYG4Azvr1/McZ8WIh0UINQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6tO78b-YteyP; Thu,  4 Sep 2025 19:41:41 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cHqc22wW1zlgqVk;
	Thu,  4 Sep 2025 19:41:37 +0000 (UTC)
Message-ID: <ccf0f76f-1e9f-487d-9844-b8847565532d@acm.org>
Date: Thu, 4 Sep 2025 12:41:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/26] scsi: core: Add scsi_{get,put}_internal_cmd()
 helpers
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-6-bvanassche@acm.org>
 <b9ebed12-0e89-495d-8aa2-a615603cec4f@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b9ebed12-0e89-495d-8aa2-a615603cec4f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/25 2:56 AM, John Garry wrote:
> On 27/08/2025 01:06, Bart Van Assche wrote:
>> Add helper functions to allow LLDDs to allocate and free internal 
>> commands.
> 
> did you consider reusing/refactoring scsi_execute_cmd() here? I'm just 
> wondering if it is possible.

That should be possible by adding more members into struct
scsi_exec_args. However, I'm not sure this will result in a code
reduction. As one can see in the last patch in this series, the amount
of code shared between scsi_execute_cmd() and ufshcd_issue_dev_cmd() is
minimal:

	rq->timeout = timeout;
	blk_execute_rq(rq, true);

Thanks,

Bart.
