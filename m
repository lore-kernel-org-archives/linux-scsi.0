Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568F3033F5;
	Tue, 10 Mar 2026 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164650; cv=none; b=JgweNjLU2f9PomeDZ6N4aN8VDTL9nqMMyzPdq18DCT3SurtJSwpsUBQZeDRGC/JPAtiG8emEAgxXM7nhg44SM7Nb3TCilRJgJATAZ1NM3fgHIJ5wjs7xH+GENBoTdG+DlgtRKPCeZN32+rKjjK0u+uiIXP5RyUw2jOebakmt40E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164650; c=relaxed/simple;
	bh=vHgTbX0U48RwsmfhpB0jSFedN6iaRJzrBIZ2gX5ctEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjVbgDBMLReycn584erQpJlGwdPI1LAtck1LsT+VqTUfBArb9io44Dwnz5iK/sXJfghXUGvkjFJ1n1S3Mq4dfz92VqIwAO3pvyRib//lAbEZPW/eiIMKonejeT5YpbgXvQXA5Wr9Q2G9bjNR2PDEwmyHcF/NYzkWXDzmN3AHb9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P+A6vKt9; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P+A6vKt9"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fVh89258Mz1XM6Jk;
	Tue, 10 Mar 2026 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773164647; x=1775756648; bh=vHgTbX0U48RwsmfhpB0jSFed
	N6iaRJzrBIZ2gX5ctEw=; b=P+A6vKt96iiKbxLqwxl1y06Z4TNmjqyqSbdEvb1R
	CUfaFgY9hl7j88dxRCd/+/OpAEnFv8aOUuD5Od4m1I9jretHa+weCjlrZM+esQtK
	HezgWh4iKFO2nCZIxKT/Rcd0ZZxpAExNAEavCay1OTGuMFH49uv6t3M0mWLXzQjE
	i8xmeb1+mQh6eOCHR16p4hzdYIxZmaxYRJTK40AiLxvyyAsJfB6k8kWD6z1EhhuH
	LTeQb9xqRMODqldUlD9zYfio02GjQ6vRoAhmM+2LE83yEcrOAWTvuPue4ZSVjotj
	KkUNuCyqDLAZTNBIUfzSwm35BLbwQ0MSEw+jezDAecnAlQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cgm_7vhVTVgO; Tue, 10 Mar 2026 17:44:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fVh856zWyz1XM5kD;
	Tue, 10 Mar 2026 17:44:05 +0000 (UTC)
Message-ID: <ea5c0f22-5f80-416e-a64c-79bfee98f79a@acm.org>
Date: Tue, 10 Mar 2026 10:44:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Nova Lake
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260309085815.55216-1-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260309085815.55216-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/26 1:58 AM, Adrian Hunter wrote:
> Add PCI ID to support Intel Nova Lake, same as Intel Meteor Lake (MTL).
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
