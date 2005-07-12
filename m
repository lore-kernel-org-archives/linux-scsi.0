From: James.Smart@Emulex.Com
Subject: RE: PE1800 S-ATA RAID CERC6 with RHEL 3 / 4 ???
Date: Tue, 12 Jul 2005 10:35:09 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201ACD4@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:16049 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261480AbVGLOfU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 10:35:20 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt_Domsch@dell.com, mark_salyzyn@adaptec.com
Cc: kitgerrits@gmail.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org

I really hated these patches.  The issue that was causing >90% of the 
problems we encountered was that pci_alloc_consistent was overextending
when no_iommu was set by ignoring the dma masks of the adapter and
forcing the use of the dma map pool when it wasn't necessary. IMHO, fixing
this issue seems like a much better approach than having to make the
dma pool or swiotlb larger.

-- james s

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Matt Domsch
> Sent: Monday, July 11, 2005 9:55 AM
> To: Salyzyn, Mark
> Cc: Kit Gerrits; linux-poweredge@dell.com; linux-scsi@vger.kernel.org
> Subject: Re: PE1800 S-ATA RAID CERC6 with RHEL 3 / 4 ???
> 
> 
> On Mon, Jul 11, 2005 at 08:02:47AM -0400, Salyzyn, Mark wrote:
> > One of the problems with this class (2.4.* based 64 bit) is 
> the Software
> > IOMMU. You may have to boot with 'swiotlb=12288' in order 
> to free enough
> > mapping resources for the card.
> 
> And if you're running RHEL3 Update 5 or higher, the swiotlb no longer
> is mapped into ZONE_DMA space, so you can safely make it larger (as
> Mark describes above) without depleating the 16MB ZONE_DMA.
> 
> Thanks,
> Matt
> 
> -- 
> Matt Domsch
> Software Architect
> Dell Linux Solutions linux.dell.com & www.dell.com/linux
> Linux on Dell mailing lists @ http://lists.us.dell.com
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
