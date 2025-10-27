Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBEA313E1C
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761580118; cv=none; b=CtzSm0TNHrogcHZ+40dv1Sfn8ZJAgZ3zcH0y0naRZg4RITUnVTtUhLnIXRVrx6T/zS/4FHlPa65W3AboivgLegkhPT7WZK726RA2SA18kpvLpXcafQco4K+FdSH6WzsD4AtId2vUxDDtPwiRF23Cai7u4eMwjgTzjMqRSity7KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761580118; c=relaxed/simple;
	bh=Chs4uBLVNXkITLQIhrYMMQcLqrhnaxdWbv+XRWE2D58=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qlSnpFLb6pNsoXBhnwEGj5J+fo6YM8/SUKBjICza6j6Q+aOTnO+MIzvhMWJfEQZTke1OYzJzmdRfUMohFG44qe65yty/nujvfOY0Sc+lwU1639nRJcnepdEIQ9Ug05g2CKT05dJX+pL0NZDAgDfna7Jg39f4RIuqKemLCnYxD5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAJTgAyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAJTgAyM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 316ACC4CEFD
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761580118;
	bh=Chs4uBLVNXkITLQIhrYMMQcLqrhnaxdWbv+XRWE2D58=;
	h=From:To:Subject:Date:From;
	b=hAJTgAyM88qTC0meMn+fPzJMqNjyQy4RBPFQwNF4X2wncPOhmwTs3FgIPFsYKUgHo
	 A9xN4k/pXuJ/pxplQQcpQpMLMIAb3rjgRMJYbvSXvkKNvhPEP744OzKQnKBo9Og6Fq
	 /cdTFebdeVd4+QwsPKjl2hlTlkSxGMLZPgiRLHH0jz/cn7Nd48adDa9YghdZeCFRZ8
	 7xNTWo5y9pjpH6xMKRVKLxDrVPHY516IxYHrB/Ohht2yEgp1iyJCHt3prVaSiXrKU3
	 Z/v+REsKxjI47frVd3uSrjARvipARpjVT92G5jnhBDIeK/AQBGDXRMq9QwfwrpUUD4
	 vaPZ2Vh6F7r2A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2AB38C433E1; Mon, 27 Oct 2025 15:48:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220707] New: ESAS2R: missing a NULL check in
 esas2r_init_adapter
Date: Mon, 27 Oct 2025 15:48:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: qiushi.wu@ibm.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220707-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220707

            Bug ID: 220707
           Summary: ESAS2R: missing a NULL check in esas2r_init_adapter
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: low
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: qiushi.wu@ibm.com
        Regression: No

In esas2r/esas2r_init.c, function esas2r_init_adapter() allocates a workque=
ue
using alloc_ordered_workqueue() but does not verify whether the allocation
succeeds. If the call fails and returns NULL, the returned pointer
a->fw_event_q remains unchecked, which could later lead to a NULL-pointer
dereference when the queue is used. This issue was found via static code
analysis. No specific runtime reproducer is available, but the missing chec=
k is
evident in the source logic.

Code: ```a->fw_event_q =3D alloc_ordered_workqueue("esas2r/%d", WQ_MEM_RECL=
AIM,
a->index);```

Also, at this allocation point, a->index is initialized to 0 (due to the
earlier memset(a, 0, ...)) and has not yet been assigned the adapter index.=
 It
might be worth confirming whether a->index was intentionally used here for
naming or if the local index variable should be used instead.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
