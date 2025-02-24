Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C176C61
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740431721; cv=none; b=sA7jeRB4wOgzqxhLwSLL8Ch4Mh44HqQOfwhATPHgRPoJ7GvGhvPz4Xf6Qp41PS5YzmoCXZH+m/QYOhCluz0JbiVBAp8PpkDDK5cglurAa80Dgjxd6q0m/nk5ko8ABtiedGN2kNv8QxMhUS1MyVE4kodAk0F2uzjkAR4xPaE+KT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740431721; c=relaxed/simple;
	bh=/4m5jMTxyyJ/2QgFVzaSGpO4RG/BTtBdd9OhH7sDtew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jeQwgb9BOLhz27Mfh8/Umki/QuqUandJlXLyyFpTHtxji/ixy6ncaYyFriqCJBkafdkGItFq7WHu3LbY3mWmCpoVSrMnIAXZGJRbs+MzaMw7MZQO6hpKrD6/xgm1G6bzorlao0TCv970MMeHeojql0NdWBdyQ3EOowxDJiXNWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EPbgnkBY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPbgnkBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740431719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JwYk+qvRdHeCT5O5Q7IhWc6fPywrFLLusUUTjdta4A=;
	b=EPbgnkBYfmFMpgRS8a9fGsf9nOKkBoKt11OUH5Cp4jk6tUvdkHWBM0B7pY6bsYO/kXhWXw
	JPoJoFqUmkSjwO6BIrIOL7HB3ycw10F+cKQ/H2nIbyjkKzhKTdGOHeh5qiRaa0uzmlchov
	n1aZHFoFFJtVztRLI5rSXC9sguemiRw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-QRhWZUukNpy373_fA-o3sQ-1; Mon,
 24 Feb 2025 16:15:15 -0500
X-MC-Unique: QRhWZUukNpy373_fA-o3sQ-1
X-Mimecast-MFC-AGG-ID: QRhWZUukNpy373_fA-o3sQ_1740431712
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36546180034A;
	Mon, 24 Feb 2025 21:15:12 +0000 (UTC)
Received: from [10.22.65.70] (unknown [10.22.65.70])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9161919560AE;
	Mon, 24 Feb 2025 21:15:08 +0000 (UTC)
Message-ID: <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
Date: Mon, 24 Feb 2025 16:15:07 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 pheidologeton@protonmail.com, kernel@roadkil.net, maokaman@gmail.com
Cc: Sagar.Biradar@microchip.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
 Scott.Benesh@microchip.com, Don.Brace@microchip.com,
 Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
 <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On 2/20/25 9:38 PM, Martin K. Petersen wrote:
> 
> John,
> 
>> However, I agree it would be better to just fix the driver,
>> performance impact notwithstanding, and ship it. For my part I'd
>> rather have a correctly functioning driver, that's slower, but doesn't
>> panic.
> 
> I prefer to have a driver that doesn't panic when the user performs a
> reasonably normal administrative action.

Agreed. The only clarification I want to make is that users will
not see a panic, they will see IO timeouts and Host bus resets.
It was my mistake to report earlier that the host would panic.

When aac_cpu_offline_feature is disabled users will see higher performance
but if they start off-lining CPUS they may see IO timeouts.  This is the
state of the current driver and this is the problem which the original patch:
commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based on IRQ affinity")
was supposed to have fixed. The problem was the original patch didn't fix the
problem correctly and it resulted in the regression reported in Bugzilla 217599[1].

This patch circles back and fixes the original problem correctly. The extra
'aac_cpu_offline_feature' modparam was added to disable the new code path
because of concerns raised during our testing at Red Hat about reduced
performance with this patch.

> If go-faster stripes are desired in specific configurations, then make
> the performance mode an opt-in. Based on your benchmarks, however, I'm
> not entirely convinced it's worth it...

I agree.  So how about if we can just take out the aac_cpu_offline_feature modparam...?

Alternatively we can replace the modparam with a kConfig option. The default setting for
the new Kconfig option will be offline_cpu_support_on and performance_mode_off. That way
we can ship a default kernel configuration that provides a working aacraid driver which
safely supports off-lining CPUS. If people are really unhappy with the performance, and they
don't care about offline cpu support, they can re-config their kernel.

Personally I prefer option 1, but we the thoughts of the upstream users.

I've added the original authors of Bugzilla 217599[1] to the cc list to
get their attention and review.

/John

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217599

