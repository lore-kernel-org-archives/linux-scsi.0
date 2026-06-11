Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8432135DA6C;
	Thu, 11 Jun 2026 05:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155877; cv=none; b=pAIZRJCiRJZpiVg1uPFrB+WIueWbTW1oYCxAvHmYWqv+2YXzdW714/wFFR2HlFDj8ybwSZLhLldG5j1jH5/JRmuLPmfOvn3+jhsK3UA9yUQ8um060TDhtFWoM/UldUo+1yhOR92T3A+a+VtleCycfju+S892GuZkBv/64PjCnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155877; c=relaxed/simple;
	bh=rotmOvlrl5edWdBLhhVradm0ReD6D/d84BNrkbqs+KI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fl/SbaH7et03kB0xbU8dlvUPi/vA1Hf/UvF5Fxi7zY9DKjPXzdqd58qsJoqaXeYow7jfFmel5e4P7iR5GEYMQrg6SoLCVwCNl/pj9txhUpkCgGdrk8dR+X2i59E4b9w5y4QOoM+jTbh7w8/EDVLrva56FgMNYKe5OQh6ERREFNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQudeafs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQudeafs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7602F1F00893;
	Thu, 11 Jun 2026 05:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781155874;
	bh=7KzzAszJz6+pq055Ux6PtIqk7yijdEgzoxsUQn27HrE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bQudeafss5xeGGyHPQpoPsStHHqcYDC+nyBTrzkOUOQ2o34HBWts5l87ddUWo8eIK
	 0zJolUC4nZOKPoDNEXPTNegzlCfca2hXP2BiUMT66JuVHfJXnCkapK//hn71Z5yJbD
	 fdN+30DHKEQ1PL47GrehHHR0CGqnG7ujCoeo9313PxwQn8lcDj2Yy8X48pMqQNJtHC
	 Vd2bKsSRnUGeOj/+3aj/vnqd/yqZgjQJjd8E7LEfxg27NZ6jPMnc7YcNLOLGBZAjw7
	 7DwKChGreqdHd1+tmCDO3F6mwXFQnCc+7UkXzo2kGeR28FunrFxkKTiAwclZ3M/jVb
	 5xxrd0W5FzyXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] zfcp: trace return values of sysfs unit add store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260611050550.796772-5-niharp@linux.ibm.com>
References: <20260611050550.796772-5-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 05:31:14 +0000
Message-Id: <20260611053114.7602F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Uninitialized stack variable `fcp_lun` is logged to the debugfs =
trace buffer when `kstrtoull()` fails, leaking kernel stack memory.
--

commit 907efa1a4b46ed7f2ac643c1a75f4e115a834154
Author: Chinmaya Kajagar <chinmayk@linux.ibm.com>

zfcp: trace return values of sysfs unit add store

This commit adds tracing for zfcp sysfs unit add failures to help debug
cases where the kernel cannot add a LUN. It records the wwpn, fcp lun id,
return value, and associated hba of the device.

> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysf=
s.c
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
Is there a risk of leaking kernel stack memory into the trace buffer here?

If kstrtoull() fails to parse the input string, it returns an error and
leaves the stack-allocated fcp_lun unmodified.

Since fcp_lun is uninitialized, this trace call passes 8 bytes of
uninitialized stack memory to zfcp_dbf_hba_uas(), which might expose it
via the DBF trace ring buffer and result in misleading garbage LUN values
in the log.

> +		return retval;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611050550.7967=
72-1-niharp@linux.ibm.com?part=3D3
