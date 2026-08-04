Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39853382CD
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 04:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785818013; cv=none; b=tPzS/c9KVKV7v/TfnChvX6KzLPSguYLoSYh2yB6okcAo37tpisvdEHnq2rFavGFuiNmC/tIqxcBeTgI8sm2G5VLTTIu/gsXuMuOzCGJr4t3tvtCY4feoHh5/4OTBeiB40LTJPDtrGSjKuu1K1njiqQnq64GGFRk/nNdwSOgvsVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785818013; c=relaxed/simple;
	bh=WlOrKvx4ydzgJWlyuvIKx83MxZ+uA23+FhYB3Cqrb+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WHkU+B8U7Uchm7xEUxUxf6FMi7+raUpRf3tQ/3nfCVvbaCGa2/VVpjbSCaVs9ZJJDGOwUolQK184oi3dWBQrJlSa0F6n6Yf27B8iPa8YR24JipyEY6tYbP+bEpbDByYxt63GHPll2/EiuO2ut+ixGm1V+ojvb4oAf2Ul3HhNMmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjLcqudW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjLcqudW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEE01F000E9;
	Tue,  4 Aug 2026 04:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785818012;
	bh=pGOT0iwsjq17HX4mLIV/LKw40XuWKxaHjnBKd8xG2D4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MjLcqudWNQFvBXbp+s+petlWAh033WLZCJVTcR3bLEV2D7YxCeaY8o2pHEwTmCwCj
	 X70CzoUdWWV6oZ8MhfHOyNChrAhHrGbOPntQ/YQ5Lz/8JWDIR+TuNFNdNv68QPi0DF
	 N3hEAN6mZ43qf+LDkikO9NXl0oFm5rfo3PxlJVkKnVOlMk5nKMNeu947qoBpX3IRr8
	 FbkCeHmdMsAwZ3g5gRCE5i0IYsF6wk5bjgTIhdi44zV6h007+X2Q5hRi7liftW/tS/
	 DkdqMo1QGwv1NOgKU8NqKivbqlQ8xjEefoELKhWwf3/9GMgm6PXm1x72uXGJY9kw5d
	 p4sUo7VoXq0fA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] scsi: libiscsi: validate the task named by a
 management response
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804040546.2264137-4-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
 <20260804040546.2264137-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 04:33:31 +0000
Message-Id: <20260804043332.3BEE01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] iscsi_complete_pdu() acquires session->lock with spin_lock(), but =
can be called from process context, leading to a deadlock against softirqs.
--

--- Patch [3]: [PATCH v2 3/3] scsi: libiscsi: validate the task named by a =
management response ---
commit 5135af06e5540d3c52932cc2310608b06242c034
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: validate the task named by a management response

__iscsi_complete_pdu() fetches the task for five response types from one
place and checks only that the index resolved. This commit fixes an issue
where task->conn could be NULL by requiring the task to be in flight and
not a SCSI command.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f6e7facf296b2..b686cd2aa4dd2 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1180,7 +1180,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
>  	case ISCSI_OP_SCSI_TMFUNC_RSP:
>  	case ISCSI_OP_NOOP_IN:
>  		task =3D iscsi_itt_to_task(conn, hdr->itt);
> -		if (!task)
> +		if (!task || task->state =3D=3D ISCSI_TASK_FREE || task->sc)

[Severity: High]
This is a pre-existing issue, but could the lock usage in the caller lead
to a deadlock?

Looking at iscsi_complete_pdu() (which calls __iscsi_complete_pdu()), it us=
es
spin_lock(&conn->session->lock) instead of spin_lock_bh().

If qla4xxx_task_work() in drivers/scsi/qla4xxx/ql4_os.c is called from
a workqueue (process context), it calls iscsi_complete_pdu() without disabl=
ing
softirqs:

drivers/scsi/qla4xxx/ql4_os.c:qla4xxx_task_work() {
    ...
		iscsi_complete_pdu(conn, hdr, data, data_len);
    ...
}

If a timer interrupt fires on the same CPU while the lock is held, the timer
softirq callback iscsi_check_transport_timeouts() will attempt to acquire t=
he
same lock, resulting in a lock inversion deadlock:

drivers/scsi/libiscsi.c:iscsi_check_transport_timeouts() {
    ...
	spin_lock(&session->lock);
    ...
}

Should iscsi_complete_pdu() use spin_lock_bh() to prevent this?

>  			return ISCSI_ERR_BAD_ITT;
>  		break;
>  	default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804040546.2264=
137-1-yhlee@isslab.korea.ac.kr?part=3D3
