Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37078383304;
	Fri, 24 Jul 2026 06:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873604; cv=none; b=WmuvNMoR5oJdWWAfpirT3jNnEfF+geN7GmrBZWkAdSionZQwNP1g7uNU3gUyv3sybN0vMS5lri0XGVX1pj1S8PJmBxivOqiojARDvzo+PTvmRDMlk42pjsFO9++itNqSBAhTpVe1prD6V0pQ9cqhe6vgJNV0uvZPY5elF65zJpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873604; c=relaxed/simple;
	bh=jIGiR0gW0yCab6jPMGRsOh1axvp+lOfSfHwVL9pTThU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eh8ajpAgT7dfbN9heRzdF4Pyb3X5Cn6Gd/3XDTl/DMi3KVQPJ4YkV6yCsnU0tqqKEPvzoZARMbVmYRuwSirxfmjytY80JDCx/gGa9/FZALkOUeoJvnfP3Uy8QueyRa2I2h6rz5XHz3thToKR3roPBkekCTFbfA0EEz5PxLSXnnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6vFWB8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6vFWB8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9DB1F00A3A;
	Fri, 24 Jul 2026 06:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784873602;
	bh=cdiA0wVSeAY+8J+9yQk2C5GGwWU8OvD9aRS2CmDf+bA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y6vFWB8Ia/h5BFbw0MZisGfnMFAUzyj0FFfFEjrPJAkdFUnSWTojSYQfS8pJqKBGj
	 Oc5Q9Zpdc1Cf8lHSKgEJDx0jKgVv8g33BOZMvwF34rxc63fJPPQ7Fuypqbtb7sUteP
	 mW+NjyWzMAaz4aKg6CdOpM3NkOz735rUXPgsYTH0jpja+aRdyahLBS6i0YNuFEjkrL
	 6/UibXP2aPA9MXzcznD0JYIJ7WXfD3BUSxSO5jzP1cOpohsX57nmkFNuHP6NZafmY4
	 vbD5WIdXpKFMV5bG/cEXxXvVnByWtdFz4I7n/X2623VESZNHZRX7R/gaTlsn15vlx/
	 +auIDkIBAiYGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] fixup! zfcp: trace return values of sysfs unit add
 store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260724053934.2781087-5-niharp@linux.ibm.com>
References: <20260724053934.2781087-1-niharp@linux.ibm.com>
 <20260724053934.2781087-5-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 06:13:21 +0000
Message-Id: <20260724061322.6C9DB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unbalanced atomic_dec on error path causes state corruption in `zf=
cp_unit_add()`, permanently bricking the port.
--

--- Patch [4]: [PATCH 4/4] fixup! zfcp: trace return values of sysfs unit a=
dd store ---
commit ccd7f94929b859d2a706671b750a2197236c689b
Author: Nihar Panda <niharp@linux.ibm.com>

fixup! zfcp: trace return values of sysfs unit add store

upstream discussions...

> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysf=
s.c
> index 729c9664a48f8..597e04cdcc976 100644
> --- a/drivers/s390/scsi/zfcp_sysfs.c
> +++ b/drivers/s390/scsi/zfcp_sysfs.c
> @@ -443,7 +443,7 @@ static ssize_t zfcp_sysfs_unit_add_store(struct devic=
e *dev,
>  {
>  	struct zfcp_port *port =3D container_of(dev, struct zfcp_port, dev);
>  	struct zfcp_adapter *adapter =3D port->adapter;
> -	u64 fcp_lun;
> +	u64 fcp_lun =3D 0x0ULL;
>  	int retval =3D -EINVAL;
> =20
>  	if (kstrtoull(buf, 0, (unsigned long long *)&fcp_lun)) {
>  		zfcp_dbf_hba_uas("syuast1", 3, adapter, port->wwpn,
>  				 fcp_lun, retval);
>  		return retval;
>  	}
>=20
>  	flush_work(&port->rport_work);
>=20
>  	retval =3D zfcp_unit_add(port, fcp_lun);

[Severity: High]
This is a pre-existing issue, but does zfcp_unit_add() have an unbalanced
atomic_dec() on its error path that can cause state corruption?

If device_register() fails in zfcp_unit_add(), put_device() is called which
invokes zfcp_unit_release():

drivers/s390/scsi/zfcp_unit.c:zfcp_unit_release() {
	...
	atomic_dec(&unit->port->units);
	kfree(unit);
}

However, atomic_inc(&port->units) is only called after a successful
device_register() in zfcp_unit_add():

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

Because the decrement happens even if the increment hasn't, a failure in
device_register() would drop port->units to -1. Since -1 is used as a
sentinel by zfcp_sysfs_port_is_removing() to determine if a port is
permanently removed, would this failure permanently prevent all future
zfcp_unit_add() operations and SCSI scans on this port?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724053934.2781=
087-1-niharp@linux.ibm.com?part=3D4
