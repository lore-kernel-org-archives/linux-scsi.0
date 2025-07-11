Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E193280334
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2025 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752252577; cv=none; b=CJCCUBbGFERTGZHYKpAwUxhpEpWnZhB62R7Na2IM7WuAsHgPN9igj77ML1olecEa1Ul9uhpR20uJE6zIV+Hag6s1GPkNsp47GbygJLgxcx8a1vrSujkV6/lkM5Lj994XxM6WYwxStFatbmBqriGrQoMgF+x8Rgq9kJgYDDgWtpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752252577; c=relaxed/simple;
	bh=qiNR5UAdoTe+DIhT4Q+zcZdfYP1oHiZqbm4EqS3+u6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=duNkzEE9bwGU7d+JmyIVdww6kIqmV9C7e65E/5oizOQZClJADUWFY2H1r2qqmxTzBdYD0o0tyP/VeGAnAdUtYzq+/9bP5E8hJ+WoMGvEIO+hd6IkTylsgpk692XbND1n+AlcLuCyZrrYenYrDYkgmivlMuZq6ciP+bqth7/TglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0ZdbEg4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0ZdbEg4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752252574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70Z4opZRL076ZNWR+XkCjBSaf4ucd3Hi4biRYZjy3XY=;
	b=Y0ZdbEg4rfd7VByntaWYVfsXltJTmV6ruO+FLpnpAmUJFNw/cS0XLgxat8CKZ1gNSOx2Qs
	z1PN9H5yL0lC03o62Xmszc7KORg/Illl2PFjvBt2Xwt6SAjwaoYV28UXNfkxSR5G174wnH
	D4xkCIYF2dgDclyehQlGRr+jqLtXQYA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-Fd4cwRNGMUqib7e4qSMyUA-1; Fri,
 11 Jul 2025 12:49:31 -0400
X-MC-Unique: Fd4cwRNGMUqib7e4qSMyUA-1
X-Mimecast-MFC-AGG-ID: Fd4cwRNGMUqib7e4qSMyUA_1752252569
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04D3C1800289;
	Fri, 11 Jul 2025 16:49:28 +0000 (UTC)
Received: from [10.22.88.94] (unknown [10.22.88.94])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A26D71800287;
	Fri, 11 Jul 2025 16:49:23 +0000 (UTC)
Message-ID: <06f27533-ea9b-4ee1-96ed-12ddda271a76@redhat.com>
Date: Fri, 11 Jul 2025 12:49:22 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>,
 Hannes Reinecke <hare@suse.de>
Cc: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk,
 james.smart@broadcom.com, dick.kennedy@broadcom.com,
 linux-scsi@vger.kernel.org, njavali@marvell.com, muneendra737@gmail.com,
 Howard Johnson <howard.johnson@broadcom.com>
References: <20250624202020.42612-1-bgurney@redhat.com>
 <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
 <19484829-0a7b-42ce-99fe-e74ccda67dce@suse.de>
 <b0817e2a-1c4e-4d7d-9a84-633913d9e0e4@redhat.com>
 <0db83ea3-83aa-45ef-bafd-6b37da541d22@suse.de>
 <CAHhmqcTNrfjj-ABjTfj7LUCQ_qRtcTrZCzhtaERViaAQut3TUw@mail.gmail.com>
 <fb150df4-d235-455b-8394-55b816c0e6ad@suse.de>
 <CAJtR8wVupqRK3t0+7shrNCTZ9qZC7gHAR2X8Ov0AR-RJamxcWg@mail.gmail.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <CAJtR8wVupqRK3t0+7shrNCTZ9qZC7gHAR2X8Ov0AR-RJamxcWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Adding Howard Johnson.

On 7/11/25 4:54 AM, Muneendra Kumar M wrote:
>  >>But that's precisely it, isn't it?
>  >>If it's a straight error the path/controller is being reset, and
>  >>really there's nothing for us to be done.
>  >>If it's an FPIN LI _without_ any performance impact, why shouldn't
>  >>we continue to use that path? Would there be any impact if we do?
>  >>And if it's an FPIN LI with _any_ sort of performance impact
>  >>(or a performance impact which might happen eventually) the
>  >>current approach of steering away I/O should be fine.
> [Muneendra]
> 
> With FPIN/LinkIntegrity (LI) - there is still connectivity, but the FPIN is identifying the link to the target (could be multiple remoteports if the target is doing NPIV) that had some error.  It is *not* indicating that I/O won't complete. True, some I/O may not due to the error that affected it.  And it is true, but not likely that all i/o hits the same problem.   What we have seen with flaky links is most I/O does complete, but a few I/Os don't.
> It's actually a rather funky condition, kind of sick but not dead scenario.
> As FPIN-Li indicates that the path is "flaky" and using this path further  will have a performance impact.
> And the current approach of steering away I/O is fine for FPIN-Li.

OK, then can we all agree that the current patch series, including the patch for the queue-depth handler, does the correct thing for FPIN LI?

Right now this patch series will "disable" a controller and remove it from being actively used by the multipath scheduler once that controller/path receives an FPIN LI event.
This is true for all three multi-path schedulers: round-robin, queue-depth and numa.  Once a controller/path has received an LI event is reports a state of "marginal" in the
controller state field  (e.g.: /sys/devices/virtual/nvme-subsystem/nvme-subsys6/nvme4/state). While in the marginal state the controller can still be used, it's only the path
selection policy that avoids it in the nvme multipath scheduling code.

These patches also prefer non-marginal paths over marginal paths and optimized paths over non-optimized paths. If all optimized paths are marginal, then the
non-optimized paths are used. If all paths are marginal then the first available marginal optimized path is used, else the first available non-optimized path is used.

To clear the marginal state a controller must be disconnected, allowing the /dev to be removed, and then reconnected.  (We might want to change this, but that can be discussed in a future patch)

Bryan and I have tested these patches with all of the above configurations conditions and, at this point, they are working as described above while using an LPFC adapter.

You can see the test plan Bryan and I used is at https://bugzilla.kernel.org/show_bug.cgi?id=220329#c1

We observed a problem while testing this with a QLA adapter.

So I am hoping one more update to this patch series, to fix the QLA problem, will complete this work.

/John







