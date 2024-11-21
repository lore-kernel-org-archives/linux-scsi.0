Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10A1BF58
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 19:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732217452; cv=none; b=nkp2Qf4fK4D2pHe9MtFmvozADq/73SkwekM+IoLLvhsPxjpAS95PgW9WV962MGUqpPUCN5im0Yrgq/LaAemZQASOR+x3mbPMmfZPbuOpekjcBbqBxnClD1LWSomM1q5sK+Y2XLjsXnlDlDwyFPNKzE2kGAieu3HxsVuUGG+bOGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732217452; c=relaxed/simple;
	bh=15Yr4YQAN++tHeGP/SobMT0c5i3JNKMqEyzNtYvR2AM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GHSjuaV1z4QOCtMM/NwDoARqEfzz1M6fgLeCzLfyOWlrKxgYDitwGmlkX6LxpPrWxBnc09w3uEIsGScFLtWbD0iexx5eLOgeXHyoBJX01ON9+rSiUrGHW7BrMiPdPLBpvvuIdBSPLE8PM/E3pSHTi9ap/jA55eED99lcl8JX+gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdjZrTsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdjZrTsK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8175AC4CECD
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732217451;
	bh=15Yr4YQAN++tHeGP/SobMT0c5i3JNKMqEyzNtYvR2AM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OdjZrTsKd5NUOHI95K2oQYk51kt8LhaTLpC+otuuC1Ii9iXLQpyP+Qwcfy7mZzidw
	 io63EB8Jf+8aSNenIVO98FjvYWO/yAHIyEqPIRsV8j5z8zAq0UV37hGfINDHKZQQnu
	 Fvt7WLr7p1crNjTUsntvY74NxGtI7ksH4vFXLfef0P0SzTIwJwlXKfzMbYFAP0G9dr
	 Occ+5Gf1B1dI3gGZw503/LeSGqODCzQBRO75gRfcGLnOtCaCFGlYg6lYzFFoAoH7XL
	 BBcqcLWVUFu8zpk37HXqanAwVxAIh5qw6hkCB6HAjzir0Wny/WQpZGAhil7LOTsn36
	 Bq8vhEdWUUPCw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6D062C53BBF; Thu, 21 Nov 2024 19:30:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date: Thu, 21 Nov 2024 19:30:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: laktak@cdak.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-217914-11613-300NmwGGYt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

Christian Zangl (laktak@cdak.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
