From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: do not print 'reservation conflict' for TEST UNIT
 READY
Date: Tue, 13 Sep 2016 16:24:44 +0200
Message-ID: <18995c82-c3b1-89f1-9336-dafe9169963c@suse.de>
References: <1473668453-115818-1-git-send-email-hare@suse.de>
 <1473775496.2214.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37781 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbcIMOYq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 10:24:46 -0400
In-Reply-To: <1473775496.2214.6.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 09/13/2016 04:04 PM, James Bottomley wrote:
> On Mon, 2016-09-12 at 10:20 +0200, Hannes Reinecke wrote:
>> SPC-2 and SPC-3 (or later) differ in the handling of reservation
>> conflict for TEST UNIT READY. SPC-2 will return 'reservation 
>> conflict', whereas SPC-3 will return GOOD status.
>> On a mixed system with both SPC-2 and SPC-3 targets one will
>> see lots of 'reservation conflict' messages from the SPC-2 system but
>> no messages from the SPC-3 system when eg multipath path checkers.
>> These messages might confuse the unsuspecting user although in fact
>> they just signal normal operation.
> 
> I don't agree with this: a SCSI-2 device will not get properly
> configured if it's reserved by something else, so you get other strange
> artifacts of this condition.
> 
It's not about SCSI-2, it's for later arrays. See below.

>> So we should not be printing out 'reservation conflict' for
>> TEST UNIT READY responses.
> 
> This doesn't sound like a good rationale to me.  The way I see it, if
> this message is actually useful, people would like to see it when they
> get a reservation conflict.  That does mean even when SCSI-2
> reservations give one where SCSI-3 would not.  The other reason is that
> it tells you why your device didn't get configured properly: both Test
> Unit Ready and Read Capacity get conflicts with SCSI-2, whereas they do
> with SPC-3+ devices (trying to forget SPC-2).
> 
This specific issue occurred with a customer which had a mix of SPC-2
and SPC-3 arrays.
So I can't just 'forget' SPC-2 :-)
The system works just as designed, _except_ that one array is printing
this message (the SPC-2 one) whereas the other one doesn't.
So the message has zero value in this case.

> You could argue that the entire message needs removing, since it's
> reporting stuff that mostly only shows when systems using reservations
> correctly are in operation.
> 
Oh, I'm perfectly fine with that.
I'm happy to send a patch removing that line altogether.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
