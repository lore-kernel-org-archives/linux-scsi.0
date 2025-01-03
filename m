Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D36B1CCEF6
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735892857; cv=none; b=fQFMFfuR176DgavZyPT0Kzzhv6WJzqpAsynqRU5BBbVexTiRnhh7lffvq2A8SgOEgXZGEgTCis5GcjwS9SFxM/6u2MZhVG3qd7JVZnhM2zau9aAEHA8rGhkMpQlf9S95vtZPyGwUpabimIRXlmfQXtLi6fe1P1jKs3qx5XRTf0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735892857; c=relaxed/simple;
	bh=LoDre/cKFrX805uQ9ZdUFlkvO/F7zeau0G0VCpTyNFw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lhdjXcnU9qtaAufznCZ7hOxX3Pz7Dr94dGIKpQ2EcM/j8TK3UEDS3vAYLG2HlhkhInCE2UH5diuS2gj6zvsktpQJiaQqO8Xx1qTEUmchfzYoAyMC7vRlHLMhcx0Dn7VnQWyZpDBOK2YrR1RRkl/x5sZjUUGgkX4vymAqm2y6+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WuSSq1fW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WuSSq1fW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6441C4CEDE
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 08:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735892856;
	bh=LoDre/cKFrX805uQ9ZdUFlkvO/F7zeau0G0VCpTyNFw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WuSSq1fWhnFXsMG3mrLfwZ6uAD8vtUZqi01+mO6Rgqs2CrHhwMgHTdZe/bWQbp4FL
	 llRQl/OjMZCqpdClJK7D5BtOqvoT3QEmLWrvYUFoFHpOvNdkFLpbk47vo0HiJCA6xk
	 nNeOFHzenLFoNpcgaWfYoozP7VDOnF8Bq0tR1UJKagQrRRed+iho1OSjm8DbAGiacs
	 +51z9xC4LQPPODlfzAFuMqOTFOHObO0VeVZzQqiqQD97nWsWKXUI8oACLlf+rPB5mr
	 0c0E/Y/wGAvMqBCsKfp5wPmg92YiwXlT2yoohy7UVccF3URNmXzVIS5SkomRJjKNMn
	 6cJnGfINDUQHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A0B19C3279F; Fri,  3 Jan 2025 08:27:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Fri, 03 Jan 2025 08:27:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: leyyyyy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-fPO6hSBqBc@https.bugzilla.kernel.org/>
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

--- Comment #68 from Maxim (leyyyyy@gmail.com) ---
Hi

> Maxim, have you opened a new dedicated ticket for this?

No. To be honest, I am unsure about what to include in the ticket since all=
 the
critical information is already outlined in the comments here as result of =
our
ongoing discussion.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
