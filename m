From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: do not print 'reservation conflict' for TEST UNIT
 READY
Date: Tue, 13 Sep 2016 07:04:56 -0700
Message-ID: <1473775496.2214.6.camel@HansenPartnership.com>
References: <1473668453-115818-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59868 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751567AbcIMOFA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 10:05:00 -0400
In-Reply-To: <1473668453-115818-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, 2016-09-12 at 10:20 +0200, Hannes Reinecke wrote:
> SPC-2 and SPC-3 (or later) differ in the handling of reservation
> conflict for TEST UNIT READY. SPC-2 will return 'reservation 
> conflict', whereas SPC-3 will return GOOD status.
> On a mixed system with both SPC-2 and SPC-3 targets one will
> see lots of 'reservation conflict' messages from the SPC-2 system but
> no messages from the SPC-3 system when eg multipath path checkers.
> These messages might confuse the unsuspecting user although in fact
> they just signal normal operation.

I don't agree with this: a SCSI-2 device will not get properly
configured if it's reserved by something else, so you get other strange
artifacts of this condition.

> So we should not be printing out 'reservation conflict' for
> TEST UNIT READY responses.

This doesn't sound like a good rationale to me.  The way I see it, if
this message is actually useful, people would like to see it when they
get a reservation conflict.  That does mean even when SCSI-2
reservations give one where SCSI-3 would not.  The other reason is that
it tells you why your device didn't get configured properly: both Test
Unit Ready and Read Capacity get conflicts with SCSI-2, whereas they do
with SPC-3+ devices (trying to forget SPC-2).

You could argue that the entire message needs removing, since it's
reporting stuff that mostly only shows when systems using reservations
correctly are in operation.

James

