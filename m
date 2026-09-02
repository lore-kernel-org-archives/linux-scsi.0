Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1B24AA3F1;
	Wed,  2 Sep 2026 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369309; cv=none; b=bp618E5AA6aLR9mrWLtNproeOU2JCFb0jAj6n+nyStdpNI41/oL9ERH7LCsOmxDiPqcW8hSjzGpnAUrzyvrcogET25xVkog5a+cFVRbMFCrNqnDVWxgqynI3tkR5RcYA9JVZ8unf/Nsm8qstZfmAeBY02YgCuVa8Vdxh1zApOt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369309; c=relaxed/simple;
	bh=gyzRRNKiER4sC+Q7Ep+ITx8hOBiZACbTB3GJVLcZIQ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lGFczPU4B+6w5mvmOwBq35CBJkN8LKUGSCMn007Vf9GMK51GgZFnDrqOGMQ+jx2b6j0LKOgd9dJBf8cm6I4LeqbxE93jYK2TXuFSCziFNlOtLqElcS06OWL2Dt7O68N8wKIGT4ThtAoy8WNbQvG5SxMhU6gXBeelDG0jwvWmwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jU9ykNpe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jU9ykNpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A341F000E9;
	Wed,  2 Sep 2026 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369307;
	bh=gyzRRNKiER4sC+Q7Ep+ITx8hOBiZACbTB3GJVLcZIQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jU9ykNpe+5VuXqYFMLB8PJvXmc/RXZsLGd1CiHUVRoUZh4uXv4JsLd9boj9cas3OI
	 h+upU7oCo6LCwB9E/u5cVyIDVxpnOLFabQmLYXOlVUwgRnJwxfT8VG+dHdlMRpUkpe
	 3DkWRqArbkub250OTS3eENSp7XyAqTUE8gT72NIcP1nWPn//5wTGQhNu0YJQQlhZW4
	 Dla12kSXLNUpjsVCAuxddR5Ajpdhex8DARnBPWAkK8P5Iv9bnb7OBtUtr2kkRgit5q
	 5JIqGSITnuJmnpiiRP6b5L97TbuLF5MnW1DIQt7OeLePye+qxBHERcQDv0RNLZYd5P
	 b2CCMKssRSdNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] driver core: prevent device_add() during system
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260902170734.95504-3-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-3-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:15:07 +0000
Message-Id: <20260902171507.60A341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: Tarun Sahu <tarunsahu@google.com>
>=20
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
> device_add incase of these states of the system. And use srcu so the
> device shutdown operation can synchronize device_add and ensure any
> device_add in progress is finished.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D2

