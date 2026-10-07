Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810D61B4223
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 02:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791339173; cv=none; b=RDyjiArwPffWvbHGQ/3GZC/dBt07sY6pUgm8I84tB8BjixFomnTofTlvj4jN1xsAp/h9ITB8FTSaweR9Rpqb3QobAcVkmy9elfqiuPU7RLvqpChoED3QDRBHA3ALj3WLMEJ4Dn1KUmErV+2g8NXk7ER6wUKIT04Me7+aJlxGrfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791339173; c=relaxed/simple;
	bh=hYUHSdqGk3+GA2FeRlN+RGxsb3BX/+Xa84kxC4sSlhc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rtacDOr2Wh62FqKXyAAlNkTSIHIVKGIMJyejpcYylCXm1KARXR4DKTWYtZkfAyfmkjdeaIwqfpKCS1WJ32fCEuwzhRM1w4SEGxr9paiuhsuCpBVoKzQmIJvKkSxl82+41zSWt38VysTOHOutcd8nveeVFtlOQNvsBzbZFqZ6YvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRz2+XYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRz2+XYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048F31F0089B;
	Wed,  7 Oct 2026 02:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791339172;
	bh=1yJR98O2VDBvHHljEB2i4eMiUkoOTyzy/68RdRuLFeo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JRz2+XYaZx+NR6OYOvDvhbVY8A3sfPhDKew+//cAjmV9Wi4M4hEkk6EGWU0iPrRJU
	 Itg1wUsaf9IyjlFe+ZicEfpHW7CxHO9b3QbbM+KDPMSguf8slJL62B+t6hXxu9jdsx
	 RKcqom6wNGnaSsVRmVqpvzIgreaSDRVWRDqlA+3Q3+5ApHjFGqsKuR7+c+Csd+lLY/
	 MLbSeA6fLOL8A3o+pfYpjGK43E0BDd9wxZ/ZrmwqmjOniiF1pKNzlLEMOPyOs0bKUP
	 r8K8lJdTSVk0E47W0KJUM/nY3jqpMz6Z5Kz7REQ1G7SAXh6hxfVsaLq5RJTABf5sNo
	 jkTPab1wxt6+Q==
Message-ID: <sashiko-outbox-162584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] scsi: libiscsi: validate the ITT reflected in a
 Reject PDU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007015842.634893-3-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
 <20261007015842.634893-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 02:12:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: libiscsi: TOCTOU race allows malicious target to corrupt SCS=
I task via Reject PDU
--

commit 0da359490f3ff756111324f1c5b68673b764be99
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: validate the ITT reflected in a Reject PDU

This commit adds validation to the ITT reflected in a Reject PDU to prevent
naming an unused or free task from the pool. It introduces checks to ensure
the task state is not ISCSI_TASK_FREE and that task->sc is NULL.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 7a74bc697d23b..ffd6446d07b28 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1142,13 +1142,15 @@ static int iscsi_handle_reject(struct iscsi_conn =
*conn, struct iscsi_hdr *hdr,
>  			spin_unlock(&conn->session->frwd_lock);
>  			spin_lock(&conn->session->back_lock);
>  		} else {
> -			struct iscsi_task *task;
> +			struct iscsi_task *task =3D NULL;
>  			/*
>  			 * Our nop as ping got dropped. We know the target
>  			 * and transport are ok so just clean up
>  			 */
> -			task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> -			if (!task) {
> +			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
> +				task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> +			if (!task || task->state =3D=3D ISCSI_TASK_FREE ||
> +			    task->sc) {

[Severity: High]
Does this introduce a Time-of-Check to Time-of-Use (TOCTOU) race with task
allocation?

The RX path executing iscsi_handle_reject() holds the session->back_lock,
while the TX path executing iscsi_alloc_task() holds the session->frwd_lock.

During task allocation, iscsi_alloc_task() performs these updates
sequentially:

iscsi_alloc_task() {
    ...
    task->state =3D ISCSI_TASK_PENDING;
    task->conn =3D conn;
    task->sc =3D sc;
    ...
}

Because these paths hold different locks, the RX path can observe an
incomplete task allocation where task->state is ISCSI_TASK_PENDING but
task->sc has not yet been assigned and is still NULL.

If a malicious target sends an ISCSI_OP_REJECT PDU matching the ITT of a ta=
sk
currently being allocated, couldn't this check be completely bypassed?

This would falsely identify an in-flight SCSI task as a management task,
leading to premature completion via iscsi_nop_out_rsp().

This could eventually cause a refcount underflow and use-after-free when the
task actually completes.

>  				iscsi_conn_printk(KERN_ERR, conn,
>  						 "Invalid pdu reject. Could "
>  						 "not lookup rejected task.\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007015842.6348=
93-1-yhlee@isslab.korea.ac.kr?part=3D2
