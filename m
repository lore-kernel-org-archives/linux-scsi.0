From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Wed, 8 Oct 2003 14:55:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031008135553.GI10906@parcelfarce.linux.theplanet.co.uk>
References: <0998F43EAD645A47B3F6507196DD70EA256AA6@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36582 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261518AbTJHNz4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2003 09:55:56 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA256AA6@otcexc01.otc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Mark Haverkamp' <markh@osdl.org>, Matthew Wilcox <willy@debian.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Wed, Oct 08, 2003 at 09:11:24AM -0400, Salyzyn, Mark wrote:
> The scsicmd->SCp.ptr is `stealing' an unused member of the command to hold
> on to the physical address of an additional allocation that is part of the
> request so that when the command completes the memory can be `freed'.
> 
> My recommendation is to allocate an additional structure to hold on to all
> classes of `theft' like this in the driver (my guess is there is more) and
> use the SCp.ptr to point to this allocation rather than try to `steal' more
> to make up the full length.
> 
> Any wisdom of the list with regards to this?

[Someone with more in-depth knowledge of Linux scsi please correct me
 if I'm wrong]

include/scsi/scsi_cmnd.h defines struct scsi_cmnd which embeds the
scsi_pointer SCp.  The comment beside it says, "Scratchpad used by some
host adapters".  So I believe we're free to use any element of SCp we
like.  Am I correct?

If so, it already contains dma_addr_t dma_handle, so we can simplify the
aacraid code to use this wherever we currently use ptr.  The following
patch does this:

Index: drivers/scsi/aacraid/aachba.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aacraid/aachba.c,v
retrieving revision 1.2
diff -u -p -r1.2 aachba.c
--- drivers/scsi/aacraid/aachba.c	29 Jul 2003 17:25:47 -0000	1.2
+++ drivers/scsi/aacraid/aachba.c	8 Oct 2003 13:53:25 -0000
@@ -559,7 +559,7 @@ static void read_callback(void *context,
 			scsicmd->use_sg,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
 				 scsicmd->request_bufflen,
 				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
@@ -603,7 +603,7 @@ static void write_callback(void *context
 			scsicmd->use_sg,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
 				 scsicmd->request_bufflen,
 				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 
@@ -1235,7 +1235,8 @@ static void aac_srb_callback(void *conte
 			scsicmd->use_sg,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (ulong)scsicmd->SCp.ptr, scsicmd->request_bufflen,
+		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
+			scsicmd->request_bufflen,
 			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 
 	/*
@@ -1547,15 +1548,13 @@ static unsigned long aac_build_sg(Scsi_C
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		dma_addr_t addr; 
-		addr = pci_map_single(dev->pdev,
+		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
 				scsicmd->request_bufflen,
 				scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 		psg->count = cpu_to_le32(1);
-		psg->sg[0].addr = cpu_to_le32(addr);
+		psg->sg[0].addr = cpu_to_le32(scsicmd->SCp.dma_handle);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		scsicmd->SCp.ptr = (char *)(ulong)addr;
 		byte_count = scsicmd->request_bufflen;
 	}
 	return byte_count;
@@ -1606,17 +1605,15 @@ static unsigned long aac_build_sg64(Scsi
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		dma_addr_t addr; 
-		addr = pci_map_single(dev->pdev,
+		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
 				scsicmd->request_bufflen,
 				scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 		psg->count = cpu_to_le32(1);
-		le_addr = cpu_to_le64(addr);
+		le_addr = cpu_to_le64(scsicmd->SCp.dma_handle);
 		psg->sg[0].addr[1] = (u32)(le_addr>>32);
 		psg->sg[0].addr[0] = (u32)(le_addr & 0xffffffff);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		scsicmd->SCp.ptr = (char *)(ulong)addr;
 		byte_count = scsicmd->request_bufflen;
 	}
 	return byte_count;

I hope you all now feel like you might be masking a bug every time you
use a cast :-P

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
