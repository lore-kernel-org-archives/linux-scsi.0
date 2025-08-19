Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F442BD029
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632992; cv=none; b=WD76a1pKTgJRidQAvdBo/4Rw4dCq9Yl6vbh7wlLDYeVh64lB9H2IodJtwbeFzF63/5CE/+l5q+fDWUpeTJWkgtF8n7EEXM7e0xv+/xho0Y9m4vlOSp6rXBsruKB/otyylkvSqJPjHktpkNc3aze1Q5finRJiiGf/dFE/HYIzNfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632992; c=relaxed/simple;
	bh=HP99hX+fVYBviVa4I4N+UKK/ZBKKuoYKJWja2xclh2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3XvPzdJaQlLMh6bg1k06RnCYQSnbqGbVAbgaXWc5QsLidEBQijtal953IL6+Fc1vGCTv4P8D64z1B106gz/oXGKs1BWA17r4FRcxfNDef1n9IBCrKGFzsRiVJ2OTwsd0Rj3Wr2m5B56A5xckTDDIX/io3Gh2GrSdVc3nP4UI7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M3tDJvXo; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M3tDJvXo"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c60Xt1Lgczm1743;
	Tue, 19 Aug 2025 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755632988; x=1758224989; bh=HP99hX+fVYBviVa4I4N+UKK/
	ZBKKuoYKJWja2xclh2k=; b=M3tDJvXo6HAB+D/L3rvz+aivZI861DDCTv1vz3PA
	U+dq9EObVVNZIbXLWvHoxVAjkJ3QspgjrSqRPucnQNLl8TgHwP27tTJKx1EnpeE9
	2DeqOaFXC63k3Xtvs2zppfZP81jdPFmV/bd1DPB0XJSc4YCvryPtaVDj5ZRFzi3z
	vZl7dQq8idKTpsRkcmitXUeOR6lZnc3gyDY0W8FifumdqtpdJ3y2hrETdWw6wdVF
	XjcREniKaFCrsX1xZBYGmP+WdHx4VLlXTa43jz71OXHDLS1IZXnvvVI0E2fFZcmQ
	Mwdti29R6Ft0c0RTwqbmRtUbo5h/8DBpY4spsrw8jeRzjA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k5BkOet_jlXo; Tue, 19 Aug 2025 19:49:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c60Xm5Cxwzm0yNR;
	Tue, 19 Aug 2025 19:49:42 +0000 (UTC)
Message-ID: <58622f7d-a075-40b8-a2ea-190058d2737e@acm.org>
Date: Tue, 19 Aug 2025 12:49:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
 <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
 <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
 <36c7bf20-7dd4-4e19-8bc0-461a9f8a4228@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <36c7bf20-7dd4-4e19-8bc0-461a9f8a4228@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 11:34 PM, Hannes Reinecke wrote:
> and if we move TMFs and all non-I/O commands to reserved commands
> cmd_per_lun will only be applicable to I/O commands.
Whether or not reserved commands should be used for allocating TMFs
depends on the SCSI transport. As an example, the approach mentioned
above is not appropriate for the UFS driver. The UFS driver assigns
integers in the range 0..31 to TMFs. These integers are passed directly
to the UFS host controller. Hence, allocating TMFs as reserved commands
from the same tag set as SCSI commands is not appropriate for the UFS
host controller driver.

Thanks,

Bart.
