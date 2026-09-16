Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1671C400967
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586911; cv=none; b=GFkm8tIz2pGQNpJhsBR4Vf90/Ta0GmSb2Xn4YUz0MqrjeP9jfOD76XLimY1ASg3RHhNoA3P9ahxgd5S/x2RaFg5yDfrFt3Sc54aCZiELChB6RDNNa5u21v/QE+l2q3IpkSLFDeqthrugYB8YYhMSK4xeI4rlGD37hN00FGE4xcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586911; c=relaxed/simple;
	bh=ZIUhuE4tylgO2iwyn9Gr1i3wOEiBYE4QkEApuhvKrYY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S9KpN8fx8Y1di39xXKBAr1jKVdET9fBLlKwYFnIPKPkQCJIxUx8nhnOJthjDAkMfoo/C9gRfaHHi5+ZhNQRi6LG0pgDn/APqR7eF7/WhNmdHyJ0skI+oweM9Twf2IK4LR8nmPZmd611AhDZjmm/fwj9Eu+gDpzd8lnJHwzT1QkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1ZKuC20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1ZKuC20"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7532C2BCFB
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789586909;
	bh=ZIUhuE4tylgO2iwyn9Gr1i3wOEiBYE4QkEApuhvKrYY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=C1ZKuC20B7EOug19ZPi5OZ//Yq0ScT4bRyDHB4yJm8hbO7tkAmXOgJoXVtDZRWtGB
	 VpLDMTE1lZJL3kU+4+LAZfvEHKNcas2dr/n4LSP+BL/7r4+13hSrfYJGBhgkIH4hLL
	 jS/0B2c3WlNai+g16XkB3uPCZbSnsTuk5hgSN6KFiIOjEy6b2xDgwYVWoZzlb5PrUT
	 BQ9NhpDZVekFvAc30DNC+N5XhlWq4In4WpfXwhe+JpvvzjUIhmdWuurDAg+bXR6mys
	 H6TmBEIpa/KNkfl3ZTuc6MfnTAf3BWH3z/Jo6CBOZmgGHhUco3M6Lg7GCd25dG9f3Y
	 3pq7A8Ks/jcJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9F354C53BC5; Wed, 16 Sep 2026 19:28:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Wed, 16 Sep 2026 19:28:29 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit component version assigned_to
 product
Message-ID: <bug-222016-11613-YRPe3mAY9Y@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |694e1b6aabe4cd359b42c44b54c
                   |                            |409c3147b6020
          Component|Kernel                      |SCSI
            Version|unspecified                 |2.5
           Assignee|linux-kernel@kernel-bugs.ke |linux-scsi@vger.kernel.org
                   |rnel.org                    |
            Product|Linux                       |IO/Storage

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
