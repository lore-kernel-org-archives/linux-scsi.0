Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBDA3914ED
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612158; cv=none; b=qxnGZco8ZLTMoAfHokzyqWriROLoNk2RIRbjPp6RQx7dwKKvJCG1+S1lGGkd0+lTEbLTZgqjk9ZZ5Fq1NhoQJXHLkNHxfBzyC7OLUcug2sJ1QWEIRom8D9IbklcB7XtWQYlPm2/50XkuyOy6q7CacA1wER/hKyY4NFjMkJq4lqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612158; c=relaxed/simple;
	bh=WnJyPsHC2+g+VbXIgcGLJ+UPJwMFDVolBJ2XLHKIWH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eptBbelS9Qd6ZG8lBqZi+nSlYLU+xS5EJhTtzKndHiLwDOZllpHRHLwXGBmbqpYiqWyPtlaRoSbQBO7gmH0aPZBP+td98QxKlN98qPFqXI6PASAFrVOVrQ/w7ld/SPDKqgEpHxZlwAwld7Y25CIeAJtxzFQRQSHAWozUMpbUQ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PukA6Pac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PukA6Pac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1531F00898;
	Thu, 17 Sep 2026 02:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612149;
	bh=IMsc9HwsRQDBn0aMlFjArxdrvflYmvHclmEuiKZSIO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PukA6Pac0qe8NMJkkNbbh+GG+TjewRa/fwl/a+qCm3y7pgCjcTQ+L7ykKN2GP65k4
	 jmEfROpgGO9sSAwTMHjstf4N9mggvt58/mWE6Lb9QL3hHNe9OlafcC08lxj+bX2rB1
	 cXGKvF17X8IP64+qXgvVuNSxb+B9bC4NieukAR+0NeJKu6F4HJ6PqVG/1WyJoU8zzk
	 ygvYbSTObn/aXiplsOZddNXLNp1k8h7GLXf9nQyzpv/H19G6PIOtmkiR/FJowuObbr
	 G47hh52Ux03GprW7Ys1ro7OZNoov1JCoTMbXIe9CNAb2LskSSD4OZvysmvdQZ3FtBO
	 ECPibIb2kFi4Q==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com
Subject: Re: [PATCH v2 00/17] scsi: mpi3mr: Fix out-of-bounds accesses and reference leaks
Date: Wed, 16 Sep 2026 22:28:58 -0400
Message-ID: <178952247939.2757716.2182406615852538821.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 26 Aug 2026 02:33:54 +0530, Chandrakanth Patil wrote:

> This series contains a set of fixes for the mpi3mr driver:
> 
>  - out-of-bounds accesses where values reported by the controller
>    (device handles, phy numbers, topology event entry counts, reply and
>    sense buffer addresses, event data lengths) are used to index arrays,
>    derive pointers or size copies without being checked first
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[01/17] mpi3mr: Fix buffer overflow in BSG passthrough request copy
        https://git.kernel.org/mkp/scsi/c/896abdd4d81f
[02/17] mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
        https://git.kernel.org/mkp/scsi/c/9fac4cbd66d8
[03/17] mpi3mr: Fix I/O block counter leak on admin request post failure
        https://git.kernel.org/mkp/scsi/c/37e7d274272b
[04/17] mpi3mr: Fix target device reference leak in BSG task management
        https://git.kernel.org/mkp/scsi/c/f0ec04bdf615
[05/17] mpi3mr: Fix buffer overflow when caching log data
        https://git.kernel.org/mkp/scsi/c/9ff1af19c488
[06/17] mpi3mr: Fix out-of-bounds reply frame access
        https://git.kernel.org/mkp/scsi/c/bcf0a5bed59a
[07/17] mpi3mr: Fix out-of-bounds sense buffer access
        https://git.kernel.org/mkp/scsi/c/7fea128f6b82
[08/17] mpi3mr: Fix out-of-bounds bitmap access during device removal
        https://git.kernel.org/mkp/scsi/c/5dade59551d3
[09/17] mpi3mr: Fix target device reference leak in device removal handshake
        https://git.kernel.org/mkp/scsi/c/a04b0f3a17e3
[10/17] mpi3mr: Fix out-of-bounds read in SAS topology change events
        https://git.kernel.org/mkp/scsi/c/9e220ce4bd04
[11/17] mpi3mr: Fix out-of-bounds read of event data
        https://git.kernel.org/mkp/scsi/c/77554f01187d
[12/17] mpi3mr: Fix out-of-bounds phy array access on link change
        https://git.kernel.org/mkp/scsi/c/f67caaa2521a
[13/17] mpi3mr: Fix buffer overflow in the BSG target device map
        https://git.kernel.org/mkp/scsi/c/203b3072e7aa
[14/17] mpi3mr: Fix out-of-bounds read in PCIe topology change events
        https://git.kernel.org/mkp/scsi/c/7d572b4dc4ed
[15/17] mpi3mr: zero out diagnostic buffer status memory
        https://git.kernel.org/mkp/scsi/c/052aea807cfb
[16/17] mpi3mr: Fix use-after-free of the firmware event workqueue
        https://git.kernel.org/mkp/scsi/c/c94c746e6c80
[17/17] mpi3mr: Fix NULL pointer dereference on PCI error recovery
        https://git.kernel.org/mkp/scsi/c/2ba1d12b2629

-- 
Martin K. Petersen
