Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D2C14A0BF
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 12:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319717; cv=none; b=YeyZehR4i2l/Q3AAMBnRvph2fxY6gm7TSInxrbdFB02eP6lhShwbwWtD6rUZVl+lchMXGoJdU3cjor1hXYcevGtaWTBy7a/3n82/7kTcD0PwVcGpjzVetsXbDqDb89d/VaLPir3AEToTYdwIkhcNO1YCX5g3Lh0S4oupS6qqPIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319717; c=relaxed/simple;
	bh=Jvyn6+N072k9TTyIgvDJFt++ZPQaFSPqbXDDFvmTE84=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uqbve8H+W/oy4Yol7++W1fqq43Ja38YOUhTFn0v+xJ3bdFSk9UOqsl0mjoqRn/NVhWCkbVcvZjfWQ/VIdH9iZq7kvXOPM5KWW8xK9C+FByfy4ghQOgijJp8lT8tBbH8qgXtoFQdFOvYS6fTQdnlvrJt+IxmLsFXiK2Ttkw/dLlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9WTTlOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9WTTlOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6850C32781
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719319716;
	bh=Jvyn6+N072k9TTyIgvDJFt++ZPQaFSPqbXDDFvmTE84=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=m9WTTlOJp7GlRDaLn7taLrX9eJvgJw6Zmx2WgscQmYbpdezc1krfl4qH5HeTZVBmG
	 4wkKTErXmUSH1c0W52CywpedmoMlQptPln1kh3wvjhkQhGh0Kz5/RVTBCPnDx6hWbQ
	 aMTiyYcjtTDnSbjfPhqH2vc3g9DYrcILKgPFGKlsLaD9eapECpBVk1rjJIdYbZGnte
	 BSMCYJF7Tnqr83iYyApiKmDuXyP4AxOl07vySNn9ctGktL3OGZwf1vtM6QvcKnXNHU
	 tsXJKPNILaZ5tWl0Hg2MnLDBS0D/0HQg2JUA6ef7I0Zz1yT07ctpmmOAzyj6Ai4tFa
	 CcMMLdPDoFdDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DA8E8C53B50; Tue, 25 Jun 2024 12:48:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid when more than
 15 partitions
Date: Tue, 25 Jun 2024 12:48:36 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218866-11613-Dl7qPtKAG2@https.bugzilla.kernel.org/>
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

Marc Debruyne (marc_debruyne@telenet.be) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
