Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C8A34DB76
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761678070; cv=none; b=hbmyThkKX1aaxC7FivywzrBiMf9DRbRgg9/WgXI0h+w6lKNmA70nLGfV4Watw6mDO/aUbjpmqLD71mW71K41WxmQ7L/ylxNWW9f/Qs3UMf4k/USTbH3lHneI/tC49uZWHulkxSed9xqow4lcVcmk+b3kRWSou4FtHQ7p1W75C6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761678070; c=relaxed/simple;
	bh=G+CgJsjdGZhKyVFDXshWaRSwxgEMxvWd/V43G7jsBEo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UGcKp5Wj3ltEDN9Cli32fopdA7qoPQ+Q8HRsEVrbiuZPHuuKVsRoWlYKcVYzmEf66XiDzcw+hiQJcd63DDxb0qEqOMnqpBKLzF5iu0ytcaHKkhM6hxx8gLE21ky9fJd9owKgIlqeS1neAC0UL9bec3jCFwVEfQ74jpsrpnuX0hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV31+N+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV31+N+/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1298FC113D0
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761678070;
	bh=G+CgJsjdGZhKyVFDXshWaRSwxgEMxvWd/V43G7jsBEo=;
	h=From:To:Subject:Date:From;
	b=hV31+N+/9buZ/UrhT6a5PQ8F1VDsCrVyeo2iTV4FtyOXS/3gRUDtqaeMzV0BbidSp
	 n2Ze/TYvKysOE8sq2Oa/KtB4ynTTxAzbU9twOi2rTnfOa0MwkZ7+DBatqzhWslfmGE
	 +DGjVc+uOKJlZ0RTO9ttJnkruCrKoAJRvqqw3L2epHKXCssUAylCm0LsgRQY0CmINm
	 NFDQnaWOWqToQvTr0+5jzvIP/LCJqzZekxeyfCOTwRvHG2m3mOfZO4fNqHS161cWrO
	 m6IXbWw/aIqbIPxV4+8qvN2TzExNvGKZLKx7HvJCY4ii6dVnxf2JNZrGKQUe6UGCNZ
	 wK7W3Jzvpxdhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 04296C41613; Tue, 28 Oct 2025 19:01:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220714] New: arcmsr: missing NULL check for
 dma_alloc_coherent() in arcmsr_alloc_xor_buffer() leads to NULL
 arithmetic/deref
Date: Tue, 28 Oct 2025 19:01:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: qiushi.wu@ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220714-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220714

            Bug ID: 220714
           Summary: arcmsr: missing NULL check for dma_alloc_coherent() in
                    arcmsr_alloc_xor_buffer() leads to NULL
                    arithmetic/deref
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: qiushi.wu@ibm.com
        Regression: No

In arcmsr_alloc_xor_buffer() the first DMA allocation
dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->init2cfg_size,
&dma_coherent_handle, GFP_KERNEL);
is not checked for NULL before it=E2=80=99s used to compute pXorPhys and pX=
orVirt
(pointer arithmetic at lines like 775 and 779 in the snippet below). If this
allocation fails, the code performs arithmetic and later writes through
pointers derived from a NULL base. This was found by a static analyzer; no
reproducer.

The Code snippet is:
 755 static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 756 {
 757         int rc =3D 0;
 758         struct pci_dev *pdev =3D acb->pdev;
 759         void *dma_coherent;
 760         dma_addr_t dma_coherent_handle;
 761         int i, xor_ram;
 762         struct Xor_sg *pXorPhys;
 763         void **pXorVirt;
 764         struct HostRamBuf *pRamBuf;
 765=20
 766         // allocate 1 MB * N physically continuous memory for XOR engi=
ne.
 767         xor_ram =3D (acb->firm_PicStatus >> 24) & 0x0f;
 768         acb->xor_mega =3D (xor_ram - 1) * 32 + 128 + 3;
 769         acb->init2cfg_size =3D sizeof(struct HostRamBuf) +
 770                 (sizeof(struct XorHandle) * acb->xor_mega);
 771         dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->init2cfg_=
size,
 772                 &dma_coherent_handle, GFP_KERNEL);
 773         acb->xorVirt =3D dma_coherent;
 774         acb->xorPhys =3D dma_coherent_handle;
 775         pXorPhys =3D (struct Xor_sg *)((unsigned long)dma_coherent +
 776                 sizeof(struct HostRamBuf));
 777         acb->xorVirtOffset =3D sizeof(struct HostRamBuf) +
 778                 (sizeof(struct Xor_sg) * acb->xor_mega);
 779         pXorVirt =3D (void **)((unsigned long)dma_coherent +
 780                 (unsigned long)acb->xorVirtOffset);
 781         for (i =3D 0; i < acb->xor_mega; i++) {

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
