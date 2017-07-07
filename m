From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] scsi: qedi: silence sprintf() overflow warning
Date: Fri, 7 Jul 2017 15:09:57 +0300
Message-ID: <20170707120957.oolync7fdudpmcwb@mwanda>
References: <20170207130103.GA31552@mwanda>
 <5899CB2D.4050809@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23753 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdGGMKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2017 08:10:32 -0400
Content-Disposition: inline
In-Reply-To: <5899CB2D.4050809@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: QLogic-Storage-Upstream@cavium.com, Thomas Gleixner <tglx@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Feb 07, 2017 at 02:27:09PM +0100, walter harms wrote:
> 
> 
> Am 07.02.2017 14:01, schrieb Dan Carpenter:
> > The problem here is this:
> > 
> > 	sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
> > 
> > host_buf is 16 character so we only have 6 characters left for
> > ->host_no.  But ->host_no is set in scsi_host_alloc():
> > 
> > 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
> > 
> > It could theoretically go up to 0x8000000 so we need space for 10
> > digits.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> > index 5eda21d903e9..0dcf3b08230c 100644
> > --- a/drivers/scsi/qedi/qedi_main.c
> > +++ b/drivers/scsi/qedi/qedi_main.c
> > @@ -1735,7 +1735,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
> >  	u32 dp_module = 0;
> >  	u8 dp_level = 0;
> >  	bool is_vf = false;
> > -	char host_buf[16];
> > +	char host_buf[20];
> >  	struct qed_link_params link_params;
> >  	struct qed_slowpath_params sp_params;
> >  	struct qed_probe_params qed_params;
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> any chance to use snprintf here ?
>  sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
> 
> or something like asprint() :)
> 
> if ever anyone change the type to very_long_type in the future it would simply break
> but not hurt.

No, I don't think that's required.  There are infinite possible futures
and the future you're describing is not likely.  We'd just end up making
the code more complicated for no reason.

regards,
dan carpenter
