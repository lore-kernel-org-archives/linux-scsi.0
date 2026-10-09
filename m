Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFFF524B16;
	Fri,  9 Oct 2026 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570840; cv=none; b=MT2WDwyNyP57coBF8oWz11EkstyJGx+ZiqogVzSkfNEE7qZKB35vUHfC0IW90106HOMytbv3kUjTXRq3Yj5NSMeor5VlGU+UOzbv6suvf/Tc13CGJBIYsZFcC4KrceR9xn6HE8UgXliedCpLlXJTUc/j1o8dNgWVFfBNQMNe128=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570840; c=relaxed/simple;
	bh=xkooYtsuVAkQrEBEYuW+eOExdD7O8DWUyq4mMnL2MuU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=t/8DvHh17/5Agh+vPUh9lUv7jFazZCc0GqXQ9egHOy7xFuN4l1PT1T6TwLN2axhZTGWBf95+l3+EowgMyD0FwlfVZgt1eTuOT36XDnmKkT0BtUkCcuDLQRgk4qjHawP/6IqrLb4FdIstWCR1ALq55lg7KPpjaWvuKxw6j6GArpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwwBPEuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwwBPEuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABF01F000FF;
	Fri,  9 Oct 2026 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570835;
	bh=xkooYtsuVAkQrEBEYuW+eOExdD7O8DWUyq4mMnL2MuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nwwBPEuOkW4GWjitpf8Zm2Ohvg2267+y0Cd9lr+Tzjiv5g0sSo38K6uiaK/3+QJQm
	 foR3DeCkaGBeYV7ixqfBSVV9xXKJrorYbejxDDMyT81suTY7/ckWDgiaAY0dDHmENx
	 1o8PpT2K+FyYd9MQ4O9Dq5C/Z3HgZVYOWy5Gb9xPSc54+LMA2WtboCEGjOHwTblfsh
	 qaf3tV4iRN35f93TXtZbFlbY01XxAiOn8ToCF7avkOVJ/HA4dP9J7UtKu9jRz/JcCB
	 YRj5ewab+r9e4EUkQx0V5+4cI4JE4AX5shfy7smqOS2B8iWsjjCxDF51Wy8YveJP6d
	 s3U88woecfatQ==
Message-ID: <sashiko-outbox-165952@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/38] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-3-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-3-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:33:54 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, t=
he
> driver might have done something crazy that is not permitted by the kerne=
l.
>=20
> Currently we check for three such cases in __mmap_new_file_vma(), but only
> if the legacy f_op->mmap hook is used:
>=20
> * Did sparc ADI result in invalid flags?
>=20
> * Did the driver alter vma->vm_start?
>=20
> * Did the driver make a file-backed mapping on a read-only file writable?
>=20
> Generalise these checks for both mmap_prepare and mmap and apply to all
> invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
> in the core VMA code and the mmap_prepare compatibility layer.
> [ ... ]
>=20
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D3

