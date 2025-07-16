Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DA72F4A11;
	Wed, 16 Jul 2025 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681082; cv=none; b=RGDq0YY/yeUsPVeV+bccKEfIXu9CCgW8yevhn40l1+xfXZsSYqyDRRe+QN131Hu2PfVqOI63PEPJLXJC+v+NIeEtAidWEzmBrDBwnomFAMGfP5KQCfpAjJR0xql43Ycn2LiUVT9GAc42ZakOwVkKrLh/JYtalCymk0a+14bIFKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681082; c=relaxed/simple;
	bh=Dm8rijWUH5OUWDPuGsMhNhNTlMOrxKsYEJm3carquiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZSxdt811q4JI1Ys0V39vjnZQCMYS03f+k3e2f98XBk1Y8i1S2eSGHAcQtY/n3ID1kS0bAbeGHNDtqp+RQH3GIO5z0GuZahguWguRA1NlOUXIsjUp8rZW4MSirjmOJWL1s37EvNDSlHCphfLpjl4XspVgYuNmv45q08hFu0TGRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SXPTsj/S; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SXPTsj/S"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bj0sM03crzm0gc4;
	Wed, 16 Jul 2025 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752681076; x=1755273077; bh=/7ypfGplrxoRCGhGZPSUJXVq
	g/2acYgzyHSBeFFh9u4=; b=SXPTsj/SwN4oYh1ST4EVXe/jq4TN/ry6T01p4zUQ
	m4+t+/+377pKY6amC15lVi5w/YU1YybqlujG0LS124KQceX9a82EzqMdoe2wB0oU
	slhUXE93aJW9E9Tw293iE3lCPzWFlDxl/ZuJCDkmb1TaJ5j9jC62oJWoV46EOOvq
	+pZhOZDBfezuqNtNyfJXVXZNA5mIgOffLoMWsS1EMpVJW1/qv4VULc9RKDL1cuJT
	QsLk5K8De3SsHejfvkx0yhHLgrCeep7eEVZlTpIU7xNq2sKSqYsBspad94bmOGfh
	trxyATdi6PWRsSPW3yYTL8gwz6f4ZP1bU57FwsFm9KGc3g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2gt2ol6DN2bg; Wed, 16 Jul 2025 15:51:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bj0s66LfHzm0yQ4;
	Wed, 16 Jul 2025 15:51:06 +0000 (UTC)
Message-ID: <30f8ea8d-79c4-4e5c-b354-51ad8146a61c@acm.org>
Date: Wed, 16 Jul 2025 08:51:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Emit uevent on controller diagnostic fault
To: Salomon Dushimirimana <salomondush@google.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250716013103.1571029-1-salomondush@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716013103.1571029-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 6:31 PM, Salomon Dushimirimana wrote:
> +	ioc_info(mrioc, "emitting fault exception uevent");

Is it really necessary to log that a uevent will be emitted?

> +exit:
> +	kfree(env);
> +}
Why an explicit kfree() call instead of adding __free(kfree) to
the declaration of "env"?

Thanks,

Bart.
