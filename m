Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5843042CB02
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305828; cv=none; b=UScULoajF5mWg/Gz6QPqs5VIMLrQGt/iJU9fNaTLsa0hsYEaDEuXnX2zk/o1v4L19TUiNiEnXng4Vrh5CPQQriL7q8KBGIyqwdL0PBluamCUe782Dku4MtFSR8Lu07OtayAyPmKpoOMkG3lio07DnoxboQLfcc+2nM8RuFE3D8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305828; c=relaxed/simple;
	bh=i+dJI8K3zdBmqvX2BKHhW8IRDNfebTgYN5LboMWFo5U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZECLg2/qO9Au4sgkVDXw9Ps+cDVhseDFyLjS0f3JlnvfsVjANZ4LOhZ7rBF0nzLPxQ12QiOd+/wAuFB2VAUuEUiDzQmP2Y7UDY7BlDHht4/ar+lSVS3tieqh0QaD/8Jtf1OFyKhNw/1EliMLrrQ7vYvj1GBYjXaYagfHar9qGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdOjzXJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdOjzXJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26771F000E9;
	Fri, 17 Jul 2026 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305827;
	bh=6HcW1aon9o4Z6F83Wnx1uUV8DuY3t78VfnNruEAsOWA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IdOjzXJ4w2BG3Cpn0nIVwDMqOX4AOQQo8GXRSNBgkMu5+LB/27HKSEyVJEriI22KF
	 ykoN2OeQZGkU7fHda1nxrHYLPW0o4kYMCJvT9z/7UU8A4pKOmvFPFZZK3Tdtq2mXxb
	 l1nlX1QGWSLQiCPD6yuUbWxN+0I+TD/YYUYAiKU1juFrrjV7bixfzLfhn57/VB7HnI
	 Y8NMt76nkfljammOdc0AN2qz/W4r/l0d5lvAd5z0Amz5gvxJZuz2Jlvc19667B4Uuo
	 Iw2Y8heHcVC0M0EhoV/VfRAJ82FOgpzwrj9rfgZki620iAgu/pL9J/qodQoqwZh5ef
	 7ZCPG1RvCbE1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/56] scsi: qla2xxx: Enable serdes, resource count
 and FCE trace for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-20-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-20-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:30:26 +0000
Message-Id: <20260717163026.D26771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `kstrtoul` function in `qla2x00_dfs_fce_write` is called with =
a NULL pointer for its output parameter, leading to a guaranteed kernel cra=
sh when a valid input is parsed.
- [High] Dynamically enabling FCE via debugfs causes a heap buffer overflow=
 during firmware dump collection because the pre-allocated dump buffer is n=
ot resized.
- [High] Concurrent execution of `qla2x00_dfs_fce_write` and firmware dump =
generation causes a use-after-free on `ha->fce`.
- [High] QLA29XX is missing from the adapter shutdown firmware cleanup logi=
c, leading to improper shutdown state.
--

--- Patch [19]: [PATCH v5 19/56] scsi: qla2xxx: Enable serdes, resource cou=
nt and FCE trace for 29xx ---
commit 128c0c55efd466adf4231392e126249fba36c3dc
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx

The 29xx adapters share the diagnostic and management interfaces
already supported on ISP27xx/28xx, but several family capability
gates still omitted IS_QLA29XX(), leaving these paths unreachable
on 29xx.

> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_df=
s.c
> index 43970caca7b39..177d47e92e494 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -497,7 +497,7 @@ qla2x00_dfs_fce_write(struct file *file, const char _=
_user *buffer,
>  	unsigned long enable;
> =20
>  	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
> -	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
> +	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) {
>  		ql_dbg(ql_dbg_user, vha, 0xd034,
>  		       "this adapter does not support FCE.");
>  		return -EINVAL;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but since 29xx adapters will now
execute this code, could we fix a NULL pointer dereference later in this
function?

In qla2x00_dfs_fce_write(), kstrtoul() is called with a NULL pointer for the
result:

	enable =3D kstrtoul(buf, 0, 0);

A successful parse will unconditionally write the value to the address
provided, resulting in a kernel panic when a valid number string is
written to the debugfs node.

[Severity: High]
This is a pre-existing issue, but enabling FCE dynamically via debugfs might
corrupt memory when a firmware dump is collected.

When FCE is enabled, qla2x00_dfs_fce_write() attempts to adjust the firmware
dump buffer:

	if (!ha->flags.fce_dump_buf_alloced)
		qla2x00_alloc_fw_dump(vha);

However, qla2x00_alloc_fw_dump() returns early if the buffer is already
allocated, failing to resize it to accommodate the FCE data:

	if (ha->fw_dump) {
		ql_dbg(ql_dbg_init, vha, 0x00bd,
		    "Firmware dump already allocated.\n");
		return;
	}

If a firmware dump is later triggered, functions like qla27xx_insertbuf()
will append the FCE trace to the undersized buffer:

	buf +=3D *len;
	memcpy(buf, mem, size);

Could this cause a heap buffer overflow?

[Severity: High]
This is a pre-existing issue, but does the FCE trace buffer free path
have a race condition with firmware dump generation?

When disabling FCE, qla2x00_dfs_fce_write() frees the buffer under fce_mute=
x:

	qla2x00_free_fce_trace(ha);

Concurrently, if a firmware crash triggers a dump, qla27xx_fwdt_entry_t264()
reads and dereferences the pointer without holding fce_mutex:

	if (vha->hw->fce) {
		...
		qla27xx_insertbuf(vha->hw->fce, FCE_SIZE, buf, len);

Can this lead to a use-after-free if the dump routine reads the pointer bef=
ore
it is freed but executes the memcpy after the free?

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but should the IS_QLA29XX check
also be added to qla2x00_shutdown() in qla_os.c?

During system shutdown, the capability gate bypasses
qla2x00_abort_isp_cleanup() for QLA29XX:

	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
	    IS_QLA28XX(ha)) {
		if (ha->flags.fw_started)
			qla2x00_abort_isp_cleanup(vha);
	} else {
	...

This leaves the firmware and DMA engines active, which might cause memory
corruption or hangs during kexec or a warm reboot.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D19
