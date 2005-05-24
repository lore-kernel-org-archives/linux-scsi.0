From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 02:53:17 -0400
Message-ID: <4292CF5D.90809@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:10701 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261368AbVEXGxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 02:53:22 -0400
In-Reply-To: <20050524062128.GT9855@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Jens Axboe wrote:
> suspend/resume is a lot more complicated than just flushing a cache, the
> below will probably get you safe asleep but you will never get devices
> alive again after power-up on suspend-to-ram.
> 
> I also greatly prefer issuing a standby command to the drive after the
> flush, so that we don't risk using the emergency parks of the drive. If
> a drive happens to lie about wrt the flush command, it gets an extra
> chance to flush the cache as it now knows that power will be gone very
> soon. So I think the ->suspend/->resume hooks should belong to the LLD,
> not the ULD as the ULD has no idea how to suspend all devices types.


You are right about issuing the standby command after flush.  I don't 
think an LLD hook is the proper way to accomplish it, however.

The SCSI layer needs to issue the START STOP UNIT command in response to 
a suspend event, and libata-scsi will (per SAT spec) translate that into 
the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
standards gets us there.

Longer term, SATA PM through SCSI will have three facets:

* Device PM.  This is best handled by the device class driver (sd/sr/st).

* Bus PM.  This is best handled by the transport class driver (need to 
write for SATA and SAS).

* Host PM.  This is handled in the obvious manner, using existing PM 
driver hooks.  PCI D0/D3, etc.

I can describe how this will look when libata is divorced from SCSI, if 
you would like, too...

	Jeff


