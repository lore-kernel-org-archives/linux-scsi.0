Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B82F5318
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 09:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759225136; cv=none; b=ipgVB7uyF4/TyMBk9PA4b6LtFXZbEUVeEUkVJSK72PUcOrLmOltCd0lKe6fuDBfHrncxSoz9Zxi/noifAw/b4Y9JYN24GNK9c830rbOEQAqoNpcuDBGgA9S5DR6Zp7UQReH7LIiePakcQWCOr+RhWS/s8ZbeupTgrK2mTsKmw9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759225136; c=relaxed/simple;
	bh=YU8b13GXipLwNou+hqtC6h/7aFyn1y4anpdFmL5oMeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BbDGeQjyqmGP7ci/qHuc3Cb89w9JeHp0Kfdr9UZpVgL+IRXbPrd8rTTB5X0YGy43dtGWTxw0SNeY5u87v9r63IT+xrDZy6svKD105TpA+F30MzuO2W/zg6LzVJuEEckhSu82rBZcbgBuKPHM7rz+nEZ0r6UD5IMiwI4Yi3VobR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJd4eluQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJd4eluQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759225134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lTOxxV9OlZarUjt5LRTMrnxi0pIE/jk4h9AJiGhL9Sc=;
	b=MJd4eluQ5wE0wJCqh41jTfKXRlSGuR2OOxvGndQZX6jqvkNwa+DjmCfzKbXLY6+QT7lN+C
	jVGb29+OzHteRo2JELlkybz8jkVvvZnMrEEXwTpHQd2BuJpXYJnJIrhgRLMDGq2VYjAaA8
	Y5lgDshGg5h1NQYJ4BjTjbeyRHxOxug=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-OPv1_Ec0OQ-x6hQwUceWRA-1; Tue,
 30 Sep 2025 05:38:45 -0400
X-MC-Unique: OPv1_Ec0OQ-x6hQwUceWRA-1
X-Mimecast-MFC-AGG-ID: OPv1_Ec0OQ-x6hQwUceWRA_1759225123
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEB35180028D;
	Tue, 30 Sep 2025 09:38:42 +0000 (UTC)
Received: from [10.44.33.194] (unknown [10.44.33.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEF3230002C5;
	Tue, 30 Sep 2025 09:38:36 +0000 (UTC)
Message-ID: <1b17fc45-ba6e-4fb3-9352-a6ec0ae913f2@redhat.com>
Date: Tue, 30 Sep 2025 05:38:35 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/11] scsi: qla2xxx: Fix 2 memcpy field-spanning
 write issue
To: Hannes Reinecke <hare@suse.de>,
 "Gustavo A. R. Silva" <gustavo@embeddedor.com>, kbusch@kernel.org,
 martin.petersen@oracle.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
 gustavoars@kernel.org, hch@lst.de, james.smart@broadcom.com,
 kees@kernel.org, linux-hardening@vger.kernel.org, njavali@marvell.com,
 sagi@grimberg.me
References: <20250926000200.837025-1-jmeneghi@redhat.com>
 <20250926000200.837025-12-jmeneghi@redhat.com>
 <0af9cbc4-a410-44f3-affc-a09e5c41ccd4@embeddedor.com>
 <49b31606-29fc-43ea-973b-b317c53161db@suse.de>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <49b31606-29fc-43ea-973b-b317c53161db@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 9/26/25 5:29 AM, Hannes Reinecke wrote:
> On 9/26/25 11:00, Gustavo A. R. Silva wrote:
>> Hi,
>>
>> Shouldn't this patch be removed from this series, since it's going to be
>> reverted anyways?
>>
> yes. To my understanding the FPIN patch series has been queued in
> scsi-queue anyway, so it would be better to just send an incremental
> patch on top of that.
> Especially as Martin has already indicated that he will _not_ rebase
> his tree.

This V10 patch series is based on nvme-v18.

I don't see the revert in scsi/6.18/scsi-queue yet

> Best to just send this patch as a stand-alone patch, and then rebase
> any not-yet-upstreamed patchsets on top of that.

I'd prefer to merge this patch with the FPIN-LI patch series.  There is to good way to test this field-spanning write fix w/out the FPIN_LI patches,
and the last time we cherry-picked and merged this fix it only led to confusion.

I think we should keep these together.  I will add Gustavo's new fix to my V11 patch series.

/John

> Cheers,
> 
> Hannes

