From: "adam radford" <aradford@gmail.com>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 2 Oct 2006 11:06:31 -0700
Message-ID: <b1bc6a000610021106gab7efe7jcbab275b5030db9e@mail.gmail.com>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org>
	 <20061002105733.a9e82ddf.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:54883 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S965183AbWJBSGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 14:06:33 -0400
Received: by nf-out-0910.google.com with SMTP id o25so1596015nfa
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 11:06:32 -0700 (PDT)
In-Reply-To: <20061002105733.a9e82ddf.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

This driver is for the older 3ware controllers.  They can only DMA to 32-bit
addresses.  I set pci_set_dma_mask(pdev, DMA_32BIT_MASK).  When you
have >= 4GB of RAM, you should use the IOMMU.  The driver has a large
default queue depth, so it can use up a lot of mappings.  Perhaps IOMMU is
turned off in the bios, or the aperature isn't sufficiently large
enough for the mappings?

-Adam

On 10/2/06, Andrew Morton <akpm@osdl.org> wrote:
> On Mon, 2 Oct 2006 08:08:37 -0700
> bugme-daemon@bugzilla.kernel.org wrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=7246
> >
> >            Summary: 3w-xxxx, IOMMU and >1go RAM
> >     Kernel Version: 2.6.18
> >             Status: NEW
> >           Severity: normal
> >              Owner: scsi_drivers-other@kernel-bugs.osdl.org
> >          Submitter: aarnoud@agematis.com
> >
> >
> > Most recent kernel where this bug did not occur: 2.6.15-1
> > Distribution: Debian Testing
> > Hardware Environment: SuperMicro X6DVL-EG2, 4go RAM, 3ware 8006-2LP, 2xHitachi
> > 2x80go
> > Software Environment:
> > Problem Description: Data corruption with kernel newer than 2.6.15-1.
> >
> > Steps to reproduce: tested with most kernel 2.6.16, 2.6.17 and 2.6.18 all doing
> > same corruption.
> >
> > Solved the probleme leaving only 1go of RAM and setting IOMMU=off during boot
> > time, with 4go RAM kernel hangs saying :
> >
> > 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> > nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> > 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> > nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> > 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> > nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> >
> > and hangs badly.
> >
>
> James, Adam: I recall that we had a scsi driver recently which had problems
> similar to this, but I think it was with addresses over 4G, not over 1G.
> It also might not have been the 3ware driver.  Do you recall?
>
> Alexandre, can you please send the full dmesg output for that machine?
>
> Thanks.
>
