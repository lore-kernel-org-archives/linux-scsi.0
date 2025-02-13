Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA226FA5E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 22:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484242; cv=none; b=RWHDPxh6kLcsvQZqCXB5Ax1V/j92MYW30R/CEkBgYRAIpcUsWSmDRi/ipy3W4OwixZ54/saJPtvWymYPVLIN6+lIOTEeIFHkZ+fW8WVJkf5/LtXR3FlFCx1chMsBnrNJ1tKuooRyOu0JmPzdk4sZ2MZv+0xXLBEoMB88akdtZCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484242; c=relaxed/simple;
	bh=O7PCscfcO8dbarN0vjVAKZFN1V4RdcS28tNjdJG4bfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blhmpjekF/BibEVlJ2Ngn67Qn7eRwi1bU11zZo1nMoV82dBZWmcvqnABRpCFEBnEU5OqVq6EUO1mQ3emJfBwpUu3Dp7hNfgSwgAyWLO93U/051QM01+9HuJWrH7zds+J5U+PrtJye0y6WDRiaYfrLdjW5LdBYa04gET8si36vYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AL/NJja2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AL/NJja2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739484238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4ug0F1v4cDANy/J1MriGiSnkaHYR6GuwHYU0jFmjDo=;
	b=AL/NJja2PbmEoaIvoUyUpwdG14x6nGnktP61/N+ykeG9CrLjRvpUexQYwRl8KxP8gOPAVi
	Qmp5AueOmeHQ+b/sb+LDxsHXtJNUG0OQ5zJZpnFMpNcQGaCYETCwcc/VPkGUC6MF8wAhLJ
	rQK/fsuIXqrtpxuAZN5cSD/8kkRLJ9w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-DxMxhDAwN-iouThTrxpTww-1; Thu,
 13 Feb 2025 17:03:55 -0500
X-MC-Unique: DxMxhDAwN-iouThTrxpTww-1
X-Mimecast-MFC-AGG-ID: DxMxhDAwN-iouThTrxpTww_1739484234
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B15F8190F9C8;
	Thu, 13 Feb 2025 22:03:53 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5CBAC300018D;
	Thu, 13 Feb 2025 22:03:51 +0000 (UTC)
Message-ID: <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
Date: Thu, 13 Feb 2025 17:03:50 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
To: Sagar.Biradar@microchip.com,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
 Scott.Benesh@microchip.com, Don.Brace@microchip.com,
 Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

> From: Martin K. Petersen
> Sent: Wednesday, February 12, 2025 6:56 PM

> [You don't often get email from "martin.petersen@oracle.comjames.bottomley@hansenpartnership.comjmeneghi"@redhat.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]

Appears to still be a problem. I'll work with Sagar and see if we can clean this up.

>> Add a new modparam "aac_cpu_offline_feature" to control CPU offlining. 
>> By default, it's disabled (0), but can be enabled during driver load
> 
>> with:
>>         insmod ./aacraid.ko aac_cpu_offline_feature=1
> 
> We are very hesitant when it comes to adding new module parameters. And
> why wouldn't you want offlining to just work? Is the performance penalty
> really substantial enough that we have to introduce an explicit "don't
> be broken" option?

Yes, this is something that we debated about internally, before asking Sagar to send this patch.

I agree that it would be much better if we simply fix the driver and make offline_cpu suport work.

The modparam was added as a compromise, to allow current users and customers who do NOT care about
cpu_offline support to keep the increased performance they want.  People generally complain any
time there is a performance regression.

The current upstream driver is more or less unchanged when the mod param is of off, which is the default.
So upstream users will see no performance regression... but don't try to offline a cpu or you will see
a panic. This is the state of the current upstream driver.

> Thank you for your time to review and giving your valuable opinion.
> There are two reasons why I chose the modparam way
> 1) As you rightly guessed - the performance penalty is high when it comes to few RAID level configurations - which is not desired
> 2) Not a lot of people would use CPU offlining feature as part of their regular usage. This is mostly for admin purposes.
> 
> These two reasons made me opt for the modparam.
> We and our folks at RedHat did venture into trying few other options - but this seemed like a nice fit.

Another option we thought about was making this a kconfig option. We have a patch that replaces the modparam with
a Kconfig option.

However, I agree it would be better to just fix the driver, performance impact notwithstanding, and ship it. For
my part I'd rather have a correctly functioning driver, that's slower, but doesn't panic.

It's really up to the upstream community.  We need to understand what they want.

/John


