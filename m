From: "Andreas Herrmann" <AHERRMAN@de.ibm.com>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: Tue, 5 Aug 2003 09:26:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF9404399C.2F79915F-ONC1256D79.00285DC0@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-2.de.ibm.com ([194.196.100.235]:41369 "EHLO
	d12lmsgate-2.de.ibm.com") by vger.kernel.org with ESMTP
	id S272535AbTHEH0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 03:26:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

        Jeff Garzik <jgarzik@pobox.com>
        08/04/03 05:48 PM
 
> On Mon, Aug 04, 2003 at 05:42:51PM +0200, Andreas Herrmann wrote:
> > Hi,
> > 
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

> For most cases you _should_ block until another command is completed, at
> the very least.  Retrying the command immediately is _exactly_ the
> situation one wishes to avoid, when returning a QUEUE_FULL result!

>    Jeff


        ... until another command is completed ...

... which will never happen, because there was a QUEUE_FULL for the
last command for the device.  The device will be blocked. No further
commands are sent. Bad luck?

OK, retrying seems not to be nice. But better retry than blocking the
device for ever ...

BTW, the condition

                if (cmd->device->device_busy == 0)

is never met. device_busy is always > 0 if there is at least 1 command.
(Or missed I something here?)

So, I just assume: The intention of the writer of the original code was
exactly what I proposed with the patch.


Regards,

Andreas
