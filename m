From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [patch] [SCSI] fnic: potential dead lock in
 fnic_is_abts_pending()
Date: Tue, 4 Jun 2013 23:12:43 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B1289CC541@xmb-rcd-x08.cisco.com>
References: <20130530074926.GA8148@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:26775 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3FDXWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jun 2013 19:22:17 -0400
In-Reply-To: <20130530074926.GA8148@debian>
Content-Language: en-US
Content-ID: <7879ACA98A5006468799483A61B9584B@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Suma Ramars (sramars)" <sramars@cisco.com>, "Brian Uchino (buchino)" <buchino@cisco.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>


On 5/30/13 12:50 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>There is an unlock missing if the == FNIC_IOREQ_ABTS_PENDING is
>false.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>---
>Static analysis.  I can't test this.
>
>diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
>index be99e75..a97e6e5 100644
>--- a/drivers/scsi/fnic/fnic_scsi.c
>+++ b/drivers/scsi/fnic/fnic_scsi.c
>@@ -2432,11 +2432,9 @@ int fnic_is_abts_pending(struct fnic *fnic, struct
>scsi_cmnd *lr_sc)
> 			      "Found IO in %s on lun\n",
> 			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
> 
>-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
>-			spin_unlock_irqrestore(io_lock, flags);
>+		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
> 			ret = 1;
>-			continue;
>-		}
>+		spin_unlock_irqrestore(io_lock, flags);
> 	}
> 
> 	return ret;

Tested-by: Hiral Patel <hiralpat@cisco.com>

Acked-by: Hiral Patel <hiralpat@cisco.com>

