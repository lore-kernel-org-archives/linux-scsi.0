From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 09:31:11 -0500
Message-ID: <1208097071.4707.21.camel@localhost.localdomain>
References: <47F95F5C.500@sauce.co.nz>  <20080407010453.GA1952@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49888 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYDMObQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 10:31:16 -0400
In-Reply-To: <20080407010453.GA1952@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

On Sun, 2008-04-06 at 21:04 -0400, Wakko Warner wrote:
> > From the message you posted, it looks as though there may be a problem 
> > with sda.
> 
> It's working fine with /sys/block/sd[abc]/device/queue_depth = 1 (on boot up,
> as stated before, it's 64)
> 
> I performed the same copy again with queue_depth=1 after the array rebuilt.
> It worked fine then.  No errors.

Actually, I'd say this is a signal for NCQ errors with the drive.

I'm afraid only LSI would be able to say for certain, because the mptsas
implements its NCQ handling in firmware.  libata-core doesn't show any
special workarounds for your device (ST3750640AS) but that doesn't mean
there isn't a problem.  If it's really an NCQ implementation issue, then
clamping the queue depth to 1 is about the only fix, I'm afraid.

James


