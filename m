Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E21DA4E
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738015178; cv=none; b=Qdtau5K7K/nuuM0DkUCvOtkLFkRE113P1ZJS+aanOYblegn+Pcj61QzzbNLMKbrRVGqr0NeK/vO715dV+9cPkbRFMJGu5sLe+u5tnDDm9gl+vzC07IX1KOJsbkMEnDLapljWUK1iS66jtz/T2pDn5oTnNz4UxghG8eCnM+MZM3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738015178; c=relaxed/simple;
	bh=DmB3Wc6K3iV7AgiQSLvPJU/IMh3o+Re1bx9/37MLelo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OLPytceu6yNTcIRHZnUVz83iUantzuqdF2T5Lt4znLxMEBjs32hV6oQT5vsb/KhFdosCzwJaiPvINuZ/QlanZy8SgBK135XNXunp7GmxnaH3YZO4zil95Z5BnHkNvtMZyYHa23mATmSv04vcSfLDlhjuM4Cep7bqcBIP4pnbcyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FErfTDoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FErfTDoX"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6048AC4CEE8
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738015177;
	bh=DmB3Wc6K3iV7AgiQSLvPJU/IMh3o+Re1bx9/37MLelo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FErfTDoXem6BJjx40s/RFU0t4KX1cp2lquEP/t/HBVB57XihVSC1RmM0t65Lu6Vvp
	 SRRfm1uHDpCQE/e1jTs72L8L0aT02U8MFryYWwXOrzTG4V5EsfKbRMA1hsX1rbO//V
	 YPlaGi2v+kwQdepcYR3CZ8OUAVt/zE0i5RZeqYGNbTnDm15OoxHldVALXAYxECZTVX
	 vXIxImKYz0ev26I8vMcexKdRyHRneJUmFA3kq21mRqPSMTGBiG4ctNHp9UHLPkX1nz
	 2DEtvFAs2nGSPEisT/KbmJ49XcOkEDKmcVWsw3uCi0afM5l/Z+R3FiJBgJM7bRpzV6
	 Zew1qwE4V1Esw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5D198C41612; Mon, 27 Jan 2025 21:59:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Mon, 27 Jan 2025 21:59:36 +0000
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
Message-ID: <bug-217599-11613-sLDOD22SSh@https.bugzilla.kernel.org/>
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

--- Comment #72 from Sagar (sagar.biradar@microchip.com) ---
Hi all,
I submitted the patch today.
Here is the link : https://marc.info/?l=3Dlinux-scsi&m=3D173801332103896&w=
=3D2


Could you please confirm if you see the patch and if you do, could you plea=
se
ack and ask your test team to run the sanity once?

Thanks in advance

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
