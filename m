From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Blacklist flags for SCSI target vs. SCSI LUN
Date: Wed, 22 Feb 2006 16:32:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602221609580.9277-100000@iolanthe.rowland.org>
References: <788A4342-D93E-4252-B19E-CA554596897A@ieee.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46233 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751462AbWBVVcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 16:32:12 -0500
In-Reply-To: <788A4342-D93E-4252-B19E-CA554596897A@ieee.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

>From your first two messages, I gather that it might not be safe to rely 
on all LUNs in a SCSI target having the same PDT.  Fair enough.

On Tue, 21 Feb 2006, Pat LaVarre wrote:

> Working from comments, not yet grep, I see only three distinct Groups  
> of flags:
> 
> a) Mysteries:
> 
> >> 19 #define BLIST_NOSTARTONADD      0x1000  /* do not do automatic  
> >> start on add */
> >> 9 #define BLIST_BORKEN            0x004   /* Flag for broken  
> >> handshaking */
> >> 10 #define BLIST_KEY               0x008   /* unlock by special  
> >> command */
> >> 28 #define BLIST_NO_ULD_ATTACH     0x100000 /* device is actually  
> >> for RAID config */
> >> 29 #define BLIST_SELECT_NO_ATN     0x200000 /* select without ATN */
> >
> The jargon in BLIST_SELECT_NO_ATN is specific to Spi transport of Scsi.
> 
> b) Scsi Simplifications:
> 
> >> 12 #define BLIST_NOTQ              0x020   /* Buggy Tagged Command  
> >> Queuing */
> >> 15 #define BLIST_ISROM             0x100   /* Treat as (removable)  
> >> CD-ROM */
> >> 17 #define BLIST_INQUIRY_36        0x400   /* override additional  
> >> length field */
> >> 18 #define BLIST_INQUIRY_58        0x800   /* ... for broken  
> >> inquiry responses */
> >> 20 #define BLIST_MS_SKIP_PAGE_08   0x2000  /* do not send ms page  
> >> 0x08 */
> >> 21 #define BLIST_MS_SKIP_PAGE_3F   0x4000  /* do not send ms page  
> >> 0x3f */
> >> 22 #define BLIST_USE_10_BYTE_MS    0x8000  /* use 10 byte ms  
> >> before 6 byte ms */
> >> 23 #define BLIST_MS_192_BYTES_FOR_3F       0x10000 /*  192 byte ms  
> >> page 0x3f request */
> >> 27 #define BLIST_NOT_LOCKABLE      0x80000 /* don't use PREVENT- 
> >> ALLOW commands */
> 
> NOTQ is for all requests

All requests to the LUN or to the target?  Are tagged requests for
different LUNs on the same target handled separately?  For example, could
there be simultaneous outstanding requests having the same tag value 
because they are for separate LUNs?

> ISROM and _INQUIRY redefine Scsi op x12 Inquiry
> _MS redefine Scsi op x1A Mode Sense 6 and op x5A Mode Sense 10
> NOT_LOCKABLE redefine op x1E Prevent/ Allow Medium Removal.
> 
> All these I imagine we might have to store per Lun.

Agreed.

> c) Lun Counting Techniques:
> 
> >> 6 #define BLIST_NOLUN             0x001   /* Only scan LUN 0 */
> >> 7 #define BLIST_FORCELUN          0x002   /* Known to have LUNs,  
> >> force scanning, deprecated: Use max_luns=N */
> >> 11 #define BLIST_SINGLELUN         0x010   /* Do not use LUNs in  
> >> parallel */
> >> 13 #define BLIST_SPARSELUN         0x040   /* Non consecutive LUN  
> >> numbering */
> >> 14 #define BLIST_MAX5LUN           0x080   /* Avoid LUNS >= 5 */
> >> 16 #define BLIST_LARGELUN          0x200   /* LUNs past 7 on a  
> >> SCSI-2 device */
> >> 24 #define BLIST_REPORTLUN2        0x20000 /* try REPORT_LUNS even  
> >> for SCSI-2 devs (if HBA supports more than 8 LUNs) */
> >> 26 #define BLIST_NOREPORTLUN       0x40000 /* don't try  
> >> REPORT_LUNS scan (SCSI-3 devs) */
> 
> All those I imagine we can store per device, not per Lun, by your  
> original logic: "any flag that influences how LUN detection should be  
> performed" "should apply to entire targets".

That seems pretty clear.  Thanks for the help.

Alan Stern

