From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH RFC 1/3] add fc transport events
Date: 14 Jun 2004 10:28:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087223335.2118.18.camel@mulgrave>
References: <40B597F5.2030501@cs.wisc.edu>	<1087088793.1730.19.camel@mulgrave>
	<40CCBCCA.1040302@us.ibm.com> <1087166778.10940.23.camel@mulgrave>
	<40CD0A27.5070504@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:34182 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263147AbUFNO3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 10:29:36 -0400
In-Reply-To: <40CD0A27.5070504@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <mikenc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-06-13 at 22:15, Douglas Gilbert wrote:
> There are 4 categories of "devices" that we might try
> to address:
>    a) host (PCI side and SCSI transport side)
>    b) transport service delivery subsystem
>    c) target device server
>    d) logical unit

a) is really two (which we currently have represented) with the bus side
device and the host device.

b,c and d are all scsi devices.

> Only a, b + c are associated with the transport in question.
> In category b could be FC switches and SAS expanders. In
> category d could be sATA, SPI or SAS disks behind a FC
> target. So the logical unit doesn't necessarily belong to
> the same transport as the initiator (especially in iSCSI)
> as noted above by James.

The idea of the transport class is that it be invisible to the
mid-layer.  The services it provides are either to the LLD or to the
user (via sysfs).

> So the end point of the transport is category c and according
> to SPC-3 a target device server is addressed via "well known"
> logical units (see section 8). [The standard requirement for a
> device server to respond to lun==0 for INQUIRY and REPORT LUNS
> is a related hack that allows a SCSI disk to double as a
> target device server and a lu.]
> 
> Is our transport class design flexible enough for this level
> of complexity?

Well, in the SAM 4 level system:

1. Device specific command sets
2. Shared command sets (all device types)
3. SCSI transport protocols
4. Interconnects

Our ULDs do 1, the mid-layer does 2 and I'm hoping to expand the
transport classes into 3 and 4.

Enumeration really isn't addressed by SAM, but we're already moving
towards having enumeration done from user level (i.e. removing simple
scanning from the mid-layer), so that should be easily able to do
complex topology probes.

James


