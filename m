Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDE93C3F51;
	Thu, 17 Sep 2026 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663524; cv=none; b=G8kzsbC4YMo21bt65PpFOvaHvSJTL6gbYfFrwDyDN2j7N93tKW8IIIBrUXK3qBp40eLHNxwEU2uT2TTZO7d5R1rXQU3O/i1Czs6GXX/eCanp/J8AVO15w1Z7w4z45k/rDkvDOu58VW6Ftjw17VNCYu2fwdkiPZNH5z3CwmqJoys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663524; c=relaxed/simple;
	bh=1q/kOx6JG2vi/MQ8HOsXmPagpC3QttyiydLa7Cv1w8I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eEHvjKgrgO2Cf+u+QdoQb/JTh2mVt8o1ZNpp2ZRgrQghvbe5pVoanLaNc2+pqYsGzA8LrKiH7gPRrYSpt6AyjsfSQyD7Fvwr3VGOqiNCaFa+q3T7EPxZJAyFZ3sZ8QMKLO+hP61hu8QQleDdku5y8F3AXjzXz630oEyHz/ZXE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnX54qJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnX54qJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CAF1F000FF;
	Thu, 17 Sep 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663522;
	bh=1q/kOx6JG2vi/MQ8HOsXmPagpC3QttyiydLa7Cv1w8I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FnX54qJmdlzA0+fG/aSGjWc+9heDNZv9Qk1jL7SFsUwrHAYkYvUqn27SRFXmpzLyo
	 p3OUj2/FSCaLev4hq6yPXmVyd1qb5Rtl+q8CJocgB8w0cv+Kz4U1F98GS/pNTsEu4r
	 ch4Xze6uGFWzYO1Qa9LNt/VYed0bI0KAGa2btYSM7l5czbM6fiNY+EY+LeByAWVsNR
	 cYXvHWKJFLcsuC9upvj28mBvt9OtjK4kRBMxeF9gQxcNdIplVit0ayoFZEcWn4/FFV
	 WtFi3rUAv0hNLTQfm6j+EbdAtcwYtchxBz/CUE8Dr5dO4Gwj7zuM/I/rVppMuTuRhp
	 l6OYL8rGdcHMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] driver core: rely on put_device to free dev->p
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, driver-core@lists.linux.dev
Cc: "John Meneghini" <jmeneghi@redhat.com>, "Laurence Oberman" <loberman@redhat.com>, "Pasha
 Tatashin" <tatashin@google.com>, linux-pci@vger.kernel.org, "Stuart Hayes" <stuart.w.hayes@gmail.com>, "Ewan
 Milne" <emilne@redhat.com>, kexec@lists.infradead.org, Maurizio <mlombard@redhat.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "John
 Garry" <john.g.garry@oracle.com>, "Jeremy Allison" <jallison@ciq.com>, "Bart
 Van Assche" <bvanassche@acm.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Tarun
 Sahu" <tarunsahu@google.com>
In-Reply-To: <20260917163744.191748-2-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
 <20260917163744.191748-2-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:45:20 +0000
Message-Id: <20260917164521.66CAF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: Tarun Sahu <tarunsahu@google.com>
>=20
> device_add allocate private_data for device and assigns to
> dev->p. If device_add fails in later steps of the function,
> it cleans up this dev->p which is not necessary because In
> the next call, put_device free it anyway (if reference to
> the device is 0 which will be unless someone concurrently
> get the reference to this device).
>=20
> This avoids unnecessary races introduced in system. After device
> is added in device_kset->list by device_add and later steps in the
> device_add function failures occur, it will free dev->p manually,
> while in between there might be a user of device_kset->list will
> take reference to the device just added by device_add. and might
> try to access dev->p. So relying on put_device to free dev->p
> prevents such problem.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163744.1917=
48-1-djeffery@redhat.com?part=3D1

