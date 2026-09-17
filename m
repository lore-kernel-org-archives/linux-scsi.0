Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2C44F6481;
	Thu, 17 Sep 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663261; cv=none; b=a1TNphTwQpa+MuXZiA0Gjfvm4uCfw9rQ3sBvgOXnFWY/b9z/ulNbP85AbTD+tVkC0Nt7yhladvYdFwSC5waMH786UVBEl4Gw0pEwUTsTBp968fECwqKPFIErHnvM45rX+A8sfYyIkwllvmB/mQO7aLRbpdkr8J4zel7Xx4SJohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663261; c=relaxed/simple;
	bh=k/T7NeZIUiiBel/H/7gf9tYiIQu+YMUIhK6ECahuxrc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FpZWgvhQyySdx0AUeX/bSJd/1QNUGLB8N9OirvWzL9gCXlVsilB4MbmS9rQFoc6h+1fHnNx7EiVuW22jHA2TeSaAbNK2usugLI3JIMHQOmh/IBJbkcSXAP0eRtl3+6cGWt2cEkNxBFpOBVjC7ZTA06d8NF3Mivnrzr5V1iIw768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eoj1iJeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eoj1iJeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0E01F00893;
	Thu, 17 Sep 2026 16:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663259;
	bh=XMjDv8CpcRrCSJyVd2NGEOOV+eyxF8EAwstFN3OJlJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Eoj1iJehmTUI+pYMU2YQiTzGwVf2Ghrp3dVDRhASfh1ESKqEES/TarfmI4P6fsvky
	 e44Qo2d0uhFAmIsyjcZWAD46AQt+UquhRdROS+M1SB7OrjFhBZEyEnUf+8NcpWVl89
	 CpenrUCAZ8ug73kapz5VEzPobPHuCXXUYmiFnqoC94G6nkfNDAnlb9uMgq3IvdFsWM
	 N2vWKcrmRxF7kzNA5rPhKihJ8onxPH3xHUr0I7/9Klowr4sGYvKziC9O+CUOI7Qh2r
	 1OtJXYFvrCgQFiYA8TxN1daEnvIe0KzInP3ox7S0lQmka1pL4i/csSd0+D37AfCORP
	 8QJZ85E+fvFdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] driver core: separate function to shutdown one
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rafael J. Wysocki" <rafael@kernel.org>, driver-core@lists.linux.dev, "Danilo
 Krummrich" <dakr@kernel.org>, "David Jeffery" <djeffery@redhat.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "Laurence Oberman" <loberman@redhat.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, Maurizio <mlombard@redhat.com>, linux-scsi@vger.kernel.org, "Bjorn
 Helgaas" <helgaas@kernel.org>, kexec@lists.infradead.org, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "John
 Meneghini" <jmeneghi@redhat.com>, "Tarun Sahu" <tarunsahu@google.com>, "Ewan
 Milne" <emilne@redhat.com>, "Bart Van Assche" <bvanassche@acm.org>, "John
 Garry" <john.g.garry@oracle.com>, "Jeremy Allison" <jallison@ciq.com>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, "Pasha Tatashin" <tatashin@google.com>, linux-pci@vger.kernel.org
In-Reply-To: <20260917163744.191748-5-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-5-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:40:58 +0000
Message-Id: <20260917164059.1F0E01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make a separate function for the part of device_shutdown() that does the
> shutown for a single device.  This is in preparation for making device
> shutdown asynchronous.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D4

