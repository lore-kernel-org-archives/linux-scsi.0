Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B165215F6E
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731004517; cv=none; b=CkFggr9x1LMMN8cLxidOWdiKQFpgIXXG9rt1A5Jw54HLNXWGekIZFzKZ452vZjdUWfG8udjTW5bmWqN410OCvkHxRyrzbEgpg+vjiGK14tQ1B+2ym6CB2+qP+jviEW17ndi5ZxWGyT/z7vvRZl9NKmmtJmB4+0Psb1BEZGJIHcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731004517; c=relaxed/simple;
	bh=Dr3iBqAxUkSSUIfdL2QO5ZpRjAKqgwn4ITBFIpDTva0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e4xOdaOIAr82VTJnEmgxfdbuM+lNd5SMDMPaP4IZtaMrvTGoHsI4+VQMoaFPFQ7SVHiaOt61BdIwVmZwnys36XfDIgRkD/uyLlFhrRIJ4mCIXjdIrrTDNMg7+ym/Y8+YqOxLd1apked+efmO60RJjl5Ipvw4bKqSxbyPEAEqLIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EDOjt9bn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDOjt9bn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731004514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0BV4cQjK6r4k+nnOA3H++TZCIX5jl2A4n+o/usvE3U4=;
	b=EDOjt9bnoRQr9DH5X9PqRiT/4RwoY08buS96+G5gb/JSPZM2tSQuwzptc6+emIPkl9XEgz
	YK8SUzMSTW6dlLXJh3v75h28ebFNsi+neS76WG/0iM8FK5Sx/1/7Q4zq0V9uaRrLaH+8NA
	H/YKkTSHUKpfW3SisgSoDbAR9kt5rd8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-hY2Lgo2jObuaFFDtiQ22ow-1; Thu,
 07 Nov 2024 13:35:13 -0500
X-MC-Unique: hY2Lgo2jObuaFFDtiQ22ow-1
X-Mimecast-MFC-AGG-ID: hY2Lgo2jObuaFFDtiQ22ow
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 505F819792FC;
	Thu,  7 Nov 2024 18:35:09 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC8651956054;
	Thu,  7 Nov 2024 18:35:05 +0000 (UTC)
Message-ID: <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com>
Date: Thu, 7 Nov 2024 13:35:04 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: DMMP request-queue vs. BiO
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-scsi@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Christoph Hellwig <hch@lst.de>, snitzer@kernel.org,
 Ming Lei <minlei@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Jonathan Brassow <jbrassow@redhat.com>, Ewan Milne <emilne@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, bmarson@redhat.com,
 Jeff Moyer <jmoyer@redhat.com>, "spetrovi@redhat.com" <spetrovi@redhat.com>,
 Rob Evers <revers@redhat.com>
References: <2d5fe016-2941-43a4-8b7c-850b8ee1d6ce@redhat.com>
 <20241104073547.GA20614@lst.de>
 <d9733713-eb7b-4efa-ad6b-e6b41d1df93b@suse.de> <20241105103307.GA1385@lst.de>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241105103307.GA1385@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

I've been asked to move this conversation to a public thread on the upstream email distros.

Background:

At ALPSS last month (Sept. 2024) Hannes and Christoph spoke with Chris and I about how they'd like to remove the 
request-interface from DMMP and asked if Red Hat would be willing to help out by running some DMMP/Bio vs. DMMP/req performance 
tests and share the results.The idea was: with some of the recent performance improvements in the BIO path upstream we believe 
there may not be much of a performance difference between these two code paths and would like Red Hat's help in demonstrating that.

So Chris and I returned to Red Hat and broached this subject here internally. The Red Hat performance team has agreed to work 
work with us on an ad hoc basis to do this and we've made some preliminary plans to build a test bed that can used to do some 
performance tests with DMMP on an upstream kernel using iSCSI and FCP. Then we talked to the DMMP guys about it. They have some 
questions and asked me discuss this topic in an email thread on linux-scsi, linux-block and dm-devel.

Some questions are:

What are the exact patches which make us think the BIO path is now performant?

Is it Ming's immutable bvecs and moving the splitting down to the driver?

I've been told these changes are only applicable if a filesystem is involved. Databases can make direct use of the dmmp device, 
so late bio splitting not applicable for them. It is filesystems that are building larger bios. See the comments from Hannes and 
Christoph below.

I think Red Hat can help out with the performance testing but we will need to answer some of these questions. It will also be 
important to determine exactly what kind of workload we should use with any DMMP performance tests. Will a simple workload 
generated with fio work, or do we need to test some actual data base work loads as well?

Please reply to this public thread with your thoughts and ideas.

Thanks,

John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

On 11/5/24 05:33, Christoph Hellwig wrote:
> On Tue, Nov 05, 2024 at 08:44:45AM +0100, Hannes Reinecke wrote:
>>> I think the big change is really Ming's immutable bvecs and moving the
>>> splitting down to the driver.  This means bios are much bigger (and
>>> even bigger now with large folios for file systems supporting it).
>>>
>> Exactly. With the current code we should never merge requests; all
>> data should be assembled in the bio already.
>> (I wonder if we could trigger a WARN_ON if request merging is
>> attempted ...)
> 
> Request merging is obviosuly still pretty common.  For one because
> a lot of crappy file systems submit a buffer_head per block (none of
> the should be relevant for multipathing), but also because we reach
> the bio size at some point and just need to split.  While large folios
> reduce that a lot, not all file systems that matter support that.
> (that what the plug callback would fix IFF it turns out to be an
> issue) and last but not least I/O schedulers delay I/O to be able to
> do better merging.  My theory is that this not important for the kind
> of storage we use multipathing for, or rather not for the pathing
> decisions.

