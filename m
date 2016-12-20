From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] qla2xxx: Include ATIO queue in firmware dump when
 in target mode
Date: Tue, 20 Dec 2016 06:10:49 -0800
Message-ID: <20161220141049.GB16487@infradead.org>
References: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
 <1482208424-12358-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37473 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934994AbcLTOKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 09:10:50 -0500
Content-Disposition: inline
In-Reply-To: <1482208424-12358-3-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Mon, Dec 19, 2016 at 08:33:36PM -0800, Himanshu Madhani wrote:
> Include ATIO queue for ISP27XX when firmware dump is collected
> for target mode.
> 
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_tmpl.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 36935c9..a38d38a6c 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -433,6 +433,18 @@ static inline void (*qla27xx_read_vector(uint width))(void __iomem*, void *, ulo
>  				count++;
>  			}
>  		}
> +	} else if (QLA_TGT_MODE_ENABLED() &&
> +	    (ent->t263.queue_type == T263_QUEUE_TYPE_ATIO)) {

no real need for the inner braces here.

> +	} else if (QLA_TGT_MODE_ENABLED() &&
> +	    (ent->t274.queue_type == T274_QUEUE_TYPE_ATIO_SHAD)) {

and here.

Othrwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
