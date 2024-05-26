Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B840C13B
	for <linux-scsi@vger.kernel.org>; Sun, 26 May 2024 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716742139; cv=none; b=kydRk/e4fSyta2UvwFEHu4+PY+PoZCRYpPSM3JlmTiFGEmmAKBn87RmOJS4NvikHOgAj1X+AxhUrzAs82qNu7QcekGMPiQrsJCYZZfP/IXp2V9xDnL4kSVGE4jf3Gx7b8fboAeaVMtp9yPq2Cl42sddwkOz1/EmCAC5p110sLvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716742139; c=relaxed/simple;
	bh=chKt9alPENCqanWsw1QJ3T6IBN/2CnaHFkmkO9VwXaQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dy308v6M4DjVdeLazPRMnwjnqvdDc1+fdaVnt0fJXaEDIJcbU0ErFKsTCZgek7iMDCZzE5clsxXUt+WlEvnKviqQjhwxS8R+DzO2YC16uIsG4IlRCyYiZT5QVFIR5USCkVXBWXb40vtHBm4i68Xhisu9o8i6GLB0kMxMz9o21ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q512qRfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q512qRfo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DDFBC32786
	for <linux-scsi@vger.kernel.org>; Sun, 26 May 2024 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716742138;
	bh=chKt9alPENCqanWsw1QJ3T6IBN/2CnaHFkmkO9VwXaQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=q512qRfotrdOZF82F0uN9ULu7lzlRDVy6ddOsaos2ieYoBR/z9yNoHC2umx9tG4+H
	 /AJmV1OgTXNTUutdWwCh036IPe/dCGUNlzCou+0eMU3WZSkRs5f02ZT+pDC6r/nbOd
	 IsZXkE9pYAF3oi2tUD4WGN73hfBX81YNIx+kQYnNulil2IGV7cUb6sCGu261Q+ojls
	 h+yIn6J/TTn2moyBQIqERfYzMmV0UfHXeGqVqpebFv4M5ddMgtXHyP21GEhhfisAMh
	 IRgAxE8NQitMkfKXech3DMEAUxvJnT+vln+D3jW5BwdCATImh+L1tpB7RByBXVm/6X
	 1jIDPaiNIqypg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 806A5C53B73; Sun, 26 May 2024 16:48:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Sun, 26 May 2024 16:48:58 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218866-11613-NodI8kjRzU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

--- Comment #8 from Marc Debruyne (marc_debruyne@telenet.be) ---
on https://docs.kernel.org/admin-guide/devices.html

************************************************************************
   8 block      SCSI disk devices (0-15)
                  0 =3D /dev/sda          First SCSI disk whole disk
                 16 =3D /dev/sdb          Second SCSI disk whole disk
                 32 =3D /dev/sdc          Third SCSI disk whole disk
                    ...
                240 =3D /dev/sdp          Sixteenth SCSI disk whole disk

                Partitions are handled in the same way as for IDE
                disks (see major number 3) except that the limit on
                partitions is 15.
************************************************************************

Is the number of partitions really limited to 15 partitions?

Surprisingly the extra /dev/ entries start from 16

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
