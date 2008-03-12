From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [pnfs] [PATCH 05/28] pnfsblock: expose scsi interface
Date: Wed, 12 Mar 2008 18:42:29 -0400
Message-ID: <47D85C55.5060101@garzik.org>
References: <1205263929-8346-1-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-2-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-3-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-4-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-5-git-send-email-iisaman@citi.umich.edu> <1205263929-8346-6-git-send-email-iisaman@citi.umich.edu> <47D805DE.9000100@panasas.com> <20080312164306.GA3519@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52530 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYCLWmn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 18:42:43 -0400
In-Reply-To: <20080312164306.GA3519@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Benny Halevy <bhalevy@panasas.com>, Fred Isaman <iisaman@citi.umich.edu>, Andy Adamson <andros@umich.edu>, pnfs@linux-nfs.org, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Wed, Mar 12, 2008 at 06:33:34PM +0200, Benny Halevy wrote:
>> This calls for a layering violation.
>>
>> To fill-in more context, here's an excerpt from the next patch,
>> showing how you use shost_class to scan all scsi disks:
> 
> Yes, absolutely.  No one outside of few places in the core scsi code
> should ever iterate over the scsi disks.
> 
>> My question is how should a proper API between the scsi layer and
>> the block layout driver look like?
>>
>> Can you list your requirements, e.g.:
>> - scanning all available devices,
>>
>> - discovering new devices on the fly
>>
>> - getting notified for new devices?
> 
> Neither.  pnfs shouldn't open block devices from kernelspace at all,
> but do it's disovery in userspace.
> 
> Or even better this whole block layout driver crap should go away
> completely and the people who have designed it beaten up until they
> aren't recognizable anymore.

The fact that NFSv4.1 requires SCSI is stupid crap, too.

The _design_ is a layering violation.  I say we just say "no".

NFS _clients_ should not need to know deep device-level details about 
how to store their data, and should not require SCSI in order to store data.

	Jeff



