From: walter harms <wharms@bfs.de>
Subject: Re: [patch] scsi: qedi: silence sprintf() overflow warning
Date: Tue, 07 Feb 2017 14:27:09 +0100
Message-ID: <5899CB2D.4050809@bfs.de>
References: <20170207130103.GA31552@mwanda>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:47317 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754285AbdBGN1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 08:27:13 -0500
In-Reply-To: <20170207130103.GA31552@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QLogic-Storage-Upstream@cavium.com, Thomas Gleixner <tglx@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 07.02.2017 14:01, schrieb Dan Carpenter:
> The problem here is this:
> 
> 	sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
> 
> host_buf is 16 character so we only have 6 characters left for
> ->host_no.  But ->host_no is set in scsi_host_alloc():
> 
> 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
> 
> It could theoretically go up to 0x8000000 so we need space for 10
> digits.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 5eda21d903e9..0dcf3b08230c 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1735,7 +1735,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
>  	u32 dp_module = 0;
>  	u8 dp_level = 0;
>  	bool is_vf = false;
> -	char host_buf[16];
> +	char host_buf[20];
>  	struct qed_link_params link_params;
>  	struct qed_slowpath_params sp_params;
>  	struct qed_probe_params qed_params;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

any chance to use snprintf here ?
 sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);

or something like asprint() :)

if ever anyone change the type to very_long_type in the future it would simply break
but not hurt.

re,
 wh
