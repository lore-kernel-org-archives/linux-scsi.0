Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A818FDDB
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756272959; cv=none; b=k0azWmSnJaq5sGba8nwtNo1MR0EG/dRqWTVQW34NCCe2A0RVGslDVBOXDe4AvQKGbjtFRFOJPLkO6ckuHAlus8GIJ4QDglc47+gOlGfuAr1o6+JpMgKNZeQHLM7GsMi0yIUfYMLkNMeAkcl8ZouyKBrSaS3Uqq2ZljsLRd9O+Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756272959; c=relaxed/simple;
	bh=TYmN3oO7Ixyuh4WP1jH/CRQqb+t5B549qzBElHH0PVE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y0HY0mkAfA/kyx+oyVqHtOJbBr7LKglIENRCsy+jXFxthzyKH5qv6fy364nZTL/9UQhvubP3+rvKlArtrojncolkHdJDmcL8jfD0KzfUY2fTxH+AI5mHeFGwld7xEfI59JgjjFcx1z3pMWYNxKY6DoNNh0S9yBAW+mQHyLP5hqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXZaIx4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXZaIx4K"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7107C116C6
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756272958;
	bh=TYmN3oO7Ixyuh4WP1jH/CRQqb+t5B549qzBElHH0PVE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SXZaIx4KLl4M9dAm6iwhoygYOiVj7DokYUbAgeEjyNV35QIU8VpWzhnhgCBzRwcoW
	 oAYJJ4+wtX5gNOVxgv9EB4vduAPXHsi1loKkuWXynDLl201YlQfRO+4lhc4o/ctOK1
	 siRnBskGkikftTJwX0k4NipivAGQOr+IcCYhdJi1acI7cpLGr1U50vqJYVcrML/N3K
	 BkUSoH3PnR6rho3eNUr/UVH0hdXbwGCTI/z6kJLv4zqDBvXbCZijn7oHVYMjRSvqz2
	 L5N4CSSUxlH39cnThu+Zzy2Avz5z+IwCRCMGDn9z4sItfKe/Xr3swpsdxWweWDbtR5
	 lnixGARyrPG6A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AFB2FC53BBF; Wed, 27 Aug 2025 05:35:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220504] [BUG] aacraid: DMA mapping leak in aac_send_raw_srb()
 causes eventual -ENOMEM failure
Date: Wed, 27 Aug 2025 05:35:58 +0000
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
Message-ID: <bug-220504-11613-h9afIk9E9x@https.bugzilla.kernel.org/>
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

--- Comment #2 from UMEMURA Shobu (shobu@ume2001.com) ---
Created attachment 308558
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308558&action=3Dedit
bpftrace script for leak detection

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
