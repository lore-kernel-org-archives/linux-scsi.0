Received: from mojo.mkp.net (mojo.mkp.net [104.200.29.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B613D539
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 03:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.200.29.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415870; cv=none; b=Rln47VMPWB4jMYFaD3lR55puNIzpkCaUz2uaNpa2BFC3pr1sKkO33BCwcK1ilooqCd30FX4TUFZ7N1B7v0UEYsiiGlQbAE5jBMFcHCwzSs2hXyiWP2RSd0aTKHWEnc+Yd8J0oN7FnrWVRL16TTQ12RHd0BJe0alt9Z4QiM+pw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415870; c=relaxed/simple;
	bh=kXGb8AHElzY9VkopSOKnhOgIpJvPCyaUI+l24gccIAw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=YJKbH6vFPeadjdFLjsahpizFLmgvXoWqrSmOJk+6AYXq8hypFoQvSkbqjvfmCxgx8YbSsoAuhSJtGnXJ1vjJOy+w/Src6zpnZGFoAj98JpguevyVHTVbvDMXguT8QSwJz4mvYCUEuL3p8pxRLA8f/yfHRu5taiEsd4UbidonN9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=oracle.comjames.bottomley@hansenpartnership.comjmeneghi@redhat.com; arc=none smtp.client-ip=104.200.29.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=oracle.comjames.bottomley@hansenpartnership.comjmeneghi"@redhat.com
Received: from mojo.mkp.net (localhost [127.0.0.1])
	by mojo.mkp.net (Postfix) with ESMTP id 04104BF03;
	Wed, 12 Feb 2025 21:56:11 -0500 (EST)
To: Sagar Biradar <sagar.biradar@microchip.com>
Cc: linux-scsi@vger.kernel.org,  Tomas Henzl <thenzl@redhat.com>,  Marco
 Patalano <mpatalan@redhat.com>,  Scott Benesh
 <Scott.Benesh@microchip.com>,  Don Brace <Don.Brace@microchip.com>,  Tom
 White <Tom.White@microchip.com>,  "Abhinav Kuchibhotla"
 <Abhinav.Kuchibhotla@microchip.com>
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
From: "Martin K. Petersen"
 <"martin.petersen@oracle.comjames.bottomley@hansenpartnership.comjmeneghi"@redhat.com>
In-Reply-To: <20250130173314.608836-1-sagar.biradar@microchip.com> (Sagar
	Biradar's message of "Thu, 30 Jan 2025 09:33:14 -0800")
Organization: Oracle Corporation
Message-ID: <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
Date: Wed, 12 Feb 2025 21:56:11 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi Sagar!

> Add a new modparam "aac_cpu_offline_feature" to control CPU offlining.
> By default, it's disabled (0), but can be enabled during driver load
> with:
> 	insmod ./aacraid.ko aac_cpu_offline_feature=1

We are very hesitant when it comes to adding new module parameters. And
why wouldn't you want offlining to just work? Is the performance penalty
really substantial enough that we have to introduce an explicit "don't
be broken" option?

-- 
Martin K. Petersen	Oracle Linux Engineering
