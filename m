From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Wed, 28 Jan 2004 08:41:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128084142.A4835@beaverton.ibm.com>
References: <20040127003244.GM23308@serve.riede.org> <20040128033041.GY23308@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:12928 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266005AbUA1QmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 11:42:11 -0500
Content-Disposition: inline
In-Reply-To: <20040128033041.GY23308@serve.riede.org>; from wrlk@riede.org on Tue, Jan 27, 2004 at 10:30:41PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 27, 2004 at 10:30:41PM -0500, Willem Riede wrote:
> On 2004.01.26 19:32, Willem Riede wrote:
> > Jan 26 17:13:23 fallguy kernel: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344

I was trying to figure out what happened, apparently I missed a check when
splitting the locks up and removing a lock hiearchy.

Per changeset 1.75.1.8, at this link:

http://linux.bkbits.net:8080/linux-2.5/diffs/drivers/scsi/scsi_lib.c@1.75.1.8?nav=index.html|src/|src/drivers|src/drivers/scsi|hist/drivers/scsi/scsi_lib.c

We should only clear starget_sdev_user when the sdev has no more IO. We
want to run (a bunch of) IO for a given starget_sdev_user, and when there is
no more IO, clear starget_sdev_user so someone else has a chance to run.

I'm trying to figure out a fix without adding any lock hiearchy. queue_lock
protects device_busy, but host_lock protects starget_sdev_user.

The single lun devices and code are annoying :-(

Do you know if the single lun code is for performance, or because of
hardware limitations - that is we don't want a disc change between IO, or
does the device just fail?

> scsi_lib.c contains the following code:
> 
>                 spin_lock(shost->host_lock);
>                                                                                                                         
>                 spin_unlock_irq(shost->host_lock);
> 
> 
> Is it a problem that the lock is taken by means of spin_lock() and then
> released with spin_unlock_irq() ? We do need to lock against scsi_softirq
> as in the backtrace above...

No, the previous unlock kept interrupts disabled, the code path looks like:

	spin_lock_irq(q->queue_lock);
	...
	spin_unlock(q->queue_lock);
	spin_lock(shost->host_lock);
	...
	spin_unlock_irq(shost->host_lock);

-- Patrick Mansfield
