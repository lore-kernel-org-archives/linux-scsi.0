From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: A question on Linux SCSI low-level driver
Date: Tue, 18 May 2004 17:27:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFF8@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:26111 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S263665AbUERW1E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 18:27:04 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Thanks for the information.  scsi_debug is very helpful for me.

Two questions on scsi_debug/low-level driver:

- Has anyone ever created a patch for scsi_debug to support ioctl calls in lk 2.4?  If not, is it possible for some one to kindly create it or a template/part of it?

- Do SCSI passthrough ioctl calls sent to both sd and sg devices share/use the same ioctl routine defined in scsi_debug/low-level driver?  In other words, ioctl routine defined in scsi_debug/low-level drivers can not tell and do not care from which type of device (sd or sg) the SCSI passthrough call comes in, correct?

Thanks,


Lee


-----Original Message-----
From: Douglas Gilbert [mailto:dougg@torque.net]
Sent: Saturday, May 08, 2004 9:11 PM
To: Lee Xing
Cc: linux-scsi@vger.kernel.org
Subject: Re: A question on Linux SCSI low-level driver


Lee Xing wrote:
> Hi,
> 
> We are trying to write a low-level driver (no need for a perfect one at this time, just need to register the disks and do some simple I/Os).  I would sincerely appreciate it if some one could give me
some information/suggestions/hints.
> 
> This low-level driver has indirect (via other layers) information on physical disks, so it can only provide mid-level driver with bus number, target number and lun number of the disks.  It will convert
SCSI passthrough commands coming from the mid-level driver and send the converted command packages to the disks (again, via other layers).  It also sends the responses coming from physical disks (via other
layers) back to the mid-level driver.  The "other layers" are SCSI-ready and can handle
SCSI cmds/responses well.
> 
> My questions are: 
> 
> - is it (i.e. registering the disks with mid-level driver and doing some
>   simple I/Os) doable if this low-level driver only provides mid-level with
>   bus/target/lun numbers (without any hardware-related information)?

Lee,
See the scsi_debug driver (either in the lk 2.4 or lk 2.6
series). It is a scsi subsystem LLD that is basically a
ram disk so there is no "hardware" information to exchange
with the mid level.

Doug Gilbert

> - what can be the potential problems (if nay)?
> 
> Best Regards,

