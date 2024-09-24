Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B62280043
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727214858; cv=none; b=QyjbNEHLcjQrQkwwcad6EmArVeRfAJhIah+u1s3sX180cHeH7+oGnNMopCnQfhS3muhG8S65dVzd6zpZm+BBavzHc0KfMpmF8Q5uujrTADTmH82i1FtzEamt2QOz8Z+SaHlfFziY6mfwpAxBkqG+gwV4esopOZ4BfFIFBeGrb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727214858; c=relaxed/simple;
	bh=d8ZQSMuGuTzZrkC3FWh6YgnXeyFmt/0mf0rlj/uLijU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=quY0622FIT0Wm6r4myyK21+BlPzzVcdkSYk2wuQGjUoUn9pSuN/fCO9KLILTY0KcaaHhz1Q5bmPPex2xWLT8HlRbGvvEwsUHUT+mKlXdCmOjomULM3J8tIOODKQm+Fu2jaNk47bCM51hpH8LBh0pYQTv+emehmsoTPXb0sdkz+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqd8wxqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqd8wxqR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6354C4CED6
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 21:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727214857;
	bh=d8ZQSMuGuTzZrkC3FWh6YgnXeyFmt/0mf0rlj/uLijU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aqd8wxqR3fItkKBSNsYVMZiVQyx9dNAcNW6EADMJCoaloDoHzEX/028mSLxYJ+Yrv
	 YJRY4VIvx4j1y7pH9sBP7MapG8OfhRslyt8ff/iGrs5CeUJHD+zk04t/CXKvcy2vyZ
	 eF3+Jjw/rBpVNEz9VANvFVSGSlxJIZxn52TnAu6AtEk8931SQdgmQYbUgmyHI4SGF4
	 tCGk9F9dr75HDq8Z3C1B5s8O3Md8EY//I+rKA44fWo36LbJbz6p9gw3C8V0plQbVlM
	 +YD6N1x0X6b2vcJJ2pbrnsG9ip8ydSbTivXI1VM5+TrGQd4rtJY9F+O517Cjt7Lh+S
	 9cmik/uW3RBiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D0462C53BC8; Tue, 24 Sep 2024 21:54:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Tue, 24 Sep 2024 21:54:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: dep_changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219296-11613-CJMew3DE8y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219296-11613@https.bugzilla.kernel.org/>
References: <bug-219296-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219296
Bug 219296 depends on bug 218038, which changed state.

Bug 218038 Summary: bbbf096ea227607cbb348155eeda7af71af1a35b results in "di=
rty" shutdown
https://bugzilla.kernel.org/show_bug.cgi?id=3D218038

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
