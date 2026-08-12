Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B714D38D686
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559901; cv=none; b=q0ldJmmJNKS+q7D5BQ1LZHK1pgYkZ5nVbZ9WlD7SYgmoaceELjgRsw3SBuyC7EIAjv442CQ163ixu2QBrNRMs59KvGYadx7G1UxZTlXEiux94rosY+cicugoykzGO870bmpvzWHZ+Q/qbjrar5HBzQMQc8RWgimjmk4BD0qdkq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559901; c=relaxed/simple;
	bh=2VmQZC/mPqB9bd6LYSBwlP2yLXqzZn5N71MohiY1HA4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OvigP7qaHUYFCv7ZskQdTNvrCIZcbvxipMfUltE8SGSDxbT84Dr0/lrjr8hfP8LymLVUC2NM1xxodWtwf284Uxrl1L7pwEQbd1vlI2I/Fq5gsIHV+jP/UPbzXR4INuZtKVsisjdjkVqP/8MXdabzISqD0QI68kEKEvayqHXc3i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0AGuYAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0AGuYAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C711F000E9;
	Wed, 12 Aug 2026 18:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559899;
	bh=KCfrRU8VWsLUyKLueryjK6QL5n/JVOqcmpDg2qmE4WY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y0AGuYAqBVue5OLRwuLgpz2iXgzIXxIEg0UEDs2GXZGsfP1i1mWxghgOkX0e6SN4T
	 +ygR2j/dk6EItvIDBTSch1K1Gs8+Rvbvd3IgtjkxnsgHuX0bLk4ngDqn3O+TaN8ujb
	 LrzZCs+6EXvq+JUiqym9dGibETzknXp187HdqR5bMWJWtj5/hMaNGVZwcmjBp0vZWk
	 P+RRKeMB4Kp7ZdECejZoAj7Sur3d9VMbwZtDp2ael3wAdV734wC2sct4UfY/MlWVoo
	 Q4BS4lxpVBI3o6U43I5nSMQanR3yO+Gs/PlNoDdgAwQ7YCEI89b3Ru5qxiCBc7Ws/B
	 LYAlSPraDT8tg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] ufs: core: Do not forcibly complete SCSI commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <182ad9c472505abc7958d85c772d56e8a40e3b69.1786558726.git.bvanassche@acm.org>
References: <cover.1786558726.git.bvanassche@acm.org>
 <182ad9c472505abc7958d85c772d56e8a40e3b69.1786558726.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:38:18 +0000
Message-Id: <20260812183819.51C711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Polling the MCQ Completion Queue by reading hardware registers=
 while the host controller is disabled (HCE=3D0) causes a hard CPU lockup d=
ue to an infinite loop.
--

--- Patch [3]: [PATCH 3/3] ufs: core: Do not forcibly complete SCSI command=
s ---
commit af070348e9f00f73ade393f3d9421e41e0afb4fb
Author: Bart Van Assche <bvanassche@acm.org>

ufs: core: Do not forcibly complete SCSI commands

This patch removes the forced completion of SCSI commands from the UFS error
handler for MCQ mode, delegating abort and requeue decisions to the SCSI co=
re.
It makes MCQ behavior consistent with legacy mode by removing
ufshcd_mcq_compl_all_cqes_lock and the force_compl flag.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cdfcd3d4c4c97..26bc2b0c08124 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
[ ... ]
> @@ -8197,7 +8163,7 @@ static int ufshcd_host_reset_and_restore(struct ufs=
_hba *hba)
>  	 */
>  	ufshcd_hba_stop(hba);
>  	hba->silence_err_logs =3D true;
> -	ufshcd_complete_requests(hba, true);
> +	ufshcd_complete_requests(hba);

[Severity: Critical]
Can this lead to an infinite loop and hard lockup during error recovery?

After ufshcd_hba_stop() disables the host controller,
ufshcd_complete_requests() now eventually calls ufshcd_mcq_poll_cqe_lock():

ufshcd_host_reset_and_restore()
  ufshcd_hba_stop()
  ufshcd_complete_requests()
    ufshcd_mcq_compl_pending_transfer()
      blk_mq_tagset_busy_iter(..., ufshcd_mcq_compl_one, ...)
        ufshcd_mcq_compl_one()
          ufshcd_mcq_poll_cqe_lock()

In ufshcd_mcq_poll_cqe_lock():

    ufshcd_mcq_update_cq_tail_slot(hwq);
    while (!ufshcd_mcq_is_cq_empty(hwq)) {
        ...
        ufshcd_mcq_inc_cq_head_slot(hwq);
    }

If reading the disabled MMIO register in ufshcd_mcq_update_cq_tail_slot()
returns 0xFFFFFFFF, the tail slot becomes out-of-bounds. Since the head slot
wraps around at hwq->max_entries, ufshcd_mcq_is_cq_empty() will never evalu=
ate
to true.

Because this loop runs with the hwq->cq_lock spinlock held and interrupts
disabled, will this permanently hang the CPU?

>  	hba->silence_err_logs =3D false;
> =20
>  	/* scale up clocks to max frequency before full reinitialization */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1786558726.gi=
t.bvanassche@acm.org?part=3D3
