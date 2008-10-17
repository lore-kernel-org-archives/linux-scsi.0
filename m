From: Levy_Jerome@emc.com
Subject: RE: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
Date: Fri, 17 Oct 2008 14:17:13 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF65CFD0F@CORPUSMX40B.corp.emc.com>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com><6416EE16C1AF1E4C86882867E4DD0FF602B1F971@CORPUSMX40B.corp.emc.com> <1224264890.3368.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:55733 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYJQSRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2008 14:17:51 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

The change was the addition of rq->flags = 0; the memset isn't mine. Sorry about the whitespace -- I'm still a bit new at this. 
As to why it's necessary, I've had boot-time oopses on two completely different hosts -- one iSCSI, one FC -- which both resolved to exactly the same code; bizarre values in rq->flags. The source seems to OR the desired values in but never actually initializes rq->flags (the memset initializes the CDB, not the flags variable), so I added the line to do so. After testing the old module to confirm the oops still occurred regularly, I installed the new code and have since (in over 100 reboots) been unable to reproduce the oops. 

Jerry

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Fri 10/17/2008 1:34 PM
To: Levy, Jerome
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
 
On Mon, 2008-10-13 at 13:41 -0400, Levy_Jerome@emc.com wrote:
> Patch to fix intermittent but frequent oops occurring with multiple
> paths to Clariion at boot. 
> Cause is uninitialized rq->flags variable which presents garbage from
> clariion_activate.

There are several syntactic problems with the patch:  It's against a
pretty old kernel (cmd has been a pointer for a while, so the memset
went away).  It's also whitespace damaged (all tabs have become spaces).

However, I also don't quite understand why this is necessary.  All calls
to blk_get_request() ultimately end up in blk_rq_init() which does a
memset(rq, 0, sizeof(*rq)) which should clear flags.  How is it getting
bogus data?

James

> Signed-off-by: Jerry Levy <levy_jerome@emc.com>
> ---------------------
> --- drivers/scsi/device_handler/scsi_dh_emc.orig        2008-10-13
> 13:33:35.000000000 -0400
> +++ drivers/scsi/device_handler/scsi_dh_emc.c   2008-10-09
> 16:20:15.000000000 -0400
> @@ -283,6 +283,7 @@
>         memset(rq->cmd, 0, BLK_MAX_CDB);
>         rq->cmd[0] = cmd;
>         rq->cmd_len = COMMAND_SIZE(cmd);
> +       rq->flags = 0;
> 
>         switch (cmd) {
>         case MODE_SELECT:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



