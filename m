Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9804078FF;
	Wed, 14 Oct 2026 03:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950257; cv=none; b=QOfm+tatUX1aK4Zsf3j40iU0OEXOG7dz3xINpONGrTjMRJh7T/bnfOUnAS4VC83WLJEKamlsKUZHh8o0p9cMvQxNrzTHIz76AylpxuOUowpHuCQ3wJNrnBKKVFSG6JnARHFdrFkuglcfskF1Rtr7xUJLsAe894YQWCKrHW4H9vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950257; c=relaxed/simple;
	bh=AW7uceQp4L+ZZdVZOcW8jb9LuXkAD9Gc8hGAtcEzT+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IU1DWwScC3tsS7riPtZAmrYOTC0P32Xywe83xnssUICslQWZV4vO+0BiBHm76RY93HN2jF95s/dGeGQJttwcJ4ykGAQ0ZICvABhUoiaQ6gCrcMou4Z0HuMmhDCe0SvmAKiACrNFatnxIAOsI2yFvuv4phnUuJZNQ8CjGeAHXtGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRgdtL/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRgdtL/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3921F000FF;
	Wed, 14 Oct 2026 03:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950256;
	bh=krep95NG2pPtINDgFelqrvncws8jmsQoXCeuPVWJJuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRgdtL/aIJaMAoRljT8tn6ntILQarurAmsWGDk6qdkndvHoWveSoVAnB0UyvjQADm
	 WCpQUGsTbogicljt6mcCEQXBnW7H+UHTB6B6pu5b2u/xkmpBsw4NUq9MJuHHExbCYS
	 hHWM3DJjplFB+el/h/0+lpg/qAtGIVmZUYl0RYyhDuzQD3Io+ZquSOfKTth/unatkv
	 o4miA5eS+IEsY8KBmM9Lg+PXnx7AfA+On4Gkvnf3J6DHgS0EHLp/dnJ0rr/Xdz/Gz7
	 JaDzfDRS8Ifx10c5Os5nWu5ggTAbh4EQoXW32fHCi5pcg3y8/5Ivm/u3t1tTv1qeHK
	 PkS2yoZ2zQJ2g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: stable@vger.kernel.org
Subject: Re: [PATCH] xen/scsifront: check for a NULL shadow entry on a backend response
Date: Tue, 13 Oct 2026 23:57:26 -0400
Message-ID: <179194999395.3016381.7673052894147861823.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>
References: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 05 Oct 2026 21:35:54 +0900, Yehyeong Lee wrote:

> scsifront_do_response() validates the rqid in a backend response against
> VSCSIIF_MAX_REQS before using it to index info->shadow[], but then
> dereferences the entry to test ->inflight without checking that the slot
> is populated.  Shadow slots are NULL before a command is submitted (the
> host private area is zeroed at allocation) and are reset to NULL in
> _scsifront_put_rqid() once a request completes, so an in-range rqid that
> does not correspond to an outstanding request makes the frontend
> dereference a NULL pointer.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] xen/scsifront: check for a NULL shadow entry on a backend response
      https://git.kernel.org/mkp/scsi/c/8c8222c25577

-- 
Martin K. Petersen
