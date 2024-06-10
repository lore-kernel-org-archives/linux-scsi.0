Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8206139
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 06:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717999383; cv=none; b=jyjJq8aGeCNmyBlwOAZkwAnKXvLe37PU8CVOWw0h3HqkMaghCe13fjKbQZJrhYYsAiI+4ZzYKE3Ib0SM8uyQVzMzs4qprRc3yycj2VWBRqxkESMuaBByZo+J2998zd8MUvmYxtlXkYBI0N34ze0HcjApIV52A4H1oN3/m509hXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717999383; c=relaxed/simple;
	bh=oBI+h1birtKc3PfTs5wHyVtmSnswjw/oBLzxSJqEdyo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OanplxCSfVwPA6G7TNJL+XxIacXExZtqcYscCyMA9Ult6udpLmhFYB2zLLaCXGBBpzlbn0r4TcxJesVP2Kj8u2d+R7Km3JvfowdBj0dQTt8nEbg+HtEGeuaLK8V8KAKLnPZERsH6S18Q53vL2tik+ojpqRziCDg9AiZY64dHDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BguapyLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BguapyLO"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EE7FC4AF53
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 06:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717999382;
	bh=oBI+h1birtKc3PfTs5wHyVtmSnswjw/oBLzxSJqEdyo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BguapyLO29JPy5d0GfLNIIylZwaeVJQRRrgTZF7GsqR/NE0GASSlDwM/kU0PN5GnQ
	 92iVq+gdLkH8+W3nALPrMqEeha12ZXWV+9XhZ27Et0tZHGQ3zVwfGGczsbNgybbu3z
	 hjXlZu8gKqXaD0x8XVYCtXv8HnuqLsIVP5U2kW+6IlBnvDMeMh9Iec2QI7AVDG+PXH
	 M9bL+6K5VtuUB7WNxLRQfeqSlDlvkdM2MGrtr1/j5AV6Ce0LdjPxfR7ZYFY+0Z8D+5
	 1Xo3Mqmu7vqSoWTZJIMmDXJ2W06D8rxWMr8LLSu7W/5fuwIjzMAVhVSZD7UbPKh72t
	 u7/wpTDwCJv9A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 87CAEC53B73; Mon, 10 Jun 2024 06:03:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Mon, 10 Jun 2024 06:03:01 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: Sam.shahl37@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-60758-11613-CEfruTYogI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

Shah Samir (Sam.shahl37@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |Sam.shahl37@gmail.com

--- Comment #61 from Shah Samir (Sam.shahl37@gmail.com) ---
@jamie,

I too facing the same error, to look for the solution I tried to go to
http://git.kernel.org/cgit/boot/dracut/dracut.git/commit/?id=3Dfaa17f09218e=
d7e2ce4362cc2d9319f8d5b7a37f
but it seems that commit is bad or not available.

Can you help me out here?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
