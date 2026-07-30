Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051C54766A3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453480; cv=none; b=lF+IjNcXWA7z5rmSwnb37IkNOJhVZn18AayPDgz7TVM4qYS43witNrmkXFVb4Yzc24LvJFtERAYpmktCWhQi8s9DevvoJxWYf398UYKCCyJjtaEoYWIpySXu8c19v7jmwJERyrBYyv9Vl2e1vAn/bcUE7j8QGGHGDnjYX2bfS1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453480; c=relaxed/simple;
	bh=l/7z+FZ5kg45JVlM6JNWk4Oy+Bl675nXEMoWNjkysOs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h9N0rOnkuE+cISqOInxddnQZp3GrUjnvby9bC/QgjI/rS7pnT0d3cRwnB0aSzBhM/AIRnwmxtJSahbl97EfYf+Vlr4R+XH98chPXiYjmxKaiVJq5yET862BIvFXkacAo8fJS2vHvgaNPLx9yaEzESdzjb+FhUHdzEYioAoS8Fy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXoQMrJo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXoQMrJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF051F000E9;
	Thu, 30 Jul 2026 23:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453476;
	bh=jZpiyS44DhyyLPDZvF1zHeiRMKFtfJsTbujNkFDmw6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZXoQMrJoK2TfX9hstEiW9NdHOqO0aqMWuz7Q7dHkIYVptrLdQ443S0phWxONOSxlT
	 C8FDvuJ5Lopk623rt6KUoAjuLodhn70X0/m9Ft2/ant7bgCz4kFn/SVLJrVMbsE8zL
	 13YZ2CiUHvtzQZI2VKM1Dq0ep+uaDr2rMsfvBd6xwlFQbttNwhcg9MQvoOkx5+qjkp
	 ZKUdj8BjaHXpMy0ndoLzw8utR89nSvWsydQlQisysV6V1YOaBJeTEtN3dARJ7RMvXf
	 TEY9brLLuwCJKa8ld+7v964qggUhbPMEkV6lkFKSQx0PzXfsxXOFLHrPLEsoLkn6jE
	 w6DxI9FnLuuDQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 46/57] scsi: qedi: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <43ff011280be3c01537e6f696cbe721d6ff24a53.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <43ff011280be3c01537e6f696cbe721d6ff24a53.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:17:56 +0000
Message-Id: <20260730231756.9EF051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Deadlock vulnerability due to acquiring `session->back_lock` witho=
ut disabling softirqs in CQE processing paths.
--

--- Patch [46]: [PATCH v3 46/57] scsi: qedi: Enable lock context analysis -=
--
commit c592a3970ebc316b3aad74beecefeffd2a24b31b
Author: Bart Van Assche <bvanassche@acm.org>

scsi: qedi: Enable lock context analysis

Annotate qedi_cleanup_all_io() with __no_context_analysis since it
performs conditional locking.

[ ... ]

> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 854efa4f61d87..e162061ca49c9 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -1134,6 +1134,7 @@ int qedi_send_iscsi_logout(struct qedi_conn *qedi_c=
onn,
> =20
>  int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_co=
nn,
>  			struct iscsi_task *task, bool in_recovery)
> +	__context_unsafe(conditional locking)
>  {
>  	int rval;
>  	struct iscsi_task *ctask;

[Severity: High]
This is a pre-existing issue, but could the locking elsewhere in this file
lead to a deadlock?

Looking at qedi_process_tmf_resp() (and similar response handlers like
qedi_process_text_resp(), qedi_process_logout_resp(), and
qedi_process_login_resp()), they acquire session->back_lock without
disabling softirqs:

qedi_process_tmf_resp()
    spin_lock(&session->back_lock);

These handlers execute asynchronously in a kernel thread
(qedi_percpu_io_thread) with softirqs enabled.

If a timer interrupt fires on the same CPU while this lock is held, the
libiscsi transport timer (iscsi_check_transport_timeouts) could preempt
the thread in TIMER_SOFTIRQ context.

If that timer logic attempts to send a ping (iscsi_send_nopout()) and
fails due to an allocation failure or full queue, its cleanup path calls
iscsi_put_task().

iscsi_put_task() unconditionally attempts to acquire the lock using
spin_lock_bh(&session->back_lock).

Would this cause a softirq-preemption deadlock where the timer spins forever
waiting for the preempted thread to release session->back_lock? Should these
CQE processing paths use spin_lock_bh() instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D46
