From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Fri, 02 May 2003 11:10:15 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB1C577.1050204@torque.net>
References: <3EB11AD3.2070503@torque.net>	<20030501155225.7df14e51.rddunlap@osdl.org>	<3EB1ADF3.5080008@torque.net> <20030501173806.4fb6a663.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:55820 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262841AbTEBAza
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2003 20:55:30 -0400
In-Reply-To: <20030501173806.4fb6a663.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org

Randy.Dunlap wrote:
> On Fri, 02 May 2003 09:29:55 +1000 Douglas Gilbert <dougg@torque.net> wrote:
> 
> | Randy.Dunlap wrote:
> | <snip/>
> | 
> | > Hi Doug,
> | > 
> | > I have ATAPI CD-ROM as hdc and CD-RW as hdd.  I boot with
> | > "hdd=icd-scsi ide-scsi.debug=3".  Is that right/OK so far?
> | > If not, what should it be?
> | 
> | Randy,
> | I thought so but it's not picking "ide-scsi.debug=3" up:
> | 
> |  > Kernel command line: auto BOOT_IMAGE=lin2568isc ro root=304
> |    >  devfs=nomount hdd=ide-scsi ide-scsi.debug=3 console=tty0
> |    >  console=ttyS0,38400n8 debug
> |  > ide_setup: hdd=ide-scsi
> |  > ide_setup: ide-scsi.debug=3 -- BAD OPTION
> 
> Yes, I noticed that.  So I changed it to "ide_scsi.debug=3" and got
> the same message.  So I changed it to "idescsi.debug=3" and still
> get error messages...??
> 
> Anyway, I set the sysfs file values to 3 and 1 (debug and suppress_reset)
> [since it boots now for some unknown reason] and tried to burn another
> CD.  Now I have just another coaster.  :)
> 
> The system is hung-up again, no keyboard, no messages on serial console.
> 
> In the future I should probably use ide-scsi as a module to see if the
> parameters work OK.  And I'll look into the parameters for built-in
> drivers too (on my long todo list).

Randy,
Thanks for trying this. It would be great to see which
command it is locking up on.

Since you see the problem at driver load time, perhaps
this is related to what Matthew Dharm has been seeing
with some USB devices. Namely when these devices get
a SCSI command that don't like (e.g. INQUIRY with the
EVPD bit set **) they lock up. If this is the case then
the ide-scsi driver may be needing that command filter
as well.


** Patrick Mansfield has submitted a patch (now in Linus's
bk snapshots) that removes the VPD=0x83 code from device
scans. Not sure if this is a forward step. Some user app
is going to come along and send that INQUIRY (vpd=0x83)
to all SCSI devices and lock up the "bad" ones ;-( That
user space app needs information to discriminate.

Doug Gilbert

