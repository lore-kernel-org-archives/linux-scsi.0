Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E13C426D22
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890784; cv=none; b=RevIfSOiq0Mo+HHuEnvpwvuDlO99l2gdMqeQFm2XB6J15+0sssQBEAbkSYDj/F8p/1Adu3l3ciMYs3eEZIHZsuVRUhaqKsHRD/og/hFg3b2Xof0Mi+U89cuaXI4ns4oiU5xoFSqCPtyWNZwGAer3AZR6FHhcqb2BSmmSC+UxoQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890784; c=relaxed/simple;
	bh=h3zm4xNgGM/O0klpbBv1ZN9LKwBQ6fwqHSFgsATQMYI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=azTK8caDjvs0nfPGK1eJKLDLs2VcSGsMkV0XLO1yAI1fuUNNhZ2a79tN4gdLF1aht/OKkFae0CzhucfFAVlDLoJMau/lgfcxyrrYcEpA598YdMgra/SuBG6FF15QfZlOGnV3NiZS4x7NJ9UVsXdYAYPe5Ymm23H1xxFKY9WBvxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBccXEdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBccXEdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15801F0157A;
	Fri, 24 Jul 2026 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784890782;
	bh=h3zm4xNgGM/O0klpbBv1ZN9LKwBQ6fwqHSFgsATQMYI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NBccXEdCqQupifrfeBbM39z30GFZ5SWTmuo7M/gVJ/wZmMbGUOG0b1wvbRQRMyJU4
	 dqQQ4r4dkj4zZ4NyGm6UIit9oQsEosKu/I9UcG1DOeDlEerLJL/nYJULd2q1juCZyb
	 Me0IQ8aq2Zu3L2deQBozaN5x6473yYBzEKYetCw24k97B6fVYmKqCimMWFL6tCrKS9
	 WFNPvVKElWTfixvAWCjJ+yISMgjyOKkEtDQcCR5cZNpuvcHBmzUXxvLda7AQZmUUv9
	 QwjwSWGBBGq1qhELYo0T810eBRzLoJ/YRRt6ftyhUJReQ5q0f6lWSuHXnbUqbmhAG0
	 hoyl40xQQk0qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/10] mpi3mr: Skip device shutdown during unload per
 controller configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724102505.115136-2-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
 <20260724102505.115136-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 10:59:41 +0000
Message-Id: <20260724105941.E15801F0157A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The patch omits `le16_to_cpu()` when assigning `trace_min_size`,=
 introducing a regression on big-endian architectures where the trace buffe=
r allocation is unconditionally skipped.

Pre-existing issues:
- [High] The fallback allocation retry loops for diagnostic buffers are vul=
nerable to integer underflows and infinite loops if firmware provides malic=
ious or invalid decrement sizes.
--

--- Patch [1]: [PATCH v3 01/10] mpi3mr: Skip device shutdown during unload =
per controller configuration ---
Note: The format of this report is altered due to recitation restrictions, =
so
direct code quoting has been omitted.

commit 54bcd2168c5140c8342e83852ac1c6d52964f199
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: mpi3mr: Skip device shutdown during unload per controller configur=
ation

This commit skips device shutdown requests during driver unload based on
controller configuration. It also applies endianness corrections for driver=
_pg1
fields before evaluating the shutdown disable flag and allocating diag buff=
ers.

Link: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@br=
oadcom.com?part=3D1
Link: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@b=
roadcom.com?part=3D1

[Severity: Medium]
When updating trace_size, fw_size, and their decrement sizes with le16_to_c=
pu()
in mpi3mr_alloc_diag_bufs() inside drivers/scsi/mpi3mr/mpi3mr_app.c, it
appears trace_min_size was missed and is still assigned the raw
driver_pg1.host_diag_trace_min_size value. Will this cause trace_min_size to
evaluate to an unexpectedly large value on big-endian architectures, causing
the subsequent trace_size >=3D trace_min_size check to fail and silently sk=
ip
the trace buffer allocation?

[Severity: High]
This is a pre-existing issue, but I noticed something in the fallback
allocation retry loops in mpi3mr_alloc_diag_bufs() within
drivers/scsi/mpi3mr/mpi3mr_app.c. The code subtracts trace_dec_size from
trace_size (and similarly for the firmware buffers) and then retries the
allocation. Could a faulty or malicious device firmware providing a decreme=
nt
size of 0 cause an infinite loop here, or could a decrement larger than the
current size cause an integer underflow that bypasses the bounds checks?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724102505.1151=
36-1-ranjan.kumar@broadcom.com?part=3D1
