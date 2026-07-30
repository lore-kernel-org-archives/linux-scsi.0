Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17946477291
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454030; cv=none; b=ujZdDSvC9HU6mUPkbeQOTEXCrRxi9J14996h5THz6UDg0GdiYA6cK7pjLsf7xAwlUngHgX+ZV8VMf8HSgzpAdsAsQgowrJAlgjAhTo617mJg80UeimodwzZ6onm6yNsaKYzrF7Szm5zibbURqA0jBITLhIj1aCBD1qUrkNGgSIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454030; c=relaxed/simple;
	bh=84gTmNT+4qWm603YTKZ7qHbdjMWfKLjOlCFmBLziASo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G+9fYfBDh9DrdhF4O4KvOzavRsreQOggciXDPCOXUZT8USqeKWi/kZISM6uLhTbt1VJxpMvJb4C/+Vcvp7TFDByffxlK0t017qeBAnpMAQwBbd6tyEgZu2sQt5wH/dO/skl4uge/YMaHv9lWViLBfjx2PNJT7W3yudOxv3SiXiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZpVunyYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZpVunyYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5951F000E9;
	Thu, 30 Jul 2026 23:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454023;
	bh=jpndgTwopHIeuk9m64oEwniCf0UVMik3llSJrs1hygg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZpVunyYT1jr2Z/cj8QOHSHXXmqaUOz3koxAuYmroRW7LgAFEBPvVJu2bPc+YiLJlw
	 JcTKQpCM2zAAy45JeKzuUyTn8u1WZ+tUO/01y0J/Bg0MuSDJh4VvkxJFZ8sk0f0J1j
	 hwPBvAkmGhfvV5CdIvoSdUFA8Ig+mrlqB7as42OpZCen5yQa3TGst5plX8hVa39+YP
	 JDVHnZHuP1T4r0M45IrzCetPVfiCOQcUI0CbDUPh0bAj+O2kegIg+8fdIC9SYGjN9b
	 FUAKeKJ9BxwKeFsSrW0UtFToN+QCxQ7++g+++ev7+1bC66VX5G0+jv9g90kJk1Rk/n
	 Ni2zpKJEhijww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/57] scsi: ibmvscsi_tgt: Enable lock context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <d617580106d7de41548cbbae6d98ce6985b5461b.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <d617580106d7de41548cbbae6d98ce6985b5461b.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:27:03 +0000
Message-Id: <20260730232703.AC5951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] Incomplete implementation of `__must_hold` locking annotations.

Pre-existing issues:
- [High] Race condition during queue teardown leading to interrupt storm an=
d `h_free_crq` collision.
--

--- Patch [30]: [PATCH v3 30/57] scsi: ibmvscsi_tgt: Enable lock context an=
alysis ---
commit 3c00251f51d9e551b9d5359138425cfc65cd2cef
Author: Bart Van Assche <bvanassche@acm.org>

scsi: ibmvscsi_tgt: Enable lock context analysis

This commit enables lock context analysis for the ibmvscsi_tgt driver. It
documents locking requirements by adding the __must_hold() annotation to
several functions.

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> index 61f6828007654..8e532a195bf95 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -251,6 +251,7 @@ static void ibmvscsis_delete_client_info(struct scsi_=
info *vscsi,
>   *	Process level, interrupt lock is held
>   */
>  static long ibmvscsis_free_command_q(struct scsi_info *vscsi)
> +	__must_hold(&vscsi->intr_lock)
>  {

[Severity: High]
This is a pre-existing issue, but could this sequence lead to an interrupt
storm or hypervisor faults due to concurrent CRQ access?

Looking at ibmvscsis_free_command_q(), it disables hardware interrupts and
then drops the lock:

    vio_disable_interrupts(vscsi->dma_dev);
    // ...
    spin_unlock_bh(&vscsi->intr_lock);
    rc =3D ibmvscsis_unregister_command_q(vscsi);
    spin_lock_bh(&vscsi->intr_lock);

If a pending ibmvscsis_handle_crq() tasklet on another CPU acquires the lock
while it is dropped, it evaluates TARGET_STOP(vscsi) as true and
unconditionally re-enables interrupts:

    if (TARGET_STOP(vscsi)) {
        vio_enable_interrupts(vscsi->dma_dev);
        // ...
        spin_unlock_bh(&vscsi->intr_lock);
        return;
    }

Would this cause ibmvscsis_unregister_command_q() to execute concurrently
with hardware interrupts actively firing?

[Severity: Low]
Are there other functions that explicitly require the interrupt lock but
were missed by this commit?

The commit message claims to "Document locking requirements with
__must_hold()", but several other functions in this file contain explicit
comments stating they must be called with the lock held, yet lack the
__must_hold() annotation.

For example, ibmvscsis_establish_new_q():

    /*
     * Must be called with interrupt lock held.
     */
    static long ibmvscsis_establish_new_q(struct scsi_info *vscsi)

And ibmvscsis_post_disconnect():

    /*
     * PRECONDITION:
     * interrupt lock is held
     */
    static void ibmvscsis_post_disconnect(struct scsi_info *vscsi,
                                          uint new_state, uint flag_bits)

Could these also be updated to ensure complete static analysis coverage?

>  	int bytes;
>  	u32 flags_under_lock;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D30
