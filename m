Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4584212BF26;
	Mon, 26 Feb 2024 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708961129; cv=none; b=oEOvOROPu5N4fh7aQCsjzTJFgL+yVH801S1+Yj1lFL7ym/RPGubDP++eoOPu0wMzYfLBuPrQZbgkSDPGlCoOME7motXZHG83LO9a+h0a3V9LlxuaJ1SlG7G6mbMFiJTCf+zH96bfL97Vuq3NUju3bLT8BLMwim8DLwV5CthtAzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708961129; c=relaxed/simple;
	bh=OrznBSmubcTO68fGlkscilOh6FgtPLIRw+JRqFlH0FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzheM39VOROszFadAuoO2SmwO529GQ21ZzaN1h0gXfU9yYCDlWC4S8PPD7WfJNogPd/QTgEBLVxD2w5HxAUkuMRdLdeoajU3pSWCyN9LdNQIj940kctbN1TZgr79NnLoMCPFy/gfGXxg6Sch8bqPXmtny/wmDeWQhP+yJ/SorLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nqXhuOfW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nqXhuOfW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4TDYI6mXaGOZYsc19qBcuYikOacVGhB4UKPWxmyPY6o=; b=nqXhuOfWMSspveH04uPY1dryj/
	2rTYG1tjTuVxuyNB7PSGlGP+Z6tzK1a6hrro5SFYTk1D4IfS9Vg7EJvZuOBgvzMw31LfH27vrFj/y
	0bFpZWcyDWn3sJMAYJ85pbp/AyzjeDxScKubt7wEQVze4cvcMBEJcAYJqfPGLSmmn874roGYcG4un
	U13u5+WCU3P/p9mwNamaKL0Om8NNjVHJ/T0FOQb+LlAdDDM8hBbaA3Qzm3URYGSxxr6XJZlo60rsR
	XWwGBZM7TCgx1DdJj+43k9S3L8+HodQSu32FcTqZX6JiG/ISx8YYqJ7fzLKDNd75sPQOBwDHnTAnk
	fb5OX2oQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1recr4-00000001Pmx-3wWR;
	Mon, 26 Feb 2024 15:25:22 +0000
Date: Mon, 26 Feb 2024 07:25:22 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, Jan Kara <jack@suse.cz>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@infradead.org>,
	Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZdytYs8W9o0CIu_C@bombadil.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org>
 <ZYUgo0a51nCgjLNZ@infradead.org>
 <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>
 <ZZxOdWoHrKH4ImL7@casper.infradead.org>
 <ZdeWRaGQo1IX18pL@bombadil.infradead.org>
 <ZdvIlLbhtb7+1CTx@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdvIlLbhtb7+1CTx@dread.disaster.area>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Feb 26, 2024 at 10:09:08AM +1100, Dave Chinner wrote:
> On Thu, Feb 22, 2024 at 10:45:25AM -0800, Luis Chamberlain wrote:
> > On Mon, Jan 08, 2024 at 07:35:17PM +0000, Matthew Wilcox wrote:
> > > On Mon, Jan 08, 2024 at 11:30:10AM -0800, Bart Van Assche wrote:
> > > > On 12/21/23 21:37, Christoph Hellwig wrote:
> > > > > On Fri, Dec 22, 2023 at 05:13:43AM +0000, Matthew Wilcox wrote:
> > > > > > It clearly solves a problem (and the one I think it's solving is the
> > > > > > size of the FTL map).  But I can't see why we should stop working on it,
> > > > > > just because not all drive manufacturers want to support it.
> > > > > 
> > > > > I don't think it is drive vendors.  It is is the SSD divisions which
> > > > > all pretty much love it (for certain use cases) vs the UFS/eMMC
> > > > > divisions which tends to often be fearful and less knowledgeable (to
> > > > > say it nicely) no matter what vendor you're talking to.
> > > > 
> > > > Hi Christoph,
> > > > 
> > > > If there is a significant number of 4 KiB writes in a workload (e.g.
> > > > filesystem metadata writes), and the logical block size is increased from
> > > > 4 KiB to 16 KiB, this will increase write amplification no matter how the
> > > > SSD storage controller has been designed, isn't it? Is there perhaps
> > > > something that I'm misunderstanding?
> > > 
> > > You're misunderstanding that it's the _drive_ which gets to decide the
> > > logical block size. Filesystems literally can't do 4kB writes to these
> > > drives; you can't do a write smaller than a block.  If your clients
> > > don't think it's a good tradeoff for them, they won't tell Linux that
> > > the minimum IO size is 16kB.
> > 
> > Yes, but its perhaps good to review how flexible this might be or not.
> > I can at least mention what I know of for NVMe. Getting a lay of the
> > land of this for other storage media would be good.
> > 
> > Some of the large capacity NVMe drives have NPWG as 16k, that just means
> > the Indirection Unit is 16k, the mapping table, so the drive is hinting
> > *we prefer 16k* but you can still do 4k writes, it just means for all
> > these drives that a 4k write will be a RMW.
> 
> That's just a 4kb logical sector, 16kB physical sector block device,
> yes?

Yes.

> Maybe I'm missing something, but we already handle cases like that
> just fine thanks to all the work that went into supporting 512e
> devices...

Nothing new, it is just that for QLC drives with a 16k mapping table
a 4k write is internally a RMW.

> > Users who *want* to help avoid RMWs on these drives and want to increase the
> > writes to be at least 16k can enable a 16k or larger block size so to
> > align the writes. The experimentation we have done using Daniel Gomez's
> > eBPF blkalgn tool [0] reveal (as discussed at last year's Plumbers) that
> > there were still some 4k writes, this was in turn determined to be due
> > to XFS's buffer cache usage for metadata.
> 
> As I've explained several times, XFS AG headers are sector sized
> metadata. If you are exposing a 4kB logical sector size on a 16kB
> physical sector device, this is what you'll get. It's been that way
> with 512e devices for a long time, yes?

Sure!

> Also, direct IO will allow sector sized user data IOs, too, so it's
> not just XFS metadata that will be issuing 4kB IO in this case...

Yup..

> > Dave recently posted patches to allow
> > to use large folios on the xfs buffer cache [1],
> 
> This has nothing to do with supporting large block sizes - it's
> purely an internal optimisation to reduce the amount of vmap
> (vmalloc) work we have to do for buffers that are larger than
> PAGE_SIZE on 4kB block size filesystems.

Oh sure, but I'm suggesting that for drives without the large atomic
it should still help to have this as there is less aligned writes.

> > For large capacity NVMe drives with large atomics (NAUWPF), the
> > nvme block driver will allow for the physical block size to be 16k too,
> > thus allowing the sector size to be set to 16k when creating the
> > filesystem, that would *optionally* allow for users to force the
> > filesystem to not allow *any* writes to the device to be 4k.
> 
> Just present it as a 16kB logical/physical sector block device. Then
> userspace and the filesystem will magically just do the right thing.

That is a sensible thing to me, I just wonder if there are some use
cases for users who want to opt-in for the pain to and want to accept
the 4k writes. It would be silly, but alas possible.

After thinking about this a bit, I don't think the pain of flexibility
is worth it. All userspace applications looking to do correct alignement
will use the logical block size, and if we keep that at 4k, and expect
them only to use the physical block sizes, it's just asking for pain.

> We've already solved these problems, yes?

I agree, I figured the above might need some discussion.

> > Note
> > then that there are two ways to be able to use a sector size of 16k
> > for NVMe today then, one is if your drive supported 16 LBA format and
> > another is with these two parameters set to 16k. The later allows you
> > to stick with 512 byte or 4k LBA format and still use a 16k sector size.
> > That allows you to remain backward compatible.
> 
> Yes, that's an emulated small logical sector size block device.
> We've been supporting this for years - how are these NVMe drives in
> any way different? Configure the drive this way, it presents as a
> 512e or 4096e device, not a 16kB sector size device, yes?

Yup.

> > Jan Kara's patches "block: Add config option to not allow writing to
> > mounted devices" [2] should allow us to remove the set_blocksize() call
> > in xfs_setsize_buftarg() since XFS does not use the block device cache
> > at all, and his pathces ensure once a filesystem is mounted userspace
> > won't muck with the block device directly.
> 
> That patch is completely irrelevant to how the block device presents
> sector sizes to userspace and the filesystem. It's also completely
> irrelevant to large block size support in filesystems. Why do you
> think it is relevant at all?

Today's set_blocksize() call from xfs_setsize_buftarg() would limit
the block size set for the block device cache, ie, the sector size to
be lifted. Removing it would help allow us to extend the block device
cache to use sector sizes > 4k. That is, it is just one small step in that
direction. The other step is, as you have suggested before, to
enhance the block device cache so that we always use iomap aops and
and switch from iomap page state to buffer heads in the bdev mapping
interface via a synchronised invalidation + setting/clearing
IOMAP_F_BUFFER_HEAD in all new mapping requests [0]: that is to
implement support for bufferheads through the existing iomap
infrastructure.

A second consideration I had was if we wanted to have the flexibility to
have 16k atomic capable drive to allow 4k writes even though it also
prefers 16k, but that I think leads to madness. I am not sure if we
want to allow a 4k write on those drives just because its possible
through any new means.

> I'm not sure exactly what is being argued about here, but if the
> large sector size support requires filesystem utilities to treat
> 4096e NVMe devices differently to existing 512e devices then the
> large sector size support stuff has gone completely off the rails.

It is not.

> We already have all the mechanisms needed for optimising layouts for
> large physical sector sizes w/ small emulated sector sizes and we
> have widespread userspace support for that. If this new large block
> device sector stuff doesn't work the same way, then you need to go
> back to the drawing board and make it work transparently with all
> the existing userspace infrastructure....

The only thing left worth discussing I think is if we want to let users to
opt-in to 4k sector size on a drive which allows 16k atomics and
prefers 16k for instance...

My current thinking is we just stick to 16k logical block sizes for
those drives. But I welcome further arguments against that.

  Luis
