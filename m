Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F97D278E5D
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 14:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758809905; cv=none; b=G/1LlVqjvQzlyNEQAHrLNj0FyK2lGjUERbG7DBJrNPKhYpf8SpRI9F9LoEqodhqu3Y6zBKQfSn47ou9IUbrencqAunYT2csgh8wO6DnXB5O7vlVx3gdvRjLxoAYCI1aBetTGkes0HiOtnPIQ/HPI02j4Riv0cxoW8IUhnuQCwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758809905; c=relaxed/simple;
	bh=K2D2iqg1CDpOaCq53XTu1xGRcXsuf5pMcNSBp7DY3qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KTE4Y2H6/SVTSZ7Xcg0GJxDKhrt/oJo1fE0eEndQvHTOZt0JInjN2twrBF5ihcQzn0jMaSjtze63FtKi4UYdWZUv0RVFOhhvp7qeo4ITQTaPR8PhDTU62B19TqoDYIYdeUoM+TU1FQS8XnSZ0FyAqad+kLcD/nNz2U3Q9rrYoiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R3KXFX4e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3KXFX4e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758809902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NLgbSsFjchtFmvfbazfVlnKhqiQnNP0m9v1472hwd3k=;
	b=R3KXFX4eerWxD1xZPdBtQxQsbfX/9lxEx6DraIbnaXAzYe8VvRM219aSsBSYmtVy1hF3+x
	UrARoHafJmW5HJffLOp96DcTFz2VR0yfzX0tjVdzNq4VZK/k9OFlWzo8TlQMJZpGZfXY79
	K3KfD4LpwemoSyfVwFJgbYnXPgHJ/aI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-QamC6vnNMQe10HReUsJafw-1; Thu,
 25 Sep 2025 10:18:19 -0400
X-MC-Unique: QamC6vnNMQe10HReUsJafw-1
X-Mimecast-MFC-AGG-ID: QamC6vnNMQe10HReUsJafw_1758809896
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F3DE19560A0;
	Thu, 25 Sep 2025 14:18:14 +0000 (UTC)
Received: from [10.22.81.200] (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 155871800452;
	Thu, 25 Sep 2025 14:18:09 +0000 (UTC)
Message-ID: <fbbef12e-fc43-464f-b92d-f42f3692a46c@redhat.com>
Date: Thu, 25 Sep 2025 10:18:09 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: qla2xxx: Fix memcpy() field-spanning write
 issue"
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, martin.petersen@oracle.com
Cc: axboe@kernel.dk, bgurney@redhat.com, emilne@redhat.com,
 gustavoars@kernel.org, hare@suse.de, hch@lst.de, james.smart@broadcom.com,
 kbusch@kernel.org, kees@kernel.org, linux-hardening@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 njavali@marvell.com, sagi@grimberg.me
References: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
 <20250925130729.776904-1-jmeneghi@redhat.com>
 <fcdb0a83-3b1c-42bd-b58b-b501cfbf27fa@embeddedor.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <fcdb0a83-3b1c-42bd-b58b-b501cfbf27fa@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 9/25/25 9:38 AM, Gustavo A. R. Silva wrote: 
> On 9/25/25 15:07, John Meneghini wrote:
>> This reverts commit 6f4b10226b6b1e7d1ff3cdb006cf0f6da6eed71e.
>>
>> We've been testing this patch and it turns out there is a significant
>> bug here. This leaks memory and causes a driver hang.
>>
>> Link:
>> https://lore.kernel.org/linux-scsi/yq1zfajqpec.fsf@ca-mkp.ca.oracle.com/
> 
> Thanks for the report. I wonder if you have any logs or something I could
> look at to figure out what's going on.


We have a fix already.  Chris and Bryan figured it out.

> Bryan,
> 
> Could you please share how this patch[1] was tested?

Bryan, please reply with bug fix patch you emailed me yesterday as an RFC patch.

Gustavo, this patch is being tested as a part of our FPIN LI changes. To run this code you need a Brocade switch and a whole lot of hardware.

You can see a example test plan here: https://bugzilla.kernel.org/attachment.cgi?id=308368&action=view

I am about to submit a version 10 patch series for these changes and I will include a new/fixed version of your patch in that series.

/John

> Thanks
> -Gustavo
> 
> [1] https://lore.kernel.org/linux-scsi/20250813200744.17975-10-bgurney@redhat.com/
> 

