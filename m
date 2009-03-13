From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Questions about  [SCSI] modify scsi to handle new fail fast
	flags.
Date: Fri, 13 Mar 2009 16:24:21 +0000
Message-ID: <1236961461.3276.82.camel@localhost.localdomain>
References: <20090313153757.GA11370@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51286 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbZCMQYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Mar 2009 12:24:25 -0400
In-Reply-To: <20090313153757.GA11370@mars.virtualiron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Fri, 2009-03-13 at 11:37 -0400, Konrad Rzeszutek wrote:
> Hey Mike,
> 
> I was having a problem with one of the SATA controllers at work and traced it
> down to enclosure. But during that time I found out that the error handler
> of bio's issued from SCSI block vs the multipath block driver act differently.
> 
> The "scsi_eh_flush_done_q" is the one that controls whether the I/Os should
> be repeated or returned back. Earlier in the days it would check the
> bio->flags to see if the REQ_FAILFAST* attributes were set, but nowadays
> it is more discriminating and depending on the host_byte(scmd->result) figures
> out if needs to check for the REQ_FAILFAST* attribute.
> 
> The end result is that the bio's mapped through multipath have the same
> logic as through the SCSI block. Compared to Linux releases in RHEL53, SLES10
> the behaviour is different.
> 
> So my question is that OK? From the perspective of dm-mpath it looks as
> if the device driver now does the retry/re-issue and ignores the FAILFAST
> attribute. Instead of allowing dm-mpath to be the ...umm "brain" behind this.

I can try:  SCSI errors fall into three categories:

     1. Driver or Host (as in kmalloc failed while the driver was
        sending the packet out or the driver firmware failed and needs
        resetting).
     2. Transport errors (Parity/CRC error on the bus, transport failed
        to connect to end device etc)
     3. Device errors (device actually responded with an error, like
        MEDIUM_ERROR or NOT_READY).

You can see that errors in category 3 (Device) aren't going to change if
you simply change path, so we should be doing normal error handling.
Likewise, errors in category 1 (Driver or Host) are in the same bucket;
worse, some errors in this category (like firmware failure) need SCSI
error handling to fix: if we switch path they never recover and your
availability reduces.

The idea of the changes were to separate known transport errors (which
could be fixed by switching paths) from other errors which couldn't and
should still be handled via normal eh procedures (previously we'd just
switched paths for every retryable error and never got around to
actually seeing if the SCSI error handler could fix it).

James


