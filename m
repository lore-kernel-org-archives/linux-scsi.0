Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957F93B19D1
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408704; cv=none; b=sv7XQ+xWFf+U7e6Ud5wE3iBaCnz27OKGV9V2JaNIdfmI6WoZoH2sGRRxGg5pnLMMP8Ht7909oFsvrsg3GXnjEbsPplNQ+qQlGUebn5N+VvmZhG9aFAzajFoyCi7/hqwiJ8DjQVjLUUJ+DZUWzKhfw9/ZW+00Jfa5wzwockY0lZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408704; c=relaxed/simple;
	bh=jnjRgj8leRfsBy2PZ9SFW3Ob61m3ps7YdLNEAnyFLdI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JcdmoE9HpldDiaeBdHU5YMTpntdhLrOu/CN4sexdT/r1x/Y5mbqvD3c4xcpBP7/rQXccsbJhDQ/TynT1mkHQX4nClzHpl5DXEdtxJGCsIizEGcTUFMEmR4a8siL8MXVU4VDT8Udg3JxzdchqWf3blYdcbnMAkHstLcPfjQsTI4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLLXDM+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLLXDM+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062DD1F000E9;
	Tue,  7 Jul 2026 07:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408696;
	bh=Fn+U3QWsMyUmSDGUuFB7Tb5hYhXvKtnqBQRygLwN8PU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mLLXDM+N2owDXP5BK+xJFXxqqC3LiQWJlh8m1NS+UA36NQqxHg0C8AV/0d39oseMR
	 sRRpQtR+nj5OssZCN9D9JisoFWofSsggfvpS35SDo8AUPBooodslGbV7RxwklfE0v4
	 6SiFE0XsmLpC6Y8bDvB0WQq07wl6VcxN/QD8mLeGu9zEtsGPcIF0DiiEnl/ZYNq9JM
	 ZlY75T2pPAv/4BAZ3SHhkuPyaqZJ3sxxERptCkHrJOLQzYO/NhB1v9hJC3bN8QLYEx
	 SwMXJ7YFsY0i68QJRQLyKBL71GVZrhooK2kxKxSwyG1eyaKeZ9peFQ9MMJFOhpl2KP
	 5bySSXU8gjOxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 63/88] scsi: qla2xxx: Zero mailbox struct in
 qla2x00_get_firmware_state()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-64-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-64-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:18:15 +0000
Message-Id: <20260707071816.062DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized kernel stack memory disclosure vulnerability remains=
 unfixed in the sysfs handler `qla2x00_fw_state_show()` on the success path.
--

--- Patch [63]: [PATCH v3 63/88] scsi: qla2xxx: Zero mailbox struct in qla2=
x00_get_firmware_state() ---
commit 9d1cc31f70b4b1282c00f58b1e61ed39b581f84d
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()

This commit zero-initializes the mailbox command structure in
qla2x00_get_firmware_state() to prevent leaking uninitialized kernel stack
memory on failure paths. It ensures that when early returns occur, userspace
receives deterministic zeroed state rather than stack contents.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index ba4a4764de1fb..ab5648eb5f206 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -2276,6 +2276,8 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, ui=
nt16_t *states)
>  	if (!ha->flags.fw_started)
>  		return QLA_FUNCTION_FAILED;
> =20
> +	memset(&mc, 0, sizeof(mc));
> +
>  	mcp->mb[0] =3D MBC_GET_FIRMWARE_STATE;
>  	mcp->out_mb =3D MBX_0;
>  	if (IS_FWI2_CAPABLE(vha->hw))

[Severity: High]
This is a pre-existing issue, but does this still leak uninitialized stack
memory on the success path for adapters that are not FWI2 capable?

Looking at the caller qla2x00_fw_state_show() in
drivers/scsi/qla2xxx/qla_attr.c, an uninitialized array is declared on the
stack and passed to qla2x00_get_firmware_state():

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_fw_state_show() {
	uint16_t state[16];
        ...
	rval =3D qla2x00_get_firmware_state(vha, state);
        ...
}

When qla2x00_get_firmware_state() completes successfully, it only populates
states[1] through states[5] if the adapter is FWI2 capable:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_firmware_state() {
	states[0] =3D mcp->mb[1];
	if (IS_FWI2_CAPABLE(vha->hw)) {
		states[1] =3D mcp->mb[2];
		states[2] =3D mcp->mb[3];  /* SFP info */
		states[3] =3D mcp->mb[4];
		states[4] =3D mcp->mb[5];
		states[5] =3D mcp->mb[6];  /* DPORT status */
        ...
}

However, qla2x00_fw_state_show() unconditionally formats all six elements i=
nto
the sysfs output buffer, which could expose uninitialized stack memory to
userspace for non-FWI2 adapters:

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_fw_state_show() {
        ...
	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
	    state[0], state[1], state[2], state[3], state[4], state[5]);
}

Should the state array be zero-initialized in qla2x00_fw_state_show(), or
should qla2x00_get_firmware_state() guarantee all returned values are
initialized regardless of the adapter capability?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D63
