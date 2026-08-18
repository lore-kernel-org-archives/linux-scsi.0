Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE2546A5F2
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076809; cv=none; b=fBiSivt5c6o6i6K5WGyw6u97Ydr/oaRSwPviF52xdITVM4g8XmRJ15l62Q8Xl02lkSyimcV6vF3oNblv14Uio3zvK9OYpFYXEhTALhE7j4aUtQ+EbyYmLcQY06rHaK4a+/59QQeYsMsVeXpnBq4H/hnk1j5dogFN3IwCDsCAQM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076809; c=relaxed/simple;
	bh=HrJmn/AMohIU0RqQZDyz5+p43FzOo3bRsv5I87ZR1Fc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BiM9DQV+19d7HOvqNCq0R4wCQkcBDtTmKkzpx2GtGUEmf82DToVFrwLgpHc+9ALmVJLELI0PsxTOAex81vGERhvAOXIb/FsVLOkC2UstetrRklrazC9ncHTBmRLjSo/jzBqUMJAlbZRc/4bi3Q0NHmd701vIi4Ar5fDaKBEgN5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhPf22gW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhPf22gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D701F000E9;
	Tue, 18 Aug 2026 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076808;
	bh=HrJmn/AMohIU0RqQZDyz5+p43FzOo3bRsv5I87ZR1Fc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AhPf22gWw91mQuqIUY1+CCjQrROHorsf3JFEAdC37OqXdhXUGHgNOOEdZ+PzCT+d5
	 2UG2aXT9tsHisVzNLXAbn99qwoKsjoogT7wkv0zl3eDbxdRtMw2C2O4kx0Mh9rUNru
	 12HAMbhrCVOwJLD/0MdlJNUPnUrlHMIdA1O/wV+w6hYTG/XfPYnrnuMmo30EFVf1Lt
	 Xr+NBIYnIXtm5TxJMZxwThX25sEWZ0VWIWKIi+56xL784XSMjGnb5wGd9lRKC0QHGZ
	 CM/dpdgLXGetQvJs1/XPVVyATKwUv9H9Q+moAIHc3voUqb2ZtWo5lRf96rOHMw1NRh
	 E2J4o1LV9jlUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/17] mpi3mr: Fix target device reference leak in BSG
 task management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-5-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-5-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:13:27 +0000
Message-Id: <20260818181328.01D701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free of SCSI target private data (`stgt_priv`) during co=
mpletion of BSG task management commands if the device is hot-removed.
- [High] Unprotected lockless access to `tgtdev->starget` can lead to a NUL=
L pointer dereference or Use-After-Free.
- [High] Missing bounds validation on the BSG `request_len` allows an Out-o=
f-Bounds read when accessing the variable-length buffer entry list.
- [High] Little-endian `__le16` fields from the user request are assigned t=
o CPU-endian `u16` variables without `le16_to_cpu()` conversion.
--

--- Patch [4]: [PATCH 04/17] mpi3mr: Fix target device reference leak in BS=
G task management ---
(Note: The format of this review has been altered to a free-form summary due
to automated recitation restrictions. The original patch diff is not quoted=
.)

commit c103d1267a7a6a9328e7aab3dbe852bbbb68d3e6
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix target device reference leak in BSG task management

This commit fixes a reference leak for the target device during BSG task
management command processing. The reference is now dropped whenever the
lookup succeeds, regardless of whether the SCSI target data is fully setup.

[Severity: High]
This isn't a bug introduced by this patch, but there appears to be a use
after free risk regarding the SCSI target private data. In
mpi3mr_bsg_process_mpt_cmds(), the block_io counter is incremented on
stgt_priv, and then the target device reference is dropped before sleeping
via wait_for_completion_timeout(). If the target is hot-removed during this
sleep, mpi3mr_target_destroy() will free starget->hostdata. Upon waking,
does the atomic_dec() on stgt_priv->block_io write to freed memory?

[Severity: High]
This is a pre-existing issue, but the access to the target device's starget
pointer seems unprotected. In mpi3mr_bsg_process_mpt_cmds(), tgtdev->starget
is checked for NULL and then dereferenced locklessly to access hostdata.
Since mpi3mr_target_destroy() can concurrently set tgtdev->starget to NULL
under the tgtdev_lock, could this result in a NULL pointer dereference if
the compiler emits multiple loads and the pointer becomes NULL between the
check and the dereference?

[Severity: High]
This isn't a bug introduced by this patch, but there might be an out of
bounds read when iterating over the BSG buffer entries. In
mpi3mr_bsg_process_mpt_cmds(), the loop reads buf_type and buf_len from the
buf_entries list. Is there any validation that the number of entries
provided by the user does not exceed the bounds of the allocated
job->request_len? Could a small request length with a large entry count read
arbitrary slab memory?

[Severity: High]
This is a pre-existing issue, but is there a missing endianness conversion
when parsing the device handle? In mpi3mr_bsg_process_mpt_cmds(),
tm_req->dev_handle is an __le16 field, but it is assigned directly to a u16
local variable without le16_to_cpu(). Similarly,
mpi_header->function_dependent is passed directly to mpi3mr_issue_tm(). On
big-endian architectures, will this block IO on the wrong device and fail
to block IO on the actual target of the task management command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D4
