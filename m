Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3C361977;
	Fri, 24 Jul 2026 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873366; cv=none; b=kAI01/DBswYHRwb1XZMx+lFmZHCrO5Ga4N/E7rtQaoWSC2QPwUILWJe82B5nrIeriOgsv1/WaBLK8KiIjKsMY5/e1HaKnd1JJQ/xglSlse67HJm8mLYx2CnDhETP7/qwIxogbVg08zPOQIpE8LhpnnsZ2uxm2UNTW57zr53u/jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873366; c=relaxed/simple;
	bh=1mrkXI2un90Y7sZOcpE+cVy+2kBZ9jv0EClH8wgu1Bo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hczukPDgLuTWNawKNmuqDlcrN3AxNR5d6b9WRciJYYZA2+pmAwJsL/jxzcotKmK6Vj70EZG63qc+X6Td4FEpQil8v0GkIu56P1VKGwxj6nJJCuCD9a3WTFShQ/ZCmPi7vuu5c+HQ1wCvHDGLbNgRHI4xmgKdwi+icumauTVnmng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCkg8Zd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCkg8Zd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128ED1F000E9;
	Fri, 24 Jul 2026 06:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784873365;
	bh=mbJ10/3gnhevM0ACld3+CAdnnwtDpxhjDkE7FQ7Pf+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RCkg8Zd5FDTKbL3kApsa3J4J+QsEXmlUEBJSlRRHQuUyjrTfHvjx1mHX9Svb3f5U+
	 8ziRNUFaPRfiZiyMzqNUFlK8LVdcWhj+ZAlzdbl9fZZzjvV26diOa6Tq0EUfHZF1Tu
	 jgveD6FUlSeBOikCFTAYNIiFSmNeQ9bqsdlULwyxdJnlTIPSem1VIrvm2fXzYwR+Gb
	 OhLGEc5EHLYNBYXzEJzuIK1OH/YokNo2QPmi/dLqQ4fai23njQ5GNKrrCDH7vK7W+L
	 0PmIGy8R0AWKyCP0mWpcX3W+sjp55RLY4RpOAFwSy26LJCmSbH0HS4mJs8xY5hMc6s
	 XAIVRTyRC77iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] zfcp: trace return values of sysfs unit add store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260724053934.2781087-4-niharp@linux.ibm.com>
References: <20260724053934.2781087-1-niharp@linux.ibm.com>
 <20260724053934.2781087-4-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 06:09:24 +0000
Message-Id: <20260724060925.128ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Uninitialized kernel stack memory (`fcp_lun`) is written to a de=
bug trace buffer when `kstrtoull` parsing fails, causing an information lea=
k to userspace.
--

--- Patch [3]: [PATCH 3/4] zfcp: trace return values of sysfs unit add stor=
e ---
commit 2f001159c00d2d39b83745c171b53d3cb2468df3
Author: Chinmaya Kajagar <chinmayk@linux.ibm.com>

zfcp: trace return values of sysfs unit add store

This commit adds tracing for unit_add sysfs attribute failures to help
debug issues where the kernel cannot add a LUN. It adds a new trace record
ZFCP_DBF_HBA_UAS and updates zfcp_sysfs_unit_add_store() to log these event=
s.

> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysf=
s.c
> index 42423549e511d..729c9664a48f8 100644
> --- a/drivers/s390/scsi/zfcp_sysfs.c
> +++ b/drivers/s390/scsi/zfcp_sysfs.c
[ ... ]
> @@ -442,17 +442,24 @@ static ssize_t zfcp_sysfs_unit_add_store(struct dev=
ice *dev,
>  					 const char *buf, size_t count)
>  {
>  	struct zfcp_port *port =3D container_of(dev, struct zfcp_port, dev);
> +	struct zfcp_adapter *adapter =3D port->adapter;
>  	u64 fcp_lun;
> -	int retval;
> +	int retval =3D -EINVAL;
> =20
> -	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
> -		return -EINVAL;
> +	if (kstrtoull(buf, 0, (unsigned long long *)&fcp_lun)) {
> +		zfcp_dbf_hba_uas("syuast1", 3, adapter, port->wwpn,
> +				 fcp_lun, retval);

[Severity: Medium]
Does this code leak uninitialized kernel stack memory into the trace buffer?

If kstrtoull() fails to parse the input, it returns an error and may not
write to fcp_lun. The uninitialized fcp_lun variable is then immediately
passed to zfcp_dbf_hba_uas(), which records it in the trace buffer that
can be read from userspace.

> +		return retval;
> +	}
> =20
>  	flush_work(&port->rport_work);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724053934.2781=
087-1-niharp@linux.ibm.com?part=3D3
