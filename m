From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ipr SATA problems in 2.6.20
Date: Tue, 16 Jan 2007 17:11:33 -0600
Message-ID: <1168989094.2789.20.camel@mulgrave.il.steeleye.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com>
	 <20070116224115.50d29cf7@localhost.localdomain>  <45AD55A4.50208@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54331 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751400AbXAPXNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2007 18:13:42 -0500
In-Reply-To: <45AD55A4.50208@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>

On Tue, 2007-01-16 at 17:45 -0500, Jeff Garzik wrote:
> Tejun recently updated the CDB length areas of the code.  I bet it's 
> either a bug somewhere in there, or the SCSI layer isn't passing us 
> proper command lengths in a case or two.
> 
> Additional traces (starting with SCSI command, before it hits libata) 
> would be helpful.

Actually, this looks like a potential bug in atapi_xlat():  it doesn't
set qc->dma_dir.  Shouldn't it be setting it from
qc->scsicmd->sc_data_direction like ata_scsi_translate() does?

James


