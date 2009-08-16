From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sun, 16 Aug 2009 09:00:35 -0400
Message-ID: <4A8802F3.6010908@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:48737 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZHPNAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Aug 2009 09:00:35 -0400
In-Reply-To: <20090816022500.GA12392@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

Christoph Hellwig wrote:
> On Sat, Aug 15, 2009 at 10:19:21PM -0400, Mark Lord wrote:
>> Mark Lord wrote:
>>> Christoph Hellwig wrote:
>> ..
>>>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>>>> bit and then call the attached little trim.c program on the mountmoint
>>>> (or any file inside the filesystem for that matter)
>>> ..
>>>
>>> Looking at it now.  Thanks, Christoph!
>> ..
>>
>> Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
>> Rebuilding with 32-bit kernel now..
> 
> The actual ioctl is compatible, just add the
> 
> 	case XFS_IOC_TRIM:
> 		return xfs_ioc_trim(mp, arg);
> 
> to xfs_file_compat_ioctl().  I'll add this to the next spin of the patch.
..

Okay, this gives me ENOSYS now --> discard/trim support is missing from
the lower layers.

What other patches do I need to make this work?

The latest from Matthew's discard tree (May 2009) don't appear to be sufficient,
even after updating them for 2.6.31-rc6.

???
