Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC1520EB
	for <linux-scsi@vger.kernel.org>; Sat, 20 Apr 2024 07:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713597500; cv=none; b=AV1ZC0tvVlH1MJoHNvgwwAVJx7CtXNkPExHSwgudglsv8jdmdzSf0Qr7sAiddUomvW6Ba4wjj3C5NSvK8bWatEzpEAQm4zRPLOhJWSU4H0jN5abOJG4loJPs80CzXZuUbc+M7/Co7ipO8cHYlkdUqmq9MspdapxL0JYwp5s/PBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713597500; c=relaxed/simple;
	bh=ti/TRdQ0FdUAD92qspAbyjs3Pqzo8XkBNB5ASOImmDk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BJrq3FPizCn83iE+F0aalb6RvtbGX407QJg3V4xUi401JU+1gyYMABO8/CltZN0yypddveJCHSmewpCk6ROt1JLdytc3jxyR9rjNnNlY65kj5xbHVqMr1XjyygirzXr0QEv7IdBxUWFwYoH1SVhdIFLjy/8rwVFx+X1woX9Kx2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oTrCRnh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTrCRnh2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98644C113CE
	for <linux-scsi@vger.kernel.org>; Sat, 20 Apr 2024 07:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713597499;
	bh=ti/TRdQ0FdUAD92qspAbyjs3Pqzo8XkBNB5ASOImmDk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oTrCRnh2MrdMAIk/6xhIgt83xAhUmReqacdt/qyUkOHVige8Z9UbX9nv/FOOA6ISu
	 DNQqfQ6X/YtNwhmw9Egd3+SLVMZB7omua1VrgyW0W4hZ1CRMzIO7hlrMfNrFqdEY/0
	 E+W7kEnGKtNCOFgzrmXMFRmnaapREAWfwrExyU3pVzX2qmKJEg3wi7+O4en9fkHzJB
	 wpOsuTLuDUgd7x4H3QzJNOuccHRFpSQgZtcXNp0boj2Szs0ZR8vXFSf+QfF4D1if+V
	 aB2anJ+ScCrDNhjB+PxWXujlttlxTDon5KVvRqSI5JqI4oV92/jg4hukoyf1bjPPpB
	 CQubNqBBT35OQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8AA9DC433E5; Sat, 20 Apr 2024 07:18:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Sat, 20 Apr 2024 07:18:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bekeanloinse@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-u4NxxJr1HJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

Bekean Loinse (bekeanloinse@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bekeanloinse@gmail.com

--- Comment #14 from Bekean Loinse (bekeanloinse@gmail.com) ---
(In reply to Theodore Tso from comment #8)
> The people you need to contact are on the linux-scsi@vger.kernel.org mail=
ing
> list.  They are extremely unlikely to be following this bugzilla issue.=20
> You'll need to ping the mailing list thread on the linux-scsi mailing lis=
t.=20
> Or contact the two SCSI maintainers:
>=20
> SCSI SUBSYSTEM
> M:    "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> T:    git https://heardleunlimited.com/
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
> M:    "Martin K. Petersen" <martin.petersen@oracle.com>
> T:    git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>=20
> Or try contacting the patch author in question, Bart Van Assche
> <bart.vanassche@wdc.com>.   There's not much we (the ext4 developers) can=
 do
> here to help.

Since it is a duplicate of bugzilla #198861, kindly close this entry.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
