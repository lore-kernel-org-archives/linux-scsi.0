Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CDF1487F6
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2024 20:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731962734; cv=none; b=CqmOGrpCnKg+vWSj843Llfchk2QwU76N7ATp2OqE5br0SmfbMKytdF48SIFqrVdxnpksqMyzppQMrp+aHsf0ivCl97OBRXhm7HYjqYmuzURj6u+0Rzc8je6YQfGwzJCAHYgkf9ac8Wm4HJVz9PqXaUM6L7L0hTlQagcl+SNPpOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731962734; c=relaxed/simple;
	bh=pM1HGj0dZDWrQ+gryHG1m+iCXk1mLUxa8UD0EfAMAoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dh3fGADapWkme06a75xWMo1E+EveErnrp3eeqEhhGvvumqS/VqLg/3FrTUNTjN/N6pWZGv2izKYDuDNqpOQP6Gahgkb9xo1EbuvSXFy9eudtsOm7vsOyohGRxvYzOyQnpRJb0Ji9u7b4s7TsZRM9fH1Q5wxMo0J+M/C8P+kdy/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5IBsVyA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5IBsVyA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731962731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w/5pJfddChMZESUhaaa/X1FyTbQBaboVfW2BkcotxK0=;
	b=Q5IBsVyAXX/43LNEF9AwDclnhN5RbV5pVlLx3pOQAqp/hXhyJ0JwgbwDT0KIMVf3e5XmCG
	KLe/dFX2mG1VVNMMWSY22gLs+ndbtzMmgG8p6kqi0Yi2ioiq6GypcHYttrfrsGsn7acwOG
	qLQS8cD+W4Ywx3gKn/64NxsnXSawxws=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-xGU3lz2ING2rFz6rlcSY4Q-1; Mon,
 18 Nov 2024 15:45:28 -0500
X-MC-Unique: xGU3lz2ING2rFz6rlcSY4Q-1
X-Mimecast-MFC-AGG-ID: xGU3lz2ING2rFz6rlcSY4Q
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6D991955F3C;
	Mon, 18 Nov 2024 20:45:26 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 360FD1956054;
	Mon, 18 Nov 2024 20:45:24 +0000 (UTC)
Message-ID: <cb2546ad-a36a-4ef6-b545-75a25c171018@redhat.com>
Date: Mon, 18 Nov 2024 15:45:24 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: st: Remove use of device->was_reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
 <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On 11/15/24 12:45, "Kai Mäkisara (Kolumbus)" wrote:
> The device->was_reset flag stays set in many (most?) cases forever, unless
> someone resets it. (Scsi_error resets it only if the associated kthread ends
> up locking the device door.) Because the flag stays set, the st device can
> notice it even if the sg device gets the UA.

Yes, this is my observation too. Once was_reset is set, it stays on until a mt load or mt unload command is done.  Rewinding or 
repositioning the tape does not clear it.  Perhaps this is what the code in st.c was there to clear was_reset.

> Using a flag set by an other layer is ugly (to put it mildly). Even uglier is that
> st clears the flag when it has noticed that it is set.
> 
> And there are cases where the device reset does not originate from the
> same computer.

Yes, this is the original case that caused the problem.  A true third party device reset comes from another host, connected to 
the same SCSI tape lun, through a different IT nexus.

/John

