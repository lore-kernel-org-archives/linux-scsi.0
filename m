Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE534F3931;
	Thu, 17 Sep 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663699; cv=none; b=VDyY4ofZIte9qCX/W8xMq2Tv5JzFGVjC0oYr6Y12V1S/ijXXarKVf4vvatgnzPEiaKHAK0SisX4AhzNm6Uq3gFJLwLHoPHJejOvIk2BogNPAjRoLne/Ma2WOnBzgXgPAPbFDvvz0432yNcN+41LP4wBpWNILKNTz68WRjBRSnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663699; c=relaxed/simple;
	bh=uRDxUsoUx/5GBEtufJ3qz2htzusfPT9XjctbtT7XS+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hVZlaq41wkQiLXpEJ31YTbIJwzgkjQ2aoERomGCW2W6dPm9gy3uCcI0CMm71Yl066Ll4AfGskVZqSy4vV0yldn/5wHF6kCRum1no4H3CdZGlIa1WvZNdRiZ30XsW5r6D+n7p2NQ0TyHHNpYkq0p3HVDiov5XsJ6Jzj9WxW+Lx/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AdhXRDWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AdhXRDWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FB21F000FF;
	Thu, 17 Sep 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663697;
	bh=uRDxUsoUx/5GBEtufJ3qz2htzusfPT9XjctbtT7XS+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AdhXRDWEI8z8/VqFT8f1/Zb8gNtPvn8fEU5Hht+JlautNgX0zryQ2lqimxN8UfxEM
	 exVhz313nt4ajGoS6Cr+SJ2q/6iCDF/MrmyVSWv3uygMYy8i7qXTPSiSBHYzsGlz5U
	 n9s4VQPl1TcUFUqJsRy4sSDFoBwByv+koT3x+heWDR7Jnzfc1UwKQhpc3wA3zb7kr7
	 V2T1jAlIx2NrtZp/yFgz+utPHYEQWb0/JTyXxriYCDkE8Dtq1PpZjBMpB+X3JrPMQl
	 a5V65AGxRdwYrzsy9pkUT7/bDs5yc8HtamcrvgBV4TC7jOmaPyic0LB35EskMo6WDv
	 wbjZIs9XjZrog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] PCI: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>, "Rafael J. Wysocki" <rafael@kernel.org>, driver-core@lists.linux.dev, "Danilo
 Krummrich" <dakr@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, "Laurence Oberman" <loberman@redhat.com>, linux-kernel@vger.kernel.org, Maurizio <mlombard@redhat.com>, "John
 Meneghini" <jmeneghi@redhat.com>, kexec@lists.infradead.org, "Tarun Sahu" <tarunsahu@google.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, "John Garry" <john.g.garry@oracle.com>, "Jeremy
 Allison" <jallison@ciq.com>, linux-scsi@vger.kernel.org, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Bart Van Assche" <bvanassche@acm.org>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, "Ewan Milne" <emilne@redhat.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pasha Tatashin" <tatashin@google.com>
In-Reply-To: <20260917163744.191748-9-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-9-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:48:16 +0000
Message-Id: <20260917164816.B3FB21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Like its async suspend support, allow PCI device shutdown to be performed
> asynchronously to reduce shutdown time.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D8

