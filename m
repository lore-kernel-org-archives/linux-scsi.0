Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CB31CD210
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731679538; cv=none; b=Yh+j5R9MPT03mB3ySOtcW9blGVEx25ChuzsyfClIyOjvI3nOifn5NGNrmrkrgYyYf/VEeTsSwaFmHvrCyiNmrCfVP+g7/5C5F/+3VdcmI881OucoVO5rNqMSTsErLED48VbV2bI1caRUBeSc2msYGP9wiDWAxOLor+vOANOQcKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731679538; c=relaxed/simple;
	bh=K8vgzXowzXEa0GP4N0CidBWM7T8OysqQyHlH3YDyDp0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GzOEg+zO4mo0errOTPrOONkzdEP+SfDkD1T2cvKlnd+O4ApkwOvV9GSFkKk99kg27CAqNK3+/Qs6EgaJaJ7em0OgXSpjA639g4ZQ/Tjsw74+/UujiGisTkIc/02Goe24TBrLQ/zIWEU/6ANBFfwzGFpCeNpOYiTum7j7da5AkIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wxl8xQ8Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wxl8xQ8Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731679536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j6HJrV9/5j/i/D0uhM8oJMZ+ivXjUPSmntpb+sO46M4=;
	b=Wxl8xQ8YMwwGuXyaYDGN4X0VLK7HFHuRhXCz7Y85C+R96pTLBQasSfnL9qFLCuxm0TeVkw
	k4N4WQjbav2zwfKleYNcKRLfmCRTwdmbpRnYcynqLkHkbChPAVr57rc1snTlg9Vs+nqj+H
	sT/GuNX9+9cvcOjP9+URQHdSlGInfBM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-nYk_OlM4MpK0DBFPOKVWXQ-1; Fri,
 15 Nov 2024 09:05:33 -0500
X-MC-Unique: nYk_OlM4MpK0DBFPOKVWXQ-1
X-Mimecast-MFC-AGG-ID: nYk_OlM4MpK0DBFPOKVWXQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AED0419560BD;
	Fri, 15 Nov 2024 14:05:31 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DEAC19560A3;
	Fri, 15 Nov 2024 14:05:26 +0000 (UTC)
Date: Fri, 15 Nov 2024 15:05:21 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>, 
    Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, 
    snitzer@kernel.org, Ming Lei <minlei@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Jonathan Brassow <jbrassow@redhat.com>, Ewan Milne <emilne@redhat.com>, 
    bmarson@redhat.com, Jeff Moyer <jmoyer@redhat.com>, 
    "spetrovi@redhat.com" <spetrovi@redhat.com>, Rob Evers <revers@redhat.com>
Subject: Re: DMMP request-queue vs. BiO
In-Reply-To: <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com>
Message-ID: <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com>
References: <2d5fe016-2941-43a4-8b7c-850b8ee1d6ce@redhat.com> <20241104073547.GA20614@lst.de> <d9733713-eb7b-4efa-ad6b-e6b41d1df93b@suse.de> <20241105103307.GA1385@lst.de> <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi


On Thu, 7 Nov 2024, John Meneghini wrote:

> I've been asked to move this conversation to a public thread on the upstream
> email distros.
> 
> Background:
> 
> At ALPSS last month (Sept. 2024) Hannes and Christoph spoke with Chris and I
> about how they'd like to remove the request-interface from DMMP and asked if
> Red Hat would be willing to help out by running some DMMP/Bio vs. DMMP/req
> performance tests and share the results.The idea was: with some of the recent
> performance improvements in the BIO path upstream we believe there may not be
> much of a performance difference between these two code paths and would like
> Red Hat's help in demonstrating that.
> 
> So Chris and I returned to Red Hat and broached this subject here internally.
> The Red Hat performance team has agreed to work work with us on an ad hoc
> basis to do this and we've made some preliminary plans to build a test bed
> that can used to do some performance tests with DMMP on an upstream kernel
> using iSCSI and FCP. Then we talked to the DMMP guys about it. They have some
> questions and asked me discuss this topic in an email thread on linux-scsi,
> linux-block and dm-devel.
> 
> Some questions are:
> 
> What are the exact patches which make us think the BIO path is now performant?

There are too many changes that help increasing bio size, so it's not 
possible to pick one or a few patches.

> Is it Ming's immutable bvecs and moving the splitting down to the driver?

Yes, splitting bios at the driver helps.

Folios also help with using larger bio size.

> I've been told these changes are only applicable if a filesystem is involved.
> Databases can make direct use of the dmmp device, so late bio splitting not
> applicable for them. It is filesystems that are building larger bios. See the
> comments from Hannes and Christoph below.

Databases should use direct I/O and with direct I/O, they can generate as 
big bios as they want.

Note, that if a database uses buffered block device, performance will be 
suboptimal, because the buffering mechanism can't create large bios, it 
only sends page-sized bios. But that is expected to not be used - the 
database should either use a block device with direct I/O or a filesystem 
with or without direct I/O.

> I think Red Hat can help out with the performance testing but we will need to
> answer some of these questions. It will also be important to determine exactly
> what kind of workload we should use with any DMMP performance tests. Will a
> simple workload generated with fio work, or do we need to test some actual
> data base work loads as well?

I suggest to use some real-world workload - you can use something that you 
already use to verify the performance of RHEL.

The problem with fio is that it generates I/O at random locations, so 
there is no bio merging possible, so it will show just the IOPS value of 
the underlying storage device.

> Please reply to this public thread with your thoughts and ideas.
> 
> Thanks,
> 
> John A. Meneghini
> Senior Principal Platform Storage Engineer
> RHEL SST - Platform Storage Group
> jmeneghi@redhat.com

Mikulas

