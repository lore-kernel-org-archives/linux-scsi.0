From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12120] [Block layer or SCSI] requests aborted too early
	during check_partition()
Date: Sun, 30 Nov 2008 10:16:37 -0600
Message-ID: <1228061797.4115.18.camel@localhost.localdomain>
References: <20081129193241.9EC3B10800F@picon.linux-foundation.org>
	 <1227988491.4636.14.camel@localhost.localdomain>
	 <tkrat.08c6487c76d999a8@s5r6.in-berlin.de>
	 <1228003702.4636.29.camel@localhost.localdomain>
	 <49326062.6000800@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50770 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbYK3QQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:16:36 -0500
In-Reply-To: <49326062.6000800@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sun, 2008-11-30 at 10:44 +0100, Stefan Richter wrote:
> James Bottomley wrote:
> > Theory number two is a block timeout cockup.  It looks like
> > sdev->timeout is vestigial and has zero value, so we shouldn't be using
> > it in the start command, so try this.
> > 
> > If this works, the correct fix will be to kill the sdev timeout
> > parameter so we get a compile failure where anything tries to use it.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 3863617..de3f6d0 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -933,7 +933,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
> >  
> >  		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
> >  			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> > -						scmd->device->timeout, 0);
> > +						3*SENSE_TIMEOUT, 0);
> >  
> >  		if (rtn == SUCCESS)
> >  			return 0;
> > 
> > 
> 
> Yes, this works with all of the SBP-2 bridges here which exhibit this
> false TEST UNIT READY "GOOD" status.
> 
> BTW, 3 * SENSE_TIMEOUT == 30 seconds may actually be a little bit narrow
> as a START UNIT timeout.  The disks which I tested here --- a few 7200
> RPM IDE or SATA disks behind the SBP-2 bridges --- usually take about 7
> seconds to spin up in single-disk enclosures and 14 seconds in dual-disk
> enclosures, since the bridge spins them up serially.  But a dual-disk
> enclosure with Hitachi Deskstar 7K400 took 28 seconds.  Maybe this
> should be used in scsi_eh_try_stu:
> include/scsi/scsi.h:#define START_STOP_TIMEOUT          (60 * HZ)

Actually, unfortunately not.  This feature isn't designed to spin up non
standards compliant devices, it's designed to restart automatically
stopping media.  As such, the timeout is going to have to go back to
being the queue timeout ... it's just that this exposes a few more
problems than firewire.

James


