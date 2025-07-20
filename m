Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206AE1D5CE8
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2025 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753017082; cv=none; b=p6cdO2Yxnu27nY88sJIlkUEty3rbbFXcCOv0BqPtk+jj5oL56z3hkekT4x4i2fgdlp1yFHniGZm8gb3+lb57uf0cVbOb0j56yLgoqUY/kXm5+ectaRJeHH+R2GkLL08Tl5PxjoPiBF6MlOH7GpXAEqHXYs4gLSqISPg4T63eZt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753017082; c=relaxed/simple;
	bh=YRjyyOIy5BENzkRnORVk1YguWGZbNGJvbNSebABMdnU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m0ByKXUnryAEFqKj/G4c7M4G7E9AdLuGgeM5Yt7jFOsLY28wmOE+06n+VLadpkB7nHXRnuFzrUPQm9gQn/SsGymqwTV2yPtFJHYn94Hwvc8pFdliRMPmhzFjE8yaF04NL9EuWay5VN5q9+ELK4VqDZo/MjBM0GVhxqDwkSl2DCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPtAHJMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPtAHJMq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5ABBC4CEF7
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2025 13:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753017081;
	bh=YRjyyOIy5BENzkRnORVk1YguWGZbNGJvbNSebABMdnU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PPtAHJMqdYlAezOT3znv24KVIdTn6+1c5pxCFIisV2svjj0TWsNQZHkQ2aIA/XLq3
	 zAgtXid10kS7+hXMiidMYAd8G2kvnt6Y+tu5pkbTQcppn2tCF28j2//SwLkiKHdzvd
	 oowna9n64cRC2QMEgRDsKm8rraTR5gayMhaEn/h9l2LZEnxLsTg8f6msNKrjY+ZrQI
	 8gzkBU/ks6ttXMoTSMCIBYgOrVYwR2cSR0UMGduaSz7JJG9dYxr+fVmS68MMhYJ1/m
	 iSJAL/o4urYt7OG6xKDtWgubRITBfVOpEicrcH3TyWrlG0B72J6TzEie5yhQFenHyt
	 c6WY2jEHiIeXA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AE530C41612; Sun, 20 Jul 2025 13:11:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Sun, 20 Jul 2025 13:11:21 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tahol17863@kissgy.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-Exjo5yy3nz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

clarkbrown (tahol17863@kissgy.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tahol17863@kissgy.com

--- Comment #20 from clarkbrown (tahol17863@kissgy.com) ---
With EFI, long-travel suspension, and a race-built frame, the Yamaha YFZ450R
sets the standard for modern sport ATVs.
https://world4cars.com/2025/07/09/yamaha-yfz450r-review/
https://world4carsreviews.blogspot.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
