Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907825208C4;
	Thu, 17 Sep 2026 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663677; cv=none; b=mKdEdwHCYD+mGAOcpZE3O7Dk6WVyscRf+1ZAGLLdttLy5vhb7l8fidE+sHnHSkWr0bTpRaeGgk1qtLY9IUbVYLP63C6j9x4J3v/T2mNJDsrWK+F887JyId+FOvDuwGSntD4X8fZ5vQeCsMb4MCCmG/jLH8IEzD+QsWmWJxLKA7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663677; c=relaxed/simple;
	bh=LAxtjYEua4plusINVTHcMgxVKXWmoP1/pA9iq8tgzLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BmtTwGi/WzhTxlGPlVpgiEPhRZ4Xd7MsqHirsUM0ARULUpw5JJCArYFuLtENlh0XdzICEcjRShVDNMSAsAfvWD+Ei48og/7jIlilSa6u6WH2I/ZZc+YbjHrpsc6+je3aDequa9FJI42oIQe29gywr/uzAPVlwByT5DrWoucmam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTitcEIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTitcEIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3566C1F00893;
	Thu, 17 Sep 2026 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663676;
	bh=LAxtjYEua4plusINVTHcMgxVKXWmoP1/pA9iq8tgzLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nTitcEIWbzlk+odPQnUeF0nJT6d5yWSXoqf8KNtrfF7Wtkxu5OSj8RUQdw61PuRgp
	 IGYQ3h+rYgG17SJbxNWCOVMhLGJUdCuxI8FuU0Vt5UQO22rxZJxgBBZCVxJmFhlT5r
	 cxi7DBGLJv681mS5YesTDO5zvdKjf2SB9C4Ez8p7h5uJ2KAeyAnFWEXhypXXy4rQeh
	 GaMUcctlOEyWUpd/EfPmiQX5fVrEKaNY8ChfrNau4xL1n1BKYiLbw7YCGSslZK1556
	 z0np5252lOVT/84rVd2yStnO8p0SomjB87tVT1h2TIoc+0sjjMseKtgdyB4MxwLWBe
	 8HQcdSOR/zT/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] driver core: warn should device_move try to move a
 need_parent_lock device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rafael J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "David Jeffery" <djeffery@redhat.com>, driver-core@lists.linux.dev
Cc: linux-pci@vger.kernel.org, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "Laurence
 Oberman" <loberman@redhat.com>, "John Meneghini" <jmeneghi@redhat.com>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, "Pasha Tatashin" <tatashin@google.com>, "Ewan
 Milne" <emilne@redhat.com>, "John Garry" <john.g.garry@oracle.com>, "Bart
 Van Assche" <bvanassche@acm.org>, "Tarun Sahu" <tarunsahu@google.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, Maurizio <mlombard@redhat.com>, "Jeremy
 Allison" <jallison@ciq.com>, linux-scsi@vger.kernel.org, "Bjorn Helgaas" <helgaas@kernel.org>
In-Reply-To: <20260917163744.191748-4-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-4-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:47:54 +0000
Message-Id: <20260917164755.3566C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently, no device has need_parent_lock set and is moved by
> device_move. need_parent_lock is only set by the usb bus and very
> few device types ever use device_move.
>=20
> Add a warning to device_move to catch should it ever be used on a
> device with need_parent_lock set. The combination would break
> the immutable relationship needed between parent and child for
> need_parent_lock when locking and unlocking both.
>=20
> Suggested-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D3

