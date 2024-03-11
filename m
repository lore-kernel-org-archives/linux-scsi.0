Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB63C54BD4
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710182068; cv=none; b=H6kUODOanWOzscAeTnDjNI0bxPxjU50YKl9zHMHzwkLM21/fuolgHKcMXdm1oZzSeN/HGESpvxftm6CkcpLjiuLKQ9MIX6qYIg0U2ieBWy1fgpXCWWMgMQLSm/6Ags8atUMWdDEbZgdbLmNEtYeYnOzzguObRmLisCGwxXg4SVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710182068; c=relaxed/simple;
	bh=YbXFWyym6Ehm+Fh3KkbR/zsbq+kvBC2GW22B8iI65aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O8QAqPB8OwKkl2LOsKiPuK/lxXO2HoyCxWcOoEG9yxaQtCxmfEMv/BSKoud8JobpFgIABOt3qQHSvb8nBg0CwKrIsTlmjR8a1Aw9dj/9nANv/3DL5/FNaoq2X/tm4peA0WAn6K/g6u6STPg8KER8xehghYzsruh+PZCChUcl+U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ue+IPUOR; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ue+IPUOR"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Ttlmf04vbzlgVnY;
	Mon, 11 Mar 2024 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710182064; x=1712774065; bh=0/18iAL4ylQVwu5vkP0bRXnZ
	HJcDTge0Gx1e3peaxEg=; b=ue+IPUORkz5oB0agnhn7YoTKZWOyl4jfNovRT7R1
	Dhl4PA7Dxc/mGJcifJOn6LSHDCGST77khtgYx53LYNPlTBDgksETHs60CYIsY77X
	vx53RV1K2d4LE53iqQDJMEB2xtwu8ustKwBLeZyFYGxmaN0/iebJo4snzP4BGhr6
	p2E8nVrPwk6t6b9CVVX6Fo677pmnn6LBQXp2/jnSK1rUPdOWlN1bAjMPKPQiB565
	+HFYnENSUKILVO78qmOg/ofuOSWGuxGhs93vGSCXtEo1eD1jWhtAlXhufkDCogYU
	X43zAetK7Qx25rfOLDbOk+Irhs8vQQDNfjsue2ovd4Q3ow==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qILRo_L9rR5u; Mon, 11 Mar 2024 18:34:24 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Ttlmb39RbzlgVnN;
	Mon, 11 Mar 2024 18:34:23 +0000 (UTC)
Message-ID: <c6686a85-1003-41b2-b57e-340a8e87954c@acm.org>
Date: Mon, 11 Mar 2024 11:34:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
 <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
 <4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
 <218b4bb9-ced8-4480-8b6d-24969180053c@oracle.com>
 <2f2c14e4-1a8c-4472-9ac4-887b8b0f2689@acm.org>
 <ef5dd96c-0de6-43bc-ba64-05729329ba2f@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ef5dd96c-0de6-43bc-ba64-05729329ba2f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 01:45, John Garry wrote:
> On 07/03/2024 17:59, Bart Van Assche wrote:
>> The approach to use multiple files in order to avoid #ifdefs in .c files
>> is strongly preferred in Linux kernel code.
> 
> Then what about this change in this patch:
> 
>  > +#ifdef CONFIG_CRC_T10DIF
>  > MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
>  > MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
>  > +#endif

This ifdef has been removed in v3.

> BTW, I don't think that modparams should be compiled out like this. 
> Better would be to leave as is, and error when the user sets them.

Hmm ... aren't unrecognized kernel module parameters ignored silently?
See also unknown_module_param_cb() in the kernel code.

> scsi_debug is complex, to put it gently. I don't see any value in 
> splitting it into further files, spreading the complexity. More 
> especially when there seems to be little gain. scsi_debug requires 
> CRC_T10DIF, so let it have it.

We are using the scsi_debug driver in Android for kernel regression
testing but there are no plans to support T10-PI in Android. Any
proposals for alternative solutions for removing the dependency of the
scsi_debug driver on the CRC_T10DIF code are welcome.

Thanks,

Bart.

