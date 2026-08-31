Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B908E37DEBF
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194851; cv=none; b=A2gGN0jIMDoI3IQGwBxHz2ucKMRjyJntm3Xg4pGO7IxYJ1v00rRZcb8yCUdTmkElumvTwzwB/VlX7n8pCIbTRTVkgw8/4+w6frYt5F2NoNALLietKbCgB/9OKkeAcNZCUS2FsH1zrYEU/Ndduput8WPQ6Qsvctqla+tvO6b3OG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194851; c=relaxed/simple;
	bh=KObFCTOaLQ0zgz/APpjylu2u/3pz5jNjxQgyczcv0s8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iKzSntxOl1rMI3nYKzwIRbWvQybAvbeOpX1y8NwJKOqmK702boQyOPh+b8zJXOtFGTBAINFRfAc9GC2OG11kZtFNxTIfnyNhl38w5LKog4jEUaVK+fcH7t5oRcUAiQSp63DzCSD7DTcXqCJmzEjbtClxSpOBcpGgP+BgxUDX2tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojn7989O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojn7989O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288401F000E9;
	Mon, 31 Aug 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788194849;
	bh=y3AsZF9YWAre7zrb7VBKHld7R3xOHofiDg/CJvq9hsM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ojn7989Ob9V3SQpxD5O8TOmFIz3Wo0GHXC8BfK1Szf3hzKjRArm5/lnncGJqaumaM
	 2mb10NKDjHSpMsFGMK0GRw74P3XSKFFVneFWw+g/4pyUmvenvJbOyWk5cGu7niQx8h
	 HWkj/Jvwl9OdjX15ZmHoD4VDMwXEiVcCdwt+7VCklkKwN9gDadjwSlDFrX7SvFHF23
	 3NIJn67/uvt1+BL7l9IUEBmgHw8Edlj84aGdSC3pe6RwWZ2ImReviuZRc1YGjiEeK2
	 iBJKJZnLx2BLUGy3ZGH/ipxK4Qo2wdQsoCfvTtuzSBqvxOeofTrFtVqsWLkaXEqH2X
	 6J6G6ews4CgsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] scsi: pm8001: Reject non-fatal dump
 when controller is crashed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831133314.4125787-493-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-493-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 16:47:28 +0000
Message-Id: <20260831164729.288401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Returning -EINVAL from pm80xx_get_non_fatal_dump() is improperly h=
andled by its caller, which truncates the negative error code to a large po=
sitive u32 integer, leading to severe sysfs corruption and kernel memory le=
ak.

Pre-existing issues:
- [High] Preexisting buffer overflow in pm80xx_get_non_fatal_dump due to in=
correct snprintf size parameter and trusting unvalidated hardware register =
values for loop bounds.
- [High] The sysfs callbacks for fatal and non-fatal dump collection access=
 and modify shared driver state and hardware registers without holding any =
locks.
--

commit 88fed450e7290e833f0fc22f3e8782d89c4fea56
Author: Kumar Meiyappan <kumar.meiyappan@microchip.com>

scsi: pm8001: Reject non-fatal dump when controller is crashed

pm80xx_get_non_fatal_dump() can be called even after the controller has
entered a fatal error state. In that case the forensic memory contents
are not safe to access for a non-fatal dump request, and attempting to
do so can trigger a call trace.

Check controller_fatal_error before reading the non-fatal dump buffer
and return -EINVAL when the controller is already in a crashed state.

Link: https://patch.msgid.link/20260416154650.415624-1-sagar.biradar@microc=
hip.com

> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 31960b72c1e92..1ce8226fcd292 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -401,6 +401,13 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cde=
v,
>  	char *buf_copy =3D buf;
> =20
>  	temp =3D (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
> +
> +	if (pm8001_ha->controller_fatal_error) {
> +		pm8001_dbg(pm8001_ha, FAIL,
> +			   "non-fatal dump not available in fatal error state\n");
> +		return -EINVAL;

[Severity: High]
Does returning -EINVAL here cause a massive sysfs memory leak?

The caller of pm80xx_get_non_fatal_dump() in drivers/scsi/pm8001/pm8001_ctl=
.c
is non_fatal_log_show(), which stores the return value in a u32:

drivers/scsi/pm8001/pm8001_ctl.c:non_fatal_log_show() {
	u32 count;

	count =3D pm80xx_get_non_fatal_dump(cdev, attr, buf);
	return count;
}

When pm80xx_get_non_fatal_dump() returns -EINVAL, count becomes a large
positive integer (4294967274). This is returned to the sysfs core as a ssiz=
e_t.
Because the sysfs core sees a huge length, it caps it to PAGE_SIZE and copi=
es
uninitialized kernel memory to userspace.

> +	}
> +
>  	if (++pm8001_ha->non_fatal_count =3D=3D 1) {

[Severity: High]
This isn't a bug introduced by this patch, but does this sysfs read callbac=
k=20
access shared driver state and hardware registers concurrently without hold=
ing
any locks?

Since sysfs read callbacks are not serialized, multiple threads reading the
non_fatal_log sysfs file concurrently can increment pm8001_ha->non_fatal_co=
unt
and execute multi-step MMIO sequences simultaneously.

This also seems to affect pm80xx_get_fatal_dump() which modifies hardware
registers without serialization:

drivers/scsi/pm8001/pm80xx_hwi.c:pm80xx_get_fatal_dump() {
	...
	pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
			pm8001_ha->fatal_forensic_shift_offset);
	...
}

Could concurrent reads overwrite each other's hardware doorbell requests and
corrupt the forensic DMA setup?


[Severity: High]
This is a pre-existing issue, but is it possible for snprintf to write
out-of-bounds later in this function?

drivers/scsi/pm8001/pm80xx_hwi.c:pm80xx_get_non_fatal_dump() {
	...
	accum_len =3D pm8001_mr32(nonfatal_table_address,
			MPI_FATAL_EDUMP_TABLE_ACCUM_LEN);
	output_length =3D accum_len -
		pm8001_ha->forensic_preserved_accumulated_transfer;

	for (index =3D 0; index < output_length/4; index++)
		buf_copy +=3D snprintf(buf_copy, PAGE_SIZE,
				"%08x ", *(temp+index));
	...
}

The loop dictates the number of iterations using accum_len, which is read
directly from the hardware register MPI_FATAL_EDUMP_TABLE_ACCUM_LEN.

If the hardware provides a large value, snprintf is statically passed PAGE_=
SIZE
on every iteration instead of the actual remaining buffer space
(PAGE_SIZE - (buf_copy - buf)). This allows snprintf to write past the end =
of
the single-page sysfs buffer, leading to a kernel heap buffer overflow.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831133314.4125=
787-493-sashal@kernel.org?part=3D1
