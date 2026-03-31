Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F2A271A71
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 01:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774918947; cv=none; b=hiCPcjhIlO3z4I3bY+wRIlggwPK8B940mqm9+CQBQyigt+XAhsTg5tjWzyLpgLhjRJR+Rd/juQVlUuSdWCM2MJYhbCXU50AqJEJ/MvH3ydtdoNLFvHpV6hm3p9XpmkRQWjJahcOkEMjlf09+lorSgKhI+mjFbeHHmbBpYEOUq04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774918947; c=relaxed/simple;
	bh=ypRpAL/SOpf+fJx+QABf23+W6rQ4iDe3inTkvlPaqX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRF4yZArRmCimwaM2jpQ1wbd2mTE+02slhX36J7crapvbimOCZmMuKocey5NX1XH/aoP5hlOlNGTyg8tTI0QJZYvkEXwWdmvYc/cH4BdMvvzQWHhLfekLQ6k0ODC+qBtxtnWen9i7Fcn+4SO/xUeBlZYZCXP1yn92QzLHY++VYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zs12qFBv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zs12qFBv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774918945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vCyOd8Hq2eAy0S/aAjPXgTm66WXi3qjg5wbQWwZEhK4=;
	b=Zs12qFBv06my5f2JEpXTF2oQ0+NOu4RztfWK3Le0tDzO/5f3vIFvqJ4xoWe2XNWyOGREGe
	khvC5BJXizprxVnITPfFTXg17xdZ1U8L2WBZ7QkUOAySmwtRX/NyL403QqCu1cBDOelEO5
	tYQyIQ3fn40wBrhXbF3pAumzJ8JyjfU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-brngCdPJOnCsi5PsAzUHdw-1; Mon,
 30 Mar 2026 21:02:23 -0400
X-MC-Unique: brngCdPJOnCsi5PsAzUHdw-1
X-Mimecast-MFC-AGG-ID: brngCdPJOnCsi5PsAzUHdw_1774918938
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F39D1956056;
	Tue, 31 Mar 2026 01:02:17 +0000 (UTC)
Received: from fedora (unknown [10.72.116.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BB319560AB;
	Tue, 31 Mar 2026 01:01:52 +0000 (UTC)
Date: Tue, 31 Mar 2026 09:01:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	mst@redhat.com, aacraid@microsemi.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	liyihang9@h-partners.com, kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 00/13] blk: honor isolcpus configuration
Message-ID: <acsc_GHv7Q04U1db@fedora>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Mar 30, 2026 at 06:10:34PM -0400, Aaron Tomlin wrote:
> Hi Jens, Keith, Christoph, Sagi, Michael,
> 
> I have decided to drive this series forward on behalf of Daniel Wagner, the
> original author. This iteration addresses the outstanding architectural and
> concurrency concerns raised during the previous review cycle, and the series
> has been rebased on v7.0-rc5-509-g545475aebc2a.
> 
> Building upon prior iterations, this series introduces critical
> architectural refinements to the mapping and affinity spreading algorithms
> to guarantee thread safety and resilience against concurrent CPU-hotplug
> operations. Previously, the block layer relied on a shared global static
> mask (i.e., blk_hk_online_mask), which proved vulnerable to race conditions
> during rapid hotplug events. This vulnerability was recently highlighted by
> the kernel test robot, which encountered a NULL pointer dereference during
> rcutorture (cpuhotplug) stress testing due to concurrent mask modification.

Can you share the bug report link?

IMO, it should be solved as a backportable patch first if possible.


Thanks,
Ming

