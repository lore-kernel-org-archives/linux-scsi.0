From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Fri, 15 Jan 2010 00:43:33 +0100
Message-ID: <4B4FAC25.1050504@s5r6.in-berlin.de>
References: <20100114165602.GY13413@beardog.cce.hp.com> <4B4F617B.5050609@interlog.com> <20100114200715.GB13413@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43904 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab0ANXon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 18:44:43 -0500
In-Reply-To: <20100114200715.GB13413@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.org, axboe@kernel.dk, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

scameron@beardog.cce.hp.com wrote:
> On Thu, Jan 14, 2010 at 01:24:59PM -0500, Douglas Gilbert wrote:
>> scameron@beardog.cce.hp.com wrote:
>>> I'm seeing a problem which I think is a problem in the SCSI mid layer.
[...]
>>> Remove the device while something has it open:
[...]
>>> [root@slicer ~]# rmmod hpsa
>>> ERROR: Module hpsa is in use

The sg driver's open method takes a reference to the underlying SCSI
device representation of the mid layer.  Among else, this step increases
the module use count of the respective low-level driver (transport layer
driver) so that the SCSI mid layer can be sure that function pointers to
driver methods stay valid during the lifetime of the SCSI device
representation.

This reference taking is of course being reversed when the sg driver
finishes its last uses of the underlying SCSI device.  This may be at
the respective close() or even later.

In short, it is normal, expected, and necessary what you are seeing.
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
