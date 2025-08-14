Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8731E4BE
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755190311; cv=none; b=N8imlU7znCkkmRzraPKwRmu9OunkKDDwZZgZzhUqg18XPn1myziFS64pFiaLFTwfREZ4kRf7oc/1Ne1Bf31iis1yY1EmEZUR6HgcQfI0RIC04YYYLwE7H21e/ZxWOgpvk2HF6kuel/Qr0Ttax0tX/g6eoHyBbaRuE6ZcL7dutLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755190311; c=relaxed/simple;
	bh=/dbHY105+wt/iesX1nJqZjCddkbYYto+U/f4Q/Cmynk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Br3sycf+IYkrYLtO1vItcaYo82/UP9tkJHxm2uL3DP+E64VIm15AIeiCVrZelymaTTBTNJ26ezMYJuDQOgW3bVQ9Fs229jgeIXavrP7P9FWgjCLLi4/qsK7avAYcuMJtRoht+9nui2QLO7uEClAmYTsFiy5cm97/GSmYTeR4+FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wNG/MTRd; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wNG/MTRd"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2rqg5gNKzm1747;
	Thu, 14 Aug 2025 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755190302; x=1757782303; bh=eVIJsG8zQygobyapUg6E4edm
	GiNoPKVX/Q9Xp0aTHB0=; b=wNG/MTRdi/aXRP64SlRf2Ufs6NFQUsvDZqVqfwQX
	CWHeSa/RZlDXYlAJUL0nJRQkVMrY7doL1NWO9VJB8KpRCcrEjmSyuqSpYua4v1kE
	TSLLOoZQT0e6RfY4L1An6MaE+2UledGViZRX5if/iewyrhp5nLLiUgaskP6n8as2
	ApdRb7SeqqqqU/wRdYyz4IKwPbrcPGM6HYwOJydSkgwBm1ARNv+1cp80Z/3U4bPv
	r2v89hQKHhfJDXvZBs/xV6qBJ8jcGZia9HGgoeBzLAXlAgMgV3HXVmGM2YwSL7ON
	sfAYr4A1GDLhjBObdkuL0WZbpfxCtJwRCXVLtQ2wGMJyOw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CdSLP7yCdh73; Thu, 14 Aug 2025 16:51:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2rqb44DRzm174N;
	Thu, 14 Aug 2025 16:51:38 +0000 (UTC)
Message-ID: <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
Date: Thu, 14 Aug 2025 09:51:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
 <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 1:40 AM, John Garry wrote:
> Some further initial points on this series:
> - the driver still has the separate tmf tag set. Why cannot the tmf be 
> allocated as a reserved command in the shost tagset?

The UFSHCI standard defines different tag spaces for TMFs and for UFS
commands: [0..hba->nutmrs) for TMFs and [0..hba->nutrs) for UFS
commands. These ranges have to be kept separate because of how UFS host
controllers use these numbers. The TMF tag is passed to UFS host
controllers by writing it into a bitwise register. From
__ufshcd_issue_tm_cmd():

  	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);

The UFS command tag ends up in a protocol header. From 
ufshcd_prepare_utp_scsi_cmd_upiu():

	ucd_req_ptr->header = (struct utp_upiu_header){
		[ ... ]
		.task_tag = lrbp->task_tag,
		[ ... ]
	};

Mixing up TMFs and the reserved UFS command and allocating all these
from a single tag space would require a additional code and data
structures to translate reserved tags from the [0..hba->nutmrs]
range to the [0..hba->nutmrs) range. In other words, code would become
more complex and harder to maintain. Hence, I prefer to keep the TMF tag
set.

> - I like that you are using blk_execute_rq(), but why do we need the 
> pseudo sdev (and not the ufs sdev)? The idea of the psuedo sdev was 
> originally for sending reserved commands for the host.

In the UFS driver several reserved commands are sent before
ufshcd_scsi_add_wlus() and scsi_scan_host() are called. Hence, the
pseudo sdev is the only sdev that is available when sending reserved
commands like the initial NOP OUT. Allocating the well-known LUNs before
sending the initial NOP OUT is not possible because ufshcd_sdev_init() 
gets called while adding WLUNs and there is code in that function that 
is based on the assumption that UFS device initialization has completed
(ufshcd_lu_init() calls ufshcd_read_unit_desc_param()).

> - IIRC, I was advised to have a check in the scsi core dispatch command 
> patch to check for a reserved command, and have a separate handler for 
> that, i.e. don't use sht->queuecommand for reserved commands. I can try 
> to find the exact discussion if you like.

It would be appreciated if a link to that conversation could be shared.

Thanks,

Bart.


