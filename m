From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Re[2]: Fwd: Re: problems with scsi_transport_fc and qla2xxx
Date: Wed, 1 Mar 2006 11:20:08 -0800
Message-ID: <20060301192008.GF4321@spe2>
References: <735056370.20060228195436@netvision.net.il> <1984428707.20060228200029@netvision.net.il> <20060228181900.GC4541@andrew-vasquezs-powerbook-g4-15.local> <1261469398.20060301130903@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32699 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750740AbWCATUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 14:20:12 -0500
Content-Disposition: inline
In-Reply-To: <1261469398.20060301130903@netvision.net.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maxim Kozover <maximkoz@netvision.net.il>
Cc: linux-scsi@vger.kernel.org

On Wed, 01 Mar 2006, Maxim Kozover wrote:

> Hi Andrew!
> I applied the patch changing 2 lines in scsi_transport_fc.c to
> if (fc_host_tgtid_bind_type(shost) != FC_TGTID_BIND_NONE) {
> 
> I tried first with Emulex as QLogic seemed yesterday to have more
> problems, (not only orphan rports, but also not creating all rports),
> so let's start solving problems one by one.
> 
> I saw no change in behavior with Emulex.
> 1. I had 3 LUNs on adapters 6 and 7.
> # ls /sys/class/fc_remote_ports
> rport-6:0-0  rport-6:0-1  rport-6:0-2  rport-7:0-0  rport-7:0-1  rport-7:0-2

Ok, so specifically you have one target-port at rport-7:0-2 which has
three luns (0, 1, and 2).

	/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:07:01.1/host7/rport-7:0-2/target7:0:0/7:0:0:0
	/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:07:01.1/host7/rport-7:0-2/target7:0:0/7:0:0:1
	/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:07:01.1/host7/rport-7:0-2/target7:0:0/7:0:0:2

So what are the other rports?  Other initiators?

> 2. disconnected the cable between adapter 7 and the switch,
> rport-7:0-0 disappeared momentarily with Emulex LinkDown event.
> lpfc 0000:07:01.1: 1:1305 Link Down Event x2 received Data: x2 x20 x110
> # ls /sys/class/fc_remote_ports
> rport-6:0-0  rport-6:0-1  rport-6:0-2  rport-7:0-0  rport-7:0-2

Actually, rport-7:0-1 disappears -- my guess an initiator.  Is
rport-7:0-0 an FCP_TARGET with no luns?

> 3. Then after a timeout I got a message about blocking rport-7:0-2, but
> nothing changed.
> rport-7:0-2: blocked FC remote port time out: removing target and saving binding

Exactly, the scsi_target and scsi_device is reaped after TMO expires.

> # ls /sys/class/fc_remote_ports
> rport-6:0-0  rport-6:0-1  rport-6:0-2  rport-7:0-0  rport-7:0-2

This is still correct.

> However, all scsi entries related to adapter 7 are removed from
> /proc/scsi/scsi.
> 
> Please advise.

If your question is, are the /proc/scsi/scsi devices (/dev/sda, sdb,
...) supposed to disappear when the rport TMO expires , then yes they
are supposed to disappear.  The rports persist with a port_state of
'not present' for persistent-binding purposes, until the port return
(i.e. you reinsert the cable).  If that were to occur, then upon rport
addition, the 3-lun storage would be attached to rport-7:0-2 and a
request signaled for lun scanning by the midlayer.

--
Andrew
