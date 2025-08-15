Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA77830FF01
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755278033; cv=none; b=twk6qYxsIt2xmVtdJoVu9i8XbJVP1CnJMMxvSOEkdkkRwwdgp2ILCHDIND4S36Jh8UwhnTtaqCTd1TKqIWx5kdpzU/PWL1Ro45mFrEdqoJb7vovC+iN37LNRXy7VNhSROwvSEmyTBGldoxDBHIruQBoz2h1Q1MYu1bVaarnZK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755278033; c=relaxed/simple;
	bh=R5jFMaH2ljNApw+HuFRaK6kvMS/UN+7g8qz/xO8V8pQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uf6vhzF5briELtm3BEBLGCTo9P7eC4IEVg/tc/R4zwhUlit5wgaevnpsBl1vKzo0y/p/n7PmujW4fkDHB6QCMS3F1utVnw1VjGDhTzNd8uN0qhGBfrLuHLk2mJ2NAuJKu2z+x0BGeMUafFGHih24UlTMaXx4AXimbmEul8EVius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tFrQnwAv; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tFrQnwAv"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c3TGk5mzMzlgqVX;
	Fri, 15 Aug 2025 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755278029; x=1757870030; bh=6vhNOzPGg0K2yvYK0T8a5wcb
	Mjt+BeeCTynv2N0dQ5I=; b=tFrQnwAvDqwKP1jgqY2J5/ZPP/xfeDg+zXakJhEs
	yIPvxzx/OlKdziCyYx7nBy2cV1/5BPWmDLhjt7ZYxF3Uk+8gYVKLpj43I424apj7
	TN6WPxneCAn33ee0/V6xFB6tDtdGLbGopnCE3jleJwbXujpb+NSPx+ymkv638H5v
	rlfYfXCoS/8cK2HPVKcK8uQ3Ek04/R8iQy/UIGbVj4m5CTr24pDTizM1xgv5okYH
	dsk1fR2bPqlj2DERtuUVEXrTA0EAPK1LGpX2LQ0LL7oFRl0KoVVPO4dzzxTv6IIc
	JTeagwN92sDma8gtLnqXm181tZayu6dD1+Ufih0Vyi0myg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jkRkQ0PhvUMG; Fri, 15 Aug 2025 17:13:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c3TGf4P9dzlgqTp;
	Fri, 15 Aug 2025 17:13:45 +0000 (UTC)
Message-ID: <e62c01e3-2aa0-4b5e-8b69-a3d04a4906f9@acm.org>
Date: Fri, 15 Aug 2025 10:13:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
 <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
 <26558c0b-d793-4804-a60e-a21ab7116d1a@acm.org>
 <dcb3c431-c9d8-4f9e-acda-a3111bc05c38@oracle.com>
 <c9458843-db32-4619-837b-bd0a87cebbae@acm.org>
 <8feb4887-ec2e-460b-ba53-532cde86aeb6@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8feb4887-ec2e-460b-ba53-532cde86aeb6@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 10:03 AM, John Garry wrote:
> Well that is how life is for other SCSI drivers. Changing the shost q 
> depth with scsi_host_update_can_queue() is a bit ghastly, IMHO.

I will look into setting host->can_queue before the UFS device queue
depth is queried and also into setting host->cmd_per_lun after the UFS
device queue depth has been queried.

Thanks,

Bart.
