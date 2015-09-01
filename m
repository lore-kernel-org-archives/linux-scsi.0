From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 09/14] fix: lpfc_send_rscn_event sends bigger buffer
 size
Date: Tue, 1 Sep 2015 23:41:11 +0200
Message-ID: <20150901234111.00006b62@localhost>
References: <55e4bd90.zlcxDDRSu3edLd6S%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60125 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbbIAVlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 17:41:21 -0400
In-Reply-To: <55e4bd90.zlcxDDRSu3edLd6S%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> From: Ales Novak <alnovak@suse.cz>
> 
> lpfc_send_rscn_event() allocates data for sizeof(struct
> lpfc_rscn_event_header) + payload_len, but claims that the data has size
> of sizeof(struct lpfc_els_event_header) + payload_len. That leads to
> buffer overruns.
> 
> Signed-off-by: Ales Novak <alnovak@suse.cz>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index c859aa3..f9c957d 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5401,7 +5401,7 @@ lpfc_send_rscn_event(struct lpfc_vport *vport,
>  
>  	fc_host_post_vendor_event(shost,
>  		fc_get_event_number(),
> -		sizeof(struct lpfc_els_event_header) + payload_len,
> +		sizeof(struct lpfc_rscn_event_header) + payload_len,
>  		(char *)rscn_event_data,
>  		LPFC_NL_VENDOR_ID);
>  

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
