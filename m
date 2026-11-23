Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795429912;
	b=KZsBYLevNkS0Quc17vVHs9j6VzwTujn9S3XCqNBvNfzXUngQcvSJR+N6ygw42s+a9oPX
	 pQQdFSp7OYP1vsFZucJz+dxKGVK+SqeDGug16o4x/AfJlplBjkbcnvEJMsVf7i76IWP3L
	 18fGAzkRASl1o08d6zF6ZpY3xAI17diR+PIq3kIHMYOw7R9sXwLBjcKfLx6eHVlM35JdN
	 znJ4bW5XvhOnLZhzz9u19QRi+b/G88VYvva3r0Js5vvtsqfyy/J/zHMTCrwhqnCBJ73Ig
	 FHN36m0OvaPPOCdoasv701zqMrjbueJ83AkQz5BmiAUTIUMhT/ZppdgEnWZyazF7IsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795429912;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AH17Hl4P0Yy9hJAj3KTSPmG6HltksqpMYCcrpg2AHFw=;
	b=zV/zwS80keS0LjUVV2q6Zp6mzbvQPX+HI2uXOKF57gHHLo9o3AgXtv5ajTe81IomLgus
	 kKR0LfrKp07HAZ6AOZMXH+I1gVgD+HPXifbf/lJleDZuNFkjONPBipK3bS5lITWEiZECb
	 PmrdSmdWydIAdrUlUzs/rVkCKI4JUkQYg9qCwdos9amoapj27o4OCY/XiWbF5Y4yXGkM+
	 2p8LmHXJMM+0UbCIFMH6CCH5NKxiFqD1G0cGel1qx86UhonCOkQ0ZZCTgYFgPDKhfVf9v
	 IT0M3/DnFytiLZmEQoXzLECG4YhXjcurpmYrIpPLkp2kDEutLFMLVXRl+mDjYnkL0og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="j6/8JoQj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5E2606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 10:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6/8JoQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797AB1F00ACF;
	Mon, 23 Nov 2026 10:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795429912;
	bh=AH17Hl4P0Yy9hJAj3KTSPmG6HltksqpMYCcrpg2AHFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j6/8JoQjpObaZM/L6HkeoMdB4YpISXH0m9+wGpBA7zBG1g6hkpZy7OAsm7LdVqkxl
	 uoBCv9uAkvdtlCQ9D/ga1vGn7ve0mJBT7nvv1F8s2TSOmweBTS5nvL968wW9/zA8SB
	 As7FkKpCcovwrkOiVfCx5W8sY1zgHcpWGHs/8efQW2mZ1ha0RfkaMGDDKByMA2B+4J
	 IRvGIfWfPZJLIHO4zBaWe3FGKbKP5gGOa2limRBKdiTD9A9mmBEWrcLVcYBvkquL/L
	 YuwK+ALaCnU/c/W86+gBEgH6DcpTTSBEa7b3dfELZ0mi0/TOOcKszsDVK55rfyr0FH
	 CeqsyX5LF+JcA==
Message-ID: <sashiko-outbox-229048@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: bvme6000: fix request_irq failure cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziheng Wei" <zihengw03@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261123102320.8590-1-zihengw03@163.com>
References: <20261123102320.8590-1-zihengw03@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 10:31:52 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] scsi: bvme6000: invalid free of interior pointer in
  bvme6000_device_remove() [1]
--

commit 684af44cd3d918fdbd788ebad664eb615c0eff53
Author: Ziheng Wei <zihengw03@163.com>

scsi: bvme6000: fix request_irq failure cleanup

This commit unregisters the SCSI host and releases NCR_700 DMA resources
before dropping the host reference on the request_irq() error path in
bvme6000_probe().

Link: https://lore.kernel.org/linux-scsi/sashiko-outbox-228089@kernel.org/

> diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
> index 23301edf100d9..81082e754a655 100644
> --- a/drivers/scsi/bvme6000_scsi.c
> +++ b/drivers/scsi/bvme6000_scsi.c
> @@ -82,6 +82,8 @@ bvme6000_probe(struct platform_device *dev)
>  	return 0;
> =20
>   out_put_host:
> +	scsi_remove_host(host);
> +	NCR_700_release(host);
>  	scsi_host_put(host);
>   out_free:
>  	kfree(hostdata);

[Severity: Critical]
This problem wasn't introduced by this patch, but in the corresponding
teardown path in bvme6000_device_remove(), doesn't kfree(hostdata) pass an
interior pointer of struct Scsi_Host [1]?

NCR_700_detect() stores the allocated struct NCR_700_Host_Parameters
pointer in host->hostdata[0], whereas shost_priv(host) returns
&host->hostdata[0]:

drivers/scsi/bvme6000_scsi.c:bvme6000_device_remove() {
	struct Scsi_Host *host =3D platform_get_drvdata(dev);
	struct NCR_700_Host_Parameters *hostdata =3D shost_priv(host);

	scsi_remove_host(host);
	NCR_700_release(host);
	kfree(hostdata);
	free_irq(host->irq, host);
}

Calling kfree() on shost_priv(host) corrupts the slab allocator and leaks
the actual hostdata allocation; hostdata should be retrieved from
(struct NCR_700_Host_Parameters *)host->hostdata[0] (and host also needs
scsi_host_put(host)).

[1] https://sashiko.dev/#/bug/linux-c25b18f8-e945-482b-8e44-8cd86f4f0aa1

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123102320.8590=
-1-zihengw03@163.com?part=3D1
