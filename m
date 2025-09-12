Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA92F2853F7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757708107; cv=none; b=g00PJKEur0nX97cTtNp7rO9hK6GZ7ogT0QJiwAa+KMOajJnEyDIIx7j5fyTAQWTvP6choMd3/DIqiHYb14GiTmeJCotkmC8UFMscsiEss0oBvhvlFqbivyGoWsA913N02L5aHREBnVdiHz5FBuGKHV/ooWhV3Fk6IKd1H2v4oCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757708107; c=relaxed/simple;
	bh=vjTVVf63hX0kjLgPopY9N8sl51TNV9C5y72V40hZ7Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j+rnrTyJv8brNJCF/sPyMGnxu81cYwO0ENo8lOmwbGbZew6QGJdFfLwqfpDCcpOOTlagEEu7l9mtYTbBPeRA0IH48Pg+kd+q63zyr/ACP6bUIRVqEwVkH4DtU0OnDArafX3lZ9QBbr6oRuweiw59HWU3TJwryCxvaAbEiN1vsjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Jp3++bjq; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Jp3++bjq"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNlyv4f02zlgqxs;
	Fri, 12 Sep 2025 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757708102; x=1760300103; bh=I3EyYVGPekv1FH9lIIcR1/dL
	DKx+VCfxTdNbM3JETWI=; b=Jp3++bjqU+bNCVM363qFHzz1QUrOcRhQ+pRbQcqZ
	hr0Ikxl5SjZqxF1WAoOWwYssGZwqEUWybztAac6Hdo3nfB9PgLOP+JtcRGb+S8Tv
	+fKbALj4xVbjhnpVLbq7NhkxjZala+5Vv+P/r82lD6B5q4qSyDKZNkrFBVRkHcIZ
	vI4Mpn0dC97URWwVFFgC14HxFOGce76PTdAyxFuKCgVCOD3LcXbxFf2dJfed0zOX
	MagD7z/P9wARhvD0NStp9x8dm3bSXJV8b3viWQCohCZe3pQQZw8VQcIclihJue7h
	d1wNhIzGIGA1HYCEy4pX7z6Xj3AGzliazAx6KW5Uejm3hg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SBCzXWQmKM40; Fri, 12 Sep 2025 20:15:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNlyp26Jvzlgqxj;
	Fri, 12 Sep 2025 20:14:57 +0000 (UTC)
Message-ID: <0db49a74-5317-45bf-978f-5e4da11a3aff@acm.org>
Date: Fri, 12 Sep 2025 13:14:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: michael.christie@oracle.com,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <1a1335d9-5690-49fe-b5a9-542cc17c1bff@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1a1335d9-5690-49fe-b5a9-542cc17c1bff@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/25 1:03 PM, michael.christie@oracle.com wrote:
> On 9/12/25 1:21 PM, Bart Van Assche wrote:
>> +	if (cmd) {
>> +		scmd->cmd_len = COMMAND_SIZE(cmd[0]);
>> +		memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>> +	}
>> +	if (args->init_cmd)
>> +		args->init_cmd(scmd, args);
> 
> I didn't follow all the reserved tag discussion so this might be a
> duplicate question. What will you do in the callout?
> 
> For these types of commands is the scsi_host_template->init_cmd_priv
> callout not called, or not called at the right time, or do you want to
> do special case initialization?

Hi Mike,

The scsi_execute_cmd() @args pointer is not passed to the SCSI host
template .init_cmd_priv callback. There are several examples in patch
29/29 where that pointer is essential at initialization time.

Patch 29/29 uses scsi_execute_cmd() to submit non-SCSI commands to a UFS
device.

Thanks,

Bart.
