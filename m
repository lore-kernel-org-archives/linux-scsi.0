Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FE93655D6
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773664; cv=none; b=dCmsd/Hda1chVw+el4/ZkqnBwU6jH1GgfPRnBb8A21ImjUR5udVx+PqTvspuzdIBwkfWU24V1sFoXa9eWGYf9aGzbco3ntEvMVSHBvmLt2uW3nhRRnsEBvrpZ3AB+yEzbWq4b2FWlJ4eZP3nB6I0FFiwTvaNanF+3R+5WLj/jKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773664; c=relaxed/simple;
	bh=ZDjFPYYAwje8vjXwyfntMXN07CH8KItpi4Y8ONfKMYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QH2SLrob+hNP0W/Mk1ez8GysIY1jEJqr/05F1IhpBUsH4VnskE1DLG5LT3Q7fh7OJwD4hG8KEYRfxbvI+NE3ETNM9mVF7F6SVk/5+JGGA2vCq+ONQbIhJ4hG7RA3hOPZb2oSgy8u9v3UUoLEtf6D8BT20N8WPb50QzGIma0jAAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mb1WKSbF; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mb1WKSbF"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hDMF42ZMYzlfvq4;
	Mon,  3 Aug 2026 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785773653; x=1788365654; bh=dH6ENl02gN2jH50XrUAHGP/u
	TSil+ou21ofB7XVznOs=; b=mb1WKSbFrGQaLJzkv/Wugl/ohkh9yktaXKlyxcJS
	I/6FlVhdj/GB4zPiRu//8zTPLcAlmn0e7lLdDOHo/QTfSYd2e3AxbVA/PLAjIkqu
	gM54ybXSM0FyaOKx3w2Dw4975dB5+6WLt30Jr2rTmzMt7yJipy4IKTjTlDkh8pbb
	OBQ76gb8Jc9DAurqN0vnywAsP8V8thnzktejdoeEPZUcPl9nfOfJ/QCnAm3hcv/S
	Z7dKxzEpC3hGxvHOXS4vhEzAwIH/bQ4Qtjc4y3cGJ1JMwdUxS4vu3juCVV/pSQVx
	+jvHn0DQxZucJFzqqs00rvvE6aJfyDM/olxD5H9kOTnVVg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AQ_0KokGVkxm; Mon,  3 Aug 2026 16:14:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hDMF02FfnzlfvpM;
	Mon,  3 Aug 2026 16:14:11 +0000 (UTC)
Message-ID: <58b7c76f-6893-44e1-bf0c-e9cbf080a073@acm.org>
Date: Mon, 3 Aug 2026 09:14:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] scsi: core: Pass the SCSI host pointer directly
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <0f417deef926f1574c555ec44fb2036e997a727c.1785534721.git.bvanassche@acm.org>
 <98049e01-09ac-43cb-aa5e-593bd5fb25c0@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <98049e01-09ac-43cb-aa5e-593bd5fb25c0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/3/26 6:01 AM, John Garry wrote:
> On 31/07/2026 22:52, Bart Van Assche wrote:
> 
> "Pass the SCSI host pointer directly" - that's too vague a title.

Huh? This patch passes the SCSI host pointer directly to several 
functions instead of deriving the SCSI host pointer from the SCSI target
pointer (dev_to_shost(starget->dev.parent)). Hence, I think the title is
accurate.

>> In the functions scsi_probe_and_add_lun(), scsi_sequential_lun_scan(),
>> scsi_report_lun_scan() and __scsi_scan_target() the SCSI host pointer is
>> derived from the SCSI target pointer. Pass the SCSI host pointer
>> directly. This patch prepares for enabling lock context analysis.
> 
> How?

With this patch, lock context annotations can refer to the SCSI host
pointer directly (__must_hold(&shost->scan_mutex)). Without this patch,
the following lock context annotation would have to be used instead:

__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)

Additionally, in code that locks shost->scan_mutex, the following would
have to be added to help the compiler understand that shost ==
dev_to_shost(starget->dev.parent):

__assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);

Christoph Hellwig made it clear during the LSF/MM/BPF summit that he is
doesn't like __assume_ctx_lock() statements being added and also that he
prefers to add arguments to functions if that eliminates the need for
introducing __assume_ctx_lock() statements. Hence this patch.

Thanks,

Bart.
