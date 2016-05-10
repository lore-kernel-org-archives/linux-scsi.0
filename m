From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Application error handling with write-back caching
Date: Tue, 10 May 2016 22:12:15 +0200
Message-ID: <5732409F.6050706@redhat.com>
References: <20160510134737.GA1922@stefanha-x1.localdomain>
 <1462889808.2320.4.camel@HansenPartnership.com> <57320F7D.4010208@redhat.com>
 <1462901500.3163.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38073 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbcEJUMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 16:12:22 -0400
Received: by mail-wm0-f50.google.com with SMTP id g17so47285622wme.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2016 13:12:21 -0700 (PDT)
In-Reply-To: <1462901500.3163.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kevin Wolf <kwolf@redhat.com>



On 10/05/2016 19:31, James Bottomley wrote:
> > What about a SPACE ALLOCATION FAILED error or a similar error that 
> > can be fixed by administrator actions (or just by a concurrent 
> > process doing an UNMAP)?  Would a subsequent cache flush cause data
> > loss?
>
> You're now asking about how these are handled?  It's not a SCSI
> problem.  I believe if you look at the various layers, RAID would still
> treat it as fatal and fail the drive and so would most filesystems. 
> The AEN warnings for TP are reported, but the admin has to sort it out
> before they become a fatal error.

Thanks, fatal errors are fine I guess.  We were worried that the next
SYNCHRONIZE CACHE would succeed and throw away the writes because it has
already "performed a write medium operation".

POSIX fsync is pretty underspecified in this respect too; gluster has
been throwing away those writes for a long time!  It stopped now because
we explained the issue to them, but it's pointless if the next layer
below does the same---hence Stefan's question.

(In our case the next layer is not the page cache, because we generally
use O_DIRECT.  Evicting dirty pages from the page cache would be okay if
the process(es) that wrote them are SIGKILLed, but in general it would
be a problem too).

Thanks,

Paolo
