From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
Date: Fri, 17 Oct 2008 12:34:50 -0500
Message-ID: <1224264890.3368.24.camel@localhost.localdomain>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>
	 <6416EE16C1AF1E4C86882867E4DD0FF602B1F971@CORPUSMX40B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52523 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593AbYJQRe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 13:34:58 -0400
In-Reply-To: <6416EE16C1AF1E4C86882867E4DD0FF602B1F971@CORPUSMX40B.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Levy_Jerome@emc.com
Cc: linux-scsi@vger.kernel.org

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

