Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28243A6F0B;
	Sat,  3 Oct 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050202; cv=none; b=j1QTaYzzYNZbdiHYmNy47N3cSDaADowaXBr4xsdnDqMVhlRpBy+uwLeeUTPSqr/0lAH3EGcW1PhQxb3I0Iyf8yjABBAW5oxAiuprecGVi4H4cvLmYXwEHkbmJK3hykf1VzvNYf8KY+Lox0zQtVJZa1DedoEDNlYrsfxoOo/CDqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050202; c=relaxed/simple;
	bh=We9SPyjRDJvyFxiU73xJrKbNsJY8jWQtDNcOJSCIRZE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=haHPh4hdWcNiKUtnlPC4crbthj8UvwpsUobN1wR851IQ5imT4TRkiO7DahU6rYbHj73y6saIUNZX3m0XBB/uEULRRw6cQ1pYZsdGigJ3YdgL7myzxgno2+gcWQYMIp8mX7w/Vnl9+jXBTHu2lLH01RXlrEWiyJVkTim75nv7hDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+sMmNlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+sMmNlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041461F0089E;
	Sat,  3 Oct 2026 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050200;
	bh=We9SPyjRDJvyFxiU73xJrKbNsJY8jWQtDNcOJSCIRZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E+sMmNlcwWMdOivJYnnKbEA/WJgQE7x7RnJNKHzxmBmif0O9Kb9/6K9UDgx8WPC45
	 yWy3qtW6fW7eWrBWWLH2cRsoq6UEsK8M+957iQxzLZrHHKiCM8nl75ga9PW6kbRc41
	 paqUVUe+twpgQZ4Uv2lqv1ZbNjbnT05/iVbKs4encEJs8sxRu+A0aC7wxaHty5KVK4
	 oMvPxd/ZIQWOM+4wbvRtfcZsycJ196lj1ealjtFDg3pws3fnXygg32raO1poNF03IP
	 N3NOOzpYXdRT5knlSOqXIa+csOyEnGgIaIWT4fubtAYNFhzVy1rD87d4NuzJusfquN
	 QFZERzH4uG++g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/38] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-11-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-11-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:39 +0000
Message-Id: <20261003175640.041461F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> kernfs does.
>=20
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> check in sel_mmap_policy() cannot be reached. Remove it.
>=20
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>=20
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Acked-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D11

