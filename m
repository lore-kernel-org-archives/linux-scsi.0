Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C14436
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 07:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719042545; cv=none; b=eMCAZ2j8ZUR+J0cncGUbZandiIbKfPzu0Jpv7fksiZQj0OHxpDZ+2txnSfl5EARa8p5lQgDb34vYXpP766TJENRyvDQCtgvKJno9HUffYpJRq2ERr0pbDqckzWIeX9uTAZ8gnu/w5dt0dQLyIWmMdOpr4WWiuRCv6uJw7e1ssws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719042545; c=relaxed/simple;
	bh=6VCT9Q5SnjJe/m6bSSeHE+94bTQMpQ4JkeHjMvPdo34=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xv/er2tj68OC/ya5e1MW4j8XnKCcM8YDgqPHr39qLsp2oZ3GQVTdtp9Mz/Yug365EKx57YJzZnIh0ZhCv3SekVKxb2LZeya5YmXiw08aGT0dBMCotCVwmm8+rLpwIklnvT18PyU8f89/hLPigogupBxj/ma8aoYqqJ4TaqovEEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FueiqecT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FueiqecT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33486C32781
	for <linux-scsi@vger.kernel.org>; Sat, 22 Jun 2024 07:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719042545;
	bh=6VCT9Q5SnjJe/m6bSSeHE+94bTQMpQ4JkeHjMvPdo34=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FueiqecTduBncIgsYabDU5weSRXaRRpnMOTutll8Kjx6h2tw9kbKs1ckQKHHq51ku
	 m0asJnFs+3NXOeVBdzclB8EAi530pzH5dVU7TxC/UknrYPWl3Nb5vK2SjiO+xJlL82
	 JDx6UgINPU5fLa0WRlj0sj1G9wf4u2kkzMtQzVd3/5gdnnlIQ+Lo6ChRs8AsvjGD8o
	 AfFuwkOGU0wBtfA0O9njSoYvepP3qKuLArnp6tP4W4abF4zPvN9xkAtLIGZL8i94Op
	 g1+JtRvS/rbj+a367+I4lIk29UxzT0PhVAgqzw73KeqGG0rWbS1XOsUekr2T3AMyVS
	 YvifRvfpAOaHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 28642C53BA7; Sat, 22 Jun 2024 07:49:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid when more than
 15 partitions
Date: Sat, 22 Jun 2024 07:49:04 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-218866-11613-pdjU4tGsWN@https.bugzilla.kernel.org/>
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

Marc Debruyne (marc_debruyne@telenet.be) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Extra /dev/sd.. entries for |Extra /dev/sd.. entries for
                   |a fake raid on Z10PE-D16 WS |a fake raid when more than
                   |motherboard.                |15 partitions

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
