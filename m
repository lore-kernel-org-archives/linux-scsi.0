Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25EF3B42C4
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452666; cv=none; b=LUQb4YMu+4ieOBPmAJKmp0YJH37xldSRW3NHYuwKOVackOyHqvK1DOG0QKlWI/Mbfc/4ls94Xd9MFE+lGy9tqeVIGs88qmyqE5IEPJdB/Q4r+IiE+hcTOUAli+YV3//0g7lVF4jIfvwRehYhPm5NUfwZ/75RFSepJT2wixZYbgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452666; c=relaxed/simple;
	bh=tCWdeoeKNb0pxz66UCyqulv1T/6pxb12sv5ScSLgzHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=teI4YRKdY7lP/ujkLUBfhjML6fftQdbXfxFRAwXFeyb1WLqxxLFU++s7tjJC7gchct5JAqpDHLshwi7lU7iLhGMHszxs5oy6cpldACBfTpMrr2CTEKZA16ajDYmizVSSqXK2wH+C303JK41yR+vtXlNYgJpz1lj7kt/rcs+buow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vy2KY+hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vy2KY+hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880521F000E9;
	Thu, 30 Jul 2026 23:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452665;
	bh=veBB9kG7yhcd2NSWq5P/MFv1l4jraIQXVW9bIovt8yo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vy2KY+hGky64ml073O00+OZeKSnpp7+0nFnwGvYVcvHRXJURF8Wus1wy5U7IiJGqU
	 w3YKqJV/lM3oD0K+uE9Pk9Oo/yLUfufk4yP9JorqaD+MPsrnTZFt/xtcQ2ZdCcL4Cy
	 dbT/LHIW9/bDLhLRh/ws+M8AQ50X8AJb/0l+tULBt38T9XFqucWVnV+7ra4Tuzqoh8
	 ca1lVKod7zS2vl+q/OnHzBB7Givyca6XPNdMUCHDkbPGa4WoQK0lICct1lqBAgdYqb
	 y4wxUGNQsIc2tol3NkbBVrk9xhU8LhNsEWJ6V9JviYBkfirbVcsx7SEljO5Yl9nMLg
	 UoN0jexIqHKVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/57] scsi: be2iscsi: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <4262a35feddb1851a77a1d3d8bf1da750a766e65.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <4262a35feddb1851a77a1d3d8bf1da750a766e65.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:04:25 +0000
Message-Id: <20260730230425.880521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Low] The patch adds the __must_hold() lock context annotation to several=
 task completion handlers but misses be_complete_io() and beiscsi_cleanup_t=
ask().

Pre-existing issues:
- [High] Synthesized response PDUs fail to initialize `statsn`, corrupting =
connection state.
- [Medium] Assignment of a native integer to a `__be16` field without endia=
nness conversion.
--

--- Patch [15]: [PATCH v3 15/57] scsi: be2iscsi: Prepare for enabling lock =
context analysis ---
commit 4a36248898c49dd5d9e82e5e2120d9998eb707c9
Author: Bart Van Assche <bvanassche@acm.org>

scsi: be2iscsi: Prepare for enabling lock context analysis

This commit prepares the be2iscsi driver for lock context analysis. It adds=
 the
__must_hold() macro to document locking requirements on various completion
handlers.

> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
> index fd18d4d3d219b..289d9d18482c3 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -1185,6 +1185,7 @@ static void
>  be_complete_logout(struct beiscsi_conn *beiscsi_conn,
>  		    struct iscsi_task *task,
>  		    struct common_sol_cqe *csol_cqe)
> +	__must_hold(&beiscsi_conn->conn->session->back_lock)

[Severity: Low]
Does this patch miss annotating some other completion handlers?

For example, hwi_complete_cmd() calls be_complete_io() under the exact same
session->back_lock:

hwi_complete_cmd() {
    spin_lock_bh(&session->back_lock);
    ...
    be_complete_io(beiscsi_conn, task, &csol_cqe);
}

Should be_complete_io() and beiscsi_cleanup_task() also receive the
__must_hold() annotation to fully document the locking requirements for the
core I/O completion and cleanup paths?


[Severity: High]
This is a pre-existing issue, but synthesised response PDUs fail to initial=
ize
statsn, which can corrupt the connection state.

In this function, the response PDU is constructed using the memory of the
original request PDU:

be_complete_logout() {
    hdr =3D (struct iscsi_logout_rsp *)task->hdr;
    hdr->opcode =3D ISCSI_OP_LOGOUT_RSP;
    ...
    hdr->itt =3D io_task->libiscsi_itt;
    __iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
}

Because statsn in the response overlaps exactly with cmdsn in the request, =
and
statsn is left uninitialized, the response inherits the request's sequence
number. When libiscsi processes this fake PDU via __iscsi_complete_pdu(), it
updates conn->exp_statsn =3D be32_to_cpu(hdr->statsn) + 1.

Can this overwrite the target status sequence number with the initiator com=
mand
sequence number, leading to immediate connection state corruption and break=
ing
iSCSI sequence numbering?

This same issue also appears in be_complete_tmf() and be_complete_nopin_res=
p().


[Severity: Medium]
This is a pre-existing issue, but is a native integer assigned to a __be16
field without endianness conversion here?

be_complete_logout() {
    hdr =3D (struct iscsi_logout_rsp *)task->hdr;
    ...
    hdr->t2wait =3D 5;
    ...
}

The driver assigns the native integer 5 to hdr->t2wait (a __be16 field) wit=
hout
using cpu_to_be16(). On little-endian architectures, this stores 0x05, 0x00.

When iscsid parses this via be16_to_cpu(), it interprets the value as 1280
seconds instead of 5. Can this cause the initiator to wait ~21 minutes befo=
re
attempting task reassignment during logout recovery?

>  {
>  	struct iscsi_logout_rsp *hdr;
>  	struct beiscsi_io_task *io_task =3D task->dd_data;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D15
