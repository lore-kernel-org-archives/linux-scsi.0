Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B641B6FBF
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726900291; cv=none; b=aVfWiJNj4MXfl38S5WcPLUhKqY8iTBMHaXFsfzuNmcmlWAUraPnpok/QVctHy/xFD5A2NXdzH6ieyleZGgaQo395Oc07H9hEpGLfqGj2o/oHgvWZTdBcf2jxFJYEHAblfqHMDmyRPW7frLf55bNBFpK1yZk12bF//NX0xiC8QbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726900291; c=relaxed/simple;
	bh=zp5wFHtycJNZ/K2gU6dmddfO7Cx+lzvHGiViRUBtuu8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NKWKDgWuKyJFSnwRbEQnnO5jutFpX7FM56/EAMM01QXmMk0AhNJEf/Ri/VzHPgDoNengXp7ZmKqUofrQ1YxlpQbVs3NzE3POYkH1/69/cj3VZily/RJ2fXt12cP+3HAlT98EY9Pyes3x9Re00ccgcctfUNcXiEiP4xV5YFRdGZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1Eje5nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1Eje5nj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E5CEC4CEC6
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 06:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726900291;
	bh=zp5wFHtycJNZ/K2gU6dmddfO7Cx+lzvHGiViRUBtuu8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=W1Eje5njx9F7CKHB6VyFdyCUsO3kDYCU10KKg85FOTGAwJ9kwkp/uVLrYjQZk6/sP
	 X/XMdRrJJhmZiEa5YPxiy7NxMvIP4YAwEAAH5Y6iCivWd3TiD2bu+/4TqEDXNo/vld
	 go4UgFxK/8BuzYZmFuIfacbL+fwv5/1OXJRekpVoVW4nUbOuvLEck48jlwNipsVJ1L
	 cnputFnPBZUvwyXyaTplhg+UavYL0JmmVgKH4K25mVZ2UOm21be0ZUKBbSeZoUGVhQ
	 tLTtdr7VIeeAR5iENpEQVi7OvqrDHOyEjR3oM6lKF/Co4n6PR5/y/xjPuu/UBrwJku
	 iJM+vorSs+6yg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 25523C53BB8; Sat, 21 Sep 2024 06:31:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 06:31:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linuxcdeveloper@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219296-11613-lIT9pWSKoR@https.bugzilla.kernel.org/>
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

--- Comment #2 from linuxcdeveloper@gmail.com ---
Created attachment 306907
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306907&action=3Dedit
dmesg from last good commit 3cc2ffe5c16dc65dfac354bc5b5bc98d3b397567

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
