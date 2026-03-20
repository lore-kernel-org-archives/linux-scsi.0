Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C553290A9;
	Fri, 20 Mar 2026 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774033271; cv=none; b=MYjp2rU125fmZPZ5/ceJMkynZlpMXbA8wsfkI/X1ydeb7KsuI++KTVBYGD0vR5/zElItTdBUYd6jQD/ze4P4dPzYIoXUy02aLLyq7XSBM5DY6+fnPMTJQS13Jlt+/3zKU7IiY02nqBM5rGvkXsYqz3MOyrsmqJboa5YawNUgtlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774033271; c=relaxed/simple;
	bh=IRzwBVB0zy+xeJPrWoPBH63WlZlvsdY9Se2uWMFPHws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWtrbQxXjiqqGgTAPgLzwqDHmA40SG6yK4YVoODcqHLYJEmtebP50DJxJB1nqxTppULDZpupORyP306k4/ayNhVrBqr6uztl2Z0OFvK3G4pOsKgIIBQxSdoekA+GgLcxTBeI+QPlMVH4NhXnTFECv3J+2mDVdaflftgBnDemaXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILLXPG4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILLXPG4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07F5C2BCB0;
	Fri, 20 Mar 2026 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033271;
	bh=IRzwBVB0zy+xeJPrWoPBH63WlZlvsdY9Se2uWMFPHws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILLXPG4yVPR0GDfMIEVi2nln57yMPmACXQ1ivP8/+4v6ApWNPyZQVwcO8Ue5pPxiS
	 WK47pP/CTV5GnZSDg9N7cRjDlm27drFIsN77fBPEKn69UM7rB3USrjXIpPU2eOzGve
	 Nkqwyv6CkOKOeMknBTVOFTUl8fBFKgSTkggkKbQSAoA8NV0Wo7fW0+IGGcJGZS3z5Q
	 9+W0rb/lNybrKvjRjIS1QOugOJs5rOwU2otS9o0FsUQBTvRurI+3cnIanWccwlJfP/
	 t2BXlSjTo8PA3OZzTO5QTr1SoETkBdeDcVadNFWdNARo1E/k++QeAE0RT40ZxwdQBF
	 7+sGFqHZzkj5g==
Date: Fri, 20 Mar 2026 19:01:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 05/16] fs: afs: correctly drop reference count on
 mapping failure
Message-ID: <995afd70-d7c2-42af-8012-589b3319d31a@lucifer.local>
References: <cover.1773944114.git.ljs@kernel.org>
 <018cd0d8b2dae44de6d3952527e754e52ef02da8.1773944114.git.ljs@kernel.org>
 <608ba54c-f19e-4e27-8142-0870f91d6514@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <608ba54c-f19e-4e27-8142-0870f91d6514@kernel.org>

On Fri, Mar 20, 2026 at 07:57:29PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> > .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
> > of the deprecated mmap callback.
> >
> > However, it did not account for the fact that mmap_prepare is called
> > pre-merge, and may then be merged, nor that mmap_prepare can fail to map
> > due to an out of memory error.
>
> So that means a file can become pinned forever? OOM is probably only a
> problem with fault injection in practice, but the merge case can happen. And
> 9d5403b1036c is pre-6.18 LTS. Are we going to need Fixes: and Cc: stable then?

That'd require backporting all of the .mapped functionality and half of this
series, I don't think that's really practical.

I guess I can do a manual backport of a partial revert.

Thanks, Lorenzo
