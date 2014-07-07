From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 10:20:30 +0100
Message-ID: <20140707092029.GA19630@localhost.localdomain>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbaGGJUe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 05:20:34 -0400
Content-Disposition: inline
In-Reply-To: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Jul 06, 2014 at 01:18:03AM +0800, loody wrote:
> hi all:
>     we met a USB Hard Disk that will go to suspend if host stop
> sending scsi command over 5mins.
>     To save the IO, kernel will keep the file in page cache as much as
> he can and under this circumstances, the scsi command may disappear
> for a while longer enough to cause the device suspend.
> 
>     is there any kernel config or module parameter can do the dummy
> read or scsi command periodically?

No but you could set up a simple cron job to call an sg3_utils command.

E.g. issue an sg_read for one sector to the device every 4m:

  */4 * * * * sg_read count=1 if=/dev/<disk>

You'll probably want to disable mail notification for the job or have
it dropped or it'll get a bit noisy running that frequently.

Regards,
Bryn.

