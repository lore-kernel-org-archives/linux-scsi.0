Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5423AB496;
	Tue,  8 Sep 2026 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899084; cv=none; b=E3lVN41SdQq0lAzJeoJvL+gb7v4HIHNghzRwqANjLkmxdlsBB63qWSnIGwJ1WiYTP0ofZXWAbVuZposO9nJKDxG2sV5NXA+dNP1mpftHZYUYUIErz/LYOFybhNAvJ4Z+jRHoUA/S/gDQFyERQpEkh/L7P8u5IKwGf6p+hMUAN0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899084; c=relaxed/simple;
	bh=zCUwPL2YAtqeA5bpsElIHpazJ3kO727+A7o8s71Gg4Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YXQzXgILnxHEJdt7wmA5MH2O3CpvN8OgAe/W3KQ7IcgNBj/+5wnYlDaKgnQPISsZqtemGoquqqhLtLU70l0ZNQznJonLHoF7ijDaQ+PUjad2u1REpb1O96Npt2wmIB1idvn1OXYdmPDVE2EQmSFGeNV9Kq6MlgRcAG6GewajVuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8dE784E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8dE784E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE81F00AC4;
	Tue,  8 Sep 2026 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899083;
	bh=zCUwPL2YAtqeA5bpsElIHpazJ3kO727+A7o8s71Gg4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K8dE784ETtgxXvs3DyUYH8sXrEex5IBb1Rmh0iAYxtKAr7XtRcAT0BvKqpRPa3CeS
	 hUv51alwzCFtmnJGrvnqNO/OBR+Oy7xPN72lJ8F2MHSsd/Imq9Z65zFckt4xNsEtze
	 qaW6mpkwCYAAeOH4lkF/I/3jOb1IdB/iLP6MfFjqVpKjggvjrAHx5oEKp6UIIAXpvZ
	 /grKrB/HqXyNF/Z33YSKoqjujIbJiL0rtgzuImwZOHz6TnMeVXVbhW5SNJUQqL9xam
	 0AnSvYIhjo6Gxte5iJCr09YSJZ3Ua317IMZkpLnGBj3+hKoP+RmKUQZB3/PXpaeeCH
	 ZfxCfFqkU0S7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/39] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-s390@vger.kernel.org, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-5-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-5-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:24:42 +0000
Message-Id: <20260908202442.77DE81F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> There's no reason to export the symbols for these functions which are only
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
>=20
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D5

