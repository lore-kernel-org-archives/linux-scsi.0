From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:48:20 -0400
Message-ID: <429330A4.6080005@adaptec.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63136 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261229AbVEXNsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 09:48:25 -0400
In-Reply-To: <4292CF5D.90809@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On 05/24/05 02:53, Jeff Garzik wrote:
> You are right about issuing the standby command after flush.  I don't 
> think an LLD hook is the proper way to accomplish it, however.
> 
> The SCSI layer needs to issue the START STOP UNIT command in response to 
> a suspend event, and libata-scsi will (per SAT spec) translate that into 
> the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
> standards gets us there.

An SSU command may not be viable as the device may be shared
on the domain (i.e. accessed by another initiator).
 
> Longer term, SATA PM through SCSI will have three facets:
> 
> * Device PM.  This is best handled by the device class driver (sd/sr/st).

In terms of cache syncronization yes.  But we may not be the only initiator.
 
> * Bus PM.  This is best handled by the transport class driver (need to 
> write for SATA and SAS).

This is tricky.  Kudos to Doug's answer.  One thing to remember is that
this is intricately entangled with host PM.  That is, if a device
is unplugged from the domain -- would one want to computer to come
out of its current power saving mode?  Probably not.
 
> * Host PM.  This is handled in the obvious manner, using existing PM 
> driver hooks.  PCI D0/D3, etc.

Then D3->D0 would be equivalent to reinintialization of the PCI device,
doing domain discovery as usual, etc.
 
> I can describe how this will look when libata is divorced from SCSI, if 
> you would like, too...

Please Jeff.

A concern is SATA devices behind SAS HAs (host adapters).  A straightforward
translation provided by libata would be a goal.

	Luben


