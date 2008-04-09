From: Rick Warner <rick@microway.com>
Subject: Re: errors from mptsas
Date: Wed, 9 Apr 2008 11:16:33 -0400
Message-ID: <200804091116.33771.rick@microway.com>
References: <200804081820.19607.rick@microway.com> <20080409105343.GA19104@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.microway.com ([64.80.227.22]:43275 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773AbYDIPQi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2008 11:16:38 -0400
In-Reply-To: <20080409105343.GA19104@animx.eu.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org

> > I am working on 2 dual opteron systems using LSI 3041E SAS cards
> > (1064E(b3)). They each have (1) 73G Seagate SAS drive and (2) 750G
> > Seagate SATA drives hooked up to them.
> >
> > One of the stress tests we run on systems is looping through the hard
> > drives running "dd if=/dev/sdX of=/dev/null". With that running, we get a
> > steady stream of these errors in the dmesg-
> >
> > mptbase: ioc0: LogInfo(0x31123000): Originator={PL}, Code={Abort},
> > SubCode(0x3000)
> >
> > Any idea what's going on here? I have already updated to the latest
> > firmware for the card.  The system is loaded with FC8 running
> > 2.6.24.4-64.fc8.
>
> Join the club.  I have an LSI SAS with 3x 750gb seagate sata drives in
> raid5.  Does this happen only on your SATA drives or all the drives?
> Depending on the activity, it would drop one of them out of the
> array.  I think the problem has been solved for now by changing the
> queue_depth to 1.
>
> echo 1 > /sys/block/sdX/device/queue_depth
>
> Here's the drives in my system:
> [0:0:0:0]    disk    ATA      ST3750640AS      E     /dev/sda
> [0:0:1:0]    disk    ATA      ST3750640AS      E     /dev/sdb
> [0:0:2:0]    disk    ATA      ST3750640AS      E     /dev/sdc
I ran last night with 1 of the systems doing the repetitive dd on just the SAS 
drive, and that system produced no errors.

This morning, I followed your suggestion and set the queue_depth to 1 for both 
of the SATA drives.  With that setting applied, my rate of errors decreased 
significantly, but they did not go away completely.

The system I am using has 6 onboard SATA ports too, so I have moved the SATA 
drives to those ports instead. Everything is working fine now.  However, lsi 
really needs to fix this problem, as they have always told us that SATA 
drives work on their SAS controllers without issues.

Thanks,
Rick

-- 
Richard Warner
Lead Systems Integrator
Microway, Inc
(508)732-5517
