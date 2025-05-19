Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E11E1A3142
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2025 20:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747688392; cv=none; b=rYHpTEN/lftQ5mudzQu1JM52siw6TbVXRPJ9pMvtGstZdTC4TtmTVz/kpQ1eYKmqS6h9+l8cS6XELsu7f0nXG8KCosTLw5soRj/QmrVRUdifBIPzM60qiblMVyaPxcE+BwEwrF2cvTME7D4fDDGQd8LWVyc32Ss4Ohrmk8TCSVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747688392; c=relaxed/simple;
	bh=AHnn9jYAJ3ruYkJqmCITADBas1l7GWnNOASoz9riNZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWZraAjkJIF1HhSjdA+WN/SQ6f6RWDOLOXb+SEtSU8+JJzyG5WX2JcAZnUxTc+JCm6lT/ADTZug2+x55pGq8yUtKbi7ikFRqOEfMotwjkt5T4fA6MAkN4Q0GkHCwcc1k67SbnO1rYGqA0hxs5d+oAOWVotueleD/u3Qyd5BQV2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OYtTVHLx; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OYtTVHLx"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4b1VRz2l2MzlgqyT;
	Mon, 19 May 2025 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747688382; x=1750280383; bh=8aYX20HctfRxrsFmxSLnQoCs
	vr5/HEHYzzg+Eqxa0yM=; b=OYtTVHLxi7F4CWAGePjUXrfRv9y3NU6Iyg+TWbJZ
	O9fr0okkQRcmDa7qgvI/PFthpco6SMFPfT+IgbILOixsns+n0E7aqr53Fzj2I6+j
	wdHAqzK/EuqeLORktYHSOQg0HWEPTM4n07O2yV099KInGpN5Q391yLieNPh9UnuG
	EjWeI3HaO9h9JFs5S04bCjKCaLeqL/EvzVHsuFTpt9ogNY3ARaEOTDngpguTVKVD
	7VJJhi5HLGDojool46UYd3m10uO/VcayNCIZbQzJDrjRwTsR4ZX98K/25e7C+8gB
	9ZVxO/susW5hKBQAAwreE9+VPxJaqQ7I/wg0ULqI4CFXqg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2M1WhUde9RrL; Mon, 19 May 2025 20:59:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4b1VRv3k34zlgqVt;
	Mon, 19 May 2025 20:59:38 +0000 (UTC)
Message-ID: <ee1315c1-7773-4148-83bb-66d3a5d865eb@acm.org>
Date: Mon, 19 May 2025 13:59:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Make max_sectors configurable
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250515173537.1024421-1-bvanassche@acm.org>
 <da0c5ef2-4bb9-4229-9486-c595df25347d@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <da0c5ef2-4bb9-4229-9486-c595df25347d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/25 11:04 AM, John Garry wrote:
> On 15/05/2025 18:35, Bart Van Assche wrote:
>> Make the SCSI debug host parameter max_sectors configurable to make it
>> easier to trigger request splitting in the block layer.
> 
> Obviously we can do that via sysfs with the max_sectors file.

That sounds like a good enough alternative to me. I will look further
into this approach.

Bart.
