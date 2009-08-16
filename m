From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sat, 15 Aug 2009 22:25:00 -0400
Message-ID: <20090816022500.GA12392@infradead.org>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A876CA9.20906@rtr.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 15, 2009 at 10:19:21PM -0400, Mark Lord wrote:
> Mark Lord wrote:
>> Christoph Hellwig wrote:
> ..
>>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>>> bit and then call the attached little trim.c program on the mountmoint
>>> (or any file inside the filesystem for that matter)
>> ..
>>
>> Looking at it now.  Thanks, Christoph!
> ..
>
> Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
> Rebuilding with 32-bit kernel now..

The actual ioctl is compatible, just add the

	case XFS_IOC_TRIM:
		return xfs_ioc_trim(mp, arg);

to xfs_file_compat_ioctl().  I'll add this to the next spin of the
patch.

