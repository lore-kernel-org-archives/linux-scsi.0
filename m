Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247A25372C4;
	Thu, 17 Sep 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666340; cv=none; b=jRFwaGR28qIK/YlWTLoEgHqu8MHkAWO/ngjgFbtVtF6bCxmqXHF5xGtcV+NNburEbBBiWKhilybVarZ0E1bTZtkNRRnNvbY/aMDdWj0TCSTzY1/uQXmlkuDMveF/a9+WwKvYegrQ6BQdAGiV741r+fxK6ZSwtdZ09yOIiThOp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666340; c=relaxed/simple;
	bh=8e5lPCnPfILQlY1CXCm5oem5W/gzCwK+SwdkuZ8N6tQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u0QvXDZA3SO+0kd6pbv9xEkFrwWJ7rVHjq9HJFYHBz/bgTjz0GNk72E2rObUs339k4J7M5qoNuTFgbEgEYRWtrnVEIdkZDOJjJQ5lNNugtpwy58kUqTYYjRY0xIdyYPlrLW8X4KflZqBi2BNW5Jleo5aAsVwqeq+T2ZjkNF425c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9MytrAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9MytrAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564781F00898;
	Thu, 17 Sep 2026 17:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666339;
	bh=8e5lPCnPfILQlY1CXCm5oem5W/gzCwK+SwdkuZ8N6tQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A9MytrAd0M82iRMpQnofhgO2Pilbhorygomfiqk5zIYcK2s5pICXhvrPYIAoSjpuF
	 wGIE6L/fT3hIMmx2H03s+R+c19al8DL9mQZ7FQapPXf1f5thtCMcJueagNiiOCyYIs
	 RhPKaBRGDF13xy26l8/BW/1lnCyfaH3tu8IoWv8atoCRNebPKBaaXE1wo2ZfrhIZ7R
	 dIqQhqNCk+yNYJsDjnIRFH3uMbmUVqc36U3hbp80JzaI/R+suda4RHbLwUzloKvBX4
	 L1nddFBZZKinwKp+7euqcDi7Nx5kSmBGUPSs9fX+fHryW5XIuMvgPS8OIrsozJs/uq
	 nLRpa9OVky9pg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 23/40] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-23-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-23-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:32:15 +0000
Message-Id: <20260917173216.564781F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently there's a confusing mess around VMA_LOCKED_BIT and
> VMA_LOCKONFAULT_BIT.
>=20
> It is permitted for drivers to set any flags they like, with the VMA
> already possessing lock flags.
>=20
> This results in the absurd situation of a VMA possessing both
> VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
>=20
> This has resulted in mlock_vma_folio() having a very silly check for this
> scenario to work around it.
>=20
> There is no need for this - just clear the flags before invoking the hook
> and reinstate them afterwards if they are required.
>=20
> Nothing relies upon this being set during the mmap operation.
>=20
> mmap_prepare is unaffected by this so requires no fix.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D23

