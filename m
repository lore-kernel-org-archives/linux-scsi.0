From: David Miller <davem@davemloft.net>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Fri, 12 Oct 2007 15:25:08 -0700 (PDT)
Message-ID: <20071012.152508.30182036.davem@davemloft.net>
References: <20071011112058.d95fe040.akpm@linux-foundation.org>
	<20071011.173842.98873625.davem@davemloft.net>
	<1192212273.3342.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42948
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932716AbXJLWZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2007 18:25:08 -0400
In-Reply-To: <1192212273.3342.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, bharrosh@panasas.com, linux-scsi@vger.kernel.org, matthew@wil.cx

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 12 Oct 2007 13:04:33 -0500

> On Thu, 2007-10-11 at 17:38 -0700, David Miller wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Date: Thu, 11 Oct 2007 11:20:58 -0700
> > 
> > > Well if fc4.c compiles OK on non-sparc64 then perhaps we should enable
> > > compilation on non-sparc64.  It will increase maintainability and code
> > > quality and stuff.
> > 
> > No objections to including drivers/fc4/Kconfig directly from
> > drivers/Kconfig.
> > 
> > It's only included directly from arch/sparc64/Kconfig because
> > long long ago drivers/Kconfig could not be safely included
> > there.
> 
> Would you be able to test out Matthew's patch and ack it?  Not having
> fc4 compile is a blocker for the necessary SCSI merge.

Unfortunately it doesn't build.  The drivers/scsi/pluto.c part
fails with:

drivers/scsi/pluto.c: In function $,1rx(Bpluto_detect$,1ry(B:
drivers/scsi/pluto.c:159: error: $,1rx(Bpluto_detect_done$,1ry(B undeclared (first use in this function)
drivers/scsi/pluto.c:159: error: (Each undeclared identifier is reported only once
drivers/scsi/pluto.c:159: error: for each function it appears in.)
make[1]: *** [drivers/scsi/pluto.o] Error 1
make: *** [drivers/scsi/pluto.o] Error 2

I think it can be fixed by merely removing the assignment on that
line, but I'l like Matthew to look at that and generate a new
patch if he agrees that is sufficient.

Also, drivers/fc4/fc.c gives a warning:

drivers/fc4/fc.c: In function $,1rx(Bfcp_scsi_abort$,1ry(B:
drivers/fc4/fc.c:867: warning: unused variable $,1rx(Bfcmd$,1ry(B
drivers/fc4/fc.c: In function $,1rx(B__fcp_scsi_host_reset$,1ry(B:
drivers/fc4/fc.c:990: warning: unused variable $,1rx(Bfcmd$,1ry(B

which is fixed thusly:

--- ./drivers/fc4/fc.c~	2007-10-12 15:21:20.000000000 -0700
+++ ./drivers/fc4/fc.c	2007-10-12 15:22:03.000000000 -0700
@@ -864,7 +864,6 @@
 int fcp_scsi_abort(struct scsi_cmnd *SCpnt)
 {
 	/* Internal bookkeeping only. Lose 1 cmd_slots slot. */
-	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
 	fc_channel *fc = FC_SCMND(SCpnt);
 	
 	/*
@@ -987,7 +986,6 @@
 static int __fcp_scsi_host_reset(struct scsi_cmnd *SCpnt)
 {
 	fc_channel *fc = FC_SCMND(SCpnt);
-	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
 	int i;
 
 	printk ("FC: host reset\n");
