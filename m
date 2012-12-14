From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 10:44:34 +0100
Message-ID: <50CAF502.3070300@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:36919 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2LNJol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 04:44:41 -0500
In-Reply-To: <20121213164912.GA28496@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/13/12 17:49, Christoph Hellwig wrote:
> On Thu, Dec 13, 2012 at 05:47:14PM +0100, Bart Van Assche wrote:
>>  From my experience with block and SCSI drivers option (1) doesn't
>> look attractive from a performance point of view. From what I have
>> seen performance with QD=1 is several times lower than performance
>> with QD > 1. But maybe I overlooked something ?
>
> What you might be missing is that at least on Linux no one who cares
> about performance uses the Posix AIO inferface anyway, as the
> implementation in glibc always has been horrible.  The Linux-native
> aio interface or the various thread pool implementations don't imply
> useless ordering and thus can be used to fill up large queues.

Some applications need write ordering without having a need for 
enforcing durability as fsync() does [1]. What I'm wondering about is 
whether an operating system kernel like the Linux kernel should penalize 
application performance when using block drivers and storage hardware 
that preserve the order of write requests because there exist other 
drivers and storage devices that do not preserve the order of write 
requests ?

[1] Richard Hipp, Re: [sqlite] SQLite on flash (was: [PATCH 00/16] f2fs: 
introduce flash-friendly file system), October 10, 2012 
(http://www.mail-archive.com/sqlite-users@sqlite.org/msg73033.html).

Bart.
