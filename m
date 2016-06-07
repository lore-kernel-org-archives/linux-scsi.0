From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi_debug: fix sleep in invalid context
Date: Tue, 7 Jun 2016 04:55:25 -0700
Message-ID: <20160607115525.GA30861@infradead.org>
References: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbcFGLz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 07:55:27 -0400
Content-Disposition: inline
In-Reply-To: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com, hch@infradead.org

> +static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
> +				  int arr_len, unsigned int off_dst)
> +{
> +	int act_len, n;
> +	struct scsi_data_buffer *sdb = scsi_in(scp);
> +	off_t skip = off_dst;

Why off_t which is a signed value instead of the unsigned in passed in?

> +#define RL_BUCKET_ELEMS 8
> +
>  /* Even though each pseudo target has a REPORT LUNS "well known logical unit"
>   * (W-LUN), the normal Linux scanning logic does not associate it with a
>   * device (e.g. /dev/sg7). The following magic will make that association:
> @@ -3285,12 +3315,14 @@ static int resp_report_luns(struct scsi_cmnd *scp,
>  	unsigned char select_report;
>  	u64 lun;
>  	struct scsi_lun *lun_p;
> -	u8 *arr;
> +	u8 arr[RL_BUCKET_ELEMS * sizeof(struct scsi_lun)];

just use an on-stack array of type struct scsi_lun here, e.g.:

	struct scsi_lun arr[RL_BUCKET_ELEMS];

Which you can then use directly instead of lun_p later, but which can
also be passed p_fill_from_dev_buffer as that takes a void pointer.
