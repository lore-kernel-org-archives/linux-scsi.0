From: kwhite@austin.ibm.com
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 21:31:38 -0600 (CST)
Message-ID: <200412010331.VAA21676@catalyst.austin.ibm.com>
References: <1101835224.1779.1040.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:41375 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262273AbUK3T2l
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 14:28:41 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iAUJSaQf439388
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 14:28:36 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iAUJSaIp330102
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 12:28:36 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iAUJSaFL008513
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 12:28:36 -0700
In-Reply-To: <1101835224.1779.1040.camel@rebel.corp.whenu.com> from "Richard F. Rebel" at Nov 30, 2004 12:20:24 PM
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Richard F. Rebel" <rrebel@whenu.com>
Cc: linux-scsi@vger.kernel.org, kwhite@austin.ibm.com

> I am running mdk 10.0 with kernel 2.6.3-16 out of box on a dual opteron
> 250 system.  The system has a LSI logic U320 controller with 7 internal
> disks on two channels.
> 
> 
> Well, the difference is that the fiber channel card seems to boot first,
> and thus reorders the scsi bus.  If I attach the fiber channel cables to
> the switch (making all of our storage visible) and re-probe the scsi bus
> by hand using the /dev interface, access to the SAN is fine etc.  Upon
> reboot with the fc connected, my system panics because now the root
> drive is no longer where it thinks it should be (sda is now a device on
> the fiber channel switch fabric).
> 
> Is there a way to control this process or to mitigate the problem?  I
> really need the system to boot properly off of local disk whether or not
> the fc is connected or the devices available.

You need to force the LSI U320 scsi driver to load before the fibre-channel
driver loads.

To do this you need to modify the /etc/modules.conf file and ensure your
scsi adapter driver loads first.  You then have to rebuild your ramdisk, if
you are using one, to ensure the modules.conf file is picked up at boot time.

Note: The load order is not determined by the entry order in modules.conf. It is
determined by "scsi_hostadapter" field.  If you want a scsi driver to load last,
make it have the highest numbered suffix.  Here is an example of entries in
modules.conf that would load the sym5c38xx driver first, and the Emulex lpfc
fibre-channel driver second:

	alias scsi_hostadapter sym53c8xx
	alias scsi_hostadapter1 lpfc

On future installs of the machine, if your fibre-channel cables are plugged in,
to ensure local disks are discovered before fibre attached disks, you need to 
install using the "noprobe" option and then load the scsi and fibre channel 
drivers by hand.  Making sure to load the scsi adapter driver first. e.g:

	linux noprobe

Thanks,
Karen White

