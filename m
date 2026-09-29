Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228BB4E2F2F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717400; cv=none; b=YMyGEOCqykz4+0Xf+8JwBHRvMw1wSS4D8/ENqN+R0zNaC8e+10HpJPSKY4yW9/DO4CDIuNDeQocdMP2hh6eJE1h/K0p0KLAmj1TRA3cL/D7DmXRiPCOP9tRYgzS2v2jv1nVTxwN/XckUAJvUoeRHkMKsfKl8sTtrFutEX1bDmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717400; c=relaxed/simple;
	bh=+nz86y4EBXn/ZcxIZUQlTjzui3YrrYRmrUGwHvrIEIo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kXv6sMQdRCye56/if00xK4Fz93+hTjQqYt9cusWWDHDiVuknWGoZ2xansesVV1Bq/pIgBE2Sr8iTwACehfVQeMMWQNZIlMN/tzzpFFv7efgyJEAg6cBjn6rbiAzWmaD+D3+YJa3TMbGQJ059J60ouEzXzn9DBDGG5w1DtbK26qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpFhrT3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpFhrT3n"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88F56C4AF16
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 21:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790717399;
	bh=+nz86y4EBXn/ZcxIZUQlTjzui3YrrYRmrUGwHvrIEIo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hpFhrT3nvJ3yLFq4U9SgVWs8tnscdodR+F+VmmMmVGmexoWbVeDz8GlmfyMC2YKyD
	 BAas0Nxe8BQj2sTS+o92Om09aAzmu8zKKxk8CbIvB/a33CtAWQcy83u/prbLf4I6oF
	 tGRlqdnpMzH2HD6gKLxOCtcRy2JpcjVINdb3TZtCtArHEzQuWKAbdVPVXHemMB0eew
	 SYa4Pkh0MRJSngTSHUFCUp7nCn88Cpn6tZ38oXMyUl0/yEOWCHdHfACWQ1YX2OgLQ3
	 EmCMj0Nl2W76RAvoJ+S0H7brp+3WuINe/DcCvtYSVmt5q7egFxTSaoLkyfMB2fcvxn
	 H79UnzDsFNvFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 700A6C433E1; Tue, 29 Sep 2026 21:29:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Tue, 29 Sep 2026 21:29:59 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: richard@aaazen.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222016-11613-kLv0SeLbK0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222016-11613@https.bugzilla.kernel.org/>
References: <bug-222016-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222016

--- Comment #20 from Richard Narron (richard@aaazen.com) ---
I "fixed" the error in 5.15.221 by replacing the full drivers/scsi/ directo=
ry
with the old directory from 5.15.220.

So I know that the bug is in the drivers/scsi directory...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
