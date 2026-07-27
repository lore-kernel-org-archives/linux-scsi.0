Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90460399CE9;
	Mon, 27 Jul 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166766; cv=none; b=YwuEi+tOGqQ+7Rwp2+nTICVzQ+RsMZ16YXI2wYz99vN0KMki72KxRJlQp3GPlKIL34UjKTSYATkjF+GAmCUhKq2mWLDpr1D1rJvERo46Z1IFI4A1OJna6myNmdI3XCRhKgvelIlW4EI3xdzqHusGk/wwwLgCNT7XNeg2mbmx0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166766; c=relaxed/simple;
	bh=/BIkiKa/m5h4daUIGosBvOq7lyvghUc2kNstZSjO/AI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BTNnq+Vu0Iu6+Hs70fXfXf3xc4XblXVfNhPuNHI+jXYNL8dLSxcziAv5ifYjXGPtBwRox2uYG3cu0M2OaRg6UbQNdyHmgfrEhqqnWWIWaqi6PPGOBwGjGbL1KWsEPXrzia8Wz6/tbit/Y+mpKHTyDkgqOyGYmAJuxdnmGeJ7HF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CanSSLR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CanSSLR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221C61F000E9;
	Mon, 27 Jul 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785166765;
	bh=n/os754FLjUwxOdYsJ9k2KC7hX6oZqFUwDCidyjP2Gk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CanSSLR5ErPMDbw38AVEd1D1PdzlybapssTxJu1oLTMUaouKLKpCNjri4XoEoI31E
	 hWodjnHv+nrt5kLV70Y1npHpatbBfatz1UiMUh0N2jADHvD+l3P6/FJ9FjVTkI8JoX
	 z93DZIqbWymIoDu58SbeJBN5ClW07OJ3tGuaPdjm7JFIhJW5JwBpoTnwLArzduhcgz
	 ahNFq7iiwNEPcLBylhyaC1gdt+R3c0vNfIbNC6rNvT2zH5eaSYqYgc7VCha8H+p2hL
	 h+DDyawvaS8F7rk4ONu4Z4eFd8HHMsuoalu+kCMJQ+hyzxKnYN+npUdHQ9Y9gJjHf1
	 BhTXXJB8vDBdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 1/1] x86/VMBus: Confidential VMBus for dynamic DMA
 transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tianyu Lan" <ltykernel@gmail.com>
Cc: linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260727152711.2045-1-tiala@microsoft.com>
References: <20260727152711.2045-1-tiala@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:39:24 +0000
Message-Id: <20260727153925.221C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If storvsc_do_io() returns an error other than -EAGAIN, storvsc_qu=
euecommand() incorrectly returns 0 to the SCSI midlayer, leaking the dynami=
cally allocated payload and causing a command timeout/hang.
--

--- Patch [1]: [PATCH V2 1/1] x86/VMBus: Confidential VMBus for dynamic DMA=
 transfers ---
commit 0fcd974d529c3a7f6e32e98d08ecd19b7a1e7b0a
Author: Tianyu Lan <ltykernel@gmail.com>

x86/VMBus: Confidential VMBus for dynamic DMA transfers
   =20
This commit modifies the VMBus driver to support dynamic DMA transfers
for Confidential VMs. It introduces the co_external_memory flag to bypass
the swiotlb and DMA API, allowing direct DMA to private encrypted memory.

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 571ea549152b1..656fe73e0d35e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c

[ ... ]

> @@ -1870,7 +1882,7 @@ static enum scsi_qc_status storvsc_queuecommand(str=
uct Scsi_Host *host,
>  	ret =3D storvsc_do_io(dev, cmd_request, smp_processor_id());
>  	migrate_enable();
> =20
> -	if (ret)
> +	if (ret && (!dev->channel->co_external_memory))
>  		scsi_dma_unmap(scmnd);
> =20
>  	if (ret =3D=3D -EAGAIN) {

[Severity: High]
This is a pre-existing issue, but if storvsc_do_io() returns an error
other than -EAGAIN, does storvsc_queuecommand() leak the payload buffer
and silently drop the error?

If storvsc_do_io() returns a failure like -ENODEV, the code bypasses the
err_free_payload block and returns 0 to the SCSI midlayer:

storvsc_queuecommand() {
    ...
    ret =3D storvsc_do_io(dev, cmd_request, smp_processor_id());
    ...
    if (ret =3D=3D -EAGAIN) {
        ret =3D SCSI_MLQUEUE_DEVICE_BUSY;
        goto err_free_payload;
    }

    return 0;

err_free_payload:
    if (payload_sz > sizeof(cmd_request->mpb))
        kfree(payload);

    return ret;
}

Since 0 is returned, the midlayer believes the command queued successfully,
but because it was never sent to the host, scsi_done() is never called.
Will this cause the command to linger until a SCSI command timeout occurs
while also permanently leaking the dynamically allocated payload?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727152711.2045=
-1-tiala@microsoft.com?part=3D1
