From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/11]  qla2xxx: Generalize SNS generic-services routines.
Date: Tue, 14 Jun 2005 22:50:34 +0100
Message-ID: <20050614215034.GB5849@infradead.org>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com> <20050614053151.12127.52950.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37587 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261360AbVFNVuh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:50:37 -0400
Content-Disposition: inline
In-Reply-To: <20050614053151.12127.52950.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

> @@ -47,6 +55,9 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha
>  {
>  	ms_iocb_entry_t *ms_pkt;
>  
> +	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
> +		return qla24xx_prep_ms_iocb(ha, req_size, rsp_size);
> +

this is horrible style.  Please move the guts of the code of this
function to qla2x00_old_prep_ms_iocb and make qla2x00_prep_ms_iocb
a wrapper.  Or given that you things like this in lots of places
add a proper method table and just call ->prep_ms_iocb on it.

>  	ms_pkt = ha->ms_iocb;
>  	memset(ms_pkt, 0, sizeof(ms_iocb_entry_t));
>  
> @@ -72,6 +83,42 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha
>  }
>  
>  /**
> + * qla24xx_prep_ms_iocb() - Prepare common CT IOCB fields for SNS CT query.
> + * @ha: HA context
> + * @req_size: request size in bytes
> + * @rsp_size: response size in bytes
> + *
> + * Returns a pointer to the @ha's ms_iocb.
> + */
> +static inline void *
> +qla24xx_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)

also please try to avoid defining functions below their usage.  it makes
reading the code a lot harder.

