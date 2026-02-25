Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4B30FF1D
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061818; cv=none; b=g/Pp+GB7nYOKvEPiEQWhiNx9d3qgeaTsKX5V2Qzia3UV/MG1OrKYjOzDgh7epNKIBVe2FrGFWg6GPnOYIORDAGpfcMkqAfpyVc1uYIWoxyD8x2uq3snhhUXZ94RfN3+yHINVvUhOM9tR0PCs60/trtp8aIYotrV/AdFoFVEPBzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061818; c=relaxed/simple;
	bh=sw1FqPnzIILwO37vyKUSCm8Mt4HkxY0KQtwh/RF0QL0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rLylqZ1gcqyS2oWSwan9yFsfprQeBl3tGmpwSXxKlBVBV1wKUo1xdKEToR8axyGg4AYrT6sOKD7k7IFVhp0yxfNHNWL9gP9teLjWpXwbYsNw4Bjdo+229kgorS4H4uLq7OHnMeI620d5mqwiNaeqoPRdccRKDi0YISjQjmBNZCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edgRvLjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edgRvLjD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F19CC2BC87
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772061818;
	bh=sw1FqPnzIILwO37vyKUSCm8Mt4HkxY0KQtwh/RF0QL0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=edgRvLjD3KQqVI2Je4zvpqpy7vZ1YNsaNmxqr6aPTHpkNU+0V+DTbSP/VMY4RvrcN
	 9ezaBH3lKAILxiIXCLOKSs93b6kTu7BgoV5EU6BYYSY12n/ycdsXJODQcCLtyJ1qh3
	 BBfbFinZd1hRq3Dk4/G+cV0T5wdCD/RV5iQoAjOWo8nEYT4Mnc0RX4LEOZnAJBuuCp
	 H6MCtdEaRhsdoEHQUcP4F56ZVbind7n0VxavQaZPbEkWYIi/6ceH5dZFe/bYPCcawW
	 IZjC/OP2YY8NjmTxSFIr+YNlfRp2kysReY4qOQ3PbeISKPIZ1Iak9SgTxBxVg7DJxx
	 Zj143QGT7H0Qw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 66792CAB782; Wed, 25 Feb 2026 23:23:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date: Wed, 25 Feb 2026 23:23:38 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216696-11613-ZOHASSVnN5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216696-11613@https.bugzilla.kernel.org/>
References: <bug-216696-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

--- Comment #7 from Kamil Kaminski (kylek389@gmail.com) ---
Patches submitted:
https://lore.kernel.org/linux-scsi/e1b5a5e3-7700-4799-affa-510b4be7d120@gma=
il.com/T/#u
https://lore.kernel.org/linux-scsi/786c3713-ebd7-406a-bb93-ce43e249583d@gma=
il.com/T/#u
https://lore.kernel.org/linux-scsi/293e4493-023b-415f-b2b0-0fe3cdfe7149@gma=
il.com/T/#u

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
