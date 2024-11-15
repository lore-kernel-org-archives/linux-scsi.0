Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48C11E47BB
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702493; cv=none; b=aFJHGyywkfNTGnkv5KVHzheVrZs7/DoRst3OohHPpz0GGFozs+fk6H9iYeSZSIxntU4eq3pFODlxIsF3iUVXsxSM8P+xJksIQvTbfNAYoDKOG2apnxeI5UKTvkTH9+tteJhKaq1d1995LLWvCbGiowl/nGd9JO+1JYu/qXnkEgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702493; c=relaxed/simple;
	bh=qePvXLWELjUn8An+ugcMkT19H++mSExomGGTySH24C8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFBwQWL7tC0UPbmAByJFEpqMYUpAJeDRFidSEm4jrZcBT6PPyL9GiqxhY6tulV5oRwYKpcGrOsASo2bdtCmMSaTq/ooDR6j3BeaeIAPwo9pjzriebc1W5hVtoqibSqyMM7W2s3k7iuj/btOaAOxvDnzHu43vI1hbu6XJPn70OZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XT+/yW2a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XT+/yW2a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731702491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DjmFRbZ2NKDN+MKMboIHAU8fJcOIo14ejwEod7JVZFM=;
	b=XT+/yW2azP271Q3za2bZJG5ZGL4/fsUDHATu0RUG0TeSg18wOD8AKvY0uXHTx4sSydIYXM
	4pzYdeS6HZGtPxvAD5F8GpImJREPT4eukVibisran8BKZfFLIPrurVgRPTAe61G6LwexTW
	3I23WHgAk0M1U243zPXdkJMWQTsagVY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-p-wmdLolMhiCSPd-2Bheew-1; Fri,
 15 Nov 2024 15:28:09 -0500
X-MC-Unique: p-wmdLolMhiCSPd-2Bheew-1
X-Mimecast-MFC-AGG-ID: p-wmdLolMhiCSPd-2Bheew
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9874519560AF;
	Fri, 15 Nov 2024 20:28:07 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45892195DF81;
	Fri, 15 Nov 2024 20:28:04 +0000 (UTC)
Message-ID: <e48b533d-c28a-4e92-b459-74820957ec7d@redhat.com>
Date: Fri, 15 Nov 2024 15:28:03 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: DMMP request-queue vs. BiO
To: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
 Hannes Reinecke <hare@suse.de>, snitzer@kernel.org,
 Ming Lei <minlei@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Jonathan Brassow <jbrassow@redhat.com>, Ewan Milne <emilne@redhat.com>,
 bmarson@redhat.com, Jeff Moyer <jmoyer@redhat.com>,
 "spetrovi@redhat.com" <spetrovi@redhat.com>, Rob Evers <revers@redhat.com>
References: <2d5fe016-2941-43a4-8b7c-850b8ee1d6ce@redhat.com>
 <20241104073547.GA20614@lst.de>
 <d9733713-eb7b-4efa-ad6b-e6b41d1df93b@suse.de> <20241105103307.GA1385@lst.de>
 <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com>
 <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com>
 <20241115170924.GB23437@lst.de>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241115170924.GB23437@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 11/15/24 12:09, Christoph Hellwig wrote:
> On Fri, Nov 15, 2024 at 03:05:21PM +0100, Mikulas Patocka wrote:
>> Note, that if a database uses buffered block device, performance will be
>> suboptimal, because the buffering mechanism can't create large bios, it
>> only sends page-sized bios. But that is expected to not be used - the
>> database should either use a block device with direct I/O or a filesystem
>> with or without direct I/O.
> 
> And, as pointed out in the private mail that John forwarded to the list
> without my permission if we really have a workload that cares md could

Ah come on. I deleted most of the private thread....

> implement the plugging callback as done in md to operate on a batch
> of bios.
> 
> Also not building large bios is not a fundamental property of block
> device writes but because it uses the legacy buffered head helpers.
> That means:
> 
>    a) the same is applicable to file systems using them as well
>    b) can be fixed if someone cares enough, but apparently no one does
> 

OK. Thanks, that the info I was looking for.

Thanks,

/John

