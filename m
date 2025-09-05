Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EFD1D86FF;
	Fri,  5 Sep 2025 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757090494; cv=none; b=CaqkCVsGul2DUsqoOTAGz6dm2aom5CfOLa6Emu5dltZecxixiTNONCVfPDCjMRRwt69xNSrgGMcO7NI1AOGDl1GIywkkBiB6v8wJdtfHk4Po0pvmr0uNSTDvG611xpB/Am9F4+B80KKV4Ln81+9/TXUSneUJGiLzTAmcZHfpIY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757090494; c=relaxed/simple;
	bh=X+dy/P7fvADNrK2R5d5Nq0lpWyLtghM1AHPMmLmPzJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDB+KqYsm5J7ZxJZf7Tq6AA0a727J7zcPvhjpNxw/sst7KlsMXc+AOgfSaY4iTQ0/0jg8t1qYZg7+zb0zc6rO7MI4fdbAZLZjnmbv/0Usaget59SWjfHFqJlNHGnJUUZuJ8lQFNT/uzGgN8Pcd/aTE5SokcQkdCfE/V1jC5b2/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VxR1rMsb; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VxR1rMsb"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cJMYl5LZtzm0yV5;
	Fri,  5 Sep 2025 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757090488; x=1759682489; bh=X+dy/P7fvADNrK2R5d5Nq0lp
	WyLtghM1AHPMmLmPzJ4=; b=VxR1rMsbjeLN9JyNF7GPcK5mC4XZMyu+dT4xrIyI
	/Mdhv4c/fLaxJukWvmAr72+oBMy3ZytQIbMHv/89th8KVyPmGcsq8bPOLBQdlhT/
	esbIZCJfVDb7qYaEePXDeQzJRjgwBkPB1AI/M0l2kuMK9MF+LLFuygvBDMppnEeb
	AqToEemrVlgh7xaYYtOzqFMQlGORLXmHAcHzyor1HRPnVAiIUpX0H6lf1Gp5yLsZ
	8c7qAo0iPtDVA7+BxegJ0BycmZ8tRUfnTOOMfsGMsQc5v0EErTkiH9CR5oebfi08
	3ZwbJc42b6p6lvsQ86ndiP1NuqNuRZqKEC4Heu8SyrvnVQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JridTDHfm0ir; Fri,  5 Sep 2025 16:41:28 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cJMYd2ZLqzm1745;
	Fri,  5 Sep 2025 16:41:24 +0000 (UTC)
Message-ID: <52a49b3d-be7b-464d-9566-e7b6bcbfdfde@acm.org>
Date: Fri, 5 Sep 2025 09:41:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Replace kzalloc() + copy_from_user()
 with memdup_user_nul()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250905103144.423722-3-thorsten.blum@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250905103144.423722-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/25 3:31 AM, Thorsten Blum wrote:
> Replace kzalloc() followed by copy_from_user() with memdup_user_nul() to
> improve and simplify sdebug_error_write().
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
