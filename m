From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Application error handling with write-back caching
Date: Tue, 10 May 2016 18:42:37 +0200
Message-ID: <57320F7D.4010208@redhat.com>
References: <20160510134737.GA1922@stefanha-x1.localdomain>
 <1462889808.2320.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbcEJQmm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2016 12:42:42 -0400
In-Reply-To: <1462889808.2320.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Wolf <kwolf@redhat.com>



On 10/05/2016 16:16, James Bottomley wrote:
> > If "is performed" just means "completes", maybe with an error, the
> > application would have to resubmit write requests and then try to 
> > flush the write cache again.
> > 
> > I'm not aware of applications that keep acknowledged write data 
> > around until the cache flush completion in order to retry writes.
> 
> I think you may be misunderstanding the nature of the returned error. 
> It will be permanent and fatal and usually signal that the device has
> a failed sector that can't be remapped and so the device itself has for
> most purposes failed.  The only recovery is if you happen to have RAID,
> in which case the RAID layer will mostly take care of it.

What about a SPACE ALLOCATION FAILED error or a similar error that can
be fixed by administrator actions (or just by a concurrent process doing
an UNMAP)?  Would a subsequent cache flush cause data loss?

Paolo
