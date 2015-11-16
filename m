From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 2/2] qla2xxx: fix rwlock recursion
Date: Mon, 16 Nov 2015 23:57:32 +0100
Message-ID: <564A5F5C.4050209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38550 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbbKPW5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2015 17:57:34 -0500
Received: by wmec201 with SMTP id c201so1154156wme.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2015 14:57:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

Bart Van Assche wrote:

> [PATCH] qla2xxx: Fix rwlock recursion
> 
> Fixes: 8dfa4b5a9b44 ("qla2xxx: Fix sparse annotation")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reported-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>   drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index eb0cc54..b6b4cfd 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -433,7 +433,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, 
> ulong off_in,
>   	if (off_in < QLA82XX_PCI_CRBSPACE)
>   		return -1;
> 
> -	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
> +	off_in -= QLA82XX_PCI_CRBSPACE;
> 
>   	/* Try direct map */
>   	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
> @@ -443,6 +443,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, 
> ulong off_in,
>   		return 0;
>   	}
>   	/* Not in direct map, use crb window */
> +	*off_out = (void __iomem *)off_in;
>   	return 1;
>   }
> 
> -- 
> 2.1.4

This patch is still pending or it was lost, could you please resend it ?

-thanks-
