Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9FB182D2
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289930; cv=none; b=d2+7+Gt/B/H6Qyz1f5jsdOU22GEv9yRCqRwA5uu2k1NpSltym47GrAIYZApbzLdiRLSRJTKcIQoxl6mp+74I4NiQ9Prco/y2sMRdufYu+1FsP9sgwOZDrDF+IZhFpCOshUI+3lCN/SoDQdabd0UC72pZF00dE3KEFtYd510djGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289930; c=relaxed/simple;
	bh=RUbqbEUxRxMVdU7CWR3h+IQNw6iPqU6Cd5JJ8IoLRG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gu8ynVeUZ7OzopLQfzCUEHpZB7X/anP3ceztOpcSkE8h1c7oiY9FjiTdldeUfgWLrnAJyDG7vZAJcY7ezASATYJS6Epb2kVIV5bMyijvsj0jAgZ3RcJFLZjPhGCpvuLWVZoXtWwWsCXuBTHmY/TEmGuHRNdS8hpEVDpXDkLjErc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qfk2HbU1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qfk2HbU1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753289927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRn9FpaKArn0FG0DYWvSxtBFbiaxMzHiCufTL2+OF1o=;
	b=Qfk2HbU1HBw6bM/iePVRlT5cHX8AGB1o39KLuQoPHLz6rmUE2q4m8d5DyDa71mGtyNW6Ps
	FoM7e+1lbSHz44TN/mmGDVvZrwiNa66ef6kSzHIihSDWTHGPtUZDYPZr9WAOHoKsA7CgJN
	JuCFtnmGGfyn4ueNcWDF96e5ktU2fVo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-pkTI_R-CPBCIZr2BCgRBpg-1; Wed,
 23 Jul 2025 12:58:42 -0400
X-MC-Unique: pkTI_R-CPBCIZr2BCgRBpg-1
X-Mimecast-MFC-AGG-ID: pkTI_R-CPBCIZr2BCgRBpg_1753289921
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FA221956087;
	Wed, 23 Jul 2025 16:58:35 +0000 (UTC)
Received: from [10.17.17.193] (unknown [10.17.17.193])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EBBE0180035E;
	Wed, 23 Jul 2025 16:58:30 +0000 (UTC)
Message-ID: <552ad157-ae0d-4e12-9cd4-56dc06da3457@redhat.com>
Date: Wed, 23 Jul 2025 12:58:30 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/8] nvme: sysfs: emit the marginal path state in
 show_state()
To: Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
Cc: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 hch@lst.de, sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com,
 dick.kennedy@broadcom.com, njavali@marvell.com, linux-scsi@vger.kernel.org
References: <20250709211919.49100-1-bgurney@redhat.com>
 <20250709211919.49100-8-bgurney@redhat.com> <aG7pSA6TOAANYrru@kbusch-mbp>
 <35738598-0733-408c-8597-20c3599a8973@redhat.com>
 <aHa0JpsASqGuHdOA@kbusch-mbp> <ccb69ee6-bd5e-4585-9ccc-0c49cb30f1a9@suse.de>
 <aH7-F2WxrhoCiK7O@kbusch-mbp> <4c97cc61-bb9f-4121-8681-22c9e548fe0a@suse.de>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <4c97cc61-bb9f-4121-8681-22c9e548fe0a@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


On 7/22/25 2:41 AM, Hannes Reinecke wrote:
> On 7/22/25 04:57, Keith Busch wrote:
>> On Wed, Jul 16, 2025 at 08:07:51AM +0200, Hannes Reinecke wrote:
>>
>> Okay, but can we call it "degraded" instead of "marginal"? The latter
>> implies the poor quality is endemic to that path rather than a temporary
>> condition.
> 
> Sure we can.
> (Although technically it _is_ endemic as it won't change without
> user interaction. But I digress :-)
> \

OK. We'll change this from "marginal" to "degraded" and I'll have Bryan send a v9 patch series.

Is there anything else we want to change with this series before we do that?

/John

