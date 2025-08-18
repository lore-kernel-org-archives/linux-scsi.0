Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E7253F3A
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755533112; cv=none; b=fi6l+goolqaO9bq2qhVoGUrz5l16xMH318k/sfxvqWFeEYjw6HQrWfY21IgjuWvfsFJaGGQa8AlctNPSE2hII5/o6fzHk8/7Q+W3fj5cm9X96r7mfDgCVeOlv3KotFeZ/hlttZR3r/9bBE24jcEfcRBpDnPL0E6OIyxIEvsQIyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755533112; c=relaxed/simple;
	bh=P7BxstuigmNrZqt5w0OU0uMy5opxx70odrygpWjrlVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cy/WZiptNwoA+7+1Jy41cMPTu/jIBDSFCcTPGCG60xLxgMPNRB/NZJ+ga5XbglIlBqeiikPtXSB0ylEPcdFGLygelPjngM+xU6B1PqsO+DDB444Gm4oGI5NLyVTMvpTJSVZ+zuvra36t5T2/JGt1wmYrbzHxqByd+zl0Kb93e/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wCDI/mMO; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wCDI/mMO"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5Hc50MvXzlgqVj;
	Mon, 18 Aug 2025 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755533107; x=1758125108; bh=P7BxstuigmNrZqt5w0OU0uMy
	5opxx70odrygpWjrlVA=; b=wCDI/mMOY0Gi2g+9RftWoQJkDSjyvjunrCejclbD
	wmu03O76r/9tvt7FYTABSKhavCrxHfbto9p52sQ9EUQWi8TuchgWKqwMm24WbbD5
	lGK0wLCp5eVM45xDTJvEmPRu+tBWyHNKEnae3z5NsT+ne/7R93k1EVId1+ekF3qC
	PiKWdyVRMQfmpjf2TcAOJMut6K86GaVwga3lq5PbUwC9T3Tu25IGI5NVhJUxcSjt
	zopu3eTfb+Ycx6SlFQMFUt9+uk4MaqdCwB9XsHKO5vGwYDsz3BCnu3BTmkR3I496
	p+F66aWa7Vhkus/f9eOAkz7QcQCUl/wzc5jcpcFXBCNw/g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hc1OlfM3gx84; Mon, 18 Aug 2025 16:05:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5Hc02DvVzlgqVV;
	Mon, 18 Aug 2025 16:05:03 +0000 (UTC)
Message-ID: <47f994c6-8802-48a3-8587-32cad993a6ca@acm.org>
Date: Mon, 18 Aug 2025 09:05:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
 <04ed2475-6ad5-4fe8-bf40-d3e33cfb3c6f@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <04ed2475-6ad5-4fe8-bf40-d3e33cfb3c6f@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/18/25 6:29 AM, Hannes Reinecke wrote:
> Reallocate the SCSI host device? Really?

The SCSI host device is not reallocated - only the tag set is
reallocated.

> We do have=C2=A0 blk_mq_update_nr_requests(), why can't you use that?
> I would really go with the idea from John; the minimal number of
> commands which can be allocated is trivially '1'.
> And the number of reserved tags typically should be known a priori,
> too. So you can start off with a tagset having just one 'normal'
> tag (and a pre-defined number of reserved tags).
> And then after querying you should be able to call=20
> 'blk_mq_update_nr_requests()', and we should be good here...

blk_mq_update_nr_requests() is not exported by the block layer. Anyway,
I will look into this approach.

Thanks,

Bart.
