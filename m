Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608AD379979
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035515; cv=none; b=MwUpdqnSdd0b5taY/hBS9UgkBAIpujf2J/6KCuKEE12s2Mqj1w4kVbJ3FRvNDNzYieByaupVBk52i9aFnyTnwtHooFv6EbaIPl6ReBAzuXpsYiV41be81i/VpP6VXGz8gur7xKLgBaZIQj+kEh6hwQM02ciQd4oiamlujfrk0jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035515; c=relaxed/simple;
	bh=3lsORWD9mUNDK1cAe5I5yG3ym5CGH7p7lWfwglo3hfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J9VtW+xgyYXCBmE0A85fW89pHgOmeoIt9hpKScpqUdlRi7lht+t29NiL1PXn0pjvcsGxuKS+O5bsMx/PxWFf1ZhcH4u6lKDJh3ZmTnqpsFDrn/brVRV97FtZPZI6v8AuZ/1k+qxf50bIL6sZAFHxkuGds8wotOaZKA3Y+IM9DNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NzLdVy3n; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NzLdVy3n"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGD4n6FhpzlfvqS;
	Thu,  6 Aug 2026 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786035511; x=1788627512; bh=LnyEKRSgRG1qdOm5gaE26fxC
	9sifTAehohNQ8NovuKE=; b=NzLdVy3ndrBA+MJTeJXrm1Hjfhi4I6N1KstRD0sv
	s/0sfcLbbva+sLC7gU1V7khRdi166T9D+tjFlt5bbIc0Px8b0gTP7zM5pmCisLWC
	U/ucq7tZBBHntL0EjTRnuj2PFTOCOJv7sQuJVplOv+sKb/GncXHkM+eVKCGLaBcK
	uWyZnweSxBrKmRDv1HgUnwstM1T7eLd7Y4n2g7MG5YI6XCPnS6Eq5Ru1zcJ503sw
	nAMuFHw7u9bNE8idLrpa9+Srb6PAH65HAVCqzBeSLJbR/1z/paVOuw3rsZpjyx4/
	Bi7feqr0pspFbwlDNC/VuYH8wH0nHAgxyHmL29RpE2L6Nw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id j--a92rB8pvi; Thu,  6 Aug 2026 16:58:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGD4k0vQqzlfwHS;
	Thu,  6 Aug 2026 16:58:29 +0000 (UTC)
Message-ID: <9af725d2-b2c6-4389-bf1a-abc565407ecd@acm.org>
Date: Thu, 6 Aug 2026 09:58:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/6] scsi: core: Enable lock context analysis
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1785965531.git.bvanassche@acm.org>
 <9b8e6e601725f0a6b8ac1b9609426734f4ed502d.1785965531.git.bvanassche@acm.org>
 <11c74ca7-f952-47ca-8dc7-24b688efb7cf@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <11c74ca7-f952-47ca-8dc7-24b688efb7cf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/26 2:16 AM, John Garry wrote:
> On 05/08/2026 22:36, Bart Van Assche wrote:
>> Enable lock context analysis for those SCSI core files that build
>> without triggering any compiler warnings.
> 
> Do you mean context analysis compiler warnings?

Yes, that's what I meant.

> If so, are there files which do trigger context analysis compiler
> warnings?
Yes, multiple. All code changes and lock context annotations added by
this patch series are necessary to make all SCSI drivers build without
triggering lock context analysis compiler warnings:
"[PATCH v3 00/57] Enable lock context analysis for the SCSI subsystem"
(https://lore.kernel.org/linux-scsi/cover.1785451174.git.bvanassche@acm.org/)

Thanks,

Bart.
