From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Sat, 3 May 2008 04:51:35 -0600
Message-ID: <20080503105135.GY14976@parisc-linux.org>
References: <20080502185227.GN14976@parisc-linux.org> <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51182 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYECKvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 06:51:52 -0400
Content-Disposition: inline
In-Reply-To: <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 02, 2008 at 03:06:42PM -0400, Mark Salyzyn wrote:
> The num_physpages variable works as needed for the PERC controllers  
> that are installed in vanilla x86 machines is it not? The PERC card  
> would not be installed in any other arch.
> 
> AAC_QUIRK_SCSI_32 means the card can not send 64bit format commands to  
> the SCSI devices (non DASD) but can send 64bit format commands to the  
> logical (Array) devices. This is for a select set of old PERC cards.
> 
> AAC_OPT_SGMAP_HOST64 means this card 'can' do DAC (send 64 bit format  
> commands to both SCSI and to Array devices), but sadly some that  
> report this are borken (hence the Quirk AAC_QUIRK_SCSI_32).
> 
> Dropping the cards is not an option, that is the whole reason this  
> workaround was put in place.

Thanks for the explanation of the quirks and options.  I don't want to
drop support for any cards, I just want to make aacraid not rely on
the meaning of num_physpages.

The question aacraid wants to ask is "Does this device have to
do DAC to access memory?"  The answer can be affected by an IOMMU or
by memory layout.  It's far from clear what question num_physpages is
intended to answer; there are different bits of the kernel using it in
interesting ways.  But we do have a function designed to answer the
question you want to ask: dma_get_required_mask().  This may be an
expensive question to ask, so in the below patch I cache the answer in
the aac_dev.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 460d402..cd0865d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1201,9 +1201,8 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
 
 static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 {
-	if ((sizeof(dma_addr_t) > 4) &&
-	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
-	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
+	if ((sizeof(dma_addr_t) > 4) && fib->dev->needs_dac &&
+	    (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
 		return FAILED;
 	return aac_scsi_32(fib, cmd);
 }
@@ -1394,6 +1393,9 @@ int aac_get_adapter_info(struct aac_dev* dev)
 			rcode = -ENOMEM;
 		}
 	}
+	if (dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK)
+		dev->needs_dac = 1;
+
 	/*
 	 * Deal with configuring for the individualized limits of each packet
 	 * interface.
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 113ca9c..a06c817 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1016,6 +1016,7 @@ struct aac_dev
 	u8			jbod;
 	u8			cache_protected;
 	u8			dac_support;
+	u8			needs_dac;
 	u8			raid_scsi_mode;
 	u8			comm_interface;
 #	define AAC_COMM_PRODUCER 0

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
