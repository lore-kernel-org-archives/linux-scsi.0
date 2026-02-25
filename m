Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F53D265621
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 21:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055696; cv=none; b=qxl0Kha+RxdUMuw6FcWGCEBo7v7fXmIOWKNR3CuJ3Zksi82Q7ykaLFnSiOoZ6OAOzTf5z8Ps2ORJgUiifoqyQTsPdvG4xrMan21z/GNufPPyWJ8qBv22+S0NMB+LAPalQKaKdB+BCJffNYtVZdxJSIjwEPzufF0RtHXXTo+Wteg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055696; c=relaxed/simple;
	bh=Fpk7tbw1NnxpCGy61JuvRTfaQXL6WxnsCaO2aHRbBRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGRAh1QGIRKq31UjWiy7d/chuFeHoquVQzy9G0B2MHyvNZFh+nguJVAKJbCxRfSlYU/0rrZYcI0lhwxH2GsRbicSXEtZvmycW1ZIe8Ru5p2IEAISeQX14DCGTGMBzJYH6reFt603S80MVbWZ7pfbtOwuoxE/sdbl/AxomyKPMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DT2z7s3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DT2z7s3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4258DC116D0;
	Wed, 25 Feb 2026 21:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772055695;
	bh=Fpk7tbw1NnxpCGy61JuvRTfaQXL6WxnsCaO2aHRbBRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DT2z7s3aCz+tTN7U22L3olUcb3ngSga7ZTIHIxxJNmAUchckrNj4LxTJaEwwIFFYO
	 7VwbFDPszcqaBPhTr/d9O3pqgmCJu7HLKXbj+Z1GXtwZtoZWDsR/VW0EDOGKz77Jup
	 GH+X38heNcV6E5kJkBPzct8OTaa+VBO5iGjYLT0qQemNGBR4XqpdTZW9lvap5QfRmq
	 Gp/QvaVXWAf7gFnRVcVz7iyIxf+RNly9yrN1EX59GU3GDawYiZa8+kOA/9XvvMiG0r
	 jdxjADS/Qz4eJz4VuD3c8uyC8KVlRlpO5RGYMIehwbYmqG+sLTEtVaEyG8mnWLE4PD
	 3KN+P9Lo5oNgw==
Date: Wed, 25 Feb 2026 14:41:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: hch@lst.de, hare@suse.de, chaitanyak@nvidia.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	James.Bottomley@hansenpartnership.com, mlombard@arkamax.eu,
	jmeneghi@redhat.com, emilne@redhat.com, bgurney@redhat.com
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
Message-ID: <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
References: <20260225161203.76168-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225161203.76168-1-mlombard@redhat.com>

On Wed, Feb 25, 2026 at 05:12:00PM +0100, Maurizio Lombardi wrote:
> The NVMe fully asynchronous namespace scanning introduced in
> commit 4e893ca81170 ("nvme-core: scan namespaces asynchronously")
> significantly improved discovery times. However, it also introduced
> non-deterministic ordering for namespace registration.
>
> While kernel device names (/dev/nvmeXnY) are not guaranteed to be stable
> across reboots, this unpredictable ordering has caused considerable user
> confusion and has been perceived as a regression, leading to multiple bug
> reports.

The nvme-pci driver also probes the controllers asynchronously, which
can also create non-determinisitic names. Is that part not a problem?

Just on the suffix part of the namespace's block handle, I have a
potential alternate suggestion here. The instance names pulled from the
ida guarantee we'll always have unique names for the lifetime of the
backing kobject. I introduced that a while ago, but I'm testing this out
now and it seems kobject_del is sufficient to reuse that name. The
driver already did that to all the objects when deleting the namespace,
so there doesn't appear to be a reason to wait for the final
kobject_put.

What I'm saying is I may have been mistaken about the naming collision
issues and we can just use the head's ns_id to get a consistent and
meaningful name based off the backing namespaces. There's some unlikely
races with multipath at the moment if we did use ns_id, but I think
they're all fixable.
