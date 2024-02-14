Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99853385
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2024 13:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916268; cv=none; b=iH4ib+zMeNXDCBeE8uJzJqHn1QmcCOyWYkQE8h5xn9gzltJjMt9/15MMA2lUhUGbAhvr+bKuuDZZMQCIaiwooxU71v6nse+AFjUJZUMFw/bA3Kkxcof+P5KziwQrV8lj2Im+JFGUSOUiltY+TcMKMI6RKtXDIFbpMSuhUYbBhv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916268; c=relaxed/simple;
	bh=RsTfm5yhkP3eQnQNW1zEXFGeZHvqCItHQwIZ6ByYDYY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CbARzgw2fCe0/yBvKvrrAV0iUhrvoBedxBk3s567kJGccQrofu4LRxvJbV/O6QiclMpu9mglQV+90WP/dD/Km+OfkuTF+nMmOzQzOLt1QhixW35/3hDKz3Yhbz8y6MGc5763UdAFNrKupbS8dUBZLepB2DQGd/PYxAwRVhRNPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOx/07tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOx/07tz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3932C433F1
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2024 13:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916268;
	bh=RsTfm5yhkP3eQnQNW1zEXFGeZHvqCItHQwIZ6ByYDYY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HOx/07tz8F79aVXIDmMkEhgM7G7HHO9kDIJHXjl7t/3uL8FuLldKfGxby0ADqUytu
	 GXyWJv9N06gEECivl1yYUvhXEj/n2hnma4Wi4ycm+XboFW/XJ+CiDKqOjXQYA0vUY5
	 M4UlKsz/S9u3A2jcg8QTHh28eM0bSk8NicvbE6147tGHKiialypXSwTnYVcNHK27lF
	 C0HKncxI7wqIvGx4Rb87Dv1mSe//CItSwsNVEtdTKwJ5gY7907JICmdcuqVlXOAF4y
	 Z9B/rr0iQziOUjFRktxyLAUVLiLGyw5oeAMovG3/xvWen1pRa8cCFxg0GZJ7cuAH3S
	 YXOjZCccQi6CA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C6221C4332E; Wed, 14 Feb 2024 13:11:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Wed, 14 Feb 2024 13:11:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ghosh@pw6.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-YGNFbdX9pr@https.bugzilla.kernel.org/>
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

ghosh@pw6.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ghosh@pw6.de

--- Comment #62 from ghosh@pw6.de ---
Could someone perhaps clarify a few things, please? Which versions and hard=
ware
are really affected by this? We're seeing this with an Adaptec ASR8405 afte=
r an
Ubuntu upgrade 23.04 =3D> 23.10. The mentioned Debian issue
(https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059624) talks about an
ASR8805 controller. So this isn't only about 7-series devices it seems. And=
 I
wonder whether we could downgrade to a version that still works but I'm uns=
ure
which is the last version that didn't have this bug...? An upgrade isn't
possible I guess as this bug isn't fixed yet, right? But why does the Debian
issue say: "We believe that the bug you reported is fixed in the latest
version".?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
