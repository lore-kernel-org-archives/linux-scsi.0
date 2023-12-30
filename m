Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E41B8BE3
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2023 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVprMgF0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5BD5C433AB
	for <linux-scsi@vger.kernel.org>; Sat, 30 Dec 2023 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703940072;
	bh=QQkbVVjgxxY/Wx6tHi8PP6kUROdii8WMsWbrDzSwk+Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BVprMgF0vGuPbfts9h0W5BRVSMXS4prReiHmcDfI5TNMJZ+b74PaF3vhfa7ovqHk4
	 wjw6KcvpPxIYL+CZYQhLdwu6L8oLijsOulsU+XLySshEQYJ4nmKOtkr0aMyqK30Tmq
	 4pdtyhPlRtPXd5XQXK70fZ6gdRFb5oB09QjrGrQgJUqVxXdFEvbN/EmsONyc/BUUv/
	 SKLoE71MrtvHM+1y033hLtbaLBql+QETZgUPgAo5PVV8xoCXTl/Ml1vfJqBl6qGsXL
	 16ZL1/O7LxDlwN3G/WmDNqQWVi9dih1SwrUgWNCbjwRDYNYEynfam5N6NPI94OkOXo
	 4SkgLrHFOxTbA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D5CE0C53BD4; Sat, 30 Dec 2023 12:41:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 30 Dec 2023 12:41:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: samuelwolf85@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-dBLhh3lHux@https.bugzilla.kernel.org/>
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

--- Comment #55 from Samuel Wolf (samuelwolf85@googlemail.com) ---
We see this abort request / hang on Debian 12 with the ASR8805 two or three
months ago.
Since this was not the newest server we replaced this system because we tho=
ught
this
was an hardware issue.

[two month later]

But now, this week we upgraded the next server with ASR8805
from Debian 11.8 to 12.4 and saw exactly the same issue (Debian 6.1.67-1).

This could not be the same hardware error, so we found this bug
report and opened on at Debian bug tracker [1].

Salvatore build a test kernel [2] and we fired up the old "faulty" server f=
or
testing.
With the new knowledge we was able to reproduce [3] this with an ASR8805 ra=
id6
and 58TB LUKS drive.

luksOpen and mount reproduce this every time with kernel 6.1.67-1 and need =
~ 1
minute (because the hang and reset request, I guess). Now booting into
Salvatore's test kernel (6.1.67-1a~test) and tried the same again, no issue=
 and
the luksOpen mount was really quick.

This bug was more serious than I guess and it needed some time to get this
puzzle together.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059624
[2] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059624#30
[3] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1059624#47

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
