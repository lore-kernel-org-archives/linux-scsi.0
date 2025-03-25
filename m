Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE80D25A335
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2025 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742912725; cv=none; b=Sm2LhydC3wrdmh4ZnBQe32P0TYGAke5cc5WfXkaVy/NAsGC5ZKsPlSky0brRlKDqWQ986ORukBHaV05WpVyUeXQvZm9no7uM01HO8zMy0wTMZUt8GsDA6eHLpQ9rbJVKt9F/duYR/yR5dR5NEYrsLyKApr/08jofMvffz3DB76A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742912725; c=relaxed/simple;
	bh=7R6JgDEPzrvW/21WVk0bEN9ZAcsm2QkH+g0sRtv+rpQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=JKjHoY9fyAlTgMH5ucxjLQ1GF8JzArCwpwdoAE7JVHc8Z+B3Y1Xznd52jI5ClqGxlKpidC2h4yohfQlyf3SZMGj0OvoheB9DjwJdB8WI+ixv/X89DmCueLjqmF8pW2Obg6SG441k8qu83DR+gaSvHKGTMK47U32HxcLdx9OdAto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ExWOn5jS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ExWOn5jS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742912722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GZlZzYP9GDfFqVDq8IX+yF5ihmOBChNNAERHJt/I6Wk=;
	b=ExWOn5jSlAkNjTJdiCcpl/XOJuAga/fLgwutak1fOWJfW02iUDqYb9bYBRuHOY2vAmh6r6
	RXAhCfuWeaH+JY3TDysTaeAV3uZypoCMxABXMJyS1mhEoFMnhRrHbVGTLA/M1CDGdEdKm6
	X7O19p+KdI749PfueOGoWNwUaYxHnW0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-Gu5ONsEWMAi6R5AJ7Oe48Q-1; Tue,
 25 Mar 2025 10:25:19 -0400
X-MC-Unique: Gu5ONsEWMAi6R5AJ7Oe48Q-1
X-Mimecast-MFC-AGG-ID: Gu5ONsEWMAi6R5AJ7Oe48Q_1742912718
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DF2F1800259;
	Tue, 25 Mar 2025 14:25:17 +0000 (UTC)
Received: from [10.22.88.188] (unknown [10.22.88.188])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 274B71800944;
	Tue, 25 Mar 2025 14:25:15 +0000 (UTC)
Message-ID: <1d664208-7388-4b31-b939-c46e87184206@redhat.com>
Date: Tue, 25 Mar 2025 10:25:14 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: Sagar Biradar <Sagar.Biradar@microchip.com>,
 John Meneghini <jmeneghi@redhat.com>, Hannes Reinecke <hare@suse.de>
From: John Meneghini <jmeneghi@redhat.com>
Subject: [LSF/MM/BPF TOPIC] aacraid IRQ affinity
Organization: RHEL Core Storge Team
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

While at LSF/MM/BPF this week I'd like to talk about the recent aacraid driver patches at:

https://lore.kernel.org/linux-scsi/20250130173314.608836-1-sagar.biradar@microchip.com/

In this email thread Hannes asks:

Do we have an idea what these 'specific use-cases' are?

And how much performance impact we have?

I could imagine a single-threaded workload driving just one blk-mq queue would benefit from spreading out onto several interrupts.

But then, this would be true for most of the multiqueue drivers; and indeed quite some drivers (eg megaraid_sas & mpt3sas 'smp_affinity_enable')
have the very same module option. Wouldn't it be an idea to check if we can make this a generic / blk-mq queue option instead of having each
driver to implement the same functionality on it's own?

Topic for LSF?

-- 
John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

