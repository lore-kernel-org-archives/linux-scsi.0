Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63F37E5D9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453949; cv=none; b=L4ZwFAPXcN/iXXdT9mgnb1flH1JtsoYIUEl9nQD4pKCG6+pjfvQYppnut6jaZTX4DHKTVpnNAEj2yoiYp4efdnHuSzgVtRc0nUzgPhTQihtCkK56+TjPIQ6m6iTJ4gojTPOSGWI1v3EsMsFaixDjEHnu1WOYP0yEVLJI4ryG2ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453949; c=relaxed/simple;
	bh=2u3x8Cid3ROKDppkNYR4nCbw3GEbTzGcmaRZPRj1WAA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iqO3GkBpD3kP2OQjSmwvriN1HJd11S0Z5gIZ0GhYf04S9u9LX5JaCbJ1hqsZs/mEdy6JaLET2NA+s/BaZwGRo+Q55FSf8UrJGnCeUYz51jvA3IEunYYgXX44BzMZT6JuNf+7hsEIMd/oGunLYbc11XVxCG8eos1jV3R4xiUOWJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4lJzRwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4lJzRwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A235F1F000E9;
	Thu, 30 Jul 2026 23:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453947;
	bh=RvHwcQ6wrdUg6wXpmCBTGKV+z1AZww8NAqGR0/g0ig4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N4lJzRwvSt5q2SLqWOq3eZLdXCGeRa51BdBXRXgLTHFm/jH35fDmPyk2P2KHCGE3y
	 21tetIklrjfRWqkn/PuiVttk276zIU5n4MNKWM7uX6z6eJzFV5QEXq8nMpyOyy9Wvv
	 P6VybULOW5lZpgC1TD6qsTrBD5FOFy+aqjRaTaGiTzz+dynxkgX9pMHINx/rcX65qr
	 fXPOftiW0PAraOPQHYM6b5O4hF+1SECubbarrVaLP1nPpDvgZJIW9wGsehA1Ghra/t
	 dwy259E1mpHdcfj4Vtiou0f0380CpKs23fGFewm+ldPVXJ9i5A0RcocnBhFtZiVVol
	 g8nUtaTyc0+lA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 49/57] scsi: qla4xxx: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <16b4a91a5061399166a31ab2a79368da09ba0089.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <16b4a91a5061399166a31ab2a79368da09ba0089.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:25:47 +0000
Message-Id: <20260730232547.A235F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of the hardware semaphore lock acquisition qla4_8=
2xx_crb_win_lock() is completely ignored, leading to unprotected concurrent=
 modification of the CRB window.
- [High] A potentially 16-minute long busy-wait loop in qla4_82xx_crb_win_l=
ock() runs with local IRQs disabled, leading to a hard lockup panic.
- [High] The driver fails to check for timeout errors when acquiring hardwa=
re semaphore locks via qla4_82xx_rom_lock() and qla4_82xx_idc_lock().
- [High] The hardware window register is modified, but the protective hardw=
are lock is dropped before performing I/O against the window, opening a TOC=
TOU race condition.
--

--- Patch [49]: [PATCH v3 49/57] scsi: qla4xxx: Enable lock context analysi=
s ---
commit f4615e07e950d925c6341ed2210c4fa827b136dc
Author: Bart Van Assche <bvanassche@acm.org>

scsi: qla4xxx: Enable lock context analysis
   =20
This commit annotates the functions that perform conditional locking
with __no_context_analysis.

> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
> --- a/drivers/scsi/qla4xxx/ql4_nx.c
> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
> @@ -406,6 +406,7 @@ void qla4_82xx_crb_win_unlock(struct scsi_qla_host *h=
a)
> =20
>  void
>  qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, u32 data)
> +	__context_unsafe(conditional locking)
>  {
>  	unsigned long flags =3D 0;
>  	int rv;

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the locking
in this function, I noticed that the return value of qla4_82xx_crb_win_lock=
()
is completely ignored:

	write_lock_irqsave(&ha->hw_lock, flags);
	qla4_82xx_crb_win_lock(ha);
	qla4_82xx_pci_set_crbwindow_2M(ha, &off);

If another PCI function holds the hardware semaphore and the lock request
times out, qla4_82xx_crb_win_lock() returns -1. Does unconditionally
proceeding to reprogram the shared hardware CRB window defeat the mutual
exclusion mechanism and lead to uncoordinated window switching and hardware
state corruption?

[Severity: High]
This is also a pre-existing issue on this same path, but is there a risk
of a hard lockup panic here?

The write_lock_irqsave() call disables local interrupts just prior to enter=
ing
qla4_82xx_crb_win_lock(). Inside the lock acquisition routine, a spinloop
bounded by CRB_WIN_LOCK_TIMEOUT (100,000,000 iterations) calls udelay(10):

drivers/scsi/qla4xxx/ql4_nx.c:qla4_82xx_crb_win_lock() {
	...
		if (timeout >=3D CRB_WIN_LOCK_TIMEOUT)
			return -1;

		timeout++;
		udelay(10);
	...
}

If the hardware is unresponsive or highly contended, this massive spin loop
could run with IRQs disabled for up to 1,000 seconds. Will this invariably
trigger the kernel's hard lockup detector (NMI watchdog) and crash the syst=
em?

> @@ -429,6 +430,7 @@ qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, =
u32 data)
>  }
> =20
>  uint32_t qla4_82xx_rd_32(struct scsi_qla_host *ha, ulong off)
> +	__context_unsafe(conditional locking)
>  {
>  	unsigned long flags =3D 0;
>  	int rv;

[Severity: High]
This isn't a bug introduced by this patch, but while looking at the locking
primitives in this file, I noticed other places where hardware lock timeouts
are ignored.

For example, in qla4_82xx_pinit_from_rom():

	/* Halt all the indiviual PEGs and other blocks of the ISP */
	qla4_82xx_rom_lock(ha);

	/* disable all I2Q */
	qla4_82xx_wr_32(ha, QLA82XX_CRB_I2Q + 0x10, 0x0);

And similarly in qla4_82xx_isp_reset():

	qla4_82xx_idc_lock(ha);
	dev_state =3D qla4_82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);

If the lock is legitimately held by another host or PCI function and times
out, does blindly proceeding to execute hardware halt and reset operations
risk severe hardware state corruption?

[Severity: High]
This is another pre-existing issue in the same file's lock handling, but
is there a TOCTOU race condition when the hardware lock is temporarily drop=
ped?

In qla4_82xx_pci_mem_read_direct() and qla4_82xx_pci_mem_write_direct(),
the protective hardware lock is dropped before performing I/O:

	addr =3D qla4_8xxx_pci_base_offsetfset(ha, start);
	if (!addr) {
		write_unlock_irqrestore(&ha->hw_lock, flags);
		mem_base =3D pci_resource_start(ha->pdev, 0);

While the lock is dropped, could another thread concurrently acquire
ha->hw_lock and reprogram the hardware window to a completely different
address? When the original thread re-acquires the lock and proceeds to
execute the I/O using the PCI pointer, will the hardware device forward
the access to the newly modified window, resulting in corrupted read/writes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D49
