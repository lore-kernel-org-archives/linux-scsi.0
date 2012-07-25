From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 25 Jul 2012 18:19:13 +0400
Message-ID: <1343225953.12094.55.camel@dabdike>
References: <4FFB32E5.1050109@farcaster.org>
	 <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org>
	 <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>
	 <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>
	 <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>
	 <500A9D7C.8080801@matthiasprager.de>
	 <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46822 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933117Ab2GYOTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jul 2012 10:19:22 -0400
In-Reply-To: <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Matthias Prager <linux@matthiasprager.de>, Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-ide@vger.kernel.org

On Sun, 2012-07-22 at 10:31 -0700, Tejun Heo wrote:
> Hello,
> 
> On Sat, Jul 21, 2012 at 02:15:56PM +0200, Matthias Prager wrote:
> > Now I'm not sure this isn't taping over another bug. Which leads me to
> > my question: What is the correct behavior?
> > 
> > #1 Issuing a separate spin-up command (START UNIT?) prior to sending i/o
> > by setting allow_restart=1 for sata disks on sas controllers
> > 
> > or
> > 
> > #2 Teaching the sas drivers they do not need spin-up commands and can
> > simply start issuing i/o to sata disks
> 
> I haven't consulted SAT but it seems like a bug in SAS driver or
> firmware.  If it's a driver bug, we better fix it there.  If a
> firmware bug, working around those is one of major roles of drivers,
> so I think setting allow_restart is fine.

Actually, I don't think so.  SAT-2 section 8.12.2 does say 

        if the device is in the stopped state as the result of
        processing a START STOP UNIT command (see 9.11), then the SATL
        shall terminate the TEST UNIT READY command with CHECK CONDITION
        status with the sense key set to NOT READY and the additional
        sense code of LOGICAL UNIT NOT READY, INITIALIZING COMMAND
        REQUIRED;

START STOP UNIT (with START=0) translates to STANDBY IMMEDIATE, and
that's what hdparm -y issues.  We don't see this in /drivers/ata because
TEST UNIT READY always returns success.

So it looks like the mpt2sas SAT is doing the correct thing and we only
don't see this problem in normal SATA devices because of a bug in the
libata-scsi SAT.

However, the kernel log

Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] Device not ready
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Sense Key : Not Ready [current]
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj]  Add. Sense: Logical unit not ready, initializing command required
Apr 04 22:55:10 [kernel] sd 1:0:1:0: [sdj] CDB: Write(10): 2a 00 57 54 52 3f 00 00 08 00

Indicates we got the NOT READY to a non-TUR command, so I suspect what's
happening is that sending the TUR causes the SAT to remember the standby
state and respond NOT READY to all subsequent commands.  However, if we
just send an ordinary command, not a TUR, it quietly wakes the drive and
we don't see any problems.

There is support in SAT for this behaviour because there's a note on the
START STOP UNIT command saying

        After returning GOOD status for a START STOP UNIT command with
        the START bit set to zero, the SATL shall consider the ATA
        device to be in the Stopped power state (see SBC-2)

Which in SCSI terms would mean return NOT READY to any subsequent
commands.

Can someone verify this is indeed what the mpt2sas HBA is doing?

James


