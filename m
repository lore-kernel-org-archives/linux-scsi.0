Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814CD1FAD
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 03:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706152073; cv=none; b=B17mEc6ZtxAVRVOUzSjgcrSiwdCVLIlIDL8RIX8DQW2cfOt1rJVBA70PurnJxt2tNGeXALj6tLFGnzrqVJ5JsZgSztfICKbr0SyJZh1ioNFrMuEMtWB6iyMOGEM6tEUdEV0evF79yC0uk/ztUyfh1OSZWzOleDyGNSVoyxJZa0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706152073; c=relaxed/simple;
	bh=xZh8IzeZseeBgP8TCLKsPYqUdj6C6C0tzzuT56y5lGg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ubhOcT1gdSgIssyTOW3z2VuES57QAnrWidoR4L/Tm6GQSFlj/HxHG3/6GfWqnsy/yB8pfhk39Yns0xnLkJwE656Gbyl8cFLqLBDEksFY58BVczM9RMDp6akR9XkRk5JAyWZNAci8TF7FLImEBDOE8OVsoAP6rDdV5ZS3IGDAJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTK0ORbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTK0ORbO"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F163CC433C7
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 03:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706152073;
	bh=xZh8IzeZseeBgP8TCLKsPYqUdj6C6C0tzzuT56y5lGg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dTK0ORbOn377y68e1jEDi/YwhAdsLQ1MCw3iFk8JLvOONelLPDV3EVM+6yFsFcC9s
	 5b7r7V4rren2qaYYSFnCvr+i7cySAPlp9hJgWJtKdKQXofa2qdqdsDymZmZYHRllxE
	 3bGQEucO3Se/nsvQrGh803+srOEVTxBoI+XnIGcTMywb/gM6U0iQ9uKo9VcnNQZviE
	 +x/XoQ0UO5DGpZ4LI32HCLAYD65do1+ZAcflQqB1AIXTiYSk/tfjUkz+72uPl2irUj
	 IiSIIjYj79iBZsEuapaawZFyO3KA99jeKkcW1ET7sGj+ylIiC1zSn6O/nJBcAMbRSs
	 x9o96k15pF9qw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E14B2C4332E; Thu, 25 Jan 2024 03:07:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 25 Jan 2024 03:07:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-XEJsD7WOAG@https.bugzilla.kernel.org/>
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

--- Comment #59 from Sagar (sagar.biradar@microchip.com) ---
I have duplicated the issue locally and we are able to see the issue
consistently.
I am currently debugging the issue. I will keep posting the updates.

Thank you

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
