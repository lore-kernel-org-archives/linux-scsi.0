Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DD44DD6C2
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694530; cv=none; b=AAWBAVHIk4SjyN3Y7Dvj/ht92FOy7SxnDfcskMB4o9zJja/4v6+dea8e5rswLadON0BGBc0RWqkGMAAVOB5lM2kXe1WIoF58LYg41DVrPKFvKXUd3r25rGIg/Xdk8AsCcTDxE0yCynaYH7zimxbJnirf0wj0UqiTKMAVEo0v0ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694530; c=relaxed/simple;
	bh=VFhhMaWlXtcevOTnrSeDx9zhFjrAWQR8qfageVbwn34=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=U6JICBOh6xZZx4JtHooNz6Or1IWyi847U9lqhHYFtxRiILKTAWMFyQxtdHAoAQ4XHbBkb3TPHaSArhSDHk0BdeyXzHSesBapeyt9BVnm4gAm8+tT1k6Y6QLco/V62KyLI9FQohoXs1FbY41dMOZYW/M3zmIol400MDo4cdo/cCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hRu8t+AZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hRu8t+AZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gG1Cs6VNczlfvpM;
	Wed, 13 May 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778694519; x=1781286520; bh=dNr07xk74fyRUOe7JxGeK7j1
	7kbsmtZLURb+Lkop1TE=; b=hRu8t+AZkzytCFe6qNuQZkR57eBZTArjZDO8Bo6P
	5pFbt3F1Y9khUmP1XNFUP2kJtehBN+ttHOmfx1CtTltf3mW3NN++fGgUNFyETJfZ
	C+NSMIR9eRtIhi07JqBNhrNukX0ekh6WhG3343Q/4REU3WORl0+SZizx31yx0CdT
	p+tnGfe2fsY4vxUpD78ms7b6TggQGqNnyd7K9HEveHIRJnq+Xmp26XkRb8/jcbF4
	PADBn1J4ZpM7h9kNgdfeQBGGwO6m1DfXAbYkEUAR9WbFkLpIoCyLiOc6elWKCTsX
	twJKGoasl+Km5SZCuX1AXPeMG5BBFoyBdPJQtmGFCDNzZw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id URhKU1eR4KAl; Wed, 13 May 2026 17:48:39 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gG1Cp4KlmzlfvpK;
	Wed, 13 May 2026 17:48:38 +0000 (UTC)
Message-ID: <3442d2e5-de1b-4043-97cb-464feda2623f@acm.org>
Date: Wed, 13 May 2026 10:48:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: run queues for all non-SDEV_DEL devices from
 scsi_run_host_queues
To: David Jeffery <djeffery@redhat.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260513173552.9222-1-djeffery@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260513173552.9222-1-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/26 10:35 AM, David Jeffery wrote:
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
 From scsi_host.h:

static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
{
	return shost->shost_state == SHOST_RECOVERY ||
		shost->shost_state == SHOST_CANCEL_RECOVERY ||
		shost->shost_state == SHOST_DEL_RECOVERY ||
		shost->tmf_in_progress;
}

This function returns false for the SDEV_CANCEL state. Hence, even with
commit 8b566edbdbfb ("scsi: core: Only kick the requeue list if
necessary") applied, the requeue list should still be kicked for SCSI
hosts in the SDEV_CANCEL state, isn't it?

Thanks,

Bart.
