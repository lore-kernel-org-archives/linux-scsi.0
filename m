Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CEE3E558E
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 11:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785755248; cv=none; b=R6i/wSjS98mhIi7tw66MNp/D9dEUGNbj8EIFkBfYVZHnHjI5k0Vrj8YcwumB8VB4H2cpm5V/R6yOx0oO8HeDQ0JvS2gNGvlBAwGiWF6kl9nQVBGT5lfkzFnQeSihb8pQL18ppuyy/Te4slnUK9/oWEbjrXz6eErf2xv5obaJXDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785755248; c=relaxed/simple;
	bh=tyTO7BsHXWMDAY9As767Wq9GBIRWgc6tye/rviMTEsc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZRTn6WrzpnTUv1yZYd758hzgTY5NQt6gwSUWoDuv0TY/jxnoGKdBgPbpn4zl2CN240Rp/qCzzAUXRy9DDiW/IV7Jg7N+efpkmQOXDDqrwlQUGLSZki+yjxLSEKagisHyqaamwIPi/n2oEGYNMWPENFZwoYgMWCPSNcogJ3k2yHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TD28A40g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TD28A40g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F781F000E9;
	Mon,  3 Aug 2026 11:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755246;
	bh=vtZQbNGc3eeBm12wsyDN9w+RX+wCEiKFaqAiyKvj0Z4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TD28A40g92qjXtzYM8sdOaoB8gh4FpN/vO7/qC8+uleer42nOCqDttJgaSQB4HDxh
	 MPIKn9pC7qxrLqbHN6RQ4ixgHduGZcKkC9oGjR6KlwHW/2R/rIWPCMbsc/Zu2H+OPX
	 2OJTNv59SKpik2km2TyEppSK5QN27adlvfr6DoUwUIHIf0+jTpbx5l/8VLzrR9D869
	 r2iqGIZQM4JhX42C3ub75UKCxYxPg0BKa6FvfFMRKn0bP7GGfevk5um8jQqTxJtMII
	 ZXWwJUHzYNwIinPypc4Mb1LbviYsjau0TFbNNjbbLyNWv5/qJSGA+vQ7OI+TAC7Xzl
	 6Oxu/LyTETr7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libiscsi: validate the ITT reflected in a Reject
 PDU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260803104149.2114414-1-yhlee@isslab.korea.ac.kr>
References: <20260803104149.2114414-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 11:07:25 +0000
Message-Id: <20260803110726.45F781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The newly added task validation logic in `iscsi_handle_reject` int=
roduces a Time-of-Check to Time-of-Use (TOCTOU) data race against concurren=
t task allocation.

Pre-existing issues:
- [Critical] The vulnerability preventing malicious target completion of in=
-flight SCSI commands or free tasks is only patched for `ISCSI_OP_REJECT`, =
leaving other management opcodes vulnerable to the exact same exploit.
- [Critical] Negative ITT values bypass bounds checking when using drivers =
like be2iscsi, leading to an out-of-bounds array access on the session cmds=
 array.
- [High] The patch prevents spoofed Reject PDUs from erroneously completing=
 SCSI tasks by checking `!task->sc`, but leaves non-SCSI management tasks (=
e.g., TMFs, Logout) vulnerable to a double-completion exploit via reallocat=
ion.
--

--- Patch [1]: [PATCH] scsi: libiscsi: validate the ITT reflected in a Reje=
ct PDU ---
commit bf6ef027cf2ac528cf92e9e76e0a750fc88ecc70
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: scsi: libiscsi: validate the ITT reflected in a Reject PDU

This commit addresses an issue where an invalid ITT in a Reject PDU could
cause a null pointer dereference or complete an active task incorrectly.
It adds a check in iscsi_handle_reject to verify the ITT and ensure the
task is valid and is a SCSI command before cleaning it up.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 6bffd91b973a4..23ae038c54820 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1089,8 +1089,11 @@ static int iscsi_handle_reject(struct iscsi_conn *=
conn, struct iscsi_hdr *hdr,
>  			 * Our nop as ping got dropped. We know the target
>  			 * and transport are ok so just clean up
>  			 */
> -			task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> -			if (!task) {
> +			task =3D NULL;
> +			if (!iscsi_verify_itt(conn, rejected_pdu.itt))

[Severity: Critical]
This isn't a bug introduced by this patch, but does the new call to
iscsi_verify_itt() properly handle negative ITT values?

When using drivers like be2iscsi, the network ITT is cast to a signed
integer:

drivers/scsi/be2iscsi/be_main.c:beiscsi_parse_pdu() {
    ...
    *index =3D (int)itt;
    ...
}

In iscsi_verify_itt() and iscsi_itt_to_task(), the bounds check performs a
signed comparison:

    if (i >=3D session->cmds_max) {

If an ITT with the MSB set (e.g., 0x80000000) is provided, would this
evaluate to false for negative integers and completely bypass the bounds
check, allowing an out-of-bounds access on session->cmds[i]?

> +				task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
> +			if (!task || task->state =3D=3D ISCSI_TASK_FREE ||
> +			    task->sc) {

[Severity: High]
Does this unprotected lockless read introduce a Time-of-Check to Time-of-Use
(TOCTOU) data race against concurrent task allocation?

Looking at iscsi_alloc_task(), which runs under frwd_lock, it assigns
task->state before setting task->sc without any memory barriers:

iscsi_alloc_task() {
    ...
    task->state =3D ISCSI_TASK_PENDING;
    task->conn =3D conn;
    task->sc =3D sc;
    ...
}

The RX softirq thread here in iscsi_handle_reject() checks task->state and
task->sc without holding the frwd_lock. If a Reject PDU arrives exactly as a
task is allocated, could the RX thread observe task->state =3D=3D
ISCSI_TASK_PENDING and task->sc =3D=3D NULL, causing this check to evaluate=
 to
false and prematurely complete the task via iscsi_nop_out_rsp()?

[Severity: High]
This is a pre-existing issue, but does this logic leave non-NOOP management
tasks vulnerable to a double-completion exploit?

Since TMF tasks are allocated from cmdpool but have task->sc =3D=3D NULL, t=
his
new check evaluates to false for an in-flight non-SCSI management task
(like an Abort TMF).

If a target sends a spoofed Reject PDU with the ITT of an in-flight TMF
task, could iscsi_nop_out_rsp() prematurely complete and free it?
Consequently, if the initiator reallocates this freed task for a legitimate
SCSI command and the target finally sends the actual response for the
original TMF, would the new SCSI command be prematurely completed?

>  				iscsi_conn_printk(KERN_ERR, conn,
>  						 "Invalid pdu reject. Could "
>  						 "not lookup rejected task.\n");

[Severity: Critical]
This is a pre-existing issue, but is this vulnerability also present for
other management opcodes?

While this patch addresses ISCSI_OP_REJECT, __iscsi_complete_pdu() fetches
the task for other management response opcodes without validating if it is a
free task or an active SCSI command:

__iscsi_complete_pdu() {
    ...
    case ISCSI_OP_LOGOUT_RSP:
    case ISCSI_OP_LOGIN_RSP:
    case ISCSI_OP_TEXT_RSP:
    case ISCSI_OP_SCSI_TMFUNC_RSP:
    case ISCSI_OP_NOOP_IN:
        task =3D iscsi_itt_to_task(conn, hdr->itt);
    ...
}

If a target sends a management response containing the ITT of a free task or
an active SCSI command, could it completely bypass this patch's logic and
be erroneously passed to completion functions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803104149.2114=
414-1-yhlee@isslab.korea.ac.kr?part=3D1
