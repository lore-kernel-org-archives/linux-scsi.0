Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7235229B77C;
	Fri, 21 Nov 2025 21:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763759869; cv=none; b=tD6ylFkoFgR1AFLhf+tCXs7Wfd8Nah8xO3jQna9KqXaWKXNDuUgvM59F2MrjAQ3rlZAQUeSnEd/JC/ckZxnvZ5v9tMqyHgkJOc/mtMcVubv8u+WRJkP9+fOrsmssypCz19PgJvRwwz+EHslccZ7x1nscPFyvHk7Gd9aGAuCiyzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763759869; c=relaxed/simple;
	bh=ECVZndL4qQqdTOz+dA2RzYbgpk1skRciNb9m8d6BYko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HbY4exaIAn6NoLOqdh6/FG0cJxOsgSZp7it+u/FSME10WPYZL94CqBbspUExV+E4R/5PQ0p7685qc6v7uHZCUG9to4Pw8b8cLOS4jQH/APLj28xSgIhckKED7zhV+90qwidSpQfSajvDoxH6DDxpwqeorS6mHshJYKrd2HOiwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2m4zeB20; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2m4zeB20"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dCp2y3BJ2zm2kJt;
	Fri, 21 Nov 2025 21:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763759865; x=1766351866; bh=ECVZndL4qQqdTOz+dA2RzYbg
	pk1skRciNb9m8d6BYko=; b=2m4zeB20DMcxCG7anknksWQaHPk8YN3EUZ9AEJHs
	4Fw/WFU80t0H2hHJx7g/U355JB0l2MHCCN7wdMX91XWCaLFT15qurB/p7bN3jd2D
	yeC4E3qt58Sp9jkL/c5DeBc1WC2ZxVM6bpgdR9OztZRGTLPVeNkTVcBtTR2OupdW
	rzUDbFm7XmY9DKBti2DHWYwwmJYAhEdRGdUgA73LrnF8okww4e60viYXyGCoxUYr
	LYFrmtcAQqoLOBopJMO5qb+/Ovr+Y18pEgKFwoEqGpbRhXDcuctFr4x6KnNi1gnO
	9Iog8L29PGxfppH1TwbLBWD/saVh+VV1Tz8mIiD+v1W0QA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HVM6Vi7Y_xvy; Fri, 21 Nov 2025 21:17:45 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dCp2t2hwfzm2kJN;
	Fri, 21 Nov 2025 21:17:41 +0000 (UTC)
Message-ID: <c7d42cdc-dbf8-4eda-9844-70755a728d2d@acm.org>
Date: Fri, 21 Nov 2025 13:17:40 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Increase SCSI IOPS
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>
References: <20251117225205.2024479-1-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251117225205.2024479-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/25 2:51 PM, Bart Van Assche wrote:
> This patch series increases scsi_debug IOPS by 5% on my test setup by disabling
> SCSI budget management if it is not needed.
(replying to my own email)

The kernel test robot reported that this patch series introduces a hang
during LUN scanning for ATA devices. I have been able to reproduce this
hang in a VM. The root cause has been identified and a fix is under
test. I will post a new version of this patch series after testing has
finished.

Thanks,

Bart.
