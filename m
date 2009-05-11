From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 09:15:57 -0400
Message-ID: <4A08250D.1010902@redhat.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20090511120936.GB6277@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/11/2009 08:09 AM, Theodore Tso wrote:
> On Mon, May 11, 2009 at 07:27:29AM -0400, Theodore Tso wrote:
>> I believe the ATA TRIM draft standards specs don't have the 1-4
>> megabyte; that craziness is only coming from the SCSI world.  So we do
>           ^^^^  I left out the worlds "granularity requirement", sorry.
>
>> have more information than what Intel has released; also, note that
>> OCZ is the first vendor who has shipped publically available SSD
>> firmware with Trim support.  Supposely Intel is going to try to get me
>> their trim-enabled firmware under NDA, but that hasn't happened yet.
>
> I just did a bit more web browsing, and it appears that OCZ's
> userspace support for trim is currently Windows-only, and they've
> implemented it by taking the filesystme off line, and running a
> userspace utility that sends TRIM requests for all of the free space
> on the drive.
>
> After doing this, write speeds for sequential writes, random 512k
> writes, and random 4k writes all went up by approximately 15-20% on
> the OCZ Vertex, at least according to one user who did some
> benchmarks.  I'm not sure how repeatable that is, and how many random
> writes you can do before performance levels fall back to the pre-TRIM
> levels.
>
> It's also supported only on 32-bit Windows XP.  On 64-bit platforms,
> there seems to be an unfortunate tendency (probability around 50%)
> that the TRIM enablement software trashes the data stored on the SSD.
> So there is currently a warning on the OCZ discussion web forum that
> the tools should only be used on 32-bit Windows platforms.
>
> All of the web browsing I've doen confirms that the ATA folks expect
> trim to work on 512-sector granularity.  It's only the lazy b*stards
> who don't want to change how their large high-end storage boxes work
> that are trying to push for 1-4 megabyte alignment and granularity
> requirements in the SCSI standards.  I'm not that worred about the
> crappy flash devices (mostly SD and Compact flash devices, not SSD's)
> that don't do sub-erase block wear-leveling and management; those will
> probably get weeded out of the market pretty quickly, since SSD's that
> crappy will have really lousy small random write performance as well,
> and web sites like Anandtech and PC Perspectives have picked up on why
> that really hurts your OS performance on said crappy SSD's.
>
> 						- Ted

I don't think that the large arrays are being lazy - it is more a matter of 
having to track an enormous amount of storage and running out of bits. There has 
been some movement towards using smaller erase chunk sizes which should make 
this less of an issue.

One thing that will bite people in the SCSI space might be the WRITE_SAME with 
discard bit set. (Adding linux-scsi to this thread)

On the plus side, this has very clear semantics. but if you send down requests 
that are not aligned or too small, the device will have to "zero" the contents 
of the specified sectors in order to be compliant if I understand correctly.

In this case, coalescing would almost always be a win as well,

ric

