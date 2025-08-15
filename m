Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A14529B8CC
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225018; cv=none; b=l3UfnBxfHoUMzad7+wv5UM62qrSxZ/imDpdxoFidGqdcp0aU6nqeIwHndX7+RB7FCAructCkkV8XhFcG1CYo4zjVyop230nVXy3zyFO+wtUFwLE8b89bt9Q6SjD7Q6xSJ9pvW9LCmNrNNNn6KVTitQVIPZ3fM9E1JnwbYcoJTDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225018; c=relaxed/simple;
	bh=r/vJuTW1oWdBUyThbeRGGAyiesdRy1FJsmisj/++hJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOx229eCxiWC8ypxBN0iY3EYr/siR+IHh95rMuSrWQKsuslaYMvQ0qRk9teZREH3y3z9zJvFwR/3q8+UshPg0ZzplqUK8pMCdsHS3rFWfFF//2LJwam5zBBPie8/u5Jib6YptLgVnRcw6KYMMBf/necfZRWDFaHDrRc6qieASTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYd+r0tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYd+r0tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14723C4CEED;
	Fri, 15 Aug 2025 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225018;
	bh=r/vJuTW1oWdBUyThbeRGGAyiesdRy1FJsmisj/++hJY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cYd+r0tk1SvGtRUi5vIlh2bzQ5cPWzOlI3KjNv4wbcvgspJzT1wJXQcVqaFPPIU8f
	 DdyuFwxGAhyfUX47Y52Hxkqk1kLa4Fn9kp37Okju0ob4xk94oxTq+LS4EubEFwDhuZ
	 J8kItN73HnUe0fxf34INAD3YMEZT4RfQZUo68jdteF1A4+P63ypZP+VNcc288n/7ZK
	 PezMK9Krz6Qb9PDfBhWi6WNzYLxlhr8XkHz8twozuzFbRmVOvJ/9pTwkwz07NNm7bz
	 D6ARbMOZPRA+uUlbaKTeuOJ+ud/48Q3XItFBuviUlbwMuXJ4XgXLV0lOSZSYmXl4NM
	 cexKFuZIzAgbw==
Message-ID: <3e710f91-efe0-4241-9d2f-bdca9f28d5e6@kernel.org>
Date: Fri, 15 Aug 2025 11:30:15 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] scsi: pm80xx: Restore support for expanders
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-13-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-13-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") broke
> support for expanders. After the commit, devices behind an expander are no
> longer detected.
> 
> Simply reverting the commit restores support for devices behind an
> expander.
> 
> Instead of reverting the commit (and reintroducing a helper to get the
> port), get the port directly from the lldd_port pointer in struct
> asd_sas_port.
> 
> Fixes: 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID")
> Suggested-by: Igor Pylypiv <ipylypiv@google.com>
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
