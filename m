Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C08C14B947
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719056948; cv=none; b=FFyVmyyHYrnUxmw9/PIDE39/l7/2JxYO4v/FDSdbT5LPEi8h+CMWN7n6t5ItJeGB6CMv9wRt1RDrlWD1+CrceVeu7TZQevU7xwJVjVOYcWAbiMBBPdtyEbuzg+DYDm70i0CubILvLIG3n/BJWVsPRK72K/SZhvj65y50hVPiN6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719056948; c=relaxed/simple;
	bh=ZXJ9wcbvuGokiAoBRmYbUQYCBCpJkPVURK2ODLnwOkc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o/ka9RPKifNRreFEyHGiQmP5zJiQ9dRsiw8WYdIvd/o6fRTHl6QeRv1tegWy+5coTbO1QRoUrzm//utbDpJUT0uXYjOcll9VMmpJ0VGEMkjMlDubrAf9431Fu3j84UmNn5C++VX5h1YbQakaA+Z9PE66R2btt/fpLThxzOa5oDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3t8I+XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3t8I+XH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0238C4AF0F
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719056947;
	bh=ZXJ9wcbvuGokiAoBRmYbUQYCBCpJkPVURK2ODLnwOkc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T3t8I+XHUozTA3hzz8P4vPYmgap+gtt4NlDAPfljZ10/FfecOYSAZv0TgGZ6FBq7P
	 HQYtPhskm15yMxPug3f4GTFpvuMMOzluo5nX5t77+jOvCbOyJunp80kLyawa8tEC78
	 vz8OmF6hrgKJPDCxrAHPyC2BiCYc45THG6JIE/2Q9Z/3zHRlVu0gIDxYgjVYAyEpug
	 GcGj3pZcZyDJDzMOKiMmZdgP0Hwj6c//gIc0S7EtDUTfJtD/UGbCWhkXm95l9iuAuI
	 Q+YfevvjrRk9CAsLcJ/hR0l8TzCwpb0/GrGDaVsVOofk6U/prjk0RYOR8gCARBxPW9
	 DMNCpu9G1ZEdA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C94E3C53B73; Sat, 22 Jun 2024 11:49:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date: Sat, 22 Jun 2024 11:49:07 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zeph@fsfe.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209177-11613-zrh6o2oM1j@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

--- Comment #9 from Guido Serra (zeph@fsfe.org) ---
maybe worth adding the whole dmesg entries for such:

mpt3sas version 43.100.00.00 loaded
mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32779040 k=
B)
mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page size to 4k
mpt2sas_cm0: MSI-X vectors supported: 1
mpt2sas_cm0:  0 1 1
mpt2sas_cm0: High IOPs queues : disabled
mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 100
mpt2sas_cm0: iomem(0x00000000e2540000), mapped(0x00000000dddd21ca), size(16=
384)
mpt2sas_cm0: ioport(0x000000000000e000), size(256)
mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page size to 4k
mpt2sas_cm0: scatter gather: sge_in_main_msg(1), sge_per_chain(9),
sge_per_io(128), chains_per_io(15)
mpt2sas_cm0: request pool(0x000000004246b71a) - dma(0xfed80000): depth(3492=
),
frame_size(128), pool_size(436 kB)
mpt2sas_cm0: sense pool(0x00000000333696a2) - dma(0xcfa80000): depth(3367),
element_size(96), pool_size (315 kB)
mpt2sas_cm0: reply pool(0x00000000eef15715) - dma(0xcfa00000): depth(3556),
frame_size(128), pool_size(444 kB)
mpt2sas_cm0: config page(0x000000009bf3e151) - dma(0xcf9fb000): size(512)
mpt2sas_cm0: Allocated physical memory: size(7579 kB)
mpt2sas_cm0: Current Controller Queue Depth(3364),Max Controller Queue
Depth(3432)
mpt2sas_cm0: Scatter Gather Elements per IO(128)
mpt2sas_cm0: overriding NVDATA EEDPTagMode setting
mpt2sas_cm0: LSISAS2008: FWVersion(20.00.07.00), ChipRevision(0x03),
BiosVersion(00.00.00.00)
mpt2sas_cm0: Protocol=3D(Initiator,Target), Capabilities=3D(TLR,EEDP,Snapsh=
ot
Buffer,Diag Trace Buffer,Task Set Full,NCQ)
mpt2sas_cm0: sending port enable !!
mpt2sas_cm0: hba_port entry: 00000000319a47bc, port: 255 is added to hba_po=
rt
list
mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x500605b002c8f75a), phys(8)
mpt2sas_cm0: port enable: SUCCESS

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
