Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794621938;
	b=zCP2BwGepvmnXLBMSiJ2bg+aqFG5aV4AxI/YNI3GBcouNLO72QiFWTuGzCMx1hHoOxlQ
	 q95QqsmjMWIH2ncHhwuoC+n5HxZAOBr0qhOivU8ME2C9KHC4wRYvpzmLyqutbW2x97wN4
	 2sMhe2IipKFOs3IDZtBhw+sMv3Z9vY2fvCq0ZXBnsdeAfvY0yIXaD6TkWfZBc3jcnah9y
	 0EHRMrUBOkgYF3nRwR2IdmazKlGr0imSGuJCxF9WB0Pz303vVepcjly1SJ969Hb63UJKu
	 nAvLg6URWS8GD0HikroZjD5+tGuIEEwiLBA7ha1mTibua8VsTDQaJRPguS5zsDrbsqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794621938;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=V+gy4cBhBzVJQehhpS/eNec8NXKHqCiPYKqgyEaV3G4=;
	b=eupOsfdgSViJTzerXkZATpKgz+BTmaLXuc22JtHzC7SOVEX+spcfbbxHXWPbminyGmk3
	 /eBh164AWjEFlesF/8h7ogZStAjXlHKNaB2fRU5Xsu0N0auup6+wgP3Riqsq1GJPqC6lQ
	 n6YW/D8aqJlHimHIpUXiOLWwHDsEWEA0vvBQqhRdIydhFc9DFVraTIdVwtYKCcCwXPzMA
	 O2NhUtcp/3D/Aeeg64FrxWK49L+XsPAUlNCNa+/jkCp4EtPIxSVeT6eg7p/X6FaneZQB2
	 AZ9feki6mJkt1WE1BI/GbtDsDG2UXvT8IN08v5S0KWy4jXQFFNIPT0EFs+9N1BBFwFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ery94GoV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F30606A331
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 02:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ery94GoV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95651F000C4;
	Sat, 14 Nov 2026 02:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621938;
	bh=V+gy4cBhBzVJQehhpS/eNec8NXKHqCiPYKqgyEaV3G4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ery94GoVKSrFl6g1Cr1sfpV2S+j9AfBf6UZXLCIlA6pbwpV0zezeivdeFhin3e+A8
	 rRauybRCWCsuWJ9PZHRlIBNPOSpXCCQhh75JOORkLQv/c5z5ic3mCcp5Dpx9HGnqna
	 kflR4CHlj9D/gBND1OgapqpUWxCO1z9hyT7UxyWhvs/f3lD8Bm2ewKvDNoDyVyKXer
	 9/PpTe1IWszWYfszfedUr0LLxIahEvsVPX45tUThzcZosPFhUTdbk/rPp2hjlIrQkG
	 qhsSQ8g1xtOnOivHe51eEEb8mU0xcOPxbCT+Iy51tpIbzzgYMl7kzsSRIjVvwhbzLP
	 skcPQtHw37Wdg==
Message-ID: <sashiko-outbox-214039@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: mvumi: quarantine a timed-out internal
 command's buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261114014430.489668-3-yhlee@isslab.korea.ac.kr>
References: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
 <20261114014430.489668-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 02:05:37 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: mvumi: timed-out cmd buffers reused in
  mvumi_probe_devices()
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [Critical] scsi: mvumi: DMA truncation and endian bug in
  mvumi_delete_internal_cmd() [1]
- [Critical] scsi: mvumi: double free in mvumi_issue_blocked_cmd() [2]
--

commit b4af4f62626fb1da667cca96d5f542e3958c02f2
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: quarantine a timed-out internal command's buffers

This commit marks internal commands that time out in
mvumi_issue_blocked_cmd() and places their DMA buffers on mhba->res_list in
mvumi_delete_internal_cmd() so they are not freed until driver unload.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 8d22d370d8608..dbbfa1cbae008 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

[ ... ]

> @@ -298,11 +321,19 @@ static void mvumi_delete_internal_cmd(struct mvumi_=
hba *mhba,
>  			phy_addr =3D (dma_addr_t) m_sg->baseaddr_l |
>  				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
> =20
> -			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
> -								phy_addr);
> +			if (cmd->timed_out)
> +				mvumi_quarantine_buf(mhba, cmd->data_buf,
> +						     phy_addr, size);
> +			else
> +				dma_free_coherent(&mhba->pdev->dev, size,
> +						  cmd->data_buf, phy_addr);

[Severity: Critical]
This problem wasn't introduced by this patch, but does reconstructing
phy_addr [1] truncate the upper 32 bits and miss endianness conversions?

m_sg->baseaddr_h is a u32, so (m_sg->baseaddr_h << 16) << 16 is evaluated in
32-bit arithmetic and zeroes the upper bits before the cast to dma_addr_t,
and neither baseaddr_l nor baseaddr_h is converted with le32_to_cpu().
Passing the corrupted phy_addr to dma_free_coherent() or
mvumi_quarantine_buf() causes IOMMU faults or frees the wrong DMA mapping on
64-bit or big-endian systems.

[ ... ]

> @@ -734,6 +765,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *=
mhba,
>  	if (atomic_read(&cmd->sync_cmd)) {
>  		spin_lock_irqsave(&mhba->shost->host_lock, flags);
>  		atomic_dec(&cmd->sync_cmd);
> +		cmd->timed_out =3D 1;

[Severity: Medium]
Can mvumi_probe_devices() reuse cmd->frame and cmd->data_buf after a timeout
without quarantining them first?

mvumi_inquiry() only calls mvumi_delete_internal_cmd() when its caller pass=
ed
a NULL cmd, but its sole caller mvumi_probe_devices() allocates a single cmd
up front and reuses it across every target ID:

drivers/scsi/mvumi.c:mvumi_probe_devices() {
	cmd =3D mvumi_create_internal_cmd(mhba, 64);
	...
	for (id =3D 0; id < maxid; id++) {
		wwid =3D mvumi_inquiry(mhba, id, cmd);
		...
	}

	if (cmd)
		mvumi_delete_internal_cmd(mhba, cmd);
}

When mvumi_issue_blocked_cmd() times out on target id, the next loop
iteration zeroes cmd->data_buf, overwrites cmd->frame, pops the just-releas=
ed
tag from mhba->tag_pool, and resubmits the same DMA buffers while the
controller may still DMA to or read from them for the timed-out command.
In addition, if mvumi_match_devices() returns -1 in that loop,
mvumi_probe_devices() returns early without calling
mvumi_delete_internal_cmd().

>  		if (mhba->tag_cmd[cmd->frame->tag]) {

[Severity: Critical]
This problem wasn't introduced by this patch, but can a completion arriving
just as wait_event_timeout() expires race with this timeout path [2]
and double-release cmd->frame->tag?

cmd->sync_cmd is checked before acquiring mhba->shost->host_lock and is not
rechecked under the lock:

CPU0                                  CPU1
mvumi_issue_blocked_cmd()
  wait_event_timeout(...)
  if (atomic_read(&cmd->sync_cmd))
                                      mvumi_isr_handler()
                                        spin_lock_irqsave(&host_lock, ...)
                                        ...
                                        atomic_dec(&cmd->sync_cmd)
                                        mhba->tag_cmd[tag] =3D NULL
                                        tag_release_one(..., tag)
                                        spin_unlock_irqrestore(&host_lock, =
...)

                                      mvumi_queue_command()
                                        spin_lock_irqsave(&host_lock, ...)
                                        tag_get_one(...)  /* gets same tag =
*/
                                        mhba->tag_cmd[tag] =3D new_cmd
                                        spin_unlock_irqrestore(&host_lock, =
...)

    spin_lock_irqsave(&host_lock, ...)
    atomic_dec(&cmd->sync_cmd)
    if (mhba->tag_cmd[tag])
      mhba->tag_cmd[tag] =3D NULL
      tag_release_one(..., tag)  <-- frees new_cmd's active tag

Releasing an active tag back into mhba->tag_pool allows it to be handed out
to a third command while new_cmd is still in flight, corrupting tag_pool and
misdirecting command completions.

[1] https://sashiko.dev/#/bug/linux-76320be4-9016-4f09-ab08-37df27a6afc4
[2] https://sashiko.dev/#/bug/linux-23bd99c4-2d45-42f2-b477-ed58fe586f8f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114014430.4896=
68-1-yhlee@isslab.korea.ac.kr?part=3D2
