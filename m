Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC8A45957;
	Mon, 16 Sep 2024 08:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726476057; cv=none; b=oKgRmNl3rRWF4+A/28opdInVvFhQuNPpD/Kcigcc/n37lkaLnTZ/iR8s+Xhnn+LZLqqQcTuf8IUbPuATML0LZbCFOSLthZz/r0EDUhOyAH2QRN1jrCqhddPpkp6DfvwaXIFGKGEHikWxnPvpF3C8DuYB+Sh23OyfIOwq32+BEms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726476057; c=relaxed/simple;
	bh=XQXfmHXYm8nPbHnm4cGGcfowXPNvc5CPB4QSkYiTM00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOjeC9EeVJvoFFIGgFG9hkNMBLkW0Ivgomt5oat7eFmxTyfRs/7riFArAGCYHtPGTW3KJ8XQs9gkFD0Aflm1wVtkuJnOOJa1vrM5VuNVOrz4aBMVkodi5MRgOCepYi6QM4dCZlyRpfmvS1QmHqa+A6FkvY1lZaPkfFflobFfGIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9rBmWll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9rBmWll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A2BC4CECC;
	Mon, 16 Sep 2024 08:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726476056;
	bh=XQXfmHXYm8nPbHnm4cGGcfowXPNvc5CPB4QSkYiTM00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9rBmWllFZJJ90mP9ftq7DHqmtMJIZX+gbnDVKqeSthnuBm+yXKJeEnb4uFVb48Gj
	 IyZ7HnudXGA3uFdWbUjs9IfktXE1cwNee799w4lYvybnrMIQpK6HfPriESACBylkVk
	 BOfTa3O6BaZLX2SL4qXdqJNpCUhfpzKk4P9BJSWvRCsUxuTaIfTmKdt37x5EPk8wmE
	 I33QGpTfZTffHxtBZocGHRGqCikE5I59B+sxrGl6MrciDcMvwnVCr//KWmuLQjGOjz
	 3ZWKDQI7VplHMHExM6H7hCuappaKMALOup7N32F3Io2436ps1QXqUgRHfdfjTqqswS
	 1cH32ywDDGbBQ==
Date: Mon, 16 Sep 2024 10:40:50 +0200
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv5 4/9] blk-integrity: consider entire bio list for merging
Message-ID: <ZufvEhr-UO_BGm6_@kbusch-mbp>
References: <20240913182854.2445457-1-kbusch@meta.com>
 <20240913182854.2445457-5-kbusch@meta.com>
 <20240914073011.GA30261@lst.de>
 <ZuW-_hu1-98SEjll@kbusch-mbp>
 <20240916064412.GA15929@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916064412.GA15929@lst.de>

On Mon, Sep 16, 2024 at 08:44:13AM +0200, Christoph Hellwig wrote:
> The wrong thing primarily is the above commit log.  The code change
> itself is correct, but we'd be better off killing the iteration over
> the bio chain as well to make the code less confusing.

Okay, gotcha. I mentioned the existing code is a no op in "most cases"
but it should just be "always". Maybe a sanity check with a WARN here is
appropriate too.

BTW, sorry for mislabeling the tags. The patch numbers changed a few
times in this series, and I pasted reviews from the a different message.
