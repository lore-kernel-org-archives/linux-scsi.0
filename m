Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097C837754B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407832; cv=none; b=AvY3EkrrnvzwZB/egrPCBBk6YVKhM59Z6AUdEhPzx910MBAwSY1n9kPoKFG4IwndJm1CvUuiPKbuJxKPB8dVoLEBaf7l27F7MR2iJZg1XtC51TEdLDSdMx1btAAh8aoAdjBR0b5hAizBRSSfBNeE6QK7IkfG55pePMDREbaiVkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407832; c=relaxed/simple;
	bh=Hd0CnFLU7NZx3+fI8uWoH5vXB5NG0LLd4GWHcvBMN4g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MPMhy3b558cQfgxA8JzEdjZGA6GMzqm14mIhE2wLrBPZ9nZ8ZJ2z2NgTAgdZNTQEZHsVT5Kg522cZRWqDqdM2hIeD27YptJ0bflqmhUOfi9mrWCHsHN+wUmaFVDcBB4r5/uTG7oYISYOaiQ2PZE2mRjbt+CFOxuvX/SMJA5fVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhXgsMpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhXgsMpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9867E1F00A3A;
	Tue,  7 Jul 2026 07:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407830;
	bh=EkQDjuX4SqgtUfKDh4sbDbdbvoYWk1EJy44pSSEKI1k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lhXgsMpx11Mfe7A4V62cOboNipVbysSDVmYtipGOLTJknJ/p9ZW8Abz6MR0AA+Twe
	 3a5l3YShD0b1b950WS6MgRlRuBEI3CetsRONUIKLuuluYb5Gb5XD0eZnf/+igdYmA0
	 Ar9WL+UkEHhY3Jy8PKCSTdnZi5lEmsFAMgbldRTPr4ZZU/tO7v+csfHxrh1+jdVWnE
	 HXcYpYJ3wGxIOaC2Jjj0zpCiYUgXrbzsGdNDytsgydhhWNsUr4Br4KJlLNhjULFvLG
	 49Bc/GkeTAZmnAZD81WgH6xo4TD87+8n23PtEBoLg1KS2zG2JEAAhTAQHC+g5y8es5
	 XCMsXryGVgAIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 62/88] scsi: qla2xxx: Don't query firmware state
 while chip is down
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-63-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-63-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:03:50 +0000
Message-Id: <20260707070350.9867E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `qla2x00_fw_state_show` sysfs attribute handler leaks 10 bytes=
 of uninitialized kernel stack memory to unprivileged userspace on older (n=
on-FWI2 capable) adapters.
- [High] TOCTOU race condition in `qlafx00_fw_state_show()` due to lockless=
 checks, allowing unsynchronized mailbox commands during ISP reset.
--

--- Patch [62]: [PATCH v3 62/88] scsi: qla2xxx: Don't query firmware state =
while chip is down ---
commit 7d6c905f305cb054a288e70e2b54f81eb14573f5
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Don't query firmware state while chip is down

This commit addresses an issue where qla2x00_fw_state_show() issues an
unsynchronized mailbox command during an ISP reset or PCI error recovery.
It updates the error path to avoid re-issuing qla2x00_get_firmware_state()
outside of the optrom_mutex. This ensures mailbox commands are only sent
when the chip is up and not EEH-busy.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6a87d3bb0b0eb..a4ca22024edeb 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1678,10 +1678,8 @@ qla2x00_fw_state_show(struct device *dev, struct d=
evice_attribute *attr,
>  	rval =3D qla2x00_get_firmware_state(vha, state);
>  	mutex_unlock(&vha->hw->optrom_mutex);
>  out:
> -	if (rval !=3D QLA_SUCCESS) {
> +	if (rval !=3D QLA_SUCCESS)
>  		memset(state, -1, sizeof(state));
> -		rval =3D qla2x00_get_firmware_state(vha, state);
> -	}
> =20
>  	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
>  	    state[0], state[1], state[2], state[3], state[4], state[5]);

[Severity: High]
This is a pre-existing issue, but does this function leak uninitialized ker=
nel
stack memory to userspace on older adapters?

In qla2x00_fw_state_show(), the state array is declared on the stack without
initialization. If qla2x00_get_firmware_state() succeeds on a non-FWI2
adapter, only the first element is populated:

qla2x00_get_firmware_state() {
        ...
        states[0] =3D mcp->mb[1];
        if (IS_FWI2_CAPABLE(vha->hw)) {
                states[1] =3D mcp->mb[2];
                ...
        }
        ...
}

The remaining elements (state[1] through state[5]) remain uninitialized, but
they are unconditionally formatted by scnprintf() and exposed to userspace
when reading the sysfs attribute. Should the state array be zero-initialized
when it is declared?

[Severity: High]
This isn't a bug introduced by this patch, but while fixing the missing
serialization here, is the qlafx00-specific path still vulnerable to the
same adapter hang?

When qla2x00_fw_state_show() calls qlafx00_fw_state_show() earlier in the
function for fx00 adapters, the reset and EEH busy states are checked
without holding the optrom_mutex:

qlafx00_fw_state_show() {
        ...
        if (qla2x00_reset_active(vha))
                ql_log(ql_log_warn, vha, 0x70ce, "ISP reset active.\n");
        else if (!vha->hw->flags.eeh_busy) {
                rval =3D qlafx00_get_firmware_state(vha, state);
        }
        ...
}

If an ISP reset or PCI error recovery begins immediately after this lockless
check, does qlafx00_get_firmware_state() issue an unsynchronized mailbox
command to the resetting chip? Could this be prevented by applying the same
mutex protection to the qlafx00 branch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D62
