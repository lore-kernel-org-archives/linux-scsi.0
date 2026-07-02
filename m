Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B44A339844
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015960; cv=none; b=P4cCQdOHVynWswGAgCx7qMX3gePKWNeB8745N/fFU4bbl13mQki+IE+6NasNMSWP14a0rpiYGt4dpWib1+XXZoLRvF8S32wjSzzcc+2trbxmVH0Swnm8zEMESZ9reae5G492MuHOF2i9xrBHIBrkDgLSQKsx3gRZip9fHm6OLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015960; c=relaxed/simple;
	bh=CIZn3dO5QhDJHu+kv56fAnzazmnxF80XAtWODXedGx8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bLUG1a/8qkot6Fduok8o/P+KLmGZpxbBrala2khkwL95RYkxvHyg8CUJqqrLzyUaBtXShUL/NYsHiP8ldPzCX4WJ/vj+9MWiLcgvijX/ZZfweIwPFs/nJXAQAoIa+HHKrr8FqMi5wxFw4l5PhXIRZJwidGc5otsR8T/6bSnQwfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrTX3K+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrTX3K+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22AF1F000E9;
	Thu,  2 Jul 2026 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783015959;
	bh=e8XcgFjZpAWEq9zbP/2tdrVEIEAq7zbK3BppP/QpJQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lrTX3K+9Dz7yEiMEDatS+E/+mQlN36gOGsfLmhlS19zSaLBqDvCcNcYTQp/k4KUdG
	 WiUDcNNGGPG5GPIXhMbuUJcpNsHSAYLUOfmdzYxV9yd2ojomAMIlMA4dYKlM9VjCDI
	 aMTGBhdGENUOOnb1C2ylsuWP3/BdDezdzl32lJeXxfMsVTnZRNONNrdIC9t1gUkwWC
	 oCAg1E9GR9UmQ6cweImlMfAxufnkG/otb712LTjbAPrhcvceMV7ZS/bYhZoBggS1KD
	 XIn4XL+GlLKB2H5jCXEUigK/HhffTWhAhPec32ckDzC9q97iyIgOP6dYfgqkcUsxe8
	 W0KwocqkMhIxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/8] ibmvfc: define asynchronous sub-queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-4-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-4-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:12:38 +0000
Message-Id: <20260702181238.C22AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the driver reads=
 `setup->num_scsi_subq_channels` directly from a hypervisor-modified DMA bu=
ffer without validating it against the allocated size of the internal queue=
 array, leading to a potential heap buffer overflow.
--

commit caceab058540895b7bcd0e5a48d2dfd281f362ec
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: define asynchronous sub-queue

Defines the asynchronous sub-queue structure, modifies the existing
channel setup structure, adds the asynchronous sub-queue to the
channels structure, and adds flags needed to tell VIOS to use the
sub-queue.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index adfd67e85af86..f38dfae9924ca 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
[ ... ]
> @@ -579,6 +581,7 @@ struct ibmvfc_channel_setup {
>  	struct srp_direct_buf buffer;
>  	__be64 reserved2[5];
>  	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
> +	__be64 async_subq_handle;

[Severity: High]
This isn't a bug introduced by this patch, but since the driver reads
setup->num_scsi_subq_channels directly from a hypervisor-modified DMA buffe=
r,
could this lead to a potential heap buffer overflow?

Looking at drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_channel_setup_done():

	active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
	scrqs->active_queues =3D active_queues;
	...
		for (i =3D 0; i < active_queues; i++)
			scrqs->scrqs[i].vios_cookie =3D
				be64_to_cpu(setup->channel_handles[i]);

If the VIOS partition responds with an unexpectedly large value for
setup->num_scsi_subq_channels, would the driver write out of bounds into the
queue array without validating against the allocated size?

>  } __packed __aligned(8);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D4
