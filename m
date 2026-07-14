Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948172FD665
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990473; cv=none; b=Lxrt8UEbZOm7Gd4KWhYp+B0nXOx6cbNHfiKMeAOcrfFHQZjQFkN93QikzV07AgZ6EHIxDF9A9B2tewBuFokAU3zVtD5VgjP5A1RSAmJSs45P9yXxyehfRH14f61w/TlLslOECnM+CpZVkXNLJS1rkd59eye1yvhppSuTEijjhkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990473; c=relaxed/simple;
	bh=fMnnEmtg7SBjFKK+6hJsHZjdMRMLMq20jVwaUV8o18o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WxpF+YLMKCikLaMeoiCh9PshSoz3AWooAu9p2x+xKF7ynGL1UwPYbic9vE8SZpTOYFWIULo1QcfY9dhXChZi44N87zV7ci91e1eC9Cuxga/3QKG4G+PqeiJHbZ8ARQLlrqxlV+rhrbr0PEnWHaKBSHHFo8UQa998y9dS/mV1MXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osdYz1j1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osdYz1j1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF711F000E9;
	Tue, 14 Jul 2026 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990460;
	bh=ot0TyQMJ7nmoYliaiTlWY2Op35J0HACzoHhAEBI80ME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=osdYz1j1fJWOugo+9mUi0TpR85qQiddVWjIjC8Hw/ze8ZBZA1WDtqJwH1tt9ucnfK
	 cJrGMdqNqzjJAT/9gOQL8h4EqwW/kWRYgfZTeqm7i4Y5EnVLUSM85tAkd89Nzb7yDj
	 r1WYWG2JbG5GD6MX/s3MrmY0lzNmDzp9ugvY6cyblZ8VZI19PI35kciSG4YmG6E7V9
	 MecAPO8/TNnt1Gy+DdmYOSN8r1spj8ANTs8NdHcM7y7cicRw8bIpAP1cjzDg7QJnB9
	 S4IMZjnAy5Imec27y7ejGcNOIUn27BzIIBfOEUUflccp1xxC9Bei7m3+HtVqeaPPVW
	 xSjt95EGteOJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/14] lpfc: Remove slowpath cqe process limiter in
 slow ring event handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-11-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-11-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:54:20 +0000
Message-Id: <20260714005420.6AF711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Removing the 64 CQE process limiter creates a structurally verifie=
d infinite loop when processing MDS Loopback or unsolicited data frames und=
er resource exhaustion, leading to CPU soft lockups.
- [Medium] Mismatch between the commit message's stated log threshold (64) =
and the actual implemented code (256).
--

--- Patch [10]: [PATCH v3 10/14] lpfc: Remove slowpath cqe process limiter =
in slow ring event handler ---
commit 69f6839c38e91e160d808d1e850edd0295006605
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Remove slowpath cqe process limiter in slow ring event handler

This patch removes the 64 CQE processing limit in the slow ring event
handler to prevent delayed processing penalties during large SAN
rediscoveries. It replaces the hard limit with an unbounded loop that=20
drains the queue and adds diagnostic logging.

> Remove the slowpath cqe process limiter in
> lpfc_sli_handle_slow_ring_event_s4 to ensure the slow path CQ is drained.
> Add log messages to notify when the 64 cqe count is reached.

[Severity: Medium]
The commit message states the log messages notify when the 64 CQE count
is reached, but the implementation uses LPFC_WQE_DEF_COUNT (which is 256).

Could the commit message be updated to match the code, or should the code
be using 64?

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4527,7 +4527,7 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba =
*phba,
>  	struct hbq_dmabuf *dmabuf;
>  	struct lpfc_cq_event *cq_event;
>  	unsigned long iflag;
> -	int count =3D 0;
> +	u32 count =3D 0;
> =20
>  	clear_bit(HBA_SP_QUEUE_EVT, &phba->hba_flag);
>  	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {

[Severity: High]
Could removing the event limit here lead to an infinite loop and a CPU soft
lockup under resource exhaustion?

If an MDS loopback frame or unsolicited data frame is received while the
driver's IOCB pool is exhausted, lpfc_sli4_handle_mds_loopback() fails
to allocate an IOCB and puts the event back on the tail of the exact queue
being drained:

lpfc_sli4_handle_mds_loopback() {
    ...
    list_add_tail(&dmabuf->cq_event.list,
                  &phba->sli4_hba.sp_queue_event);
    ...
}

Since the loop in lpfc_sli_handle_slow_ring_event_s4() no longer breaks at =
64
events and doesn't yield, it seems the requeued event will be immediately
dequeued again. Because the kthread never yields to allow IOs to complete,
does the IOCB pool remain permanently exhausted while it infinitely requeues
the same event?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D10
