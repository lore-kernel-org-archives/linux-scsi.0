From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch] [SCSI] libosd: check for kzalloc() failure
Date: Wed, 30 Jan 2013 17:56:13 +0200
Message-ID: <5109429D.1080802@panasas.com>
References: <20130130070602.GB12396@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:44801 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab3A3P42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 10:56:28 -0500
In-Reply-To: <20130130070602.GB12396@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 01/30/2013 09:06 AM, Dan Carpenter wrote:
> There wasn't any error handling for this kzalloc().
> 

ACK-by: Boaz Harrosh <bharrosh@panasas.com>

James please queue for inclusion

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan

> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index c06b8e5..d8293f2 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -144,6 +144,10 @@ static int _osd_get_print_system_info(struct osd_dev *od,
>  	odi->osdname_len = get_attrs[a].len;
>  	/* Avoid NULL for memcmp optimization 0-length is good enough */
>  	odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
> +	if (!odi->osdname) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  	if (odi->osdname_len)
>  		memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
>  	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
> 

