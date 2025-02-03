Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FFD13212A
	for <linux-scsi@vger.kernel.org>; Mon,  3 Feb 2025 18:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608053; cv=none; b=MkbVUsgXbpybH76WKf6VScGgRz9x2gLyUDQmBDlGo0lV939jG0eIa5tp5eHGZeNQE0OcvQm5xphEQgaxAPigvCyuPiTTE7GTWX8YmRuJnaT5iBaFX/GjH58PJzbVJu6xnUxbeq7wfIfFZJDkHl2vmXoMjxXRUxWnUcupS2jR0vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608053; c=relaxed/simple;
	bh=ZTgTfcOD7Z6Y1DYV4WZ8/WOqTQlZZWFSSxCVi1At01s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T5X5tk9kWzX+0DspAlzWnrI7Jok8P+KBvImgN3Rv1qN0tCUO5lwUDCyjiVmXb56AwM6dF/8LEIffonB+1xyBWJo53i3wGuKJVIcCcfTOQrrNR3MPieGCvch/XuGQSv+1MiDHtUlvMINduFlN/gr+nPbdKt2e5TLxnm8qDOLpIxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFXaECVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFXaECVh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 135A2C4CEE7
	for <linux-scsi@vger.kernel.org>; Mon,  3 Feb 2025 18:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738608053;
	bh=ZTgTfcOD7Z6Y1DYV4WZ8/WOqTQlZZWFSSxCVi1At01s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gFXaECVh/7xWXZ19bUCF4g9/J1bqhxMkQJU67sRqAZUiwhI/pVTa2x0udfQ+I2TzZ
	 i1FWxbORbvrkPx1mS6tisXBUGiM6VfTxixRSl1RSklU/7lhfkqFxxegdmpQ9N6JTji
	 i8A44ZLGdT0Hqw/vyLcHtwmoewgz0J88LNoBlIzlx0GKXqRiGjzonS6EKuBiAJ1bmA
	 QTZctHnjqINKW+MbUYgtufwWMLuJJsyo3G4YfKI+zwMRqyTo/Tuzz/0bRM6jYWEI5v
	 QjRyEEyv6xpymoIMdC5iwEZDS8xwZc3mfWJxozTD2TG+7JeP9f8fKtuKGX6AOSezWN
	 HZIPh+kEPvucg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0D1FAC3279E; Mon,  3 Feb 2025 18:40:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 03 Feb 2025 18:40:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-UX2IXm2L0H@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #73 from Sagar (sagar.biradar@microchip.com) ---
(In reply to Sagar from comment #72)
> Hi all,
> I submitted the patch today.
> Here is the link : https://marc.info/?l=3Dlinux-scsi&m=3D173801332103896&=
w=3D2
>=20
>=20
> Could you please confirm if you see the patch and if you do, could you
> please ack and ask your test team to run the sanity once?
>=20
> Thanks in advance

I had to rebase and resubmit a V2 with a comment added (NO CODE CHANGES WRT=
 the
functionality). Here is the link -=20
https://marc.info/?l=3Dlinux-scsi&m=3D173825819000502&w=3D2

Please use it to test the reported issue.

Thanks
Sagar

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
