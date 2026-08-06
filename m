Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863D73EDE4F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786049846; cv=none; b=Sk94yfFx+fxlAC5qc3+vKMjmfPSNK3+OXVRWXuHohwPVtbkRU7IaUGRVsYpIwMLloWl/q7RhOaHPEv0PCt5tgeF1nwpjGe/Ao+bYnc3pD6rROaCti6mEOV9LMJoEZ/M0VqkihGrN0gTGJ8Yn8XeY0O2EqEOwbrWn5icXiGlWWC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786049846; c=relaxed/simple;
	bh=BfW2dULK7SGPxX/NSLs+rZN/iQERM3TPXnxgJOYF6JI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IUhp+TC47Vlt1bkXFZH3CE1lxL8mYFh6L5Ix/kKDp7rPpBvz55i+M3jK3u/5pJkoJV2kwcIUTDgy0nl/cHi6uN65ETyLUWDjB0juKvmYEKjnY6OHWQiW7Eg/KpAtkFr6MDhhqEYXVAEk83wCcjkDa/NbqKI2RKL0hE1VZxJULqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXjyTeAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXjyTeAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8711F000E9;
	Thu,  6 Aug 2026 20:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786049840;
	bh=zffjmIh0HO5lqniMF0L1oX1QtDjDx05OPEV32MNkBHY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fXjyTeAqPLdOT0MoKUcHU82o7b3rzc7cztp30Ry60ctCzEHD4zZgtfc4SpQdqXfLB
	 ulJAaFeJUhiGBJ0TopDDDpRZPHQd5cket+IsFVOmraSeBONtF3u52QO/ufBb8vEela
	 G3tfHONJnygzLDcqQcyMa9Aydae6fIznJsEfc1OKGWxryzYvCy5j9r+OPtquLmydf4
	 J/nhQUXbo0chhQGbwhPwhIz4kcONMtSNrjWuJAObxRpjHGpHfsiPiJxYdahwBex3LR
	 U3en7C1vgsflsC9vbn34Bw5U2K/w/sjo3Z8P79lCf3c+M4g+ZEwEYNQZYBN9JBkYs1
	 ShJLemgP68Teg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/5] scsi: elx: efct: destroy the mailbox pools when
 setup fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806202205.345326-6-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806202205.345326-6-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 20:57:19 +0000
Message-Id: <20260806205720.3B8711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The global list `efct_devices` is modified and accessed concurrent=
ly without any locking, causing list corruption and use-after-free races.
--

--- Patch [5]: [PATCH v2 5/5] scsi: elx: efct: destroy the mailbox pools wh=
en setup fails ---
commit 250c50655b4add3b10d0ee9bad5b35495210fdcb
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: destroy the mailbox pools when setup fails

This commit prevents memory leaks by destroying mailbox mempools in=20
the error paths of efct_hw_setup() before returning.

> mempool_destroy() for these two runs only in efct_hw_teardown(), which is
> not reached here. efct_hw_setup() is called from
> efct_device_interrupts_required(), and when it fails efct_pci_probe()
> unwinds through efct_device_free(), freeing the struct efct that held the
> only pointers to the pools.

[Severity: High]
This is a pre-existing issue, but since the probe error path unwinds throug=
h=20
efct_device_free(), does this code safely handle concurrent accesses to the=
=20
global device list?

Looking at efct_device_alloc() in drivers/scsi/elx/efct/efct_driver.c, the=
=20
device is added to the global efct_devices list without locking:

    list_add_tail(&efct->list_entry, &efct_devices);

When unwinding through efct_device_free(), it is removed and immediately fr=
eed:

    list_del(&efct->list_entry);
    kfree(efct);

Meanwhile, userspace configfs operations can trigger efct_find_wwpn() in=20
drivers/scsi/elx/efct/efct_lio.c, which traverses this same list locklessly:

    list_for_each_entry(efct, &efct_devices, list_entry) {

Could concurrent probe/remove operations and configfs reads race here,=20
causing list_for_each_entry() to hit corrupted list pointers or trigger=20
a use-after-free on the released efct object?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D5
