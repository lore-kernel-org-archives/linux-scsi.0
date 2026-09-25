Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DF638AC96
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348128; cv=none; b=CmeWOkWwSuUNr0ozXp8KZKCGtcJr95wl6oxnNjc5SLPky/lGOx8awRR2B5P4ZK8Ut4IFKTnFiOX6vtl8HEbkQHU9+tQImU2JPlD50+Vu78dZgjcJxd1x9FBHs2snMVdZhQKukqJYNR22+z1PcwmraI8U9vhQx3Z6xQ0xOKyQYgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348128; c=relaxed/simple;
	bh=swvM5BjCRtPuDumrnn2HQoCV2Z3/lhHwuLj1hAaw7Ec=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iWtBdD2kiVi7C8ufq2URif/daQ0+9jjfWhNvBNnJALwM9ZR1WeiveaDF65lVV7/jNgwiIMp/kjMU0Jwl0VkbfjxKm1XjG4pJ2D+3tlHeoBWJ+nYX2UAbjCFVUK3BuNsHcqKqwNkpKuW9Cynasw2/y3bOETSEmyHox5ch4yljC0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utiRfoZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utiRfoZv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ED9EC2BCFA
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 14:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790348127;
	bh=swvM5BjCRtPuDumrnn2HQoCV2Z3/lhHwuLj1hAaw7Ec=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=utiRfoZv8256W8CaheZuTX7Bv1JXI+c3FYm+ds53JOvivDfqlpa5HVceUJS9lMsBJ
	 e1KfjHa2YDJqNXz9tgcDcSfO1MOOqdmxXxUdk1691Dfjp6tOwDgvlZ6TY0PJ40eNnX
	 L4e6jCaAtjtpmYRv3Gw5hmFfh1U9MOWdT90cKriBW8yIrjk6MvxizAPQN+WKRGcBwj
	 +F4IxMBoUWyHFukWcPSNnp94xTWsIVDYzcIU9m+XRdXlv+iUKPHkXx3ja/k0qOeFJW
	 N+qOYAl85/J6nxa3vIWv81eH5AV6bLN8/ybK05PWP91qvssb1fPBnlofs3RripwPCS
	 OHcwdOEaVlLww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 158D3C53BC5; Fri, 25 Sep 2026 14:55:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Fri, 25 Sep 2026 14:55:26 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: haasje@welmers.net
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222016-11613-4PONowYlJ9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222016-11613@https.bugzilla.kernel.org/>
References: <bug-222016-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D222016

--- Comment #19 from Bastiaan Welmers (haasje@welmers.net) ---
(In reply to The Linux kernel's regression tracker (Thorsten Leemhuis) from
comment #17)
> (In reply to Bastiaan Welmers from comment #16)
>=20
> > I unfortunately also can confirm that a build of the
> > git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git bran=
ch
> > queue/5.15 commit 731937a9e48136b71ba06095c68204a4f545efed is failing w=
ith
> > "Error 2"
>=20
> What's the error? Is it related to the revert?

The error on 731937a9e481 seems to be:

[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/drivers/mmc/core/h=
ost.c:[m[K
In function '[01m[Kmmc_free_host[m[K':
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/drivers/mmc/core/h=
ost.c:664:26:[m[K
[01;31m[Kerror: [m[Kpassing argument 1 of '[01m[Kcancel_work_sync[m[K'
from incompatible pointer type
[[01;31m[K-Werror=3Dincompatible-pointer-types[m[K]
  664 |         cancel_work_sync([01;31m[K&host->sdio_irq_work[m[K);
      |                          [01;31m[K^~~~~~~~~~~~~~~~~~~~[m[K
      |                          [01;31m[K|[m[K
      |                          [01;31m[Kstruct delayed_work *[m[K
In file included from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/rhas=
htable-types.h:15[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/ipc.=
h:7[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/uapi/linux=
/sem.h:5[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/sem.=
h:5[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/sche=
d.h:15[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/rate=
limit.h:6[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/dev_=
printk.h:16[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/devi=
ce.h:15[m[K,
                 from
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/drivers/mmc/core/h=
ost.c:12[m[K:
[01m[K/mnt/WDGREEN_1TB/bastiaan2/build/ubuntu-linux-5.15/include/linux/work=
queue.h:466:50:[m[K
[01;36m[Knote: [m[Kexpected '[01m[Kstruct work_struct *[m[K' but
argument is of type '[01m[Kstruct delayed_work *[m[K'
  466 | extern bool cancel_work_sync([01;36m[Kstruct work_struct
*work[m[K);
      |                              [01;36m[K~~~~~~~~~~~~~~~~~~~~^~~~[m[K

Full screen log can be found on
https://users.welmers.net/bastiaan/731937a9e481-screenlog.0.txt

However, on the newer 38803ff4fab8 this error is gone.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
