From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 12:04:22 -0500
Message-ID: <49132396.4050405@redhat.com>
References: <4913028B.6010405@redhat.com>	<1225984628.4703.80.camel@localhost.localdomain>	<Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>	<491314B2.9040902@redhat.com> <yq18wrwn6yp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48328 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbYKFREf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2008 12:04:35 -0500
In-Reply-To: <yq18wrwn6yp.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

Martin K. Petersen wrote:
>>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:
>>>>>>             
>
> Ric> Big arrays have an internal "track" size that is much larger than
> Ric> 512 bytes (Symm for example is 64k. Everything smaller than that
> Ric> is a read-modify-write. Effectively, they have few to no bits
> Ric> left to track this other bit of state at the smal level of
> Ric> granularity.
>
> My point still stands that this is an implementation problem in the
> array firmware.  It's not really our problem to solve.  Especially
> since drive vendors and mid-range storage vendors are getting it
> right.
>
> If EMC wants to provide thin provisioning on the Symmetrix they'll
> have to overcome the inherent limitations in their own internal
> architecture.
>
> What's next?  Requiring us to exclusively read and write in multiples
> of block sizes that are artifacts of internal array implementation
> details?
>
> For thin provisioning to really work on the Symm, then, we're
> effectively requiring the filesystem to use 64k filesystem blocks.
> Lame!
>
> I don't have a problem with honoring some bits akin to the block
> device characteristics VPD in trying to do a best-effort scheduling of
> the I/O.  But effectively disabling thin provisioning for blocks
> smaller than that is simply broken.
>   

Actually, the big arrays have larger "unmap" chunks than the 64k, so it 
is even more painful than that :-)

What is likely to happen is that "thin" will work for vendors with this 
kind of limitation in a very limited way and they will need to have some 
kind of user space tool to clean up the mess.

ric

