From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC 1/3] add fc transport events
Date: Mon, 14 Jun 2004 12:15:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CD0A27.5070504@torque.net>
References: <40B597F5.2030501@cs.wisc.edu>	<1087088793.1730.19.camel@mulgrave>  <40CCBCCA.1040302@us.ibm.com> <1087166778.10940.23.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:25096 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261685AbUFNCPU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 22:15:20 -0400
In-Reply-To: <1087166778.10940.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Christie <mikenc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2004-06-13 at 16:44, Mike Christie wrote:
> 
>>I am not adding a host and a device transport class. I am structuring 
>>things so there is a single fc transport class.
> 
> 
> I don't think that's such a good idea.  A class is supposed to represent
> an interface on a device.  The host and scsi device should have separate
> interfaces.  The only reason we don't have any host interfaces in the
> transport classes is because no-one has yet had a reason to add one. 
> However, since the loop status is definitely a host property, you
> do...part of what's missing is an attribute showing the loop state.  SPI
> has a similar need; the host property there is LVD or SE, and we might
> be interested in transitions between them.

There are 4 categories of "devices" that we might try
to address:
   a) host (PCI side and SCSI transport side)
   b) transport service delivery subsystem
   c) target device server
   d) logical unit

Only a, b + c are associated with the transport in question.
In category b could be FC switches and SAS expanders. In
category d could be sATA, SPI or SAS disks behind a FC
target. So the logical unit doesn't necessarily belong to
the same transport as the initiator (especially in iSCSI)
as noted above by James.

So the end point of the transport is category c and according
to SPC-3 a target device server is addressed via "well known"
logical units (see section 8). [The standard requirement for a
device server to respond to lun==0 for INQUIRY and REPORT LUNS
is a related hack that allows a SCSI disk to double as a
target device server and a lu.]

Is our transport class design flexible enough for this level
of complexity?

Doug Gilbert
