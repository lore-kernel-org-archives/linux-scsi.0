From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: do not print 'reservation conflict' for TEST UNIT
 READY
Date: Tue, 13 Sep 2016 12:20:58 -0700
Message-ID: <1473794458.2214.89.camel@HansenPartnership.com>
References: <1473668453-115818-1-git-send-email-hare@suse.de>
         <1473775496.2214.6.camel@HansenPartnership.com>
         <18995c82-c3b1-89f1-9336-dafe9169963c@suse.de>
         <1473779178.2214.9.camel@HansenPartnership.com>
         <1473793540.4648.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34198 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755419AbcIMTVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 15:21:00 -0400
In-Reply-To: <1473793540.4648.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, 2016-09-13 at 15:05 -0400, Ewan D. Milne wrote:
> On Tue, 2016-09-13 at 08:06 -0700, James Bottomley wrote:
> > On Tue, 2016-09-13 at 16:24 +0200, Hannes Reinecke wrote:
> > > On 09/13/2016 04:04 PM, James Bottomley wrote:
> > > > You could argue that the entire message needs removing, since
> > > > it's
> > > > reporting stuff that mostly only shows when systems using 
> > > > reservations correctly are in operation.
> > > > 
> > > Oh, I'm perfectly fine with that.
> > > I'm happy to send a patch removing that line altogether.
> > 
> > OK, how about lowering the priority to KERN_DEBUG so it can still
> > be
> > seen, just not usually.
> > 
> > James
> > 
> 
> So, if we do this, and someone else does a SCSI-2 RESERVE on the LUN
> while we have a file system mounted, what error will we end up
> getting?
> I would assume that we would still see the usual SCSI error message
> with the CDB printed, and that the "reservation conflict" message was
> supplemental?  Or does the message get suppressed?  I'll have to try
> this...

It will print out the CDB and the return code, which should say Read
(or Write) [ACTION_FAIL in scsi_io_completion()].  However, it looks
like scsi_print_result() doesn't actually print the device byte, which
is where the reservation conflict is, so perhaps that should also be
fixed.

James

