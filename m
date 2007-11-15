From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] Re: Disabling dev_loss_tmo?
Date: Thu, 15 Nov 2007 00:02:50 -0800
Message-ID: <20071115080250.GA15726@linux.vnet.ibm.com>
References: <47396A5B.5040001@linpro.no> <4739CE69.3040602@emulex.com> <473AAD88.307@linpro.no> <473B0644.3090403@emulex.com> <473B1692.8050606@linpro.no> <473B45B4.3010708@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:46615 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbXKOIEX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 03:04:23 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lAF84Ct4013916
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 03:04:12 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lAF84Cso132344
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 01:04:12 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAF84Ahe006081
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 01:04:12 -0700
Content-Disposition: inline
In-Reply-To: <473B45B4.3010708@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, MLOEHR@de.ibm.com, Michael Reed <mdr@sgi.com>, Christophe Varoqui <christophe.varoqui@free.fr>, Tore Anderson <tore@linpro.no>

James Smart <James.Smart@Emulex.Com> wrote:
> I've added the dm reflector to this email...
> 
> >Best would to have DM-multipath handle the disconnects gracefully, of
> >course.  But since it doesn't appear to be happening anytime soon:  A
> >workaround provided by the transport layer would be very welcome!  I
> >don't use iSCSI or SAS with DM so I don't know if such a workaround is
> >wanted there too, but with FC it is necessary.  Even if it is a bad
> >approach it is much better than nothing, the way I see it.
> 
> Background of where this thread started is:
> http://marc.info/?l=linux-scsi&m=119494675103771&w=2
> 
> Can someone from the DM community comment on where things are, or are
> going, for handling disconnects w/ device teardown ??
> 

Since the intent is for mutltipathd to handle these events it would seem
that it would be good to try to fix the issues in mainline code instead of
adding work arounds.

I was not able to replicate all the error previously described in the
above referenced url, but maybe some where on different revs of
multipath tools vs the ones I used.

On queue_if_no_path with the all-paths-down case I assume we would need
multipath to allow a table with 0 priority groups (or some other method of
holding the dm in place, but someone from the list most likely has a
better answer.

If you notice Ex 2. that when I used the multipath-tools from the git tree
I did not receive events until in Ex 3 I added a udev rule to get
multipathd to receive events. The multipath-tools change to use an
abstract namespace socket for communication with udevd will be used unless
the socket operation call fails where it will then fallback to the direct
kobject uevent netlink socket. Christophe V can add better context here.

Some results on some experiments performed.
Ex 1.
	- Using linux-2.6 git head and device-mapper-multipath-0.4.7-12.el5
	on a RHEL5.1 distro.
	- On the FC switch I port disabled the port going to the target.
	- multipathd received event and loaded new table minus the removed
	  devices.
	- On reenabling the the port the devces where added back into the
	  table.
	- On disabling both target ports multipathd received both events
	  and removed both multipath devices.
	- On renabling both ports multipathd only added one path.
Ex 2.
	- Using linux-2.6 git head and multipath-tools git head on a
	  RHEL5.1 distro (default distro udev rules).
	- On the FC switch I port disabled the port going to the target.
	- multipathd did not receive the remove event.
	- udevmonitor showed the remove events "rport-2:0-2: blocked FC
	  remote port time out: removing target and saving binding"
	- On reenabling the the port a number of warnings where generated
	  due to the previous sysfs names still existing which resulted in
	  new devices not having everything setup correctly.
Ex 3.
	- Same setup as Ex 1, but I added to the multipath udev rule:
	  RUN+="socket:/org/kernel/dm/multipath_event"
	- multipathd received event and loaded new table minus the removed
	  devices.
	- On reenabling the the port the devces where added back into the
	  table.
	- On disabling both target ports multipathd received both events
	  and removed both multipath devices. In progress dd received
	  errors (expected).

Ex 4.
	- Same setup as Ex 3, but I added queue_if_nopath
	- On disabling both target ports multipathd received both events
	  and removed both multipath devices. In progress dd received
	  errors (expected).


I provided config info at the bottom of this email for reference.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

Test config info

# uname -a
Linux elm3b87 2.6.24-rc2am1 #1 SMP Wed Nov 14 10:08:48 PST 2007 x86_64
x86_64 x86_64 GNU/Linux

# dmidecode |grep "Product Name"
        Product Name: BladeCenter LS21 -[7971AC1]-
        Product Name: Server Blade
# lspci
...
03:05.0 Fibre Channel: Emulex Corporation Helios-X LightPulse Fibre Channel Host Adapter (rev 01)
03:05.1 Fibre Channel: Emulex Corporation Helios-X LightPulse Fibre Channel Host Adapter (rev 01)

# ./lsscsi
[0:0:0:0]    disk    IBM-ESXS ST936701SS       B51D  /dev/sda
[1:0:0:0]    disk    IBM      1815      FAStT  0914  /dev/sdb
[1:0:0:1]    disk    IBM      1815      FAStT  0914  /dev/sdc
[2:0:0:0]    disk    IBM      1815      FAStT  0914  /dev/sdd
[2:0:0:1]    disk    IBM      1815      FAStT  0914  /dev/sde

# ./lsscsi --host
[0]    mptsas        
[1]    lpfc          
[2]    lpfc 

# multipath-tools version
commit fa75d374cad8fa966dcf17dc18eee4ef5e70ff33

# multipath -l
mpath29 (3600a0b800011a1ee00001e5a46eab101) dm-2 IBM,1815      FAStT
[size=512M][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:0 sdb 8:16  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:0 sdd 8:48  [active][undef]
mpath5 (3600a0b800011a1ee00001e5c46eab185) dm-4 IBM,1815      FAStT
[size=512M][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:1 sdc 8:32  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:1 sde 8:64  [active][undef]


