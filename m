Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59003CA6B;
	Thu,  7 Mar 2024 01:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709776749; cv=none; b=OhmB+7mUJiGd7FQ0w7H6rW869xNSzgoTNdxksSV0Rk0Zdru2A8xkD3ziyWXuXywkf3JVKb1mvXDfS5ikqCC74LjYgi8TVoi9Oob/mkBDt21vHrc1nPlk6K2rp1iHJ6awuXjGCElk+A0WTii6o1IwD3+IpJEXwqlj8Py8ApnUqkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709776749; c=relaxed/simple;
	bh=236tVDb4U1LcEiJBpsm+q4ct07N6o1bd5xOTP4Dkl18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ohm/JP55i4PuQBT6VpXhbvV/hXSoUCK9uecxGis9XxklPvIXwyEOQNSS4HGsoXkoULiLq7U2slFeM5vk2As/YIa8OSyOs5z9RpAneZXA/O2F1t9zWYXEGgBgQA9KhYaNwv7yxk85ci0qMhv7iWguVEBXeemFWhTguBkQHQT8fAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rnQ8rWYk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rnQ8rWYk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2LrjpQ6/KtNA+kwv00MlTGCntAINDPjFBfmLOW4/G3E=; b=rnQ8rWYkh77vhJ6Qj/KIb/FLmq
	fa6QcqGTw27arOVKzPFDRJCt52oyGUm3rrg7+Sx3jtzsZcZ33JeawNYq5ugcb33TNddiP1AjdPdDg
	A8Xz5oIKi69soesOwS5phyWsnvY92sq4L+1ZYEckkdhqldSJ5smooYc7uM0/I3lcIR4eRAIqs2cAr
	bgdlHe5MuqflQhqBJDRu0z+XRJSWsEP1+jHSNXWnuZCXZwcEpXwEYmJl9Pg7p98UHW65OixkOlsjR
	54asRFCGbABTjYRFZxVZ96rnHZ9B9DeMG0fKbYR7wQYMgcs4ExvwlIua19IT0cloVkisaJW+Hi7uS
	VbXhw1Zg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ri32D-00000002aQi-20ZG;
	Thu, 07 Mar 2024 01:59:01 +0000
Date: Wed, 6 Mar 2024 17:59:01 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>,
	"kbus >> Keith Busch" <kbusch@kernel.org>,
	NeilBrown <neilb@suse.de>, Tso Ted <tytso@mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, Jan Kara <jack@suse.cz>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@infradead.org>,
	Hannes Reinecke <hare@suse.de>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZekfZdchUnRZoebo@bombadil.infradead.org>
References: <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org>
 <ZYUgo0a51nCgjLNZ@infradead.org>
 <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>
 <ZZxOdWoHrKH4ImL7@casper.infradead.org>
 <ZdeWRaGQo1IX18pL@bombadil.infradead.org>
 <ZdvIlLbhtb7+1CTx@dread.disaster.area>
 <ZdytYs8W9o0CIu_C@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdytYs8W9o0CIu_C@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Feb 26, 2024 at 07:25:23AM -0800, Luis Chamberlain wrote:
> The only thing left worth discussing I think is if we want to let users to
> opt-in to 4k sector size on a drive which allows 16k atomics and
> prefers 16k for instance...

Thinking about this again, I get a sense things are OK as-is but
let's review. I'd also like to clarify that these drives keep a 4k
LBA format. The only thing that changes is an increased is the the IU
and large atomic. The nvme driver today sets the physical block size
to the min of both.

It is similar to a drive today with a logical block size of 512 but a
physical block size of 4k. That allows you to specify a larger sector
size to create the filesystem.

After reviewing again our current language for syfs parameters in
Documentation/ABI/stable/sysfs-block for logical and physical block size
and how nvme_update_disk_info() deals with NPWG (the IU used), NAWUPF
(namespace atomic) and NOWS (optimal write size), we seem to be using
it aready appropriately. However, I think the language used in the
original commit c72758f33784e ("block: Export I/O topology for block
devices and partitions") on May 22, 2009, which clearly outlined
the implications of a read-modify-write makes it even clearer.
A later commit 7e5f5fb09e6fc ("block: Update topology documentation") 3
months later updates the documentation to remove the read-modify-write
language in favor of "atomic".

Even though we'd like to believe that userspace is doing the right thing
today, I think it would be good to review this today and ensure we're
doing the right thing to make things transparent.

We have two types large capacity NVMe drives to consider. As far as I
can tell all drives will always supporting 512 or 4k LBA format which
controls the logical block size, so they always remain backward
compatible. It would be up to users to format the drives to 512 or 4k.

One type of drive is without the large NAWUPF (atomic), and another with it.
Both will have a large NPWG (the IU). The NPWG is used to set minimum_io_size,
and so, using the original commit's langauge for minimum_io_size, direct IO
would benefit best to rely on that as a minimum.

At least Red Hat's documentation [0] about this suggests that minimum_io_size
will be read by userspace but at least for direct IO it suggests that
direct IO must be aligned to *mutiples of the logical block size*.
That does not clarify to me however if the minimum IO used in userspace
today for direct IO will rely on minimum_io_size. If it is, then things
will work optimally for these drives already.

When a large atomic is supported (NAWUPF) the physical block size will be
lifted, and users can use that to create a filesystem with a larger
sector size than 4k. That certainly would help ensure at least the
filesystem aligns all metadata and data to the large IU. After Jan
Kara's patches which prevent writes to the block device once a
filesystem is mounted, userspace would not be allowed to be mucking
around with the block device, so userspace IO using the raw block device 
with, say a smaller logical sector size would not be allowed. Since,
in these cases the sector size is set to a larger value for the filesystem,
direct IO on the filesystem should respect that preferred larger sector size.

If userspace is indeed already relying on minimum_io_size correctly I am
not sure if we need to do any change. Drives with a large NPWG would get
minimum_io_size set for them already. And a large atomic would just lift
the physical block size. So I don't think we need to force the logical
block size to be 16k of both NPWG and NAWUPF are 16k. *Iff* however, we
feel we may want to help userspace further, I wonder if having the option to
lift the logical block size to the NPWG is desriable.

I did some testing with fio against a 4k physical virtio drive with a
512 byte logical block size and creating a 4k block size XFS filesystem
with a 4k sector size. fio seems to chug along happy if you issue writes
with -bs=512 and even -blockalign=512.

Using Daniel Gomez's ./tools/blkalgn.py tool I still see 512 IO commands
issued, and I don't think they failed. But this was against a virtio
drive for convenience. QEMU in NVMe today doesn't let you have a
different logical block size than physical, so you'd need to do some
odd hacks to test something similar to emulate a large atomic.

root@frag ~/bcc (git::blkalgn)# cat
/sys/block/vdh/queue/physical_block_size 
4096
root@frag ~/bcc (git::blkalgn)# cat
/sys/block/vdh/queue/logical_block_size 
512

mkfs.xfs -f -b size=4k -s size=4k /dev/vdh

fio -name=ten-1g-per-thread --nrfiles=10 -bs=512 -ioengine=io_uring \
-direct=1 \
-blockalign=512 \
--group_reporting=1 --alloc-size=1048576 --filesize=8KiB \
--readwrite=write --fallocate=none --numjobs=$(nproc) --create_on_open=1 \
--directory=/mnt

root@frag ~/bcc (git::blkalgn)# ./tools/blkalgn.py -d vdh

     Block size          : count     distribution
         0 -> 1          : 4        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 0        |                                        |
        64 -> 127        : 0        |                                        |
       128 -> 255        : 0        |                                        |
       256 -> 511        : 0        |                                        |
       512 -> 1023       : 79       |****                                    |
      1024 -> 2047       : 320      |********************                    |
      2048 -> 4095       : 638      |****************************************|
      4096 -> 8191       : 161      |**********                              |
      8192 -> 16383      : 0        |                                        |
     16384 -> 32767      : 1        |                                        |

     Algn size           : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 0        |                                        |
        64 -> 127        : 0        |                                        |
       128 -> 255        : 0        |                                        |
       256 -> 511        : 0        |                                        |
       512 -> 1023       : 0        |                                        |
      1024 -> 2047       : 0        |                                        |
      2048 -> 4095       : 0        |                                        |
      4096 -> 8191       : 1196     |****************************************|

Userspace can still be do silly things, but I expected in the above that
512 IOs would not be issued.

[0] https://access.redhat.com/articles/3911611

  Luis
