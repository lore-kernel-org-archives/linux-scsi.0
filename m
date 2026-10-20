Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534180;
	b=XETwdqqGrejp3DoLqlZpLEBiR8/XGhlMNBUZYRo1MNP12MtUpKAwj58uwlGL0VYeh6zo
	 wmXOyvaC4GMT6jNKBY22HItmAovkgLABTh2rSmiqsdleBFzfvkaE6coQW7/cMdkjTzGxz
	 UpXJFqKnHL4KIFszYChkwaX/dpRmx4lPDLkfNp3y1m+L1aYs/crk362j3T/P2NnqEzvjZ
	 vZQDFH51eceVV6zuVHLdHSY/m7EiCcE73OwwcTOCoUfIaHoPut+dy8NbuxooX1eu9tOX+
	 VRZmiI8puWjGudefNB/IAYqZtBCHNGGMXFsjXxcG2CkarPzIY4xyauv2ltZQhqwzVIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534180;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zQHEitVHtoQOsqr+EQps1HIdYrTbRVQjl/j0tMKQTVE=;
	b=0irP1U4j/UVOBwUaxCFqo38r31tjc6VhloLfuEesv5hi8l0aJtgP8QnZ4UPMeUxsJLM5
	 kwRIhu52LRiEQJ68PnyZDrzia31OV427sTO+rlfA0RUdTZ43pjc90Iu+1nLZpoZBmow0G
	 mAWMdQIsquhnllcvKZDSBGmoEtuJn1LeD2aUPZTy6AkI68+p6jwdvzMgl8QGes6/7gqRs
	 nZCzZl/crie5+pk8TgS04jBciwzEc2uChVsgiODFrZIddoMGRV642GQ6bTOQ3vs86Blcz
	 0lolx7wBYofckLpooP/2cRUxLDA0DfFNXJiOO3K7SYw06L6x0WUWQbeR4F2EbBSaTGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=NPNGqPUM;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79427606A31B
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 22:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79427606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=NPNGqPUM
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8RR66G6zz1XM4Tn;
	Tue, 20 Oct 2026 22:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792534174; x=1795126175; bh=zQHEitVHtoQOsqr+EQps1HId
	YrTbRVQjl/j0tMKQTVE=; b=NPNGqPUMuATF1StlacILQD/STma7ivjtcjU47WfF
	qL9VyTbasr5PIxYNvuJ+IJf2CetMtN+4ERfqnIu0mMam+k5te2K1uQMSnvpK8JvY
	/HTc3EPN2UECk0TEAQu44/3UFU0e5VZtIeUIpg4UIHYJNLZ9F8aO720E5F/+SaVL
	Amp4QZ89cZOanAKTRx+EzjhSh+zH/NcVQCJCULraEnMr7ohgrXHiy2AiehNDd4kP
	4XQaG/hFxmZVEz0dVxvabvKkgfYEJ56sc3a5FeemX8P6SMg3VSgYqy+mkBdrrJFD
	1Tt/S3o2cpWb3uA8cjAi/bmp7UqJG2UvS6O6e+p75Pb7Rg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9vdsMUPqbVP9; Tue, 20 Oct 2026 22:09:34 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8RR12yZpz1XM4Tl;
	Tue, 20 Oct 2026 22:09:33 +0000 (UTC)
Message-ID: <227b9f93-0dda-448f-a268-05cf4f9b6046@acm.org>
Date: Tue, 20 Oct 2026 15:09:32 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@HansenPartnership.com, Hannes Reinecke <hare@suse.de>,
 krishna.kant@purestorage.com
References: <120fc95e-432a-4f05-aa87-54873363ed9f@acm.org>
 <20261020171748.7207-1-brian@purestorage.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020171748.7207-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 10:17 AM, Brian Bunker wrote:
> On 10/19/26 3:41 PM, Bart Van Assche wrote:
>> The open question: a target can now remove a disk that is bound and in
>> use. [...] My suggestion is to only reprobe when no driver is bound
>> (PQ 1 -> 0), but the author should say which direction the ALUA case
>> actually needs.
> 
> Both directions. Let me describe the setup that motivates this, because
> it isn't a short interruption.
> 
> Pure ActiveCluster is two separate arrays that present the same volume.
> The volume is synchronously replicated between them, and each array
> exposes it through its own front-end ports, which are in their own
> target port groups. A host sees paths to both arrays as one multipath
> device.
> 
> When the replication link between the arrays breaks, one array keeps
> serving the volume and the other must stop, because it can no longer
> mirror writes or persistent reservation changes to its peer. Its
> front-end ports stay up, but its paths must not serve I/O. The array
> reports those target port groups as unavailable. Unavailable is the
> state we can use here, because its required command set is one we can
> fully support without the link: we don't have to accept reservations
> we cannot mirror. This lasts as long as the link is down, which can be
> much longer than a microcode download.

Having taken another look at the cover letter makes me wonder whether
it is really necessary to refetch standard INQUIRY data and reprobe the
device when the peripheral qualifier or device type has changed? This is
a huge behavior change with a complex implementation so it will be hard
to convince the SCSI maintainer that this change is both safe and
necessary. When I was working on active/active SCSI arrays myself we
didn't care about the INQUIRY data in the kernel and let multipathd
figure out which path(s) to use.

> Why I think Linux should honor it in both directions: today the
> outcome depends on when the host looked, not on what the target
> reports.
> 
>    - A host that scans while the link is down sees PQ = 1 on those
>      paths. scsi_bus_match() doesn't bind sd, so they are not disks.
>      When the link comes back and PQ returns to 0, nothing binds sd, and
>      those paths stay unusable until someone deletes and rescans the
>      device. That is the bug this series started from.
> 
>    - A host that was already running keeps sd bound on the same paths
>      for as long as the link is down.
> 
> Reprobing on a PQ change in either direction makes the binding follow
> the PQ the target reports, which is the rule the scan path already
> applies. With dm-multipath, the unavailable paths leave the map while
> the link is down and come back as new paths afterwards, while the
> other array's paths keep serving I/O. Without multipath, a disk whose
> only path is unavailable cannot do I/O anyway, and it reappears when
> PQ returns to 0.
> 
> If you or Martin would still rather not unbind a bound disk by
> default, please say so now and I'll rework v9 around that.

This is a big behavior change. I prefer not to unbind disks if PQ
changes.

Thanks,

Bart.
