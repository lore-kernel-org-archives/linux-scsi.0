From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs
 take 2
Date: Wed, 8 Sep 2004 07:38:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040908073843.7dbcddb6.rddunlap@osdl.org>
References: <20040907210520.0251476C56@isis.visi.com>
	<413E6F8F.3020008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:43174 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268227AbUIHOod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 10:44:33 -0400
In-Reply-To: <413E6F8F.3020008@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: sferris@acm.org, James.Bottomley@SteelEye.com, mikenc@us.ibm.com, michaelc@cs.wisc.edu, willy@debian.org, hch@lst.de, surekhap@cisco.com, linux-scsi@vger.kernel.org

On Wed, 08 Sep 2004 12:33:51 +1000 Douglas Gilbert wrote:

| Scott M. Ferris wrote:
| <snip>
| > 
| > Should all drivers that currently use one host for each SCSI initiator
| > device, and a channel for each initiator port on each device, be
| > modified to use a host for each initiator port?
| > 
| > Documentation/scsi/scsi_mid_low_api.txt says that a host corresponds
| > to a SCSI initiator device.  Could someone change that to say SCSI
| > initiator port instead, since that seems to be the new goal?
| 
| Scott,
| Yes, I can change that if we all agree. Randy Dunlap asked me some
| time back to define what was meant by a "linux SCSI host" and that
| was the best I could come up with at the time.

Sorry to be dense here, but what is an "initiator port" in this context?
Is it a physical connector or something else?  A logical connector?
(whatever that means)


| Interesting to see you mention SAS. There could be lots of fun
| for the linux SCSI subsystem here:
|    - addressable switching elements (called "expanders") in the
|      SCSI domain ** service delivery subsystem. These are not
|      SCSI devices (in the SAM sense) but are pretty close. They
|      are controlled by a packetized protocol called SMP whose
|      initiator end sits on a host and target end sits on an
|      expander. [SMP has no concept of logical units.]
|    - discovery is either dead simple (for example when a disk is
|      directly connected to a HBA's phy [like SATA]) or something
|      that needs a breadth first, hierarchial descent through
|      expanders to end devices. The latter type of discovery is
|      probably better done from the user space.
|    - in SCSI, devices can have multiple ports and in SAS a port can
|      be made up of multiple phys (i.e. a wide link). The SCSI
|      subsystem can ignore phys and just talk about ports but
|      users can see and touch phys (e.g. those SATA red cables).
|      Also expander routing is done at the link level.
| 
| It would be great to see a transport class architecture that
| could cope with this. Think about how a SMP target device
| (i.e. an expander's control port) will be represented.
| I don't think struct scsi_device is appropriate ...
| 
| 
| ** the term "bus" seems to have lost favour in SAM and been
|     replaced by the term "domain".
| 
| 
| A few related matters:
| 
| Steven Fairchild dropped a proposal for SAS storage management

"dropped" as in dropped (oh, as in deleted) or as in "added", "put",
or "placed" ?  Seems to be "added"...

To me, this all boils down to "communication is hard" or
"it's too easy to be ambiguous".


| called "Common Storage Management Interface for SAS" in the
| t10 "New Documents and Drafts" section. The url is:
| http://www.t10.org/ftp/t10/document.04/04-284r0.pdf
| A linux interface and driver is proposed.
| 
| A draft standard titled "SCSI-ATA translation" (SAT) is moving
| along briskly. The primary target areas for this translator are
| in a SAS host above an SAS domain when some of the "SCSI" devices
| are SATA disks and SCSI-(p/s)ATA bridges.
| 
| Doug Gilbert


--
~Randy
