Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A6C51A135;
	Thu, 17 Sep 2026 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663650; cv=none; b=op0xPG6Q9DoOiozdqUF+bXaLXwqBfdofLyN1iQ6X0PKtC1n1tT25KytWR7VC17eVy7+/kXRsW1CjeHHgGbLyMy2twpvHD4jnGtiTFrC09TMzhlRE6l0Obt8R/UeysWEQlm1aITGOvdatTEvNaMb/5RL2kZuALRvUxUuiuss1qPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663650; c=relaxed/simple;
	bh=6yFF79F5pQkgMedudQVjJc80KoLUU5S3vMNtZZ0tn1M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uFTcvyhTWG/GAUCYg8bHHrTbw3R5A5ZLLS0oj7GnY5gIN7Jx8mI5rgz/Lb2B/u4P4xMAmfLPZBCJgBl8vArpTOO+LewvPVpC1Rn4Q/rerlYEQ7uTez7cUsyVPZrej5o+KLrqLarXWQXRuCcw1diFW/9ak1dDzqfr5dqAG1+hDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFidRq4c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFidRq4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4481F000FF;
	Thu, 17 Sep 2026 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663648;
	bh=6yFF79F5pQkgMedudQVjJc80KoLUU5S3vMNtZZ0tn1M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OFidRq4co7W/H4Q0PKxuKIDlbFLlFG4EOXi0FBxtNdm5DxmCLDlC1qroW1vy6HFlK
	 6T98+/Ok2N0TlOBnQor2u4TRrCt6bIMfVoC7ssd8Z7BdWBvVAnP+VpPXjKIMvsb8bx
	 52qI60Xn2w+0bWMxkvfYILOzj6gS26Y9+aNCYJ1yA7aBePmOYUC/Siah6LOe80j4q2
	 wAEco4ALy5CtxFCaQpQjw/T1m/s6py1rAty3kkZs/V1+UuikPq/p0VSKwqPLjUOyal
	 E/YRAtHW12iVoWT6HgDemLlvqw0yoy9nGTsQaBhQMmCAb2f/wciXEDMmFmmYIJjb9y
	 fnhXmmI8QIumg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] driver core: async device shutdown infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, driver-core@lists.linux.dev, "David
 Jeffery" <djeffery@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "Bjorn Helgaas" <helgaas@kernel.org>, "Ewan
 Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, Maurizio <mlombard@redhat.com>, "Bart
 Van Assche" <bvanassche@acm.org>, kexec@lists.infradead.org, linux-pci@vger.kernel.org, "Laurence
 Oberman" <loberman@redhat.com>, "Jeremy Allison" <jallison@ciq.com>, "Pasha
 Tatashin" <tatashin@google.com>, linux-kernel@vger.kernel.org, "John Garry" <john.g.garry@oracle.com>, "Tarun
 Sahu" <tarunsahu@google.com>, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "John
 Meneghini" <jmeneghi@redhat.com>
In-Reply-To: <20260917163744.191748-7-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-7-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:47:27 +0000
Message-Id: <20260917164727.DE4481F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for the=
ir
> dependencies to shutdown before executing their shutdown routine.
>=20
> Sync shutdown devices are shut down one at a time and will only wait for =
an
> async shutdown device if the async device is a dependency.
>=20
> Enabled by default, async shutdown can be explicitly enabled or disabled
> by using the kernel parameter "core.async_shutdown=3D<bool>"
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D6

