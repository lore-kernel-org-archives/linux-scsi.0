Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B0199FB2
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 16:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755188282; cv=none; b=Q2X7Zbr1wfTjpkVaJeILykuC3ditxAFq+iW9WyX/jUiUbeIXi7y45XTSvYjl8JkZq+lxEFLs+QIa8Gz0fQLiqf7ReVm6CrCszVm3CNNt2xoqU8bTfwIP6uhcnHlqetHCKkJhEjw4mccpeAIhZwUpw/XvoElliv27FZHqzTsdrhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755188282; c=relaxed/simple;
	bh=IzOUKCfLyB2cygS+TJ/xDy/Gjin8HsFFWHegHbfhwPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBMSOT54lHXg51VaH379u1RbLP7dr/mkI/ZuriSe7H3J/vxtr3CDmUpSQpB07v+ZWgfPDk44Un/pPqFhI1Q3xE7M3QSZFxXzNiJ9Xx6/aLswnnuX+HxnBInQGHPLbDLJEBDHn+Y9sjfYLrelomks4eiH3Ir6HjpMNfinFUE179g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bIy2j9oe; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bIy2j9oe"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2r4l3S6fzm174T;
	Thu, 14 Aug 2025 16:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755188278; x=1757780279; bh=5Q2TouVDqPNKgIMFvbU5WdrK
	7kJ4OIjE5Zvp98HT3nk=; b=bIy2j9oec0nWqIeeEVoGCjWrUd06HRHewrwigvw8
	Go9OTf0zWS+e7UdHwtNX/H1mejKZFueMWQixmdg9eReflfqFU15frcnWULRiCzmj
	nhBrT+9N6OINBNG6NPi0MQiuVM8MBg5rPE2pB+WSfQ+o8XzjFIBmjgARkGfCj76j
	ec2sKDB8IdYJzpuKpEWAbpr/A+2UvQugNxy46a54amr/43ukgMr+rXE4wohJMhcq
	dDjIRD1mBo+Bu+EXQYpC1RfaMOOnT83FWnU/wH7g1FxkspayVEaLzSXl1rDjiiJj
	DpWOX9Nu2/sa3AVYkoDeEl7NCTtLJhrgsZtkS0iyK49JcQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zYBN4cQqlGqq; Thu, 14 Aug 2025 16:17:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2r4g0SZKzm0yTk;
	Thu, 14 Aug 2025 16:17:53 +0000 (UTC)
Message-ID: <c9458843-db32-4619-837b-bd0a87cebbae@acm.org>
Date: Thu, 14 Aug 2025 09:17:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
 <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
 <26558c0b-d793-4804-a60e-a21ab7116d1a@acm.org>
 <dcb3c431-c9d8-4f9e-acda-a3111bc05c38@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dcb3c431-c9d8-4f9e-acda-a3111bc05c38@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/14/25 1:24 AM, John Garry wrote:
> From my limited understanding of ufs architecture, we have a ufs host=20
> and a single ufs device.

That's correct. JEDEC publishes a standard for UFS host controllers (the
UFSHCI specification) and another standard for UFS devices (the UFS
specification). UFSHCI stands for UFS host controller interface. Each
UFS host controller can support only one UFS device.

> The host max commands is read in function=20
> ufshcd_mcq_decide_queue_depth() and only MMIO-based register accesses=20
> are required for this.
>=20
> The ufs device max commands is read by sending some query command to th=
e=20
> device. This is held in hba->dev_info.bqueuedepth.
 > > In the driver, we seem to combine the host queue depth and device=20
queue
> depth into a single value, hba->nutrs - see ufshcd_async_scan() ->=20
> ufshcd_alloc_mcq(hba, bqueuedepth) ->=20
> ufshcd_mcq_devide_queue_depth(ufs_dev_qd)
>=20
> ufshcd_mcq_devide_queue_depth(hba, ufs_dev_qd)
> {
>  =C2=A0=C2=A0=C2=A0=C2=A0...
>  =C2=A0=C2=A0=C2=A0=C2=A0return min(ufs_dev_qd, mac); //mac is host max=
 commands
>=20
> }
>=20
> ufshcd_alloc_mcq(bqueuedepth)
> {
>  =C2=A0=C2=A0=C2=A0=C2=A0...
>  =C2=A0=C2=A0=C2=A0=C2=A0hba->nutrs =3D ufshcd_mcq_devide_queue_depth(h=
ba, bqueuedepth)
> }
>=20
> And hba->nutrs is used for the shost->can_queue. And that is why you=20
> need to re-add the shost, as the hba->nutrs may change after querying=20
> the ufs device, which can only be done after adding the shost (in this=20
> series).
>=20
> Am I correct so far?

The above matches my understanding.

> If so, I just don't know why the ufs host and device queue depths are=20
> not handled separately like other SCSI drivers. That would be the shost=
-=20
>  >can_queue =3D ufs host queue depth and the scsi slave device qd would=
 be=20
> the ufs device queue depth.

It is probably possible to convert the UFS kernel driver to this
approach. However, that will lead to some wasted memory. UFSHCI
4.0 controllers may support up to 256 outstanding commands. The UFS
devices that I'm familiar with support 32, 64 or 128 outstanding
commands. pahole reports the following for a local aarch64 kernel build:
* sizeof(struct scsi_cmnd) =3D 344.
* sizeof(ufshcd_lrb) =3D 152.
* sizeof(utp_transfer_cmd_desc) =3D 1024
* SG_ALL =3D 128
* ufshcd_sg_entry_size(hba) =3D sizeof(struct ufshcd_sg_entry) =3D 16
* ufshcd_get_ucd_size(hba) =3D 1024 + 128 * 16 =3D 3072
* sizeof(struct utp_transfer_req_desc) =3D 32

For a controller that supports 256 outstanding commands and a UFS device
that supports 32 outstanding commands this will result in (256 - 32) *
(344 + 152 + 3072 + 32) =3D 224 * 3600 =3D 806,400 bytes of memory that i=
s=20
never used. I'm not sure all UFS users will agree with this.

BTW, reserving space for SG_ALL (128) scatter/gather entries in each
command seems excessive to me but even if that would be addressed, there
still would be a significant amount of memory that is not used without
scsi_host_update_can_queue().

Thanks,

Bart.
