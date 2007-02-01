From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 15:21:25 -0500
Message-ID: <45C24BC5.6060305@torque.net>
References: <200701021935.07840.liml@rtr.ca>	 <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com>	 <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com>	 <45C1A4BD.3030909@garzik.org> <45C1A823.30008@gmail.com>	 <45C1B8D4.1070209@garzik.org> <1170342565.3388.4.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40427 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422982AbXBAUVu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2007 15:21:50 -0500
In-Reply-To: <1170342565.3388.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-02-01 at 04:54 -0500, Jeff Garzik wrote:
>> Agreed... but that doesn't make it the /right/ thing to do ;-)
>>
>> The logic behind the current code, which limits to the maximum size 
>> allowed by an attached device on the port, is mainly to leverage the 
>> SCSI layer as a filter for bad CDB lengths.
>>
>> IOW, it's called "being lazy" ;-)
> 
> But you're requesting code changes in the SCSI layer because of this
> incorrect usage.  max_cdb is supposed to be the *host* limit.  The mid
> layer finds out and respects device limits separately from this.

To be more pedantic:
  actual_max_cdb = min(MAX_COMMAND_SIZE, host_limit)

Since the host is a bridge, that could be a limit on
near side (i.e. PCI (unlikely)) or the outer side (i.e.
transport initiator (port)). In modern HBAs the
host_limit is likely to be greater than 16, to allow
for advanced SBC and OSD commands. However currently
MAX_COMMAND_SIZE (defined in scsi/scsi_cmnd.h) is 16.

It is the ATAPI _transport_ that has the 12 byte cdb
limit *** (at least according to MMC-5 rev Annex A;
is S-ATAPI any better?).
Other MMC transports referred to in MMC-5 are
SPI, SBP(IEEE 1394) and USB mass storage; and no mention
is made of cdb length limits for them. Since ATAPI is
the dominant transport for cd/dvd drives, MMC doesn't
define any commands over 12 bytes in length, but both
SPC (which MMC should honour) and SSC-3 (think tape
drives, ATAPI connected) do.

My point is that the linux block layer and scsi mid
level should get out of the business of putting hard
limits place. Why?
Since kernel limits are at best necessary but not
sufficient, the upper layers still need to be able to
cope with errors associated with that limit.
So why have the limit?
Does the kernel do analysis to find out whether a USB
connected DVD drive has a USB to ATAPI bridge externally?
I don't think so. There is a role to fetch information
that may act as a guide when a ULD has a choice of commands
to build (e.g. sd deciding between READ(10) and READ(16)).
Let the cdb size bottleneck (or whatever) report an error
and upper layers that are impacted, including user space
programs, can act accordingly.

If the kernel really wants to offload complexity to the
user space, the kernel needs to get out of the business
of trying to foresee errors. It needs to get better at
coping with errors and if possible adapting its behaviour.


*** not the host nor the device

Doug Gilbert
