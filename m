From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 14:40:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095370854.16820.34.camel@praka>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org>
	 <200409161305.02947.jbarnes@engr.sgi.com> <1095368210.16820.6.camel@praka>
	 <200409161409.20896.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-iJSsAAvUkVF/Ctj71Rvx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:58799 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266821AbUIPVpE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 17:45:04 -0400
In-Reply-To: <200409161409.20896.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Paul Jackson <pj@sgi.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>


--=-iJSsAAvUkVF/Ctj71Rvx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2004-09-16 at 14:09, Jesse Barnes wrote:
> On Thursday, September 16, 2004 1:56 pm, Andrew Vasquez wrote:
> > On Thu, 2004-09-16 at 13:05, Jesse Barnes wrote:
> > > On Thursday, September 16, 2004 12:56 pm, Paul Jackson wrote:
> > > > Andrew Vasquez has been looking at this, via private email with just
> > > > me (no progress yet).  Figured I update the larger list with this much
> > > > ...
> > >
> > > It seems to be failing on one of the accesses to PCI_COMMAND in config
> > > space in qla2x00_reset_chip().  I'm checking now to see if we're
> > > accessing the card right after a reset but before the card has finished. 
> > > That would cause a master abort, the symptom I'm seeing at least.
> >
> > Interesting, the only changes in reset_chip() are for PCI posting
> > issues.  Relevant diff attached.
> 
> Yeah, I think one of these is the culprit.  Before I got your message, I fixed 
> some of them in my tree already (see attached) and things seem to work.
> 

Hmm, seems we were a bit too over-aggressive in placement of the
readw()s :(

>         WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
> +       RD_REG_WORD(&reg->hccr);                        /* PCI Posting. */
>         WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
> +       RD_REG_WORD(&reg->hccr);                        /* PCI Posting. */
>  
>         /* Reset ISP chip. */
>         WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
> +       RD_REG_WORD(&reg->ctrl_status);                 /* PCI Posting. */
>  
> In particular, are the above ok?  If the chip is resetting, won't doing a read 
> cause a machine check (or at the very least, a device select timeout, which 
> will return all ones on friendlier platforms).
> 

There are several more which deltas in qla_dbg.c which are suspect
also.  

>         WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
> +       RD_REG_WORD(&reg->ctrl_status);                 /* PCI Posting. */
> 
> Same here?
> 

Andrew, please add Jesse's patch along with the patch I'm attaching to
your tree.  I'll be sure to add the ia64 machine back into our test
ring.


Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

--=-iJSsAAvUkVF/Ctj71Rvx
Content-Disposition: attachment; filename=qla_dbg_less_posting.diff
Content-Type: text/x-patch; name=qla_dbg_less_posting.diff; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

diff -Nurd -X /home/praka/Work/QLogic/Drivers/8.x/dontdiff linux-2.6.9-rc2-mm1/drivers/scsi/qla2xxx/qla_dbg.c linux-2.6.9-rc2-mm1_praka/drivers/scsi/qla2xxx/qla_dbg.c
--- linux-2.6.9-rc2-mm1/drivers/scsi/qla2xxx/qla_dbg.c	2004-09-16 14:30:38.000000000 -0700
+++ linux-2.6.9-rc2-mm1_praka/drivers/scsi/qla2xxx/qla_dbg.c	2004-09-16 14:36:18.907767776 -0700
@@ -712,7 +712,6 @@
 
 		/* Reset the ISP. */
 		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
 	}
 
 	for (cnt = 30000; RD_MAILBOX_REG(ha, reg, 0) != 0 &&
@@ -746,7 +745,6 @@
 
 			/* Release RISC. */
 			WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
 		}
 	}
 

--=-iJSsAAvUkVF/Ctj71Rvx--

