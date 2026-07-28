Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1743B14A3;
	Tue, 28 Jul 2026 05:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785216257; cv=none; b=Eu6qjSgVLF77AVSDmLbDqAJlbvTG3Kl8qDdYWV9v+1CoIRP7e0HHuabtIGjzvQv+HKe1Pz48B2SAK1nX3F4dhpVXBs0MTr8zGKdqCPEZHFTBXR0TViN54gAi42HapRIFknwz/HmKm1EBseI6c3YUqyp8OBumGwrx3gyZKR5ExZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785216257; c=relaxed/simple;
	bh=vj/CeQedQhVM2DF2yEnwXmo1lZEThEhA/1+8zGnINWw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iNAdYGwJxOZg+WYa1nzsuwWh8pSDHPJcl1B+61tauLrI9Q8r3ZMIDOSQef67MEIu5Dh2hD1Z9MMUOceAQwwAejmM5H/myvtgJ7AN0A9PhbV3k9woKccR3HBIJkGWtE+5tmY1VtIkQTQcB0RvPvpmJuladpnxKLhd32davFh/Vn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YebnQVQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YebnQVQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111671F00A3D;
	Tue, 28 Jul 2026 05:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216256;
	bh=w8dcoWL/7FsGjt67AhpDDr6Wv+fw1tpYw5W3G46yFqY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YebnQVQReRV6MC3+srszKBWRnPB9VQSNa2f/A8galymfwgijcCPSeukpWllkECjxp
	 +fsiG8oP5l/Z+AsGR9OXUvQk9ArkcAWnk4UjMgOvN5vMguY/dxO8q8np0IKf9fNGAZ
	 8OQtFj3ClUEd4qZGDeK58gF0F1iydo8libsr7aRD7ENm41ZLsOPaY+Kmp6Tu/Nm9GV
	 76jA9Ydd0ecKaDNQniu3ZL7zW399oJOCzEPberMphMQZrfpm57EfD6pfVus14sh0cT
	 KPhxT0yCLWGk28TKVDinRDQbjETXKu0SX9KIm0sRRT2hhhyyn+qC5+y4Oi1PRxcVZw
	 CdQa5p2vJExyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] zfcp: trace return values of sysfs unit add
 store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260728044857.2532646-4-niharp@linux.ibm.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
 <20260728044857.2532646-4-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 05:24:15 +0000
Message-Id: <20260728052416.111671F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unbalanced atomic_dec of port->units on the device_register error =
path in zfcp_unit_add, leading to integer underflow and port state corrupti=
on.
--

--- Patch [3]: [PATCH v2 3/3] zfcp: trace return values of sysfs unit add s=
tore ---
commit 5a4c6fdfefd98873215621f0e0b76392831e1659
Author: Chinmaya Kajagar <chinmayk@linux.ibm.com>

zfcp: trace return values of sysfs unit add store

This commit adds a new debug trace to log failures when adding LUNs via the
sysfs unit_add attribute. It records the wwpn, fcp_lun, return value, and
associated hba whenever zfcp_unit_add() or the initial parsing fails.

> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysf=
s.c
> --- a/drivers/s390/scsi/zfcp_sysfs.c
> +++ b/drivers/s390/scsi/zfcp_sysfs.c
[ ... ]
> @@ -442,17 +442,24 @@ static ssize_t zfcp_sysfs_unit_add_store(struct dev=
ice *dev,
[ ... ]
>  	flush_work(&port->rport_work);
> =20
> -	retval =3D zfcp_unit_add(port, fcp_lun);
> -	if (retval)
> +	retval =3D zfcp_unit_add(port, fcp_lun);

[Severity: High]
This is a pre-existing issue, but since this patch handles and traces
errors returned from zfcp_unit_add(), does this error path contain an
unbalanced decrement?

Looking at zfcp_unit_add() in drivers/s390/scsi/zfcp_unit.c, if
device_register() fails:

drivers/s390/scsi/zfcp_unit.c:zfcp_unit_add() {
    ...
	if (device_register(&unit->dev)) {
		put_device(&unit->dev);
		retval =3D -ENOMEM;
		goto out;
	}

	atomic_inc(&port->units);
    ...
}

The put_device() call triggers the device release callback,
zfcp_unit_release(), which unconditionally decrements port->units:

drivers/s390/scsi/zfcp_unit.c:zfcp_unit_release() {
    ...
	atomic_dec(&unit->port->units);
    ...
}

Since device_register() fails before atomic_inc(&port->units) is called,
wouldn't the atomic_dec() in the release callback underflow the
port->units counter, corrupting the port state machine?

> +	if (retval) {
> +		zfcp_dbf_hba_uas("syuast2", 3, adapter, port->wwpn,
> +				 fcp_lun, retval);
>  		return retval;
> +	}
> =20
>  	return count;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728044857.2532=
646-1-niharp@linux.ibm.com?part=3D3
