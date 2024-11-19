Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075291D131B
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732038179; cv=none; b=WIg8LERgolJBEzZjxHt1WGsyV9in6Nl3FXsecqREn8jDRSj0FWrCS9t5uZT+J3JQlIMys3JxHozMBmM9gxDo8fMVCQYt7jfb3wLzy8YYYGRYp3c4APK3cLlmoOW87rCbPFv3Q9bhtzrvDqv6XoHnXKjLzfIQHS53l03ePNYO734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732038179; c=relaxed/simple;
	bh=2fjmUz/81vZZKAYroG1qXNMHmYZMzGCNHJb7n6cgIjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wg6D3ZKcGEx3+H7z68G/s6YhsD3QFG5Z2CMQmqA/ZrRcxqxvrClfP8vx1WmFSHXNDywTfmEEOWYFBL4vkorzq/jYLphbOUsKST2ZUcaxvSoSrPH6xeDqdoWTbFG1BvGyPHdeA+kbzRGNIown+Uk6l6uJ+0LlmY3AWV1LBaddjOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LmjeHkBo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LmjeHkBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732038176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pKrxRTQC4gebi7SDGo61aSOmwb9nIf0PGkp2Pq2Q3Wc=;
	b=LmjeHkBozNQ4xWoVLoKsJKenqqlaXik5PB7mlS3rzxaWMwWB5l22ol90TMamUGhIDoeReT
	QmhoXUZVibwlTVhs3nLbEMHlmEYxyt2+yMj/dSlVX1Y49NGwERC/ayTMUek5b518E+IBuf
	NjIFaj4yIs2QEcR/oWdYBvedApsNhPY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-xbnPBFBjP-S7bHfjBb-_WA-1; Tue,
 19 Nov 2024 12:42:53 -0500
X-MC-Unique: xbnPBFBjP-S7bHfjBb-_WA-1
X-Mimecast-MFC-AGG-ID: xbnPBFBjP-S7bHfjBb-_WA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CD42195608D;
	Tue, 19 Nov 2024 17:42:52 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 38C5130001A0;
	Tue, 19 Nov 2024 17:42:50 +0000 (UTC)
Message-ID: <4beddc65-1afd-4e4d-9c3c-4b39807a9414@redhat.com>
Date: Tue, 19 Nov 2024 12:42:49 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: st: Remove use of device->was_reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, loberman@redhat.com
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
 <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
 <BED6505B-A8FD-4445-B61B-5F43899DAD54@kolumbus.fi>
 <50e7550c-cfeb-4a14-ac56-58b2a94f0f82@redhat.com>
 <56AC8EEF-9695-477B-AA2A-19F8B9E8C9A2@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <56AC8EEF-9695-477B-AA2A-19F8B9E8C9A2@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 11/19/24 10:09, "Kai Mäkisara (Kolumbus)" wrote:
>> I'm not sure I understand what problem you are trying to solve... are you trying to get the mid 
>> layer to report Unit Attentions to all ULDs that are attached?  That is, you want the mid layer 
>> to report the UA to all ULDs, not just the last/latest ULD?

> I would rather say that midlevel provides a method for all ULDs to see if certain
> Unit Attentions have happened. One gets all the sense data, but others can
> at least see that something has happened.

OK. That might work.  Be sure to cc me on the patch and I will take a look.

/John

