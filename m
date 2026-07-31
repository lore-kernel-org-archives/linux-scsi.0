Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C29C377AA7;
	Fri, 31 Jul 2026 20:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528731; cv=none; b=OpZbuSfaFPXipErN26z2rinnSE2pKKV/zlW+2x0JrLf4Q7qmlEvrDoodbvRu3KhdXaX29nFA5TGrB6GCqafcfjrzW88YvRSqT9VVKupcEpfwXL8fI7mVm2PSzWDlO9Xq8+w9gV9rQNz+L/Dscdy7L5xzjNk5yO6Kn6XS0paOmQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528731; c=relaxed/simple;
	bh=Vo5k4SZJPu0c5kG1Rz06ghvzCkV+zWupokB5JZhLLcw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Npad7xLfwMhd5sUag/+0W9vE2qFgWuONYKzAz+kjEN3AgOq6cki/IRsVhXLf4jinbaqBU3EDUA0D4raG0EaQGq1DmccKujRC2UI29ULqQOA9lICUPT4z3/pHzerM1eWnwIu7dbivcB36mLnl6+ry+kEDFwaKDk4yDhDQPERt5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lkjq4uTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lkjq4uTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF121F00ACA;
	Fri, 31 Jul 2026 20:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785528729;
	bh=Vo5k4SZJPu0c5kG1Rz06ghvzCkV+zWupokB5JZhLLcw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lkjq4uTditw7rnxEAFgzjIexEjqQFpGUi5SzfJmHPRXemF7nAkR1QB1PrU/9Qv8OW
	 FifChjXFdjgAGOI/V5iDpRpjZL48s/bY+ogKEG6IjHy1E6cvFHPB8fGZHgrYzQa/Pk
	 ndU0OnKlt83hlfw9k/+n3zcXbO5HrheeGZpPVUGs+nCug8gYjrMvSy0dlMAlLjqhRQ
	 wjfxFe83hN6sbLII6YGW/4cYxrIpP0eQjOvT+QRb0C0ekODwh/Wdbd8q+hwoFIGYm1
	 5CpBz4fNV23PKoMtMKa5DnoN+GXAQBpv85mwqYSHMhpYs64yi837yJ4jvhCRAZO6M6
	 I3oRyn8WT4gzA==
From: sashiko-bot@kernel.org
Subject: Re: [RESEND PATCH 1/6] Drivers: hv: Remove support for
 WS2012/2012R2 & Win8/8.1 version of Hyper-V
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Kelley" <mhkelley58@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260730201123.1767-2-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <20260730201123.1767-2-mhklinux@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 20:12:09 +0000
Message-Id: <20260731201209.6AF121F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Removing the VMBus protocol version check in `vmbus_initiate_unl=
oad` exposes a 100-second delay during kernel panics if the crash occurs wh=
ile VMBus is connecting.
- [Low] The removal of version fallback logic leaves unreachable dead code =
in `version_resp()` and renders the `next_version` field functionally obsol=
ete.
--

--- Patch [1]: [RESEND PATCH 1/6] Drivers: hv: Remove support for WS2012/20=
12R2 & Win8/8.1 version of Hyper-V ---
Note: The format of this review report has been altered to avoid quoting the
original patch code directly due to recitation restrictions. Instead of inl=
ine
comments, the findings are presented as a free-form summary below.

commit 4b263fe58a4438fc239eb817b339fbf77aa1ea23
Author: Michael Kelley <mhkelley58@gmail.com>

Drivers: hv: Remove support for WS2012/2012R2 & Win8/8.1 version of Hyper-V

This commit removes the legacy VMBus protocol negotiation and special cases
for Windows Server 2012/2012R2 and Windows 8/8.1, as these older versions of
Hyper-V are no longer officially supported. The balloon and snapshot drivers
are also updated to drop related version fallbacks.

[Severity: Low]
In drivers/hv/hv_balloon.c, the patch removes the version fallback logic but
appears to leave behind unreachable code in version_resp(). Since
balloon_probe() now initializes dm_device.next_version to 0, if the host
rejects the version, the check for (dm->next_version =3D=3D 0) in version_r=
esp()
will always evaluate to true.=20

Does this unconditionally jump to the version_error label, making the
subsequent code that prepares and sends a fallback request completely
unreachable?

Additionally, does this change render the next_version field in struct
hv_dynmem_device functionally obsolete, since it is now only ever assigned =
0?

[Severity: Medium]
In drivers/hv/channel_mgmt.c, the removal of the VMBus protocol version che=
ck
in vmbus_initiate_unload() seems to expose a potential issue during kernel
panics.

Previously, the check for vmbus_proto_version < VERSION_WIN8_1 would shield
unnegotiated connections (where vmbus_proto_version is still 0) from enteri=
ng
the unload wait loop. If a kernel panic occurs while vmbus_connect() is
executing, and the state is CONNECTING or CONNECTED but VMBus isn't fully
initialized, does removing this check expose the panic path to a 100-second
spin-loop delay?

Could this delay cause hardware watchdogs to reset the system before kexec
or kdump can successfully collect a crash dump?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730201123.1767=
-1-mhklinux@outlook.com?part=3D1
