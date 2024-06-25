Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5880F14B965
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319488; cv=none; b=BQsXoqPVMYKCfNfY+CppVwQxvISmrjEbk8L1v2pLgT+Hr8RGMMMaRlpzHbm2gfapksSUsjPGn3oVlD8naeNkIqD67OsPymNgesLuzQ9R+tWWVz/CSuKF61IbeowAHfk4CrlHgiwud/vDyjzAWOueYRKmAd/qxYKhKmrlL7jkLnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319488; c=relaxed/simple;
	bh=97HDMTmu7rhPkKp1UhIJryR4aAfYVi1ahw26kdA1k4w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bEqD9b0Z3KXorIJ+paUTwQXOcgttNFaQGIh4+mCARWdoBWn2DHyfwBJ7YktRo3ZYHmBvNmzeeAzbsVRf/3yBv+17OM7XC4v8zNCK4znFltz4wgEfdDXtLDGqbhiD3e3GqjwChlTkegCbEPiWu6iQmPEFBkcwqE6zlH5P4UpiRY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyrdlEKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyrdlEKh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C101DC4AF07
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 12:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719319487;
	bh=97HDMTmu7rhPkKp1UhIJryR4aAfYVi1ahw26kdA1k4w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LyrdlEKhNLPeYay5f2956uB8dWWc6kBUzgqqgxajHCAUV0pmtmlvp0+kiUqXPh3jn
	 Mu37ZUj+63Z5qpYmblmZdEqSz/F+HJ+Z5pU+OrvZfSV1w1msquq5Iv6WvoV5iZN4W9
	 1fGwwop0XDxY+BUkwvDxpwcrNa712jDXgGIH/4Z9vWZrwKCbVTTf72sHqYZGAqQ5xf
	 2T5JPYO+5fZc2Ph9HkV70oJO5rQbCPmpLG6roG5FXk1uaHDaJ61JSc86Be0nZ+3oHN
	 jPigKfiRqSKHGBEr7jC8inqQ6Vb21T/de/SzBgzihmCB3XhZJFtmksliZd7DUD3NxP
	 Y+huh3XM9286A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B2EB2C53BB8; Tue, 25 Jun 2024 12:44:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid when more than
 15 partitions
Date: Tue, 25 Jun 2024 12:44:47 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: phill@thesusis.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218866-11613-NRjUkI7RKq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

--- Comment #12 from Phillip Susi (phill@thesusis.net) ---
(In reply to Marc Debruyne from comment #11)
> dmraid is not used; mdadm is used

Ahh yes, they did add support for the Intel fake raids to mdadm.  In that c=
ase,
mdadm needs to learn to remove the partitions from the underlying disk, but
that's a user space issue, not in the kernel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
