Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA1E3515FE
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 02:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791339320; cv=none; b=mm7cFtyJgGUUePRmxryk/ka4kR/jsPmUG3fHQWz9uHU7rNdw5gVCosBwbnDHKEhG2iUtoXZKHA5j0Pt0RUXAp3IkWPwLxPRnAjIH4nWKJqY+HA3CXO0IHViWUebf1bn29GmBpuGRCY1KOpS5Vk22nTue03vz2arS7vDcRlL0ND4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791339320; c=relaxed/simple;
	bh=IO1jFC166ytUNxfT4pt83eXuVMwr3dm18c1aUaPN+mM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SeMoiRIaEsMH7Xz2dcbWfQsYD9+sEtQNq2vtBM7L0/91Aj7JjFOV2gDozK8B6efJENJBjUJ6MSjR5l4MagJKiHm2TqnrfkHOkMWD/DK4Y0f0YLoDtngHSbrC0v0pSdjCyZrBSpRLhiZjqdEb9D/IyFUV0T2gpv2kAQNGJrlS4JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbp56qBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbp56qBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C451F0089B;
	Wed,  7 Oct 2026 02:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791339318;
	bh=yPcf2Hw5pUhLoEe7nnyxDdOTsVHRIaaJOOSYe0vrJVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fbp56qBwMCpLcxlBp+jrksp9we0efbt6yfbjX6T12vE7x6M/yn3IGF8gNW9oJtGhB
	 2v5kpvE7uIiymn11eHYKlIw0wrj9Vge2/NDRtfmC+9b56c8NCgARha+XQSsLSVHVt7
	 BnFEr+NI7r39bEItX0RC58VV0Gs1owqyrRBXEO0h0Hm444UtvjChiPCG5smwxzXQV+
	 UJT0nehTkRPca0f3WLkoh/MFi8fdZHndOwyjimHQHijMfJH1HJnu1OASgBUEA68QEX
	 lti5iv+/D97dBpCTXWGqvjFqlOGkm/S57ZvvVdLK307HY/GilcyhNv2tjWUEq39coc
	 LEqyGPAvZp2Rw==
Message-ID: <sashiko-outbox-162588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] scsi: libiscsi: validate the task named by a
 management response
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007015842.634893-4-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
 <20261007015842.634893-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 02:15:18 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: libiscsi: early completion of pending task causes UAF on tra=
nsmit queue
--

commit b24b8599f28cfc6b3085efa4f6f74df1f0a7f232
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: validate the task named by a management response

__iscsi_complete_pdu() fetches the task for five response types from one
place and checks only that the index resolved. This commit requires the
task to be in flight and not a SCSI command.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ffd6446d07b28..4329967b54260 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1286,7 +1286,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
>  	case ISCSI_OP_SCSI_TMFUNC_RSP:
>  	case ISCSI_OP_NOOP_IN:
>  		task =3D iscsi_itt_to_task(conn, hdr->itt);
> -		if (!task)
> +		if (!task || task->state =3D=3D ISCSI_TASK_FREE || task->sc)

[Severity: High]
Does this allow an early completion of a pending task? By checking explicit=
ly
for ISCSI_TASK_FREE, tasks in the ISCSI_TASK_PENDING state are accepted. If=
 a
target sends an early management response matching an ITT that was just
allocated, the task gets completed.

If the task is completed while pending, iscsi_complete_task() will drop its
refcount to 0, returning it to the pool:

iscsi_complete_task() {
    ...
	/* release get from queueing */
	__iscsi_put_task(task);
}

But it hasn't been unlinked from the transmit queue. When the transmit thre=
ad
attempts to process it, couldn't this result in a use-after-free or list
corruption?

iscsi_data_xmit() {
    ...
	/* process pending command queue */
	while (!list_empty(&conn->cmdqueue)) {
		task =3D list_entry(conn->cmdqueue.next, struct iscsi_task,
				  running);
		list_del_init(&task->running);
    ...
}

Additionally, is there a race condition here? iscsi_alloc_task() updates the
task state and sc pointer sequentially under frwd_lock:

iscsi_alloc_task() {
    ...
	task->state =3D ISCSI_TASK_PENDING;
	task->conn =3D conn;
	task->sc =3D sc;
    ...
}

Since __iscsi_complete_pdu() performs its validation under back_lock, could
the RX thread observe an intermediate state where task->state is
ISCSI_TASK_PENDING but task->sc is still NULL, thus bypassing the validation
check even for SCSI tasks?

>  			return ISCSI_ERR_BAD_ITT;
>  		break;
>  	default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007015842.6348=
93-1-yhlee@isslab.korea.ac.kr?part=3D3
