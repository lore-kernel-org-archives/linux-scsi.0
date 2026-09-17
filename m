Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABA0522EF5;
	Thu, 17 Sep 2026 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665931; cv=none; b=ZjxrBE68/yJ/RPZf+aXaeSIb/Wn3pY71XFgiPrMcxr3zzxu+Ll9Kw6JDw0vpZvL0C+9OD8FsC8knneCbLvSqYRD+9uBN/yoNxo+eU7Zifjh8cmWxuO9gIiWsifHqPBxEBq7mpJevKH7JCjvZQMwSxNemtRqpbwLgaUJeQhbO+nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665931; c=relaxed/simple;
	bh=z67KlTeWdWUfckdrR3+nSagyP8g7QLmUq4qSmxvPpiU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CUNS5U4PpTqJGgW15kOn4nKCjImxDD1ChwZ62+l0oINhWPJgB7RW14Ov+qlCs2uzzh1qvMLyfTtAarNcmGlAs2UGaOtJl/fdgwSCtddhKz0cefQAjdKftCPLkckDfvZ2Z68/VHyw8UzJ3Bv59z5IBBxxXrsPC8lNzV4prrgAThU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNP1bLwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNP1bLwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0365D1F00898;
	Thu, 17 Sep 2026 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789665929;
	bh=z67KlTeWdWUfckdrR3+nSagyP8g7QLmUq4qSmxvPpiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DNP1bLwfXsSv7FB5Dqn1iXc9cwqzYVpipsMv/WqB+Liau2yasgds0BzoUsIMzpPD+
	 PlkJTOSTmZzDUTa37vRHRMlPf8fRc2uhyHJUlTXH/VA61WFVEJ2U1mZZr6r+TR7tGx
	 ZpPCB3FLAat7SZ4qz+3PmCsqVOLMc+wQBajrWmHe3C1Jh87ulDaan82s3vn7DCQr1t
	 J0oIAO3HvTUzRNM9czotxmUPVtEbxrUaVt4i3lsAtHf94Qk8SaSorDkxts1xKQ92Ey
	 PQfmYQ143EX/ToZRDC4sdsE1WMgsddVdSDpQehSuKM3w7cR0ziqFtbkEuWlKLgYkBO
	 NY578Lh+qCkxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-12-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-12-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:25:28 +0000
Message-Id: <20260917172529.0365D1F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D12

