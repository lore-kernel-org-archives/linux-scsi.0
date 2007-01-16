From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: ipr SATA problems in 2.6.20
Date: Tue, 16 Jan 2007 17:33:13 -0600
Message-ID: <45AD60B9.3030501@linux.vnet.ibm.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com> <20070116224115.50d29cf7@localhost.localdomain>  <45AD55A4.50208@pobox.com> <1168989094.2789.20.camel@mulgrave.il.steeleye.com> <45AD5D27.8020004@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41464 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXAPXee (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jan 2007 18:34:34 -0500
In-Reply-To: <45AD5D27.8020004@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>

Brian King wrote:
> James Bottomley wrote:
>> On Tue, 2007-01-16 at 17:45 -0500, Jeff Garzik wrote:
>>> Tejun recently updated the CDB length areas of the code.  I bet it's
>>> either a bug somewhere in there, or the SCSI layer isn't passing us
>>> proper command lengths in a case or two.
>>>
>>> Additional traces (starting with SCSI command, before it hits libata)
>>> would be helpful.
>> Actually, this looks like a potential bug in atapi_xlat():  it doesn't
>> set qc->dma_dir.  Shouldn't it be setting it from
>> qc->scsicmd->sc_data_direction like ata_scsi_translate() does?
> 
> I think we are OK here since atapi_xlate is only ever called by
> ata_scsi_translate.

I spoke too soon... ata_scsi_translate only sets up dma_dir if its
a read or write, which means it never gets initialized if the direction
is DMA_NONE. 

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
