Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D7C3624C2;
	Thu,  6 Aug 2026 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786034205; cv=none; b=tpGLpzM+x6vFCjWu+SH+351RDrCohPdkSD30h3rLcKk22SWguIef/mhV9etZuk5jI+p0KADoURWmDXEMNANmP02T/EtNI70dkFx8cBbk3kuk7h3e8+J9AIGEsfE72g+PnLgICm7ltMGjVfKSVBJ24hAqXMQG25fJJHBWPMUfoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786034205; c=relaxed/simple;
	bh=swJm/Dw/JOvxaAnk7CNqyN4lTnj2yTaK3u5nw5/9WVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Piu7UM7+2UdTW7c0pNtQWj89TZE2rvWYLRFphPvZNzWwfJWt8VNI6p9qmle6hsR18LQ7Q+kho2EPSeo5YRbJH84T2TpL8D7EF/Cz5CDAlas1b+xnIijWQSWOjrCO3fv5kphQdZcKB52Xecl4xrFIPY8eGmhcgjKW0KE2muo99Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y9hJ26Zt; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y9hJ26Zt"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGCbb6cqJzlfwgF;
	Thu,  6 Aug 2026 16:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786034201; x=1788626202; bh=XFUrwPZaTMTFBb54CQcM2q7f
	/BkecJBgoDXEJ6mySYg=; b=Y9hJ26ZtRKR1gTczwh8IM8X7cib41SzFwmWhOjjG
	UYxYP9X2jqXGNZs2zpzVcqxmf/XeEtAqvdPU+m9Kx0ZNbnBJsZBOsj4k0l9L5Qff
	Odtl8iXnqa+dwSkTcDNloHO3D5dtXG1XXPH39yewB6PvDfG7guM6av0ySt6wPxdb
	PPfZNl8OAAZuaUezHnvW32yJ8LGc7KH3i0Yu0o+uQcOOam7SusfDsiXhsPNo0heh
	uo5suAU/o59isuzzFNQdHU2e+ALc8c0g1+Bfz6yMigRKBda3c5TlpevItOBOq+3U
	LWuXMZnvknCqQKjqC+5/ITGINZfqBcp9jz/j6ThA/79zMg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FEfK0LDoJjkz; Thu,  6 Aug 2026 16:36:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGCbW4QHwzlfpLt;
	Thu,  6 Aug 2026 16:36:39 +0000 (UTC)
Message-ID: <7506e54b-8c5d-48e1-8d1b-59bab17cb4fc@acm.org>
Date: Thu, 6 Aug 2026 09:36:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: zfcp: Enable CONTEXT_ANALYSIS
To: Heiko Carstens <hca@linux.ibm.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Nihar Panda <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260806134759.2122369-1-hca@linux.ibm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260806134759.2122369-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/26 6:47 AM, Heiko Carstens wrote:
> Enable CONTEXT_ANALYSYS for the zfcp driver.
> 
> Static code checking for acquiring and releasing locks used to be done
> with sparse. That was removed with [1] and replaced with a clang based
> approach [2]. The new approach requires that each subsystem needs to be
> explicitly enabled for checking.
> 
> Do that for drivers/s390/scsi. Add a __must_hold() attribute to
> zfcp_qdio_sbal_get() to address the only valid warning. Then enable
> CONTEXT_ANALYSIS, similar to other patches for drivers/s390 I'm currently
> working on.

These two patches could have been combined into a single patch. Anyway,
both patches look good to me.

Thanks,

Bart.
