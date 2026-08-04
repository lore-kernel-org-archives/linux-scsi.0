Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAA9331EC1
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 04:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785817831; cv=none; b=XNxuT1Y2s54jSc4OAaim4wXJ6gp8z65erFj3pbqC8waOiKh2xiudQZoGXo6/76dl4Rvd126unfvC99OWcPQYxaGu/ObN0pcH7LOLPHknvprIWlR8v+QZXgVwq++UNm37aVTzGrtmS0i/JmfuBDVxHlKsMDh6CGnc0/oNABFQWXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785817831; c=relaxed/simple;
	bh=RvelTbSJqlufeMYuHUitSyPtFD+sU51yE8hyRFNn3W0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BfISmZNsLrKb4WOblFur/YDNL+LtZA8tw9XMBEQzFqqWBI3QWm1WeybgRs4xUEJ1lk/hBJb0Mi8CMaWh3c8xMnU3MukiR6GH3HHmlGeLFCyN4HwPHOo8R05iwMdhNaqkwzMBAVcJYvszoCtrE6z40Knzu5c/FLx9bnh0O3PLtv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkQyTO5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkQyTO5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA741F000E9;
	Tue,  4 Aug 2026 04:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785817829;
	bh=AjhGa34kkpI8fFDXzle5F9hNCFDmIwSCHeCbgu4BWpQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MkQyTO5lLh/s54FlzGDlzi8ZJTxa/FFcJzVa+ctVo7zhXWMvE++9WI0EFOu5kyyZi
	 t/eWokOn142Qjp/Sx+eMwfwwcdrD0JGH+UXIzyADW3wV1hpzqFMcRe54xPiJaXvJd2
	 DaRjS6TSLLI+BEjNFo1pZAz7vXksMq2Mw6NkpWBo0YHqg+l7uOi47tNnMq3NdyPmWY
	 Xgq2szwuSDVnmkfg2ALXXXmtGa4R5L/zAPyI2MWhfbpIWMOYapd591met9kz1hfL8V
	 UUMfOlxHhYGH1BsNK4H7YFHoRAhJNrD3kpC5dDTmN2sTwOLDO3fcRRQCt7zglXnM9L
	 IGeELXWCZXoCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: libiscsi: validate the ITT reflected in a
 Reject PDU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804040546.2264137-3-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
 <20260804040546.2264137-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 04:30:29 +0000
Message-Id: <20260804043029.ADA741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix for ITT validation allowing remote denial of servic=
e and silent data corruption.
--

--- Patch [2]: [PATCH v2 2/3] scsi: libiscsi: validate the ITT reflected in=
 a Reject PDU ---
commit b86c9905a91963794fe78b0e96f89ab99adb9cb4
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: validate the ITT reflected in a Reject PDU

This commit fixes an issue where an iSCSI target could cause a kernel panic
or silent data corruption by sending a Reject PDU with an invalid or
inappropriate Initiator Task Tag (ITT). By explicitly validating the ITT
and ensuring the task is active and not a SCSI command, it prevents these
out-of-bounds manipulations.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ba3f971279c64..f6e7facf296b2 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c

[ ... ]

> @@ -1045,8 +1045,11 @@ static int iscsi_handle_reject(struct iscsi_conn *=
conn, struct iscsi_hdr *hdr,
>  			 * Our nop as ping got dropped. We know the target
>  			 * and transport are ok so just clean up
>  			 */
> -			task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> -			if (!task) {
> +			task =3D NULL;
> +			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
> +				task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> +			if (!task || task->state =3D=3D ISCSI_TASK_FREE ||
> +			    task->sc) {

[Severity: High]
This is a pre-existing issue, but does this same validation need to be
applied to other management responses in __iscsi_complete_pdu()?

Looking at __iscsi_complete_pdu(), when handling opcodes like
ISCSI_OP_NOOP_IN or ISCSI_OP_TEXT_RSP, it retrieves the task blindly:

drivers/scsi/libiscsi.c:__iscsi_complete_pdu() {
    ...
    case ISCSI_OP_LOGOUT_RSP:
    case ISCSI_OP_LOGIN_RSP:
    case ISCSI_OP_TEXT_RSP:
    case ISCSI_OP_SCSI_TMFUNC_RSP:
    case ISCSI_OP_NOOP_IN:
        task =3D iscsi_itt_to_task(conn, hdr->itt);
        if (!task)
            return ISCSI_ERR_BAD_ITT;
        break;
    ...
}

If a target sends one of these opcodes with an ITT pointing to an unused
task, task->conn will be NULL. This can lead to a NULL pointer dereference
when accessing conn->cls_conn in iscsi_nop_out_rsp() or=20
iscsi_complete_task().

Similarly, if the ITT points to an active SCSI task, iscsi_complete_task()
could incorrectly force its state to ISCSI_TASK_COMPLETED. Could this allow
an in-flight SCSI read to complete without transferring data?

>  				iscsi_conn_printk(KERN_ERR, conn,
>  						 "Invalid pdu reject. Could "
>  						 "not lookup rejected task.\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804040546.2264=
137-1-yhlee@isslab.korea.ac.kr?part=3D2
