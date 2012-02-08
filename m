From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SCSI, st: modify tape driver to allow writing immediate
 filemarks
Date: Tue, 07 Feb 2012 17:15:23 -0800
Message-ID: <1328663723.27428.2.camel@joe2Laptop>
References: <4F31CAC0.3010905@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35047 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754899Ab2BHBPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2012 20:15:25 -0500
In-Reply-To: <4F31CAC0.3010905@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 17:07 -0800, Lee Duncan wrote:
> Add an st module option st_nowait_eof which defaults to 0. Setting this
> option to 1 tells the st driver not to wait when writing a filemark, which
> can result in much faster times on streaming tape drives.

trivial comments:

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
[]
> @@ -81,6 +81,7 @@ static int max_sg_segs;
>  static int try_direct_io = TRY_DIRECT_IO;
>  static int try_rdio = 1;
>  static int try_wdio = 1;
> +static int st_nowait_eof = 0;

Could be bool.

> @@ -1106,6 +1109,11 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
>                                      STp->drv_buffer));
>  		}
>  		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
> +		if (!STp->drv_buffer && STp->immediate_filemark) {
> +			printk(KERN_WARNING "%s: non-buffered tape: "
> +			    "disabling writing immediate filemarks", name);

Needs terminating "\n" and it's better to coalesce the
format and ignore 80 char lines to make arbitrary greps
a bit easier.

> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
[]
> @@ -120,6 +120,7 @@ struct scsi_tape {
>  	unsigned char c_algo;			/* compression algorithm */
>  	unsigned char pos_unknown;			/* after reset position unknown */
>  	unsigned char sili;			/* use SILI when reading in variable b mode */
> +	unsigned char immediate_filemark;	/* set immediate bit when writing filemark */

could be bool


