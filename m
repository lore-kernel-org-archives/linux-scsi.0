From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi-0.15 released
Date: Fri, 22 Jul 2005 17:12:44 +1000
Message-ID: <42E09C6C.5060107@torque.net>
References: <OF9CA7648D.65634493-ONC1257044.00476607-C1257044.00496C37@de.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:19330 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261947AbVGVHMb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 03:12:31 -0400
In-Reply-To: <OF9CA7648D.65634493-ONC1257044.00476607-C1257044.00496C37@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, Nate.Dailey@stratus.com

Martin Peschke3 wrote:
> Doug,
> 
> Providing udev names is great. Makes it more user-frendly.

Martin,
It can still be tricked: for example putting disk device nodes
in a /dev/disks/ directory. Also the udevinfo approach could
be tricked by using mknod .

> Btw., what do you think about this idea:
> If lsscsi was enhanced to provide certain transport specific attributes, as
> well,
> then a user could easily look up the Linux device name of a logical unit
> that he otherwise knows by its transport specific addressing, like WWPN and
> so on in case of Fibre Channel. That's desirable, because
> SAN management is done based on these transport specific addresses.

Yes, I did kick around this idea. After discussing some
of the complexities, I thought it was better to do an
incremental release.

One problem is that lsscsi lists the attributes of logical
units (i.e. linux SCSI "devices") and hosts (i.e. SCSI initiator
ports). However most of the transport information available
is bound to SCSI target device ports (and the target device holds
one or more logical units). The logical unit may well have
transport information but in a bridged environment it is the
target's transport that sysfs is reporting.

One question is whether to extend lsscsi to cover transports
that carry SCSI command sets (e.g. SPI, FC, ATAPI, IEE1394, IB,
IP and SAS (to name a few)) or to suggest someone write a
lstransport utility. Obviously transports can carry payloads
other than SCSI command sets.

> I guess, this would require to convince James that it makes sense to
> spend effort on teaching either the midlayer or transport class to keep
> track
> of FCP_LUNs, or 64 bit LUNs respectively :)

There is probably enough transport information there
already in sysfs (but some "back" symlinks would be
handy). Increasing the degree of difficulty is the lack
of uniformity between transport sysfs representations.
The proposed SAS sysfs representation will increase
this entropy. I am beginning to see why the (maligned)
SDI ioctl interface for SAS HBAs has a <h:c:t:l> tuple
to SAS address map. It is the <h:c:t:l> tuple (or subsets
of it) that holds lsscsi together.

Doug Gilbert



