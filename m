Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315FC224C9;
	Fri, 22 Dec 2023 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fxD6B0eT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Uur8kWiCFEylSVPe8CEuTfymS/npRaY98dOGC8z4tU=; b=fxD6B0eTfA7zahTsC+znNxAVc1
	FRQLFyr+dv7ZkPfmvysDJT3Z4pPcghnkFqeF09i3uD50TzVy3tz7O6sXoWc33KNN4YTDVuVIh6hRn
	WsrUV09dv1RlMj5oP3kRCx6taxyNEKEm0UDMD+oaEWyanGAVdu2EvyX/jvgjhGZZtEgeZN3jp47g8
	fPkkEpA8XPI++ah3iAqgdfLp1rotCYd0JnwTHMNSz7p00plDqdne9odNBlUgZ/1awLrEh5aREKGRB
	D2G4r/7Z34eSw3x8BC2pYqopeuOI38EpRXLG6nEFXhJFpfvjmh3YuZRvS9wlj3Y1p/apJzoxh/6w/
	O3Kre3dg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rGfaX-0087W1-RY; Fri, 22 Dec 2023 13:29:17 +0000
Date: Fri, 22 Dec 2023 13:29:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	Bart Van Assche <bvanassche@acm.org>,
	lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYWPLQdjXzK8D6hT@casper.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <BB694C7D-0000-4E2F-B26C-F0E719119B0C@dubeyko.com>
 <4f03e599-2772-4eb3-afb2-efa788eb08c4@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f03e599-2772-4eb3-afb2-efa788eb08c4@suse.de>

On Fri, Dec 22, 2023 at 01:29:18PM +0100, Hannes Reinecke wrote:
> And that is actually a very valid point; memory fragmentation will become an
> issue with larger block sizes.
> 
> Theoretically it should be quite easily solved; just switch the memory
> subsystem to use the largest block size in the system, and run every smaller
> memory allocation via SLUB (or whatever the allocator-of-the-day
> currently is :-). Then trivially the system will never be fragmented,
> and I/O can always use large folios.
> 
> However, that means to do away with alloc_page(), which is still in
> widespread use throughout the kernel. I would actually in favour of it,
> but it might be that mm people have a different view.
> 
> Matthew, worth a new topic?
> Handling memory fragmentation on large block I/O systems?

I think if we're going to do that as a topic (and I'm not opposed!),
we need data.  Various workloads, various block sizes, etc.  Right now
people discuss this topic with "feelings" and "intuition" and I think
we need more than vibes to have a productive discussion.

My laptop (rebooted last night due to an unfortunate upgrade that left
anything accessing the sound device hanging ...):

MemTotal:       16006344 kB
MemFree:         2353108 kB
Cached:          7957552 kB
AnonPages:       4271088 kB
Slab:             654896 kB

so ~50% of my 16GB of memory is in the page cache and ~25% is anon memory.
If the page cache is all in 16kB chunks and we need to allocate order-2
folios in order to read from a file, we can find it easily by reclaiming
other order-2 folios from the page cache.  We don't need to resort to
heroics like eliminating use of alloc_page().

We should eliminate use of alloc_page() across most of the kernel, but
that's a different topic and one that has not much relevance to LSF/MM
since it's drivers that need to change, not the MM ;-)

Now, other people "feel" differently.  And that's cool, but we're not
going to have a productive discussion without data that shows whose
feelings represent reality and for which kinds of workloads.
