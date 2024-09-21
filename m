Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5D1EA87
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 08:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726908418; cv=none; b=j3//t6PT6GeV0SzmlNMQwsuM6DeFEJlYg7/1mQjGessAb+n2TAQjBQLTcWENKuoVb7gvCjTQZLAtreDG1fx/Kzcp4LH7VV1BZQ2LyN0KteledKp+C/+LfCs/4ofRZJKJu1sWIZzG6xQy/Xw/DYOCxm3OmfhAWOfkwzTHo/xMJb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726908418; c=relaxed/simple;
	bh=7wO0iYdkPAH3SBs2ZEe4M/+mOmfrdJCdVKrf8kEobak=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c1UZUE6TJ/0V0JoTHUIDhML2boZuVkXl4NY9mks/QsGQ+C/D0dLq9qzBozzY4wpbghmZoqLFxDziVFP6pHvFnRBm0fey6alvHjk9YgzqKA5Wyn8ORbH0L4S335PH90uhuVE80oK+9h9D+mqGm6i0IWr0LQ4ZxMQJ/BgNQ8C0sj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVlBIx+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVlBIx+J"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27C72C4CECF
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 08:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726908418;
	bh=7wO0iYdkPAH3SBs2ZEe4M/+mOmfrdJCdVKrf8kEobak=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZVlBIx+JX9okgCbPEdKvukVjYM/r/T2vG74Iv11OZzl46UD3vT7nX1xQkiJBDNaF9
	 ueWmAHKyr7hNcj0pbNU+nFbm4UOpufKgQy/FV4hiMidiKsNe+akHngf87+9OlyZ9d5
	 eCfQ4jeMoCl0y0e6oHZi8nNucKJ/po3HyjnxLNodhEDCHKjfV0w2L8R14HcD+HNRnR
	 kb181ySZRUOrQd/Wr4l4HdRwbP/lc65df60ZQqAgNq/xEdILJnuIQQqLTq/xwgbS+p
	 2UxpPVCvFB3KK0s6N5fGM+jS0yl+TFT6KYfY88fcfwtr/0BdORXPBSrsVBAmQB7jOJ
	 46rhnMfqCnxrw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 23EA3C53BC8; Sat, 21 Sep 2024 08:46:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 08:46:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219296-11613-KHbnpx0Ypv@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aros@gmx.com

--- Comment #5 from Artem S. Tashkinov (aros@gmx.com) ---
Bug 218038 was solved ages ago.

Could you try something more recent, e.g. Linux 6.10.11 or 6.11? Or even
6.6.52?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
