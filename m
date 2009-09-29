From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: mvsas (2.6.31) driver for Adaptec ASC-1045/1405 SAS/SATA
 controller
Date: Tue, 29 Sep 2009 14:31:13 +0000
Message-ID: <1254234673.3942.52.camel@mulgrave.site>
References: <4CA9DA403FFEC64AA62B3C295F8D47B7212674D127@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbZI2ObQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 10:31:16 -0400
In-Reply-To: <4CA9DA403FFEC64AA62B3C295F8D47B7212674D127@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yugendranath R Singh <yugendranath.s@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2009-09-29 at 19:38 +0530, Yugendranath R Singh wrote:
> We are currently working on open source drivers for Adaptec ASC
> 1045/1405 HBAs and these HBAs internally use Marvell 6440 SAS
> controller. The efforts started couple of weeks back with 2.6.30 mvsas
> driver as base. The 2.6.30 driver worked fine but had some issues with
> discovery and I/O of ATAPI devices and we were trying to fix these
> issues.  However, the newly released 2.6.31 mvsas seems to address all
> these issues and the test results of this driver are very encouraging.
> The testing basically included discovery - Hot plug, Cold plug and
> Overnight I/O with the various devices listed below except for the
> performance. There were few issues with discovery (Hot Plug) of
> daisy-chained expanders, but we have identified the fix for the same
> in 'libsas'.  
> 
> List of devices testing with ASC 1045/1405 using mvsas (2.6.31)
> ----------------------------------------------------------------
> 1. SAS disk drives
> 2. SAS Tape drives (HP LTO Ultrium-4)
> 3. Expanders (Adaptec, LSI and Promise)
> 4. SATA disk drives
> 5. SATA tape drives (DLT and AIT)
> 6. SATA DVD drives
> 7. Quantum GoVault drives
> 8. RBODs
> 9. 335 SAS JBOD
> 
> Below are our queries,
> ----------------------
> 1. How to get the PCI table of mv_init.c populated with vendor and
> device id of ASC 1045/1405? Should we submit a patch to mv_init.c or
> just sending the PCI details of ASC 1045/1405 to owners will suffice?

Just submit the patch and cc the mvsas Maintainers (There's no
maintainers file entry, so this is from git log):

    Signed-off-by: Ying Chu <jasonchu@marvell.com>
    Signed-off-by: Andy Yan <ayan@marvell.com>
    Signed-off-by: Ke Wei <kewei@marvell.com

> 2. Going forward, we are very much interested in contributing to the
> support of issues related to mvsas driver.  Is it possible to have
> access to known-bugs list on this driver? We will do our best to fix
> the bugs utilizing whatever hardware resources we have.

The bugzilla entries (for everything) all come over the linux-scsi list,
so it's the best source of information.

So far there's a slew of bug reports on the list (archived by somewhere
like http://marc.info/?l=linux-scsi from Thomas Fjellstrom
<tfjellstrom@shaw.ca>

> 3. Any plans of getting the 2.6.31 mvsas driver changes to older
> kernels (from 2.6.24 through 2.6.30) ? If not can we re-use this
> driver and submit to the earlier kernels under a different name?

Well, stable kernels don't go back that far ... they only go back a
revision or so; but no, no plans since it was a rewrite of the driver it
doesn't qualify under the bug fix only policy (the distributions will
still be free to backport it, though).

> We are currently preparing the patch for libsas (for the expander
> issue, mentioned above) and will submit the patch in couple of days.

Thanks,

James


