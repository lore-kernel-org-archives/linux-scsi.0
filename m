From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: 2.6.15-rc4 error messages with multiple qla2300 hba ports on fabric
Date: Wed, 7 Dec 2005 15:54:07 -0800
Message-ID: <20051207235407.GB3137@andrew-vasquezs-powerbook-g4-15.local>
References: <B179AE41C1147041AA1121F44614F0B0012AD98D@AVEXCH02.qlogic.org> <43907957.70402@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:20569 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964978AbVLGXyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 18:54:09 -0500
Content-Disposition: inline
In-Reply-To: <43907957.70402@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 02 Dec 2005, Michael Reed wrote:

> Andrew Vasquez wrote:
> > 
> >> From: Michael Reed [mailto:mdr@sgi.com]
> >>
> > 
> > Sidenote:  I'm on the east-coast until hopefully tonight -- won't
> > have a chance to look at debugging this for a couple of days...
> > 
> >> I've been testing with the qla2300 driver with 2.6.14.3 and 2.6.15-rc4.
> >> I've observed two sets of error messages which are not present with
> >> 2.6.14.3.
> >>
> >> First, the qla2300 driver is generating soft lockups.
> > 
> > Have a backtrace?
> 
> In the previously attached dmesg file, extracted below.  Is the driver polling
> for mailbox interrupt?

Yes during init-time, the driver polls for mailbox completions, in
this case it's for a PLOGI completion...

...
> qla2300 0002:01:04.0: Topology - (F_Port), Host Loop address 0xffff
> BUG: soft lockup detected on CPU#0!
> Modules linked in:
...
>  [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
>                                 sp=e00000b07bb27920 bsp=e00000b07bb21558
>  [<a000000100580380>] qla2x00_mailbox_command+0x860/0xc40
>                                 sp=e00000b07bb27af0 bsp=e00000b07bb21498
>  [<a000000100581070>] qla2x00_login_fabric+0x150/0x260
>                                 sp=e00000b07bb27b40 bsp=e00000b07bb21440
>  [<a000000100575580>] qla2x00_fabric_login+0xc0/0x3a0
>                                 sp=e00000b07bb27ba0 bsp=e00000b07bb21388

I'm wondering if something like the following is more appropriate.

---

Slight variant from a patch submitted by Jeff Layton
<jlayton@redhat.com>.

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9746cd1..3de8fee 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -196,7 +196,9 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha);
 
-			udelay(10); /* v4.27 */
+			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
+			    !ha->flags.mbox_int)
+				msleep(10);
 		} /* while */
 	}
 
