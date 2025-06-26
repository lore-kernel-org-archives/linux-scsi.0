Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843472EAD1A
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2025 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750952456; cv=none; b=NVtTw/efVxvC87p6tG0NIPMmHYVRR8lTK9A9oVx1jTeuNa3Mw/9/Vtt3HML+jJhtXZB9pG8LJgDSTiGYCQX4bnyHpsCcBPyLCl8kRG9Q0nRbdV7QWKzW0Y/khxq1zgBzuK0VxQgNuBSFjXSE3oQrZUaXFxCVMmHxedu+rGTUytI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750952456; c=relaxed/simple;
	bh=rwOjKNtMXhEyDkXSCMU++DOn23CSXdnTBPiVTC6em7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OydrEtHo2qKwwfWyPj6cHDsPyCSoKpgFpx2vsa0BId2m3R23erfaCJKVOCGxamx2jLBZZeoX1v1SW0KPpIRKTPRy3Mcln08Da2dOyFHPgORM8r6Qt6QLTvab9/mL12LwcEUUHvuHcnJhmKRBB7c0/DKgs/VxebUwUQcMbH9lpVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QCJByWwY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QCJByWwY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bSjZY2DWgzlgqW1;
	Thu, 26 Jun 2025 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750952451; x=1753544452; bh=ZErAGvOUmizNx9ghESk8V4Sg
	2uiP781JvxTECAT5rJU=; b=QCJByWwYiSIB/fpD/hsXP++I13PLsw/DfoQHLcgZ
	O6r1E34KWiZRrR6RRCa3P67V0leeqjCHDwojou4Rnrudk3MaTKgE98I2OdR8aF2E
	FwLEPBOt5LZ72SoME2rFOsJuWXz8/CY1PwJgWji0T8h2b6HwnsRTF0oPa6LQp4ZP
	erLROepZXwkKenClitJKUmmrTR1iJIvcJdHdETJg/Lod38qRVIUCsgn376So+8dM
	rlTM44FlkYkNW25CVD7r1pOZf4mdijxuBxKBcyYm7TG9vz4e3Tzt2rAXQ1DsN78B
	d8HXUfU8cgqeijhvq8+MJa6vxsoAcUHggvR6g0Ju5oab0Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dJfWVB3BcH0J; Thu, 26 Jun 2025 15:40:51 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bSjZS0bcHzlvbmg;
	Thu, 26 Jun 2025 15:40:47 +0000 (UTC)
Message-ID: <c6b5d62b-e039-4e3b-80a0-6ddd19624c29@acm.org>
Date: Thu, 26 Jun 2025 08:40:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-2-bvanassche@acm.org>
 <302ceae2-176e-4c89-8f44-aa2169ca2840@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <302ceae2-176e-4c89-8f44-aa2169ca2840@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/25 1:36 AM, John Garry wrote:
> Is there something special about the logging code that it even requires 
> that const scsi_cmnd * be used?

No. Declaring pointers 'const' helps to make the intention of code more
clear to human readers.

> Or will it be encouraged to use const scsi_cmnd * elsewhere in future 
> (after this change)? Or, further than that, convert all scsi core code 
> to use const scsi_cmnd * (when possible)?
Many kernel developers don't care about declaring pointers 'const' even
if these can be declared 'const'. Hence, a large scale change that
changes struct scsi_cmnd pointer to const pointers would be considered
controversial.

Thanks,

Bart.
