Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794570451;
	b=2y9rGymkNkokAp2G5V7KHHC9D4n7my838FlPCXrkq5me2AEKAnjmnefL5D4bgoOwdP2z
	 t5f3R1XDYkSP+5UDRNXoDGzlY1AE/8vgt6mLZ+iXS+Q7ccBdvt2/GrQJYumzBOX7nHCPK
	 VR08gIuK8bDv1CZoqQmMmADimLu/W2z5nVUwwa2e5SeCCf87uIAvNyc+tyufO0xkmcnJf
	 4XIkJoJaSEdv2R4eUuvJ+IiqUzvinzO5T5tdzDebx/lGqJvWTWk4owZKeVmdD0tEVX4Wv
	 9jLyQ16KbxU/ly2iJmJoutJnXJ1d8Tp8hEdDxjw0ZDwjpnO+1Ay8ttOYhfNR/KDm9jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794570451;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZWVVZ/EgJ0j6pP+PyKhklvQdbTo6FGfCQv2d8AvXNrE=;
	b=TiTaGcaaLtn6YTeF2GH/7vFg64UhMtK0HvgeP2x87NhKPuAHd4ZeOvPf71J5XCMdyafk
	 +7EupaI/mppG9iEKbw8Ml0JmR0W40MSZFaBcNZW3SsP6XYhfg3W19ZR6uEH//n3TsBWbf
	 7wsJglDcZupd38by7myXa6gzopRaPk+evH0/F+hKEgjBSqMlGjxLn5fZlFfkNxEV37kRZ
	 Hku80RwNNnOKWPLhEtJAjAUrYE0b8OAFjQEWOhOueYUdfpTyiuZ54SYbmbP9p2s83rtXj
	 REgyJergwRdxzZXMQusqcsPlMmb6a0UaCL0czD4JHjnXVEmz0V2V6U0yMQNe2aNZAHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLNmFpcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CD2606A323
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLNmFpcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491731F000C6;
	Fri, 13 Nov 2026 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794570450;
	bh=ZWVVZ/EgJ0j6pP+PyKhklvQdbTo6FGfCQv2d8AvXNrE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DLNmFpcc6KimCIC59UctSuJUbQHP3Uz1dmELz27LPu6vdDoN0J0xptwW+GtjHXCig
	 dhLLX5cNT07//q3rn4oqVcO1lKbEM2W65VACTAJ6NNckSwOH6GQ/4V67wpZiWKoqBe
	 935zf22kFCKXQ19DM0gK3GbREe+5QZcA562aRUeEvSzjCdGyo7myY9sjxGj/z9TQ7A
	 IH6hP8vujILjVzVjg/U6lzZ2FfEv5+PYhKuKC2ozUIR6E0DkC/4VP+6MPHx68xVwsE
	 DWSqAy/hExQiF/OqK2UzUPKySpswSC1+HAj01njYR9p961IehqKqRBiDPZ1scUnYbc
	 rzQ8T88bE0EiA==
Message-ID: <sashiko-outbox-212738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Recover link in
 ufshcd_set_dev_pwr_mode() on timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261113111202.3551341-2-stanleyjhu@google.com>
References: <20261113111202.3551341-1-stanleyjhu@google.com>
 <20261113111202.3551341-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 11:47:29 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] scsi: ufs: core: START STOP retry on stopped HBA in
  ufshcd_eh_timed_out()
- [Medium] scsi: ufs: core: TOCTOU race on ufshcd_is_hba_active() after
  timeout
--

commit 904c924ede89828a6af258eb088b07dc5e864450
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Recover link in ufshcd_set_dev_pwr_mode() on timeout

This commit moves link recovery on power management command timeouts out of
ufshcd_eh_timed_out() into ufshcd_set_dev_pwr_mode() and
ufshcd_err_handler(), stopping the host controller and failing START STOP
UNIT with DID_TRANSPORT_FAILFAST on timeout.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ddc953b45ce95..0f5365bd90f04 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -9660,17 +9664,20 @@ static enum scsi_timeout_action ufshcd_eh_timed_o=
ut(struct scsi_cmnd *scmd)
>  	}
> =20
>  	/*
> -	 * Handle the timeout directly to prevent a deadlock between
> -	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
> +	 * Stop the host controller so that @scmd can be completed here.
> +	 * ufshcd_set_dev_pwr_mode() recovers the link for START STOP
> +	 * UNIT. ufshcd_err_handler() recovers it for other commands.
>  	 */
> -	ufshcd_link_recovery(hba);
> -	dev_info(hba->dev, "%s() finished; outstanding_tasks =3D %#lx.\n",
> -		 __func__, hba->outstanding_tasks);
> +	ufshcd_hba_stop(hba);
> +	if (!ufshcd_is_scsi_cmd(scmd))
> +		ufshcd_force_error_recovery(hba);
> +	if (hba->mcq_enabled) {
> +		struct ufs_hw_queue *hwq =3D
> +			ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(scmd));
> +
> +		ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
> +	}
> =20
> -	/*
> -	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
> -	 * the existing MCQ force-completion path.
> -	 */
>  	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
>  		if (!hba->mcq_enabled) {
>  			struct request *rq =3D scsi_cmd_to_rq(scmd);
> @@ -9680,7 +9687,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out=
(struct scsi_cmnd *scmd)
>  		}
> =20
>  		if (ufshcd_is_scsi_cmd(scmd)) {
> -			set_host_byte(scmd, DID_REQUEUE);
> +			set_host_byte(scmd, DID_TRANSPORT_FAILFAST);
>  			ufshcd_release_scsi_cmd(hba, scmd);
>  		} else {
>  			set_host_byte(scmd, DID_TIME_OUT);
> @@ -10137,6 +10144,9 @@ static int ufshcd_execute_start_stop(struct scsi_=
device *sdev,
>  {
>  	const unsigned char cdb[6] =3D { START_STOP, 0, 0, 0, pwr_mode << 4, 0 =
};
>  	struct scsi_failure failure_defs[] =3D {
> +		{
> +			.result =3D DID_TRANSPORT_FAILFAST << 16,
> +		},
>  		{
>  			.allowed =3D 2,
>  			.result =3D SCMD_FAILURE_RESULT_ANY,

[Severity: Medium]
Can scsi_execute_cmd() retry START STOP UNIT while the controller is
already stopped by ufshcd_hba_stop()?

If ufshcd_mcq_compl_all_cqes_lock() (or a completion interrupt just before
ufshcd_hba_stop()) completes scmd with a non-zero status such as
SAM_STAT_CHECK_CONDITION, SCMD_STATE_COMPLETE is set and
ufshcd_eh_timed_out() skips setting DID_TRANSPORT_FAILFAST.
failure_defs[] then matches SCMD_FAILURE_RESULT_ANY, so scsi_execute_cmd()
submits a retry while HCE is 0 and hba->ufshcd_state is still
UFSHCD_STATE_OPERATIONAL, writing to the doorbell or SQTP of a disabled
controller and stalling for another 10-second timeout.

In addition, if scmd completes with result 0 during ufshcd_eh_timed_out()
on a host with UFSHCI_QUIRK_BROKEN_HCE, both fenced and
!(hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) are false in
ufshcd_set_dev_pwr_mode(), so ufshcd_link_recovery() is skipped even though
ufshcd_hba_stop() disabled the controller.

> @@ -10172,6 +10182,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba=
 *hba,
>  	struct scsi_sense_hdr sshdr;
>  	struct scsi_device *sdp;
>  	unsigned long flags;
> +	bool fenced;
>  	int ret;
> =20
>  	spin_lock_irqsave(&hba->host->host_lock, flags);
> @@ -10199,6 +10210,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba=
 *hba,
>  	 * already suspended childs.
>  	 */
>  	ret =3D ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
> +	fenced =3D ret > 0 && host_byte(ret) =3D=3D DID_TRANSPORT_FAILFAST;
>  	if (ret) {
>  		sdev_printk(KERN_WARNING, sdp,
>  			    "START_STOP failed for power mode: %d, result %x\n",
> @@ -10212,6 +10224,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hb=
a *hba,
>  		hba->curr_dev_pwr_mode =3D pwr_mode;
>  	}
> =20
> +	if (fenced || (!(hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) &&
> +		       !ufshcd_is_hba_active(hba))) {
> +		ret =3D ufshcd_link_recovery(hba);
> +		if (!ret && hba->curr_dev_pwr_mode !=3D pwr_mode)
> +			ret =3D -EIO;
> +	}
> +
>  	scsi_device_put(sdp);
>  	WRITE_ONCE(hba->host->eh_noresume, 0);
>  	return ret;

[Severity: Medium]
Can ufshcd_set_dev_pwr_mode() check ufshcd_is_hba_active() before a racing
ufshcd_eh_timed_out() finishes stopping the controller?

CPU0 (IRQ)               CPU1 (timeout)           CPU2 (PM caller)
ufshcd_intr()            ufshcd_eh_timed_out()
  ...                      ufshcd_hba_stop()
    scsi_done(scmd)          ufshcd_disable_irq()
                                                  ufshcd_execute_start_stop=
()
                                                    returns 0
                                                  ufshcd_is_hba_active(hba)
                                                    --> true (recovery skip=
ped)
                             writel(CONTROLLER_DISABLE,
                                    REG_CONTROLLER_ENABLE)
                               <-- HBA left disabled

When a normal completion interrupt races with request timeout expiration,
scsi_done() wakes scsi_execute_cmd() on CPU2 while CPU1 is still in
ufshcd_disable_irq() inside ufshcd_hba_stop().  CPU2 sees ret =3D=3D 0 and
ufshcd_is_hba_active(hba) =3D=3D true, so it skips ufshcd_link_recovery(), =
and
CPU1 then clears HCE and returns SCSI_EH_DONE because SCMD_STATE_COMPLETE
is already set, leaving the controller disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113111202.3551=
341-1-stanleyjhu@google.com?part=3D1
