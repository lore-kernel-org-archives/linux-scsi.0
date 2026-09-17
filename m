Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128A151A152;
	Thu, 17 Sep 2026 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663623; cv=none; b=IQ3d+jab0gz9A5z3AtunHwZXaQQvOqxMC9TATpE5FFZbDZTAHBwq7jngz34awnSbQGQYDWvvworFiJBIkNpfdh48Uic6lf190BoaPWLjhd+Zk/9xoFFw6ll0NKWnLzcgYq93KX4mqv/gHPpLwfGQmg1MKEDxzxDQA/ZaIb8rZrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663623; c=relaxed/simple;
	bh=nwZX7LWzQDsEEXIexefLINRItEhTA6HQK2X5rc/lUKI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=neEo9xbxB9XpUaAn9PIDa/j9TNYKdu4gk+BKfa6JJnSgffEhYYgPbUXpBMU1J0IEtFxIzyUnu0G4NY7t389ScYQmbTsc/9f4XDg4JBlUJGglnyUKr5ZPc2XdiKg73PX/7lL/VihL7zlEflS/nOUfb0ep611T9ifWzE5oa6kfn30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jO4cnVCX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jO4cnVCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6852F1F00893;
	Thu, 17 Sep 2026 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663621;
	bh=nwZX7LWzQDsEEXIexefLINRItEhTA6HQK2X5rc/lUKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jO4cnVCXs6364LMIAKfAUTkkpQ/ZJl4eupKU4kZxpG5EKTCoUC0n96E5Ode5UKXAL
	 qSCPRJQPgpDOHFpl6f53lvAjtGv/wzvYrggEbT5zfed2dDbegqNMwEjjkgyhyrJOhP
	 GJGIjxddTA/sk1yMtpOsl9nVXjFL6+0oMbEYZiLUThqzOU5dOpoejybO3ODUPWscJf
	 dIQXhGFLTxAPpmSsa4njcyf1F/cusnb0PdLrNWlO6SuTWklUqIBJMHuL9icZsn2Kvn
	 MRDOOr/CCGLOMWlEUMWUcVIrf4txmj/rOIv1PzYiXfLp+/1mK1635wy/6ekuxTGpCG
	 deSL9crvUHy0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] driver core: do not always lock parent in shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rafael J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "David
 Jeffery" <djeffery@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, driver-core@lists.linux.dev
Cc: "Laurence Oberman" <loberman@redhat.com>, "John Garry" <john.g.garry@oracle.com>, linux-pci@vger.kernel.org, "Stuart
 Hayes" <stuart.w.hayes@gmail.com>, "Jeremy Allison" <jallison@ciq.com>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, "Bjorn Helgaas" <helgaas@kernel.org>, linux-scsi@vger.kernel.org, kexec@lists.infradead.org, "Ewan
 Milne" <emilne@redhat.com>, "John Meneghini" <jmeneghi@redhat.com>, Maurizio <mlombard@redhat.com>, "Pasha
 Tatashin" <tatashin@google.com>, "Bart Van Assche" <bvanassche@acm.org>, linux-kernel@vger.kernel.org, "Tarun
 Sahu" <tarunsahu@google.com>
In-Reply-To: <20260917163744.191748-6-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-6-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:46:59 +0000
Message-Id: <20260917164700.6852F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Don't lock a parent device unless it is needed in device_shutdown. This
> is in preparation for making device shutdown asynchronous, when it will
> be needed to allow children of a common parent to shut down
> simultaneously.
>=20
> And only acquire a reference to the parent device if the parent is to be
> locked.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D5

