Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA917FE
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 03:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735875467; cv=none; b=fpsV4HuDZpDaVKxzqzrDBhN86LCs7W7nOqvE2sdgicv07PUsgUhFiaY/8A5aBxdxMx236nzybKPfZvqX8uH0YWiqcXD4fTbmapXmE65RlqnnfX3368DAVfQAQoJTww08bjuO9LPIYbsarqH1/5L3NyIxdt9GpSopjoR7PyKVFMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735875467; c=relaxed/simple;
	bh=vo56qt10hstoUluZeMkpyAb2eNxsilm8ysxPvrgXw1I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AlLDQlECbceAaOGG0uHYyi0q/aAM3UME8e9nVkB9e87dwz//VX0Pcm02jGGe5zH8Z/LZrFfYIRWi9JjcU3/VAZ8gWKSCaBus4/vKxnkomLuFO5vPzK1gXIZUJhT5KNe2pVb1MePi51pcspLK1P/N43eb/Hswa9zoRU67j8FIzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKk9hKFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKk9hKFc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2D3AC4CEDC
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 03:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735875466;
	bh=vo56qt10hstoUluZeMkpyAb2eNxsilm8ysxPvrgXw1I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JKk9hKFcqanyOWBB9lb14Yx1bzzTmma5Uot+mQ4fvQqoWGMjwmi17zgaMEoKKp2ea
	 pcWDsKeVqyS3OJ1TJK54/4aHT0PzI5I70ZGOgiOQxQakTfy3JAsDlIi3bZgUvxcdhD
	 BjpVdzIHJAj0WUFuDZRfvoMXFi2Q7W6AiFpxQQwCO56Kd7CWyc2ws4m99objS6ZPug
	 tqUM0Ako139z3cWbGTLimHDyPExJyagsCCJLqcNIqX7AyLOBnc6htwC5X3dsCw4t9K
	 21nHdVwa/Nh8Q4Z5TfLDUQZo6UqVRZtBEuLmlEjoC8cq2r+LjAQYU1dDsk2TYNqQlV
	 75jLD7hGK3qZg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A47EEC41613; Fri,  3 Jan 2025 03:37:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] READ CAPACITY(16) not used on large USB-attached drive
 in recent kernels
Date: Fri, 03 Jan 2025 03:37:46 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: stern@rowland.harvard.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219652-11613-MdrLl4fi8h@https.bugzilla.kernel.org/>
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

--- Comment #11 from Alan Stern (stern@rowland.harvard.edu) ---
For example, at the appropriate points in sd_read_capacity(), add:

   sd_printk(KERN_NOTICE, sdkp, "sd_try_rc16_first(): %d\n",
sd_try_rc16_first(sdp));

   sd_printk(KERN_NOTICE, sdkp, "sector_size: %d\n", sector_size);

   sd_printk(KERN_NOTICE, sdkp, "sizeof(sdkp->capacity): %d\n", (int)
sizeof(sdkp->capacity));

   sd_printk(KERN_NOTICE, sdkp, "sdkp->capacity: %llx\n", (unsigned long lo=
ng)
sdkp->capacity);

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
