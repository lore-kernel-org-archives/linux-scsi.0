From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.4.23
Date: Sun, 28 Dec 2003 20:10:20 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031228201020.C22668@infradead.org>
References: <47F3C2BE74738E4683574107469DFA201EE1D8@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:30729 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261965AbTL1UKV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 15:10:21 -0500
Content-Disposition: inline
In-Reply-To: <47F3C2BE74738E4683574107469DFA201EE1D8@XYUSEX01.xyus.xyratex.com>; from Frank_Borich@us.xyratex.com on Wed, Dec 17, 2003 at 08:13:40AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 17, 2003 at 08:13:40AM -0800, Frank Borich wrote:
> Hi All,
> 
> My name is Frank Borich, representing Xyratex International
> (http://www.xyratex.com).  We design, and manufacture Data Storage
> Subsystems.  During integration testing, we discovered that a patch to
> scsi_scan.c is required (2.4.x kernels only), in order to set the
> BLIST_SPARSELUN flag for our subsystems.  This flag adds support for
> non-contiguous lun numbering.  We are unable to use the already
> implemented "device_list" to set flags for our subsystems.  This is due
> to the fact that we sell only to OEMs, and vendor name will change.
> Rather than submit a separate patch for each branded subsystem we can
> look elsewhere in the SCSI inquiry data, and set the flag accordingly.
> The logic below, is executed once the end of the device_list is reached.
> When the end of the table is reached, a memcmp is issued to look for a
> particular string located at offset 96.  If the string is found, the
> flag BLIST_SPARSELUN is returned.  Below is a patch for the SCSI driver
> (scsi_scan.c). 

I'm not too happy about the form of this patch. Could you cook up one
for 2.6.0 that adds a function pointer to poke at the inquiry data
to the blacklist?  We could backport it to 2.4 later.

