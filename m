From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: unexpected scsi timeout
Date: Wed, 25 Jul 2007 09:06:41 -0400
Message-ID: <1185368801.3501.5.camel@localhost.localdomain>
References: <46A0A462.2090407@sw.ru> <46A5B632.8040201@gmail.com>
	 <46A5CF7B.40102@sw.ru> <46A6E4A4.6080608@tw.ibm.com>
	 <46A6FD8E.7090803@sw.ru>  <46A6FEED.2050403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46A6FEED.2050403@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Vasily Averin <vvs@sw.ru>, albertl@mail.com, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devel@openvz.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-07-25 at 16:42 +0900, Tejun Heo wrote:
> Vasily Averin wrote:
> > Albert Lee wrote:
> >>>> Vasily Averin wrote:
> >>>>> I've noticed that some scsi commands for DVD-drive attached to pata_via
> >>>>> successfully finishes without any delays but reports about TIMEOUT condition. It
> >>>>> happens because of ATA_ERR bit is set in status register. As result for each
> >>>>> command  Error Handler thread awakened, requests sense buffer and go to sleep again.
> >>>> Need more info.  Please post boot dmesg and the result of 'lspci -nn'
> >>>> and 'hdparm -I /dev/srX' and when such errors occur.
> >> Your log looks ok. It's normal for TEST_UNIT_READY to return ATA_ERR when no disc
> >> inside and libata EH triggered to request sense.
> > 
> > It's a bit strange for me, IMHO other scsi drivers requests sense buffer without
> > EH thread assistance.
> > Currently we know that ATA_ERR can be returned; it is not error, but one of
> > expected responses. Why we cannot request sense without EH? I would like to
> > understand is it implementation drawback or I missed something probably?
> 
> That was a design choice.  It's easier to implement that way.

And just so we're clear what SCSI allows:

On ordinary SCSI devices, when the device goes into a check condition
state, it won't accept any more commands until it sees a request sense.
For SCSI devices this can be a problem (because there are several
thousand sense conditions, some of which correspond to everything's
alright), so a large number of SCSI drivers implement auto request sense
emulation, which means that in the driver, as soon as they see the check
condition, they immediately send a REQUEST SENSE command to pick up the
sense code (minimising the time the device is blocked).

For drivers that don't want to implement this (and we have a few in
SCSI) the alternative mechanism is to have the eh thread collect the
sense data.  This is the route libata has chosen.

James


