Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA847F76D
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559163; cv=none; b=eB0Ro3xNa0/TcDOYrNfl0KmKH9mFGeMYjrCmvLPOYv0CJgWOwqn6kt03VIiMpOGJShvgP+NTLGgelL1JKKxtZf4avTUmet24hSk4px3rG+1YwBZIWjaCf9Vk83hUqOaB+QWvrnZAapEOlwFcM8fVNPEX3wOfV6cUaOxddAjPMUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559163; c=relaxed/simple;
	bh=oI9ma0p7kBce2zYd+aZOtd37ULQIKy4+SjXncEeVkPY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qTXw2sJWhuxl8QgudMyGUSTN+aIW1ERWpewQqHEcsSjA+d3wpdzbC2GOhvaFZrtIvXDKT8NEo/wC19rYoqtKQCuPXzXxPijuk8MIDZlhM+2EBmKmAMR1BTg3OBqRurRBJ1A1+SpcZjNLkttomdQJ9MpWH4X2YPwPz3jOOqDiZQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JeebjOLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JeebjOLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162101F000E9;
	Wed, 12 Aug 2026 18:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559161;
	bh=gjvIkzZ1dC7/CVq1z73wzlXWW6piXqXXrU8nWytyGvE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JeebjOLkIC63+Cu1H+lFS3qUdghpDGo5mCfiuny8Gokf1LDnq4583g4yU4ih+Oih9
	 wY/VYYy04xNDlnUnK44Q6neP3XqJJqt4iN9smS5hFiUgacv/KOIyObCQnju+Kr4xUn
	 pEFxvcjiEl6UJZYk05SULLotuXYJS5KHmZeyF8lNzuRYf+gZdrLh3QKf+8k3K5QQqv
	 QGXaMyAHZkMXS69Ekzo7cFPMSGozbiaYpjTHfNi++BbSnYKqCR+5BOvvCtRaswlRKU
	 amkKQLaJkRnFmeVzOKVPoQlNnjOolCVJzjMqXXwIiNPoCj896vlojTaRmcFLOHMd49
	 9UU42mPyvbipg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/13] docs: nvme-multipath: Add FC-NVMe marginal state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-14-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-14-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:26:00 +0000
Message-Id: <20260812182601.162101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] reStructuredText syntax errors and typographical omissions in the n=
ew documentation section will cause Sphinx build warnings and incorrect ren=
dering.
--

--- Patch [13]: [PATCH 13/13] docs: nvme-multipath: Add FC-NVMe marginal st=
ate ---
commit f3dba11cc9add673447a799cef2fefc827b2c2d5
Author: Jesse Taube <jtaubepe@redhat.com>

docs: nvme-multipath: Add FC-NVMe marginal state

This commit adds documentation for a new marginal state in NVMe over Fibre
Channel. It explains how to check and reset this state, and describes its
impact on multipath policies.

> diff --git a/Documentation/admin-guide/nvme-multipath.rst b/Documentation=
/admin-guide/nvme-multipath.rst
> index 97ca1ccef459b..8df4235d4d104 100644
> --- a/Documentation/admin-guide/nvme-multipath.rst
> +++ b/Documentation/admin-guide/nvme-multipath.rst
[ ... ]
> @@ -31,6 +31,23 @@ To set the desired policy (e.g., round-robin), use one=
 of the following methods:
>     1. echo -n "round-robin" > /sys/module/nvme_core/parameters/iopolicy
>     2. or add the "nvme_core.iopolicy=3Dround-robin" to cmdline.
> =20
> +FC-NVMe
> +----

[Severity: Low]
This isn't a bug, but the underline is 4 characters long while the title is
7 characters. Could this cause a Sphinx warning about the title underline
being too short when building the kernel documentation?

> +On NVMe over Fibre Channel there is an additional state called `marginal`

[Severity: Low]
This isn't a bug, but it looks like this sentence is missing a terminal
period at the end of the line.

> +All policies will treat this path as offline and will not use it unless
> +all other paths are marginal or unavailable. In that case, the policy wi=
ll
> +select the best path based on the policy.
> +
> +To see the current path state, use one of the following methods:
> +   1. cat /sys/class/fc_host/host*/device/rport-*/fc_remote_ports/rport-=
*/port_state
> +   2. cat /sys/devices/virtual/nvme-subsystem/nvme-subsys*/nvme*/state
> +To reset a path to online use:

[Severity: Low]
This isn't a bug, but reStructuredText usually expects a blank line to
terminate a list. Will omitting a blank line before "To reset a path to
online use:" cause formatting issues or incorrect list rendering in the
generated HTML documentation?

> +   1. echo "Online" > /sys/class/fc_host/host*/device/rport-*/fc_remote_=
ports/rport-*/port_state
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D13
