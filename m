From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: 08 Apr 2004 07:29:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081427380.1885.4.camel@mulgrave>
References: <40712A47.4090903@shadowconnect.com>	<1081159378.4679.1.camel@laptop.fenrus.
	com>	<20040405110524.A3987@infradead.org>	<20040405101007.GA27710@devserv.de
	vel.redhat.com> 	<20040405111245.A4077@infradead.org>
	<1081370204.1747.5.camel@mulgrave>  <40751B18.9040403@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54717 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261741AbUDHMa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 08:30:29 -0400
In-Reply-To: <40751B18.9040403@shadowconnect.com>
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-08 at 04:27, Markus Lidel wrote:
> The patch is for i2o_config, not for dpt_i2o! These are different 
> drivers and have (from the architecture view) not much in common. 
> dpt_i2o is a driver which let access to the disks entirely using the 
> SCSI subsystem. The i2o subsystem uses i2o_core and i2o_block to access 
> disks (which doesn't use SCSI at all), and also have an SCSI driver, 
> which let access to each connected disk (i2o_scsi). But the i2o_scsi is 
> not needed for normal disk access.

There appears to be some confusion:  SG_IO is a *block* layer ioctl (it
happens to be in the slightly misnamed drivers/block/scsi_ioctl.c file,
but it is usable for all block devices).

> It's very funny, that i copied the patch 1:1 from dpt_i2o, where it is 
> used too, and nobody ever complained about it :-D But don't understand 
> me wrong, if there is a better way to do it, i'll try to do it this way.

Interfaces evolve.  We have lots of examples in drivers of practices
that wouldn't be permitted if they showed up today, mainly because it
was the only way to accomplish the task when the driver was written.

> Than i have to move the patch to the i2o_scsi driver, because the 
> i2o_scsi uses the SCSI subsystem already. But IMHO the i2o_config driver 
> is better suited, cause the patch is only needed for the management 
> software. One last question, could i use the SG list building function 
> without using the SCSI layer?

Yes.  All sg functions are in block.  Without the SCSI framework, you
lose the mid-layer managing sglist allocation, so you'd have to do that
yourself, but every other non-scsi block driver also has that problem.

James


