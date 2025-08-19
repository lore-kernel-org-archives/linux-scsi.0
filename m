Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0F25484D
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632096; cv=none; b=o23kzvwRnkQKUKgbRcyYXv6I/TK/ZTGbPI7Pt03R3Fi7oqAvNSY6ydvKpC/vx3ACUedQRw5MAf8t9os87Sb+A3k/Ql3F0mStvhiUq/kMBWVpgS/JqJI8FRtnUzC+fr6foPa7NMIyKKIvqh7WmJgkjlNbPdQARlht5lxi3BciNI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632096; c=relaxed/simple;
	bh=wHCSnFZcvrei1FkVshjb/4U9VwdFDhDMGIse+keDzQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DzBas33y5AofPxA03DufrmzVGLBQkTfBchvgWZ/8OdCv8AlA5VNo5d6AY0wML6bfA+4l8tZGm4WiTZMngGD0zesxXu6Gw6ohWM/0W0cDoJmAyvpSMRoUbz84rNQg+MocE2pFXrrnSPpjgzlPRES4t43opWBY6wyutvkXMemZs3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ICLFhGOl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ICLFhGOl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c60Cc1fplzm1746;
	Tue, 19 Aug 2025 19:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755632090; x=1758224091; bh=ZIPFj2VegJq6DW8msHpTQqlM
	Trzb6H4vCI6R80OGJxA=; b=ICLFhGOldqUr22HqlCv1IuVud3WntJ1WDAZw1yrR
	w1yUX2h1k4wu8wtdT+EKwDb0D6bhD3zixtAXT/JplrNC7Wquzl91dBkIaSCvdbTU
	eiy1zZBqotq4aUwq0rrZKi8+v0ootv/d9DRl1poL8j+2bEKD+nvRzczSoDNkY86/
	4BPvuTJjY7EykZvTG1qzGsnl1Z6aVO9slguPKedKRofkMAOJjf7OPOTl+V9NAvA6
	p+2ZSK8aGeSrWcYzWtnkR9mQngsCE8x3HsBgNWowuH9gSfhIJPG1/SA6+XMNFdMZ
	1cTae9cI8wWezrYBAJD6/sRFrZAWvLQHEFVfvh2QpmwYrg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MkHw9tLW8Hlg; Tue, 19 Aug 2025 19:34:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c60CW0ZBZzm1742;
	Tue, 19 Aug 2025 19:34:45 +0000 (UTC)
Message-ID: <a0049c01-3bae-46bd-a5b9-57dc9c537ae9@acm.org>
Date: Tue, 19 Aug 2025 12:34:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] scsi: sd: Explicitly specify .ascq =
 SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-3-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250815211525.1524254-3-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 2:15 PM, Ewan D. Milne wrote:
> This makes the handling in read_capacity_10() consistent with other
> cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
> result in wildcard matching, it only handled ASCQ 0x00.  This patch
> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> if a nonzero ASCQ is ever returned.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 78f5903cc8d0..e3b802b26f0e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2729,11 +2729,13 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		{
>   			.sense = UNIT_ATTENTION,
>   			.asc = 0x3A,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
>   			.result = SAM_STAT_CHECK_CONDITION,
>   		},
>   		{
>   			.sense = NOT_READY,
>   			.asc = 0x3A,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
>   			.result = SAM_STAT_CHECK_CONDITION,
>   		},
>   		 /* Device reset might occur several times so retry a lot */

If this patch is reposted, please consider shortening the title of this 
patch to e.g. "Do not retry ASC 0x3a". Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
