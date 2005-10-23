From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [patch 3/6] SCSI HCIL: add scsi_scan_target()
Date: Sat, 22 Oct 2005 19:26:12 -0700
Message-ID: <20051022192612.1fca63d6.rdunlap@xenotime.net>
References: <20051023013618.GA18201@havoc.gtf.org>
	<20051023013849.GC18279@havoc.gtf.org>
	<20051023015042.GB1605@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:29872 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751397AbVJWC0O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 22:26:14 -0400
Received: from midway ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 19:26:13 -0700
In-Reply-To: <20051023015042.GB1605@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: jgarzik@pobox.com, linux-scsi@vger.kernel.org

On Sat, 22 Oct 2005 19:50:42 -0600 Matthew Wilcox wrote:

> On Sat, Oct 22, 2005 at 09:38:49PM -0400, Jeff Garzik wrote:
> > +/**
> > + * scsi_scan_target - scan a target id, possibly including all LUNs on the
> > + *     target.
> > + * @target:	target to scan
> > + * @lun:	Specific LUN to scan or SCAN_WILD_CARD
> > + * @rescan:	passed to LUN scanning routines
> > + *
> > + * Description:
> > + *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
> > + *     and possibly all LUNs on the target id.
> 
> Need to fix @parent, @channel and @id in the kerneldoc.  I think Randy
> has some automatic kerneldoc checking scripts?

Nothing fancy.  I use scripts/kernel-doc and a small starter
(or feeder) to it as copied from Documentation/kernel-doc-nano-HOWTO.txt.
I call it kdoc_function:

kdoc_function scsi_scan.c scsi_scan_target [text] --> text mode output
or
kdoc_function scsi_scan.c scsi_scan_target man --> man page output

This just enables someone to do quick/early checking on one file
at a time without resorting to "make *docs".  While you tell it
just one function to format and print, it checks the entire file
and lists errors.  Using it on scsi_scan.c::scsi_target_reap()
in 2.6.14-rc5 gives:

/////////////////// begin ////////////////////////
Warning(scsi_scan.c:203): No description found for parameter 'starget'
Warning(scsi_scan.c:203): No description found for parameter 'lun'
Warning(scsi_scan.c:203): No description found for parameter 'hostdata'
Function:

void scsi_target_reap (struct scsi_target * starget);

Arguments:

starget
         target to be checked


Description:

This is used after removing a LUN or doing a last put of the target
it checks atomically that nothing is using the target and removes
it if so.
Description:

This is used after removing a LUN or doing a last put of the target
it checks atomically that nothing is using the target and removes
it if so.


  /* ----- end function ----- */
Warning(scsi_scan.c:613): No description found for parameter 'sdev'
Warning(scsi_scan.c:806): No description found for parameter 'sdevp'
Warning(scsi_scan.c:806): No description found for parameter 'rescan'
Warning(scsi_scan.c:806): No description found for parameter 'hostdata'
Warning(scsi_scan.c:912): No description found for parameter 'scsi_level'
Warning(scsi_scan.c:912): No description found for parameter 'rescan'
Warning(scsi_scan.c:1035): No description found for parameter 'lun'
Warning(scsi_scan.c:1065): No description found for parameter 'starget'
Warning(scsi_scan.c:1065): No description found for parameter 'bflags'
Warning(scsi_scan.c:1065): No description found for parameter 'rescan'
////////////// end //////////////

Note:  The   /* ----- end function ----- */
is a local addition to my kernel-doc script (improves readability
for me).

http://www.xenotime.net/linux/scripts/kdoc_function
---
~Randy
