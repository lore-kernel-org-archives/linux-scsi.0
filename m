Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6348324B24
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786722137; cv=none; b=MK3jFN5cEe5gB4CJ0Fp05DOmJ5uiir9qJVcwa+oeT09LojBb++DSNUbqIUoeVyEV8kcNDfTxRfpBCx3onjQO76lpypsLKBAezSQZWd7mtu08SzOehDLxfHTIr8OtCAP6COBsdUoSbHiVPf9AzfKXMS7KrHyOAE0Uvx09P9lr/Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786722137; c=relaxed/simple;
	bh=yNAHWjsr4+ie9dPJLVv4wPKfr7hjIfl2+GkdOIB6sm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHhcYziJliAWuNhzpfAvNcaCeHm9AIAFKXn8zZwAJk5ErmultgWzAkq9Nt+gp8A/gkvP0qpxWcBu+NmovKpiVarba+QZ64YxOAmgo0AYwK6zHMnNmKjFMPsPhYKekvhAdwvT8UeOMxq8K4nxr4QYCwLNeZwGAo2ARlTZTDNI2xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cyA4p+FI; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cyA4p+FI"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hM613366hzlfpM3;
	Fri, 14 Aug 2026 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786722132; x=1789314133; bh=H3930nkwk2L88PWucS6iBryJ
	XjXA+89QYW/zypjy6yo=; b=cyA4p+FIKp4z+qk+8b0gxxkxErUA/7v/hZiEN9+k
	iIJuXGwvyagQ9L9aMtVpL1eJjMyOSBPHji3b8TN5yRBWdQUQUeIKHBPN60BHO8tC
	fgK5tiVeosiWhY1bHJevYNS3P38YD4J0Gx/0r/lMNLP/SoEewU2w5uwjBTN+uXd+
	mKtCkxNUWzRRbJ4P9mI8ENi5IdYLnZwGrpXuqXTKO4enfvWMvD27UCvMJe0cdyg2
	iAMn6SkX6+Jjh3WELcGbwizRE3PQrpfbcpH6S8H9mTYyGUEzT6GQoMlemhvCf+15
	nSI1Dsv4XpWBuTt9CzRrGE/d2QE0icO/iKlTAhGbHC3dyQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G-zLpFker3jk; Fri, 14 Aug 2026 15:42:12 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hM60z4CMtzlfwgC;
	Fri, 14 Aug 2026 15:42:11 +0000 (UTC)
Message-ID: <34fce42b-cbdd-4f3e-9a01-0b245a009c2f@acm.org>
Date: Fri, 14 Aug 2026 08:42:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] scsi: core: Enable context analysis
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1786142946.git.bvanassche@acm.org>
 <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142946.git.bvanassche@acm.org>
 <cb699d91-0ca7-40a9-bdcf-ee2c00a22aa6@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cb699d91-0ca7-40a9-bdcf-ee2c00a22aa6@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/26 7:55 AM, John Garry wrote:
> On 07/08/2026 23:49, Bart Van Assche wrote:
>> +CONTEXT_ANALYSIS_constants.o := y
>> +CONTEXT_ANALYSIS_scsi.o := y
>> +CONTEXT_ANALYSIS_scsi_common.o := y
>> +CONTEXT_ANALYSIS_scsi_devinfo.o := y
>> +CONTEXT_ANALYSIS_scsi_dh.o := y
>> +CONTEXT_ANALYSIS_scsi_error.o := y
>> +CONTEXT_ANALYSIS_scsi_ioctl.o := y
>> +CONTEXT_ANALYSIS_scsi_lib.o := y
>> +CONTEXT_ANALYSIS_scsi_lib_dma.o := y
>> +CONTEXT_ANALYSIS_scsi_logging.o := y
>> +CONTEXT_ANALYSIS_scsi_netlink.o := y
>> +CONTEXT_ANALYSIS_scsi_pm.o := y
>> +CONTEXT_ANALYSIS_scsi_proc.o := y
>> +CONTEXT_ANALYSIS_scsi_scan.o := y
>> +CONTEXT_ANALYSIS_scsi_sysfs.o := y
>> +CONTEXT_ANALYSIS_scsi_trace.o := y
>> +CONTEXT_ANALYSIS_scsicam.o := y
>> +CONTEXT_ANALYSIS_sd.o := y
>> +CONTEXT_ANALYSIS_sd_dif.o := y
>> +CONTEXT_ANALYSIS_sd_zbc.o := y
>> +CONTEXT_ANALYSIS_sr.o := y
>> +CONTEXT_ANALYSIS_sr_ioctl.o := y
> 
> Was hosts.o missed?

Yes. Thanks for having reported this. I will send a patch.

Bart.
