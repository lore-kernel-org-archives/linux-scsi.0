From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:07:14 +0200
Message-ID: <20050524070714.GU9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:43697 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261357AbVEXHHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:07:22 -0400
Content-Disposition: inline
In-Reply-To: <4292CF5D.90809@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Tue, May 24 2005, Jeff Garzik wrote:
> Jens Axboe wrote:
> >suspend/resume is a lot more complicated than just flushing a cache, the
> >below will probably get you safe asleep but you will never get devices
> >alive again after power-up on suspend-to-ram.
> >
> >I also greatly prefer issuing a standby command to the drive after the
> >flush, so that we don't risk using the emergency parks of the drive. If
> >a drive happens to lie about wrt the flush command, it gets an extra
> >chance to flush the cache as it now knows that power will be gone very
> >soon. So I think the ->suspend/->resume hooks should belong to the LLD,
> >not the ULD as the ULD has no idea how to suspend all devices types.
> 
> 
> You are right about issuing the standby command after flush.  I don't 
> think an LLD hook is the proper way to accomplish it, however.
> 
> The SCSI layer needs to issue the START STOP UNIT command in response to 
> a suspend event, and libata-scsi will (per SAT spec) translate that into 
> the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
> standards gets us there.

That sounds fine!

> Longer term, SATA PM through SCSI will have three facets:
> 
> * Device PM.  This is best handled by the device class driver (sd/sr/st).
> 
> * Bus PM.  This is best handled by the transport class driver (need to 
> write for SATA and SAS).
> 
> * Host PM.  This is handled in the obvious manner, using existing PM 
> driver hooks.  PCI D0/D3, etc.
> 
> I can describe how this will look when libata is divorced from SCSI, if 
> you would like, too...

I was beginning to dispair you had given up that plan...

-- 
Jens Axboe

