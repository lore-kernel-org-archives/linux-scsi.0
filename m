From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 20/23] aacraid driver fails with Dell PowerEdge Expandable RAID Controller 3/Di
Date: Mon, 26 Nov 2007 09:12:07 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAE54@otce2k301.adaptec.com>
References: <200711212312.lALNCVWt014163@imap1.linux-foundation.org> <E1IwbCB-0002Ft-M9@n2o.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:38764 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbXKZOMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2007 09:12:10 -0500
Content-class: urn:content-classes:message
In-Reply-To: <E1IwbCB-0002Ft-M9@n2o.xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>, akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org

> From: Miquel van Smoorenburg [mailto:mikevs@xs4all.net] 
> >+static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
> >+{
> >+	if ((sizeof(dma_addr_t) > 4) &&
> >+	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
> >+	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
> >+		return FAILED;
> >+	return aac_scsi_32(fib, cmd);
> >+}
> 
> I saw the same thing in the 64-bit dpt_i2o driver, but I

Yes, scratch and sniff, caught me :-}

> wonder, shouldn't this be something like:
> 
> #include <linux/bootmem.h>
> 
>        if ((sizeof(dma_addr_t) > 4) &&
>         (max_pfn > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
>         (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
> 
> e.g. use max_pfn instead of num_physpages ?

Yes, it would be more correct for the moment, save for the fact that it
is marked for deletion:

         * This doesn't seem to be used by the Linux memory manager any
         * more, but is used by ll_rw_block.  If we can get rid of it,
we
         * also get rid of some of the stuff above as well.
		. . .
	  max_pfn = . . .

and unfortunately architecture issues abound with all memory limit
variable :-(

in arch/arm/mm/init.c:

         * Note: max_low_pfn and max_pfn reflect the number of _pages_
in
         * the system, not the maximum PFN.

Reminder: If this automated solution represented in this patch, however
flawed with any memory limit variable, is too hacky and not acceptable
for inclusion, the workaround for the existing drivers and PERC users in
64 bit populated architectures continues to be to manually set
aacraid.dacmode=0 in the failing configurations.

What variable tells us the maximum physical memory address, is correct
in all architectures and is going to stick around? 

Sincerely -- Mark Salyzyn
