From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 7 Nov 2003 09:30:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031107093010.A1950@infradead.org>
References: <20031027153932.A16679@infradead.org> <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com> <20031106100906.A15382@infradead.org> <3FAB5DE5.2080000@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:44817 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263976AbTKGJaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 04:30:13 -0500
Content-Disposition: inline
In-Reply-To: <3FAB5DE5.2080000@torque.net>; from dougg@torque.net on Fri, Nov 07, 2003 at 06:55:01PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Fri, Nov 07, 2003 at 06:55:01PM +1000, Douglas Gilbert wrote:
> > I think we should handle it in the midlayer.  Could you come up with a
> > patch to implement it?
> 
> Interesting challenge. For a start START_STOP UNIT ** is a SBC-2
> command so the mid-layer shouldn't be generating it, the
> sd driver should. The sd_rw_intr() function in the sd driver
> could be made to detect ASC/ASCQ=04/02 but it is pretty obviously
> executing in interrupt context. The sd driver has a tailor made
> routine to spin up a disk called sd_spinup_disk() but since it
> calls schedule_timeout() it must be called from process context.

We could call sd_spinup_disk from schedule_work.  This still seems
better than having a thread in a LLDD just for this.

> Also once a spinup has commenced, it will take about 30
> seconds to complete. In that time an impatient user could
> try and mount a different partition on the same disk.
> That process should see a ASC/ASCQ=04/01 ("Logical unit is in
> process of becoming ready") and it should wait till it
> clears (and not issue another spinup).
> 
> Seems like some infrastructure changes would be needed.
> 
> Testing with lk 2.6.0-test9: spinning down a disk that
> the scsi subsystem had already seen but with nothing mounted
> on it, then trying to mount a partition on it, causes a lot
> of ugly messages in my log (at least the machine didn't crash).

Looks like we need to handle that case anyway..

> ** There is also the Power Condition mode page that all SCSI
> devices may optionally support. Trouble is with my SCSI-3 disks
> they either don't support it or the one that does gives
> ASC/ASCQ=04/02 when the disk is spun down (violating SPC-3).

Interesting.  Now that the scsi_device is part of the driver model
we could actually do some fancy things about spinning down disks
in a controlled mannor on suspend and wake them up again on
resume.


