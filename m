Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900B92D7DC8
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 20:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786049999; cv=none; b=Tz4LuuHYrsNW1kmuLJiTcUMxzNSBDHkziBC7pMsXaI7sW2wRC2JqgkuNoBxTuLFpkk5j8dJIpGk6VyseoHz5oOF3X2W2LrSbFHfdGR7XutyI5iwiAuAuj0FgkK7wLV1lD6TTJS7A0rH3RW5FWbqRK69p232lXkTwoayVht+yj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786049999; c=relaxed/simple;
	bh=jQHswJ8H4F59d8OIDvRrd8n52bUYHjrVAw9ClW0zxdk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ida3rpdJfzxiDZLA9BiXTG9VB65PsrNsVm/l7BRH1cDXiLgBxvS2IcUTsMpjq05uQjxPNeQhbbXrbm5gApM+/elzhhhF50+LGEPa3CXj5yJ6tNrFYKz1/RTcGOluKtSzAmOEdAQrxdJPc7G30VoBVPeIOSpvv8W47UEWuYhT78o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcoclFkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcoclFkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5566D1F000E9;
	Thu,  6 Aug 2026 20:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786049998;
	bh=E4OxpMMw7DUQPKPKNsbUPIrFYRDZpBUV65LjwuT0WwQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RcoclFkx7MrKgjtNvioOBsxRvdHEiDBpT+panrGlH2+zTPMU3M5Vpkl+AZkPyVTNt
	 UQp64/x92O3qn/tJ8PKZwrRsfryD/7fD3q4SjzjjwH2qnKQFi5LJDElf28Iml+E9nK
	 eRn5clU8fJ92O9y1+bJARvT8aUtllD3JF7tWMrkaT6G7kNyYmkCsPikKB6M8SMuEvK
	 qg73ZuJNvsOm3pS3Ht8sdWFFkkd6HmoYda8N+H5Lxfam0SmRU8Wchf1e2Pf7g3k5tA
	 EXjdh5Ysa0tx3VQkME7N5yiUNPjR2kfn2IXGmflw4udtylZCoG/0ezuKV4hnPcFW80
	 NhuXk+5sPYycw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/5] scsi: elx: efct: check the HW state before
 allocating an HIO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806202205.345326-2-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806202205.345326-2-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 20:59:57 +0000
Message-Id: <20260806205958.5566D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing resource leak of `hio` (Hardware I/O object) in `efct=
_hw_bls_send()` when WQE formatting fails.
--

--- Patch [1]: [PATCH v2 1/5] scsi: elx: efct: check the HW state before al=
locating an HIO ---
commit dc19c507aa2788a2b5120f2a9e8e09430d14b440
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: check the HW state before allocating an HIO

efct_els_hw_srrs_send() takes an HIO from the pool and only then looks at
hw->state, returning without giving it back when the HW is not active. This
commit fixes the issue by moving the state check before allocating the HIO.

> Check the state first, the way efct_hw_bls_send() already does.

[Severity: High]
This is a pre-existing issue, but while efct_hw_bls_send() correctly checks
the state first, does it still have a resource leak when WQE formatting fai=
ls?

In efct_hw_bls_send(), an HIO is allocated via efct_hw_io_alloc(). If the
subsequent call to sli_xmit_bls_rsp64_wqe() fails, it returns -EIO directly
without releasing hio back to the free list:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_bls_send() {
...
	hio =3D efct_hw_io_alloc(hw);
...
	if (sli_xmit_bls_rsp64_wqe(&hw->sli, hio->wqe.wqebuf,
				   &bls, bls_params)) {
		efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
		return -EIO;
	}
...
}

Should this call efct_hw_io_free(hw, hio) before returning -EIO? Once the
pool is exhausted, efct_hw_io_alloc() will permanently fail.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D1
