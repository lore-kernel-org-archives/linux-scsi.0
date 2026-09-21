Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73FB134CCF
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 04:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789964460; cv=none; b=rgwTtidpXYMPJKfZl3avm+brU8BUuQ9lXW/sKU82sFk7UP/qshse6jfKAYq3UAl8s6oT406S8HfXjD7HyXLMQ4oshLfds0Wtg1V4lhfpCpUqV0C8ucSPKy2dUHh1FyVhK/xBCkhey0H0na7KKoe2qHqSKeIzy8s1eahXrCvqTJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789964460; c=relaxed/simple;
	bh=amEnaV0OSI79qzBOfi2/z/C1LH4OXDVo2HShQVEzuKM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DpH8DF5lej1ioCuZFUWvsEFoq0rLmDsLCWC5+DMTGe/X4FM/25umo6qhtGBcx/pYS/4Y298s5NG85HqVem7RTUMB9P8sAHZd046iqgDCwM1Zd2temh4FF+Io9AGKRr9snmNeYgjptnbXe1hMT2mwEquAsA8oYY9FFOHhI77BY+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fee92qWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fee92qWc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6739DC2BCF7
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 04:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789964460;
	bh=amEnaV0OSI79qzBOfi2/z/C1LH4OXDVo2HShQVEzuKM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fee92qWcehWbrvfeGatqYVUqOqnfOOAH605aDL6NYTPWKUj8GoPAfUo6I35HerlCp
	 5KBnv8QaGWq2rXsJDLhSvAilsJ4kMzGM55mToUyCD6cFxjYmvgLbJLZkhfOICmpxh3
	 yd1UqxTneKV2gJBc97Mr14/O5CeLcDG0yf3izHHssTdI9i6ZVeO13de7Z5hcdwlsvY
	 tvp0BJiPLiSy2C15hSIrb3gXM2EpHC2Bt25pdd+ReGqs4T9BLr8Mh5+3ody6F7cYAb
	 J7fwRX62uzcH7yp/05/GNHnXyilbs1NzBzmDjwfdhbb4ni4MLRYvaYcUkkjBiCjK26
	 4C23zvvDIun5A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 572CAC53BC5; Mon, 21 Sep 2026 04:21:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 21 Sep 2026 04:20:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lindabonds836@hotmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-198923-11613-cgBUG8T5BN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

--- Comment #23 from Anne C. Flores (lindabonds836@hotmail.com) ---
This is an interesting issue to follow, especially because kernel problems =
like
this can depend on specific hardware and system configurations. The additio=
nal
details in the discussion are useful for narrowing down the cause and
understanding whether the problem is related to the kernel itself or the
surrounding setup. Hopefully, the information shared here can help lead to a
reliable fix. After all the technical troubleshooting,
https://geometrydashs.com is a fun way to take a short break with fast-paced
levels and challenging obstacles.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
