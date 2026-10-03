Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964F23ACA4A;
	Sat,  3 Oct 2026 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050196; cv=none; b=Dj6jbN0o/uxd0/dElRtdkN3q4f+cdjkRpAbgkjc17atmrS4QFqUOjxemhLmhIjx6Dbt+6F9FcF0kKXcyOvnfUYwRrpczFJ+PWJP0E6oNsAguMrFuaun0nEQ8YzyChXjd/dxkHFmO8bVAgHMjPtlnzAVx8QL0Xo84n/Hnkgqaiuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050196; c=relaxed/simple;
	bh=Ihh78CSduPBZvC+R/H8Na4GX+aBSwRY3bPQsZRmhkKU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZxIwHck3wnwYtw2wglqRbVxGN/W7zeIe5WcTcT0ZGON6agwyh+6ZmJAQWmWYhWubUtiQLzpx473qLHKz1Z3oA6Ejs48/iw8XV8fyPRx24D4YNdLsLFiFlRnNClb9zKk8W+eVKaDPwXPFoGIwCDVuvB1GRxItCmOqXZIYyimX6Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ew+G5Nlh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ew+G5Nlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6AE1F0089D;
	Sat,  3 Oct 2026 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050195;
	bh=Ihh78CSduPBZvC+R/H8Na4GX+aBSwRY3bPQsZRmhkKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ew+G5NlhkpDvMqnP6aqx9NV91Irlh2ZBpWiHT7tMhRE+5QgmS8HEq+Pj3RDyQH5kI
	 Uk7OmzIYk5HsHD8H+NVVfEKUG2iRLjDuqyIthBg/5+qa3B+uaLNT/G1xoc+rmNuFjx
	 SLmQeYv3yxpJNJwiGCCDxZNtngJ0/2IxVNKzuDdD7JYw2jiyu4nEHVQDeNbGREZvUd
	 NNsGd9ch6S18IWFYaQmsFaUk3YvjK0ErX7cP5OF8dU/pCa7NeGqku8CfDEZlH/WiKd
	 7lLihS6/Y7qIm4trjzd+LfbCyPT6iO1CF88favrXULXMfeZ9sxEVcT6jAWQLlfoDgT
	 BtHAOiWCQVANg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/38] docs: filesystems: update mmap_prepare docs
 for discontig kernel pgs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-8-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-8-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:34 +0000
Message-Id: <20261003175634.AD6AE1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Describe the newly introduced discontiguous kernel page mapping mechanism,
> detailing how to use it sensibly and how the API looks.
>=20
> Explicitly detail the various discontiguous actions available and how to
> use them.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D8

