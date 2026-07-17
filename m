Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43736F91D;
	Fri, 17 Jul 2026 03:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258123; cv=none; b=UkwI4k4DMftT9a6g/hB7gvvooniRlD/GJTupA+JFzqIRdD87aSbxR8YHKkzbBQvRv01Rlhep3DQdCgmy1VL20ps6Lzd//ayC42v+jrSyLePy8Y2IA5SrjDsK1CFp6vYw+2b7ptcKPG4z9MrRMxr2FvVDZunThZiHfGMAPNf2yLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258123; c=relaxed/simple;
	bh=LmHWhM30dVAC+XqyEJjA88f+ljZR6hfFhRL21UzfAw0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r37tZDqKliwFA0XZp0rdyI8/I0dXCnc3WWW3qhSUyn/xbHyQtMKEgVgiDUn6T/5/1mbW45BlrnPulYH8E5FFSAjc9pdqD2ePL3cU2quMjyNjJV3FJ1xxbiq2l9v2nGuD3farN3ZXEnlW7c6wnveUK+sp+CokT4mAZT04wKUZKoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGYoiDxb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGYoiDxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACE21F000E9;
	Fri, 17 Jul 2026 03:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784258122;
	bh=LmHWhM30dVAC+XqyEJjA88f+ljZR6hfFhRL21UzfAw0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lGYoiDxbUOJwtxx0P+n2qZjZyRmrO8Mzx8jDm0CaaFe30m1G8BCU53PycA10HCgu0
	 3Xxj4S3BVqzp1O+AUiLJEWgULLVnYGuXOO+xRD+jmN3YA4KqOEH6vfYmYFJabDvo0C
	 ZudhylneqsvWeYJJwYL5NYEBnXuxkqv+WUEIuIbit6Plk9Sh3kJc4CrqIifSfcdPRY
	 o5qfD6oVsXsliejDe3q7wuxGbYwGw/jHbHNJuIXZeICuBr2XLrxDdoUlpGTB6jTsyq
	 V3ukqJ/2ukZsb+/f+Ds14qhLEHXis8MRZoINJ/Nl9hXbXLpVjPzqlABJIHkFrTpqNm
	 VvRztwZFYhluQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 2/7] driver core: Prevent device_add() during system
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260716230411.2767394-3-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-3-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 03:15:21 +0000
Message-Id: <20260717031522.3ACE21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In Async device shutdown, device_kset->list lock is released to handle
> asynchronisation and hold again to get entry from device_kset->list.
> Which will leave window when device_add can try to add the device to
> device_kset list and temper with ongoing shutdown process. New added
> device can be async type or sync type and might also introduce new
> dependency which can cause device_shutdown path to deadlock. S is
> waiting C to finish but C is never scheduled as it was added recently
> from device_add path. And C can only be scheduled when main loops
> continue to reach to C which is waiting on S.
>=20
> So, When a system enters shutdown (SYSTEM_HALT, SYSTEM_POWER_OFF, or
> SYSTEM_RESTART), new devices should not be allowed to be added.
> Adding system_state check (system_is_shutting_down()) to avoid
> device_add incase of these states of the system.
>=20
> While device_add() performs an initial check of system_is_shutting_down(),
> a race window exists between this initial check and kobject_add(),
> during which device_shutdown() may already be scanning devices_kset->list.
> If device_shutdown() passes the device after kobject_add() registers it
> onto devices_kset->list, device_add() would otherwise complete device
> initialization and driver matching, leaving an active device running
> after system shutdown finishes.
>=20
> Fix this TOCTOU race by re-checking system_is_shutting_down() under
> devices_kset->list_lock right after kobject_add().
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D2

