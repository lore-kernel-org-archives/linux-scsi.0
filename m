Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3505818FDDB
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756272977; cv=none; b=oWaVbYiFkuG65GojAUsJLb+JREjXHit18aqATJnSmUo9/iAys5t/HhRu97HePrN/m49FMGeyk3GQzrJ8QDuQc7dqtC/XJsxS2Y+yIBIZWqMegIE1ZsZlLSWvVchnG5gj0KEDIJ7E7ZDvQtK3lYNhukIIRCadnhMqbi58TtjQuHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756272977; c=relaxed/simple;
	bh=pstQc4mhjYu7sTmRpKcLLjH38SG8T9bHWI727Rtfpg0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J9kjhLbbAJg6A236+ug1P3BAMUr7wziA45VhHDaMrTRyP2EqzJPie79eevEZaCzNEIoWTrKuzCarnwgPTBZEj+iT41r0v6iBU5zmuoN8mJrXHxsbn0crQM8gkkR41E8DrrBv8DMITIKdB8EblQhuKQEeOJVW7X1qSfotijgZFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcfS+7cG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcfS+7cG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB9A7C113D0
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756272975;
	bh=pstQc4mhjYu7sTmRpKcLLjH38SG8T9bHWI727Rtfpg0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HcfS+7cGbMACbEXV3UiJ7sejVz1UYo9T5DVDE+xYDVDf2sJPcYWp7gPh4Vzvgpnx5
	 /4P13ECl9TjHdguFW8kq2NoGXbuxuXfFOY8NjUNc1mNUdoVCVFvPl4v6L2i+9ekC8O
	 y63z/g9ftxsHtV2D5OeMMMXO0cVcep3atNuRHDHgYbPnGLZFaabUudobCbdmRK8m/D
	 dLCL8D8I5yyUvWariFbD8R8YUjEf4BMYc0yLTLpl5yyFvVeLd8MGZLxl9/fmHCwU7Y
	 q6mh6k3MgChRZsL1XRJ7mkYjEjpXYoRgQbQZ2uZv/QtdzNQvQsZahk6BtHtWQOVKRj
	 LMSR8oCSu1BBQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A2831C53BBF; Wed, 27 Aug 2025 05:36:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220504] [BUG] aacraid: DMA mapping leak in aac_send_raw_srb()
 causes eventual -ENOMEM failure
Date: Wed, 27 Aug 2025 05:36:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: shobu@ume2001.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220504-11613-Ey0oOlOMaJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220504-11613@https.bugzilla.kernel.org/>
References: <bug-220504-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220504

--- Comment #3 from UMEMURA Shobu (shobu@ume2001.com) ---
Created attachment 308559
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308559&action=3Dedit
experimental patch (reference only)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
