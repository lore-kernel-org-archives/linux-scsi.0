Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ECD1F3B87
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 08:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772093635; cv=none; b=iBmRQc8yIYkxep8GpiMsDEhVwwRTIIwq2CVZ5dNBkNbACR7ijE0tITfCZ8yLG6pczA0xdjvyNYHrG04VzaOv5y4rRsNATGcVG/W9jIaNTSSoes1W44pg1lCL8EKqErQgBnjQIkyR9KtsCBz2+ilkH4PCoKzr8705HF6p9S6uVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772093635; c=relaxed/simple;
	bh=9DRy7yqLQHtCip9HCmObThmwj1ASxznQZpTYJ3+LMWI=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=WLU+1P6mPSGR+lLAOy8eecRXBVQEVro+G8g0BjtDGUKWQDQ5h44OBOsvGX+yaJhgGu/9sEfw1qa0SWqzVVvmNf6eIv1qltIWhKVCFHbxV0fI8WpKAvgySVi3mJjPtDvoyfzRPBvCHIWQJq7vDmFl5XgCzAudr/vLqnBAnCcQsYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id d63d3aa3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 26 Feb 2026 09:07:10 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Feb 2026 09:07:10 +0100
Message-Id: <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Keith Busch" <kbusch@kernel.org>, "Maurizio Lombardi"
 <mlombard@redhat.com>
Cc: <hch@lst.de>, <hare@suse.de>, <chaitanyak@nvidia.com>,
 <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
 <linux-nvme@lists.infradead.org>, <James.Bottomley@hansenpartnership.com>,
 <mlombard@arkamax.eu>, <jmeneghi@redhat.com>, <emilne@redhat.com>,
 <bgurney@redhat.com>
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
X-Mailer: aerc 0.21.0
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
In-Reply-To: <aZ9sjbZ3CEW_1rW1@kbusch-mbp>

On Wed Feb 25, 2026 at 10:41 PM CET, Keith Busch wrote:
> On Wed, Feb 25, 2026 at 05:12:00PM +0100, Maurizio Lombardi wrote:
>> The NVMe fully asynchronous namespace scanning introduced in
>> commit 4e893ca81170 ("nvme-core: scan namespaces asynchronously")
>> significantly improved discovery times. However, it also introduced
>> non-deterministic ordering for namespace registration.
>>
>> While kernel device names (/dev/nvmeXnY) are not guaranteed to be stable
>> across reboots, this unpredictable ordering has caused considerable user
>> confusion and has been perceived as a regression, leading to multiple bu=
g
>> reports.
>
> The nvme-pci driver also probes the controllers asynchronously, which
> can also create non-determinisitic names. Is that part not a problem?

Potentially, it is. The difference is that so far no one ever complained
about it, while with namespace async scanning we immediately received regre=
ssion
reports, to the point we had to revert the changes and restore the
sequential namespaces scan in RHEL.

>
> Just on the suffix part of the namespace's block handle, I have a
> potential alternate suggestion here. The instance names pulled from the
> ida guarantee we'll always have unique names for the lifetime of the
> backing kobject. I introduced that a while ago, but I'm testing this out
> now and it seems kobject_del is sufficient to reuse that name. The
> driver already did that to all the objects when deleting the namespace,
> so there doesn't appear to be a reason to wait for the final
> kobject_put.
>
> What I'm saying is I may have been mistaken about the naming collision
> issues and we can just use the head's ns_id to get a consistent and
> meaningful name based off the backing namespaces. There's some unlikely
> races with multipath at the moment if we did use ns_id, but I think
> they're all fixable.


Ok, so you'd like to use the namespace's NSID as the suffix.
I also considered this approach, the reason I didn't implemented
it is that I wished to have the async namespace scan performance improvemen=
ts
while preserving the same enumeration we had for years with the sequential =
scan:

Before the introduction of the async scan, /dev/nvme0n1 always pointed
to the first entry of the NSID list, /dev/nvme0n2 to the second
entry and so on.

With your proposal, if a user has sparse NSIDs (1, 10, 333)
then he will get /dev/nvme0n1, /dev/nvme0n10, /dev/nvme0n333.
On one hand, yes, they are "more stable" and more meaningful too,
on the other hand this breaks the assumption of contiguous naming.
This might not be a problem for the mainline kernel, but I suspect we
will have people complaining again that the /dev/nvmeXnY enumeration change=
d

Maurizio


