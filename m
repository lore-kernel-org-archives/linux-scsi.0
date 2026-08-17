Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F0436361
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978564; cv=none; b=Av0NXATuFEn/2Z8kgvey7I2FsQfn24IEsDuItZZQjWofMsJZadVcBPhub7yBkdqy2s7RPBUWeowwubixoYKE8MgFNocSlHYoQ7i9cCTLaDuS81g1RAaAtHvhmPSNL3WUd3Z6BYCabtKJQVW9/PhPsQJFf8AfUy5bDAScpPxr/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978564; c=relaxed/simple;
	bh=80yNdogJv00N5/KJUL2riPX8o6d+BrDmt7mNYcZYfhc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qKCdbJ80KGCmqCBrNjvd5yIoiOBPg1xslrN1CH2KkkeGrJwIlr/KQOmFRdtR5hsqMYv7UO71FvMoPkZxCqd+L6j6c0hbMSB8hdiuonj5GfoI0HftNKu/XdzxfcbApNm0Wb7Niw0fLm5DJvkhOL3NKNaX/aSXzk9y6/ouh1nJbig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+TRMhMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+TRMhMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B961F00A3A;
	Mon, 17 Aug 2026 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786978563;
	bh=80yNdogJv00N5/KJUL2riPX8o6d+BrDmt7mNYcZYfhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D+TRMhMe6mH+8Yq2nQdQ7FNfBQsKlJSWvIlPr8uVdplQo/pBZBiNMx4Q4C2XMjbUO
	 v95TT1eTMxncOHpCatrts+o87gmNppXOC7QuKJw71T3n4K6ODNGGJmMnIiAzBTB3lC
	 LxXfhKfEJRhttG/1JcczEzBLzpTdcPTzV/U22zLcQmGRXRhdUcH3YlE2DANYb/TVE4
	 PTxfz50CC/dPoQm5QiXpnqy4OvVCCPukouaREecby0AsYL/aP54uDVg5otLw5XKWPY
	 389rXHMsfmEKTA3d3Qw6L6ESo6bmgdC22E/9c83sHJ4WW+zITjLNGlr1aeln5PbmXu
	 tjRZW4bL5MnAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2] scsi: mpi3mr: check the SMP passthrough reply status
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilya Khomyakov" <khomyakovilya@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817143841.1856-1-khomyakovilya@gmail.com>
References: <20260817143841.1856-1-khomyakovilya@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 14:56:02 +0000
Message-Id: <20260817145603.26B961F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on user-provided payload lengths causes integ=
er underflow, leading to massive out-of-bounds DMA.
- [High] mpi3mr_transport_phy_reset ignores the controller's reply status (=
ioc_status) when resetting HBA phys, falsely reporting success on failure.
- [Medium] Unbounded firmware response length triggers a WARN_ON in the gen=
eric BSG layer.
- [Low] Early error paths in BSG handlers leak 4 bytes of stale kernel heap=
 memory to user space via the uninitialized `job->reply` buffer.
--

--- Patch [1]: [PATCH V2] scsi: mpi3mr: check the SMP passthrough reply sta=
tus ---
Note: The format of this report has been altered to avoid quoting the
original patch code directly, due to recitation policy restrictions. The
findings are provided as a free-form summary below.

Commit: 8f30f09fa87333575dd13664d3ca77572ba9a47e
Author: Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: scsi: mpi3mr: check the SMP passthrough reply status
Summary: The patch modifies mpi3mr_transport_smp_handler to check the
controller's reply status from mpi3mr_post_transport_req. It ensures refused
SMP requests correctly return an error code instead of falsely reporting
success.

[Severity: Low]
This isn't a bug introduced by this patch, but looking at the early error
paths in mpi3mr_transport_smp_handler (for example, when checking
mrioc->reset_in_progress), the function exits to the out label without
populating job->reply. Does this leak 4 bytes of stale kernel memory to
user space? Since job->reply is reused across requests without zeroing,
the bsg core completing the job will truncate the reply length to 4 bytes
and copy uninitialized or stale data to the user's response buffer.

[Severity: Medium]
This is a pre-existing issue, but further down in
mpi3mr_transport_smp_handler, the code assigns reslen directly from the
controller's mpi_reply.response_data_length. It then passes reslen to
bsg_job_done without bounding it against the user-allocated
job->reply_payload.payload_len. Could this trigger a WARN_ON in the
generic BSG layer? If the firmware returns a response length greater than
the allocated buffer, the BSG core's bsg_transport_sg_io_fn triggers a
WARN_ON for the mismatched lengths, which could act as a denial of service
vector if panic_on_warn is configured.

[Severity: High]
This is also a pre-existing issue, but I noticed a potential integer
underflow when setting up the scatter-gather elements in
mpi3mr_transport_smp_handler. The code subtracts 4 from dma_len_out and
dma_len_in when calling mpi3mr_add_sg_single. What happens if a user
passes a payload length of 1 to 3 bytes? Since there is no bounds check
ensuring the payload is at least 4 bytes, wouldn't this subtraction
underflow to a massive 32-bit unsigned integer and cause out-of-bounds DMA
operations?

[Severity: High]
This isn't a bug introduced by this patch, but I found a very similar
logic error to the one you just fixed, located nearby in
mpi3mr_transport_phy_reset. When resetting an HBA phy, it calls
mpi3mr_post_transport_req and logs the ioc_status, but then completely
ignores the status value and falls through to return success. Can this
disrupt SAS link recovery? If the controller actively refuses the reset,
falsely reporting success might cause the transport layer to incorrectly
assume the phy is operational.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817143841.1856=
-1-khomyakovilya@gmail.com?part=3D1
