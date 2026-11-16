Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794835399;
	b=2HS/VtyNcFXYdwJDFfRpYolNVmfgA88Yp3p4M5VI7e5xdh2jITkAncQEePKw5HAWrsb7
	 yeXM7kWlH6BIHqKDcDAcx0Hdg61fUFBtoFDYFYc142Kl2oxcV9FnVhM6Yf60SClvAnrnY
	 a3BPo8bk0bUuVbgHKE3e4OKLeUvk3RFIrLVkeUBSeivCAXubafXtZT/a+6MaN9jNKAomW
	 LX3jYNJtkMAM8psHBn02QHRgrebCVfDcEusjiKiKnS+9yLIg1UkwiJlVUBsibk28rxPqI
	 sKd/uSF3cKVFw6t5IWGQYU+p9VWppqs2yg/pb27rfVkGWmt42Oa0/sgxrosxrXc6dNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835399;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ugeAAa5F7S8jo7o22VRNVHZRCEghXnRG4QSs0z+gWeQ=;
	b=JUD/V9Sg/tO5OYWxUCRtZDdAdNnTsonbh4mlQVLnR51U2vc807qECO+ZSen5OZid6VrV
	 E6JbEERKrHM0J2bt6sb6zd0Yc+DKkWIOIL8QGRwFWrLjKmc5vJ3qOY8iT2kQdo621yqfS
	 ZSaymC2MAT/KZnVKRd2b/HHMg8j9Dpv8fjz/c4Xqe9U3i4gzfsTPRdqPIwMapVo+IqxES
	 Z2p0fUAseFZ2z6zerUMhhlmvAoJDuWE2NwgCJwUKWTGXuQ7/s8E0KRxPrLDTAHcb4tqMj
	 AP2JOuQ8NG7nAy3+h8LPPP2g1WF1UcDpQJkUcRAKXrHgJpehnm9SyTombCSmD68Ergg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YVdhpRk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187D1606A31C;
	Mon, 16 Nov 2026 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YVdhpRk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD1F1F000C4;
	Mon, 16 Nov 2026 13:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835398;
	bh=ugeAAa5F7S8jo7o22VRNVHZRCEghXnRG4QSs0z+gWeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YVdhpRk49/rwmMkR2Jud38KOYWBE8eCd8fYpApx6gg7JhlrTG+NmRdk+94MetwqgH
	 NZGwa2e8anIBp0KxnE0LOtT8/RmP6GjIZSLksjgDdD/Wwj2BtfDbH+Vz0MgPndNK7Q
	 x9jdZYmPYLBNvm5CgAdHMugjPsk+7Pv12AtWVwAZi+19j04TzVA3F1oE6N1kNd/7tO
	 tOhQLWtGwQ6BS8LceKUuBTeirwIN85EAfRv/JLP+ilx8md+ACPvUE0/WwefbgPgkoQ
	 1BQQ/U8W8pdcpoRKzwoWXaA0FKUm5hVBA5xnNnD7EK7K7McdqkITK4A6oHdbmISsNt
	 B2L5Ae5AFK0tA==
Date: Mon, 16 Nov 2026 14:23:14 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev, Christoph Hellwig <hch@lst.de>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, bpf@vger.kernel.org, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Anna Schumaker <anna@kernel.org>
Subject: Re: [PATCH v2 02/17] fs: add kiocb_write_iter() and
 kiocb_end_write_iter()
Message-ID: <20261116-windungen-freuden-zander-0e6ef798e54c@brauner>
References: <20261116-work-fs-frozen_writes-v2-0-ecc4a2aac40e@kernel.org>
 <20261116-work-fs-frozen_writes-v2-2-ecc4a2aac40e@kernel.org>
 <sashiko-outbox-216937@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-216937@kernel.org>

On Mon, Nov 16, 2026 at 11:30:59AM +0000, sashiko-bot@kernel.org wrote:
> Should kiocb_write_iter() check S_ISREG(file_inode(iocb->ki_filp)->i_mode)
> before taking freeze protection and setting IOCB_WRITE, the way
> file_start_write(), aio_write() and io_kiocb_start_write() do?

Eeew, no. That check alone would bring the bug back for these drivers.

blkdev_write_iter() calls file_update_time() which dirties the device
node's inode on the filesystem the node lives on. And write(2) on such a
node modifies a frozen filesystem today for the same reason.

For FIFOs we skip the time update on a frozen filesystem instead of
blocking (cf. 7e775f46a125f ("fs/pipe.c: skip file_update_time on frozen
fs")). If we change file_update_time() to do that for all special files
then kiocb_write_iter() can take the S_ISREG() check.

> Without an S_ISREG() check, writes to a block device node whose hosting
> filesystem is frozen will block in sb_start_write() (or fail with -EAGAIN for
> IOCB_NOWAIT), and will deadlock if that filesystem is mounted on or
> flushing through the virtual block device during freeze_super().

That can't happen. The node is opened when the device is set up so its
filesystem can't be mounted on that device.
