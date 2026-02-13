Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A0230E0FB;
	Fri, 13 Feb 2026 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771004115; cv=none; b=r4pDGlCTGCRPMJft4cgLeMj76dilOz15t7fg8M9sgKuWPBL452GfNrjwhLE3zOIIMeexfmE36F5pErmiFWmpcDixt0sE/cshfDb4XviBc5YLYuPZBYTA/xgz5UHzxZcc2qd/QpG+wblfI6arE4fKbk9pEZIKXBzD5B0nHHfGjaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771004115; c=relaxed/simple;
	bh=078Urn+cINKSZb6O/zyy4zsXNkVkYlJujFz2tQX9BiA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zg8T9pRUrQ8hvayUFhSfOICiKhsAjv8BurgQbDnfUoflR6xATbPo/O6y/X7NsrCdK6Yro0nNw36yaH5RUztMGWdwhJ9vNsma3jnUirT/HsKo46WJBPYndU6WO4KFDgt+jJ+CM+Viy9DjwUkoQm0/cTPA3EwsCZpVUR6/ybqjhT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=CPW7M+Cp; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="CPW7M+Cp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1771004111;
	bh=078Urn+cINKSZb6O/zyy4zsXNkVkYlJujFz2tQX9BiA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=CPW7M+Cpxi6WFEOQqyjW4wTuRSvjeArjIVf30wi2Hw8PLi10Ld7eiVvO0CpzspkfL
	 wCD+qLsDsrZSu1hZq2t+IKrFOBAsaufjmu99Q7Y9jZqtM2x7VRbQpqv98/As8yDcwI
	 PlezM0S+8ljS5ih2Hx2HXH8ungCYFhGNrI+GXnQU=
Received: from [10.100.48.88] (unknown [208.52.86.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id DE8A01C0248;
	Fri, 13 Feb 2026 12:35:09 -0500 (EST)
Message-ID: <bb79a1b879e62496f64c3b264a2786701ac57942.camel@HansenPartnership.com>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bart Van Assche <bvanassche@acm.org>, Johannes Thumshirn
	 <Johannes.Thumshirn@wdc.com>, Daniel Wagner <dwagner@suse.de>, Chaitanya
	Kulkarni <chaitanyak@nvidia.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Hannes Reinecke
 <hare@suse.de>, hch <hch@lst.de>,  Jens Axboe <axboe@kernel.dk>,
 "sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
 Christian Brauner <brauner@kernel.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>,  "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, Javier =?ISO-8859-1?Q?Gonz=E1lez?=
 <javier@javigon.com>, "willy@infradead.org" <willy@infradead.org>, Jan Kara
 <jack@suse.cz>, "amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Date: Fri, 13 Feb 2026 09:35:08 -0800
In-Reply-To: <678a951d-7da1-4089-a3d8-f9d9cb48aa35@acm.org>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
	 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
	 <24634187-a4fd-4fbd-9053-03484eadf16f@wdc.com>
	 <678a951d-7da1-4089-a3d8-f9d9cb48aa35@acm.org>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-02-13 at 09:30 -0800, Bart Van Assche wrote:
> On 2/11/26 11:57 PM, Johannes Thumshirn wrote:
> > One thing that comes to my mind (and that I always wanted to do for
> > fstests but didn't for $REASONS) is adding per-test code coverage
> > information.
>=20
> Code coverage information is useful but it's important to keep in
> mind that 100% code coverage (which is very hard to achieve) does not
> guarantee code correctness. There are many state machines in the
> block layer and also in block drivers. Code coverage information does
> not reveal what percentage of the states of state machines has been
> triggered.

This is not an either/or.  Usually our functional tests try to cover
the state machine (although often requiring error injection).  However,
a lot of our bugs hide in error legs and code coverage at least assures
us we've looked for them.

Regards,

James

