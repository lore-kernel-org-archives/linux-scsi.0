Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9350486341
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786606748; cv=none; b=Dva6C7RYJ21ElKe/H657HOr2Y/xZ/bNCBH2nuprJrv9L4v+6tfpPcyQAkqsVtGYaIaN+2oIr9HSJkrVTpFovYV/RwJ+z71/jGSZjbqnow5Z/QmMbLEi4Ct5N2pTfu4C+36gFfeHnEI/3cipco/HdoR2SDFxMmriPuj+HprzOU7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786606748; c=relaxed/simple;
	bh=vPrj9PiuOYnywtnmHrONRdjIpLBRKCY9/9HIbIEOmlE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HcWgI40oI5DClrS9zhSeQaAbHImgkp3lZt+3kwfNn6hTp5/IVFfOGmcVef4ZRGhjhT0oqJcuJN/vgXDCMlxwKmQZvmxAQ9IVBvij87UnL0XmKmcIxdxp3viPG9P+yvAmRqFts4TUhFmbXMxsV9pyYBRNedF5m54EfzCNqVe8ZrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecBD3RZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecBD3RZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F541F000E9;
	Thu, 13 Aug 2026 07:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786606747;
	bh=kMRkpK9u12Gy9idMVldVnWsh4v1I6D8d/GKMo7JzofA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ecBD3RZQaDd2tVfykPReV2lebwaqzlBMmkNIfB85/sb+k2BEHSj+KW9SnmLgS4wyY
	 +g+qEkixr+U47mI3W0uxpl59RP8biNbuLZgrkmPABCxYcSwFtNbxY4qOg4iju12uSe
	 xiOe6t+ngbiCOcXmVCro9nuBubR9lMIDb7t7jyatAisCyMnkLRaoPcO8gfutkED7mm
	 oiuMihyaRaqyDwcg09w46p1nVd/zpjacirsBxoQqI1ZMEQj4OGDk2gkH9OsRyxnGgm
	 pDvjAuWXEyg58B839go3pK7oSe2gsUZ8S6CTIQPcdPFSiEeDg+sVETC8i2xhS/4/jk
	 JXVSKPTuv3kBA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: leapraid: serialize firmware log mmap with
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linmao Li" <lilinmao@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260813072614.1387555-3-lilinmao@kylinos.cn>
References: <20260813072614.1387555-1-lilinmao@kylinos.cn>
 <20260813072614.1387555-3-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 07:39:06 +0000
Message-Id: <20260813073907.24F541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Device removal and module unloading can be permanently blocked by =
a userspace process holding an open memory mapping.
--

--- Patch [2]: [PATCH v2 2/2] scsi: leapraid: serialize firmware log mmap w=
ith teardown ---
commit 3180bb0e1579b0aca65c2e7927f3bdc91744a626
Author: Linmao Li <lilinmao@kylinos.cn>

scsi: leapraid: serialize firmware log mmap with teardown

This patch addresses a race condition where a firmware log buffer could be
freed during device removal while a concurrent mmap operation is
establishing a userspace mapping. It claims a temporary mmap reference
while looking up the adapter, and drops it on the exit path.

> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid=
/leapraid_app.c
> index 841027ce2501c..790a3191e9259 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c
[ ... ]
> @@ -771,6 +773,9 @@ static int leapraid_fw_mmap(struct file *filp, struct=
 vm_area_struct *vma)
> =20
>  	rc =3D 0;
>  out_put:
> +	if (adapter &&
> +	    atomic_dec_and_test(&adapter->fw_log_desc.mmap_refcnt))
> +		wake_up(&adapter->fw_log_desc.mmap_waitq);

[Severity: High]
This is a pre-existing issue, but can this userspace-controlled reference
count block device removal and module unloading permanently?

Since a userspace process can hold the VMA open indefinitely, and device
removal waits unconditionally in leapraid_fw_log_exit() for the count to
reach zero:

drivers/scsi/leapraid/leapraid_func.c:leapraid_fw_log_exit() {
    ...
    wait_event(adapter->fw_log_desc.mmap_waitq,
               !atomic_read(&adapter->fw_log_desc.mmap_refcnt));
    ...
}

Could a buggy or malicious userspace process that never unmaps the memory
cause the kernel thread handling PCI hotplug or sysfs unbind to hang
forever without a timeout?

>  	leapraid_ctl_put_adapter(adapter);
>  	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813072614.1387=
555-1-lilinmao@kylinos.cn?part=3D2
