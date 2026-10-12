Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D0E373BFE
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796718; cv=none; b=CBoF2svu9PHXu8Doanl5WNs9xHO7KwIOcWdW9Lts7nsaUadqZg30PhKsu7dXRDoWsc4bA5nqvp4aNVN+f6D+4n1wyE8h2pDqApgFHRAb7ceeOLFY8C8R/gzpPGRZ/AYBqw9V3i6IjTFf7aanBgUs/ebCteKKh/IgtQa6c66cvyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796718; c=relaxed/simple;
	bh=uuz8lapEkD1DsZWhLW4ZPdkVIRDd+yACrjXU6ulP1Tw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Nk5Tun7cNxNzt/TdfNIDmGg1ibvryr6N+QkuOLyWbxx3yiFb2FKBGpGO/O4hov7qjk+BkDyksca/xJ1T5Bkaqc3hYBkmhKhxZ1BwNw367U8xpBkvfFCT9ljvnYo+8GwmaNoNUBpX7uDn3zQjvEJ/jpfQ3ow8/QEtyLd4uJgS4qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuelRC7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuelRC7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265881F0089C;
	Mon, 12 Oct 2026 09:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791796717;
	bh=Uu08GxPPuU6o69HT4XAUTFrYsG4NdHGbauOV7gk2wbI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IuelRC7ig+9maPz5X2wgaOJfvGC3gVhAHhVN67ySKQQLMxXsJpCn+W8G7xD1/YobT
	 r+Q9+4qIlL+ioXnDFw4csEPZ4l3qE+iQIGn/CXCVYswBSBzY2b1DUXn/0fP+s844Eu
	 wI0Tcno+cBoxB3ivJihk9T9oaa3yB4B/EPHOw7EX0l80/RXXrwie0daCJOgAh4unJG
	 Ypo8iZSXyuP50vDUoz4ayKGyk9iHc25QORu7hez87Mb8DjBAO1Em6+wZkGta2qfZev
	 FB7eRTX0GVVPvoa5ILfNVewFypNbSxF7ePLZcE+LYV1e7rJRAFxdxTGY7V0S9E9KgR
	 l303x+L7hcqTQ==
Message-ID: <sashiko-outbox-167892@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] scsi: arcmsr: wrap the type B completion index
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <d212c8fcde795a43e070d827d1d9d3fe4fcbe65b.1791792888.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
 <d212c8fcde795a43e070d827d1d9d3fe4fcbe65b.1791792888.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 09:18:36 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: arcmsr: missing lock in arcmsr_hbaB_postqueue_isr() allows d=
ouble scsi_done
- [High] scsi: arcmsr: missing bounds check on device-supplied flag_ccb poi=
nter arithmetic
--

commit d4c56c066e7826c7ed7b29fee09fa6ea641b3ec5
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: arcmsr: wrap the type B completion index before using it

This commit fixes an out-of-bounds read in arcmsr_hbaB_postqueue_isr()
and arcmsr_hbaB_polling_ccbdone() by applying a modulo to doneq_index=20
before using it as an array index. The index is read from shared memory=20
where it could exceed the maximum queue size before being wrapped.

Cc: stable@vger.kernel.org

> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2568,7 +2568,7 @@ static void arcmsr_hbaB_postqueue_isr(struct Adapte=
rControlBlock *acb)
>  	bool error;
>  	unsigned long cdb_phy_addr;
> =20
> -	index =3D reg->doneq_index;
> +	index =3D reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
>  	while ((flag_ccb =3D reg->done_qbuffer[index]) !=3D 0) {

[Severity: High]
Does this loop need synchronization to protect the shared completion ring?

The SCSI error handler invokes arcmsr_abort() without holding the host_lock,
which in turn calls arcmsr_hbaB_polling_ccbdone(). Neither
arcmsr_hbaB_postqueue_isr() nor arcmsr_hbaB_polling_ccbdone() acquires
acb->doneq_lock (unlike adapters D and F) or any other synchronization
primitive before reading from the hardware completion ring.

If a command times out and arcmsr_abort() executes on CPU 1 just as the
device interrupt fires and executes arcmsr_hbaB_postqueue_isr() on CPU 2,
could both threads fetch the exact same CCB completion entry? This could
result in concurrently invoking arcmsr_ccb_complete(), leading to a double
scsi_dma_unmap(), double scsi_done(), and corruption of the ccb_free_list.

>  		cdb_phy_addr =3D (flag_ccb << 5) & 0xffffffff;
>  		if (acb->cdb_phyadd_hipart)

[Severity: High]
Can a compromised or malicious hardware device supply a crafted flag_ccb to
trigger arbitrary kernel memory corruption?

The driver derives the pCCB kernel virtual pointer directly from the
device-supplied flag_ccb index without ensuring it falls within the driver's
preallocated CCB pool. When the driver processes this pointer in
arcmsr_drain_donequeue() or arcmsr_report_ccb_state(), it might dereference
an attacker-controlled pointer and write values like DID_OK << 16 to it.

Should there be a software-based bounds check on the calculated offset
before converting it into a CommandControlBlock pointer to protect against
untrusted device inputs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791792888.gi=
t.yhlee@isslab.korea.ac.kr?part=3D3
