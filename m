From: "Andreas Herrmann" <AHERRMAN@de.ibm.com>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: Tue, 5 Aug 2003 09:15:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFB8D09C1A.E75A6F97-ONC1256D79.00276F21@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate.de.ibm.com ([194.196.100.234]:46820 "EHLO
	d12lmsgate.de.ibm.com") by vger.kernel.org with ESMTP
	id S272478AbTHEHPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 03:15:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

        James Bottomley <James.Bottomley@SteelEye.com>
        08/04/03 06:05 PM

> On Mon, 2003-08-04 at 10:42, Andreas Herrmann wrote:
> > I observed the following problem:
> > A device was marked as blocked after a QUEUE_FULL status code
> > was returned for the last scsi command for a device.
> > And there's a snag to it -- because no further commands are pending
> > for that device, the device is not set unblocked anymore.
> > 
> > Solution is:
> > Do not block the device/adapter if getting QUEUE_FULL status code
> > for the last pending command of that device/adapter, but retry
> > the command.

> This looks like 2.4 code, right?

Right, the patch is against 2.4.21

> The problem was fixed long ago in 2.5.

> The fix you propose for 2.4 isn't optimal (although it is what 2.4 does
> for the busy case) because the mid-layer will bang the drive in a tight
> loop until it can accept the command.

The fix is short.
It works.
Has no severe side effects. (except the loop until the command is
accepted.)

> You could try backporting the 2.5 fix.  What we do there is to plug the
> queue and then count down (from 7 for host busy or 3 from device busy)
> replugging each time.  That gives a non-busy delay which is directly
> proportional to the I/O pressure in the system.

I could try, if I had time ... ;-)
But why backporting, if a "two-line-changing" patch will fix something,
that looks somehow strange in any case?
IMHO, the condition

                if (cmd->device->device_busy == 0)

is never met in scsi_mlqueue_insert(), because device_busy (same with
host_busy) is always > 0 if there is a command pending for a device 
(host).

> James


Regards,

Andreas
