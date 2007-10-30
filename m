From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC 0/3] [SCSI/libata] libata EH conversion for ipr SAS
Date: Tue, 30 Oct 2007 10:04:49 -0400
Message-ID: <47273A01.6010604@garzik.org>
References: <47263F85.70908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33142 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXJ3OEx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Oct 2007 10:04:53 -0400
In-Reply-To: <47263F85.70908@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Brian King wrote:
> The following three patches convert ipr to use the new libata EH APIs.
> In the process of doing this, I first looked into implementing this
> in a similar manner to how libata SAS is done today, which is hooking
> into target_alloc/target_destroy to allocate/delete sata ports. While
> I was able to get this working after writing my own eh_strategy_handler,
> I was doubtful this was the best long term solution. One problem with this
> implementation I didn't solve was the fact that libata now invokes EH
> for each and every error received. For some devices, such as optical
> devices, each not ready response received during a media reload would
> result in all the attached SAS devices getting quiesced as well.
> 
> My second approach is the attached patch set. In this series I have
> created a new libata API which can be used by SAS LLDDs. It introduces
> an ata_sas_rphy device object which is created/destroyed by the following API:
> 
> ata_sas_rphy_alloc
> ata_sas_rphy_add
> ata_sas_rphy_delete
> 
> When using this API in ipr, I made ipr's scsi_host the parent device of the
> SATA rphy. The SATA rphy is then the parent of the allocated scsi_hosts. This
> means that each SATA rphy in the SAS topology will have its own scsi_host, making
> SAS *much* more like all the SATA LLDDs in how it uses libata.
> 
> The only issue I ran into with this implementation is that since each SATA
> port has its own scsi_host, the adapter cannot rely on scsi core to manage
> any LLDD or adapter imposed queue depth. To solve this I added some code to
> ipr. Longer term, block layer queue groups might be another way to do this.
> 
> I'm still polishing this up, but it is up and running and seems to work with
> what testing I've done so far.

Like I said on IRC... thanks for taking care of this!  After this we are 
down to three old-EH users:  libsas, sata_qstor (patch exists, waiting 
on testing) and sata_sx4 (patch exists, waiting on testing).

I'll take a good look in the next day or so.  Overall the coupling 
between SAS (ipr and libsas) and libata definitely needs some thought.

	Jeff



