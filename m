From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: Thu, 08 Apr 2004 11:27:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40751B18.9040403@shadowconnect.com>
References: <40712A47.4090903@shadowconnect.com>	<1081159378.4679.1.camel@laptop.fenrus.com>	<20040405110524.A3987@infradead.org>	<20040405101007.GA27710@devserv.devel.redhat.com> 	<20040405111245.A4077@infradead.org> <1081370204.1747.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:13026 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261654AbUDHJ0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 05:26:16 -0400
In-Reply-To: <1081370204.1747.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

James Bottomley wrote:
>>SG_IO is for scsi passthrough.  now you could invent fake scsi command
>>opcodes for native messages, but at that point it starts to get silly.
> Actually, no it's not.  SG_IO will to IDE taskfile passthrough just as
> well.  As arjan says, it's for native command passthrough.
> Now, since the dpt_i20 commontly accepts SCSI commands it would have to
> have some way to distinguish these "native" commands from other SCSI
> commands, but surely a vendor specific service action would do that.

The patch is for i2o_config, not for dpt_i2o! These are different 
drivers and have (from the architecture view) not much in common. 
dpt_i2o is a driver which let access to the disks entirely using the 
SCSI subsystem. The i2o subsystem uses i2o_core and i2o_block to access 
disks (which doesn't use SCSI at all), and also have an SCSI driver, 
which let access to each connected disk (i2o_scsi). But the i2o_scsi is 
not needed for normal disk access.

It's very funny, that i copied the patch 1:1 from dpt_i2o, where it is 
used too, and nobody ever complained about it :-D But don't understand 
me wrong, if there is a better way to do it, i'll try to do it this way.

> The consummate advantage is that we don't have to have the driver trying
> to construct the SG list on its own (which is what about 50% of this
> patch is doing), it can use the block layer to do that on a passed in
> area of application memory.

Than i have to move the patch to the i2o_scsi driver, because the 
i2o_scsi uses the SCSI subsystem already. But IMHO the i2o_config driver 
is better suited, cause the patch is only needed for the management 
software. One last question, could i use the SG list building function 
without using the SCSI layer?

Thank you very much.



Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
