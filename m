Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBA32C315
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755537447; cv=none; b=CS1TBM4dKqGe7evfLOgq3chqJhOGhmghrLp9Bo019pH/sVcK3KT/hEO1BZ969WIpQwME4a18B4AazD7tYrWwdL3lRwSBQVoBYSs4VgNGVsSQDSBfwAxbAiSEPoYWfAPpTEVgYU2xfG3k/H/NNAWd7qTdDUcZxKfZ9WKL0rJEig8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755537447; c=relaxed/simple;
	bh=lYq19ZIXDOaVcfz8juSCjsvBbm5PkUUNyYkVdZF+gF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TBX+EO2XqY3KX/xIjMsgeuTCP1ytjHEYmHZlyZfpw6m9ENzAs6u6N4pevAp1KosVq0nK3vLj7Edvj0AYGQkpfGl3X5qvlN+D8WKcEJiorjtnf4oTa2r5AOoaQwf5Gtam6EZAmAWi2H7TEDxAZapNgp1DCAATvusSOyo8cBFabMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FZS2gB8H; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FZS2gB8H"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5KCR6bV8zlgqxv;
	Mon, 18 Aug 2025 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755537442; x=1758129443; bh=VBkq2ehhCNsaVJERtFFGt0Ue
	CHylKs5Dwwk629JpUKI=; b=FZS2gB8HKrm3hpRXrLj3HybuRuxTQthnfaTrj3j7
	gkYeMchvL1zBZUjgOxZSdaI8MeYnqSVByAZuJ3UVEVXpOBEAViIWdEFrJ4L/Q0YP
	1gWEKTtArFSoWj+TBAJCqPSlrkIs/83y8A8dr+dsWBZn1ECp+WjfYV2gNF47WjS3
	810GXS+ekv2+t3LY9keBnvJsNLKa97EYewgWVG5iTO3hFZhKz2CwPx5bc1XOy4Nl
	MUwtHRq8emCi68gMHdjSU8whLf/FCzjk0BAoiq/o/0XOtqsodIaIadAE1CwVWqLC
	bEGvn2nNhYGirYFabDebMD8GytDQXUCz7NAMyjVqSxahRw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id j5E5ya3Un713; Mon, 18 Aug 2025 17:17:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5KCM3NW2zlgqTy;
	Mon, 18 Aug 2025 17:17:18 +0000 (UTC)
Message-ID: <2dada22d-2e1d-469b-8aa6-4a026a670b57@acm.org>
Date: Mon, 18 Aug 2025 10:17:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-2-bvanassche@acm.org>
 <83347952-255f-4362-a7e4-f9f501ce6cb5@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <83347952-255f-4362-a7e4-f9f501ce6cb5@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/25 11:03 PM, Hannes Reinecke wrote:
> Is there a cover letter for this patchset?
> My mailer bunched it up under the first patch, leading to the wrong 
> impression that it's just about converting to 'const' arguments...
> (And me nearly ignoring the patchset altogether).

Hi Hannes,

The cover letter is available here:

https://lore.kernel.org/linux-scsi/20250403211937.2225615-1-bvanassche@acm.org/

A more detailed description of the purpose of this patch series than
what is available in the cover letter is available here:

https://lore.kernel.org/linux-scsi/3affc917-6634-47fc-a6d2-5b57a2e34bef@acm.org/

Thanks,

Bart.
