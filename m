From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: 04 Aug 2003 11:05:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060013144.2008.28.camel@fuzzy>
References: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:18181 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S271825AbTHDQFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2003 12:05:54 -0400
In-Reply-To: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-08-04 at 10:42, Andreas Herrmann wrote:
> I observed the following problem:
> A device was marked as blocked after a QUEUE_FULL status code
> was returned for the last scsi command for a device.
> And there's a snag to it -- because no further commands are pending
> for that device, the device is not set unblocked anymore.
> 
> Solution is:
> Do not block the device/adapter if getting QUEUE_FULL status code
> for the last pending command of that device/adapter, but retry
> the command.

This looks like 2.4 code, right?

The problem was fixed long ago in 2.5.

The fix you propose for 2.4 isn't optimal (although it is what 2.4 does
for the busy case) because the mid-layer will bang the drive in a tight
loop until it can accept the command.

You could try backporting the 2.5 fix.  What we do there is to plug the
queue and then count down (from 7 for host busy or 3 from device busy)
replugging each time.  That gives a non-busy delay which is directly
proportional to the I/O pressure in the system.

James


