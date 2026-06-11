Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0702F7AC1
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781157121; cv=none; b=qCS18QIW7iG0XlB3odcB0J91QkpSC/r1VXfUzUioyEl4ezHg3SOj41eO8ie4vbNAA3c/0wIDGdyUUaDmnOLXqCuBeeQjsOS6TFtVEgZ+tIK0XKrQ7z1fzks7FCcGHzWVSoJF6L/Edvk10Hnb1bVykRRU7OF4oIFDbmgAnn5uLrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781157121; c=relaxed/simple;
	bh=I5S0cnt0nhp2xjHApsEXcw0S5yzhUI80VKq8zFfNBHs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eplEmPLgDP3x9Lewz2cU3vmJez+oLc7rvsDm3A4SZemYRfohbGTyH4jp7w5nLRRwXn42HbWu3eyNfHYd3A8xKH0v+QeNDdsWvrNbU1QP01udOKeikQiOdT4t+DdOWmR464raMq2eIJ30hwS8rouGRVkiJUecZX5I7DEaHIRKG0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6xPXFz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6xPXFz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08591F00893;
	Thu, 11 Jun 2026 05:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781157119;
	bh=j4KWGthz8dn1QyyPeU4Oiv6oP8sY/pslWYrEMbe1Pns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a6xPXFz9KLOuhl5/vWQ+gMNfOlJrUcMGe9HBO0ZnoOd1TSxqWHjDnakeClhXgM912
	 yxZJZ6uWIYPh05Opzs3z191jm6Ndzb2275yZk14OTf6gd/JhfXlVeZEEe+8RfF/Jcc
	 0MEWhwNkyDo8fpwOyYFdQVWIjt8nEq7A8jam4Q7WbbQby/N4vb3ZHIPda15FChN7aP
	 i82Q/1hqzNwHbM8uhYCyC6iqCWxauumaYycMen1IQsrsEzRpgOrvYyDWMXNSIFJEoA
	 In9bBKE4DgwHmpW6WTcz42XmQfnH5dL8t8M4H+mHvM3lMAMRpgAK4iKqTdevmGY6Ks
	 fBnFud6R1Lwaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: elx: efct: fix refcount leak in
 efct_hw_io_abort()
Reply-To: sashiko-reviews@lists.linux.dev
To: "WenTao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611053037.63756-1-vulab@iscas.ac.cn>
References: <20260611053037.63756-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 05:51:58 +0000
Message-Id: <20260611055159.A08591F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hardware aborts for active IOs are silently dropped due to an inco=
rrect check for list membership.
--

commit 33508d96614625ca6aabac77bfd4b3f88a0202b5
Author: WenTao Liang <vulab@iscas.ac.cn>

scsi: elx: efct: fix refcount leak in efct_hw_io_abort()

This commit fixes a reference count and flag leak when
efct_hw_reqtag_alloc() fails in efct_hw_io_abort(). It adds the missing
kref_put() and resets the abort_in_progress flag to prevent blocking
future recovery attempts.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index 1838032f64862..b79c6a7ea7912 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -1997,6 +1997,8 @@ efct_hw_io_abort(struct efct_hw *hw, struct efct_hw=
_io *io_to_abort,
>  	wqcb =3D efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort=
);
>  	if (!wqcb) {
>  		efc_log_err(hw->os, "can't allocate request tag\n");
> +		io_to_abort->abort_in_progress =3D false;
> +		kref_put(&io_to_abort->ref, io_to_abort->release);
>  		return -ENOSPC;
>  	}
> =20

[Severity: High]
This is a pre-existing issue, but does the list membership check later in
efct_hw_io_abort() reliably determine if an IO is on the pending list?

When WQEs are dispatched to hardware, they are removed from the pending list
using list_del_init(). This leaves the next and prev pointers pointing to t=
he
list entry itself, meaning they are non-NULL.

Since io->wqe is not zeroed when the IO object is freed and recycled, any
recycled IO or already-dispatched IO will have a non-NULL list_entry.next
when it is evaluated here:

	if (io_to_abort->wq) {
		spin_lock_irqsave(&io_to_abort->wq->queue->lock, flags);
		if (io_to_abort->wqe.list_entry.next) {
			io_to_abort->wqe.abort_wqe_submit_needed =3D true;
			spin_unlock_irqrestore(&io_to_abort->wq->queue->lock,
					       flags);
			return 0;
		}

Could this cause the check to evaluate to true for IOs that are no longer on
the list, flagging them for a software abort and returning 0 without
submitting an actual ABORT WQE to the hardware?

Since the WQE is no longer on the pending list, the pending abort would nev=
er
be dispatched, leaving the abort_in_progress flag set forever.

If the hardware later completes the original IO, the completion handler mig=
ht
see abort_in_progress =3D=3D true and ignore the completion. Could this seq=
uence
permanently leak the IO object and its associated XRI tags?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611053037.6375=
6-1-vulab@iscas.ac.cn?part=3D1
