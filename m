Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B37D17E4
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 00:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735779564; cv=none; b=ivx1XNyEaY3Ck07NcQ3HbAXoXdGuzbQXgek9yqTxvZ5eKAmzdlQMQScOXMDmZPPQApdFPqcI3PUxSWXh+EBRswprg/RMYPcfupZgPV04tQGVT+JpZg/eUfj4EHrU1kWvx7I0H29aOpIzKcuvuyF49aK3J8msrVIkNVlzhxGKrYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735779564; c=relaxed/simple;
	bh=/TocRNVeEyxF8ZODajcwcxadxz3SMWD2pEYZntKpFBw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MjC6bFisRWLppS6uKgyt2UFcGz72mdEkUuD/Yb5hKNy/LG82bYqjyssGox551LKGJyo8MPAlP9/5ZiYP9odZPSXn6l/WKY7y8yr3esCiTJbso+tNRMiV7ClIiuG5t9W0MiqGG064mBdrfqS5IH1ucIF/fi57VaO5rZ+nTdI+YYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhKVsc+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhKVsc+X"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A420FC4CED6
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 00:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735779563;
	bh=/TocRNVeEyxF8ZODajcwcxadxz3SMWD2pEYZntKpFBw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MhKVsc+XdjQL62LWlv5rx3DQ3DL3zi8GhgF9lCvO2AojOZEPUouuY9UnavyMsWgtQ
	 /qaU0+LP1SMtBPH3cVPXcmo2PeButl5/D+7cLLs+10rA2NR912UODREM8cGKfLp2SP
	 iZ+n7MFZOpePZYWlPyZQrZyzVPhF5/0U5PqnuC/NDFeWddsCsS2jffUyX8b5cbl2aL
	 dQSbhW/Tvb6ykwr6OhUgBgBdbLirbnLhnxx5hxivNFvCKIok3/gFiHlErjLwx64nyv
	 xZFqJlqT8mKz5cfarvdoQs6hJecjE/GmtZ0eflNAfurn32UWPPuC9RyisPgV4P0rdj
	 f//v+FiAYHexA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9EC43C41613; Thu,  2 Jan 2025 00:59:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Thu, 02 Jan 2025 00:59:23 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugs-a21@moonlit-rail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219652-11613-AFdWH1pyxB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219652-11613@https.bugzilla.kernel.org/>
References: <bug-219652-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219652

--- Comment #2 from Kris Karas (bugs-a21@moonlit-rail.com) ---
Created attachment 307437
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307437&action=3Dedit
usbmon trace from kernel 6.1 showing correct capacity negotiation

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
