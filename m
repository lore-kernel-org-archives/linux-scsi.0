From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 01/15] lpfc: The lpfc driver does not issue RFF_ID
 and RFT_ID in the correct sequence
Date: Sun, 24 May 2015 13:27:48 +0200
Message-ID: <20150524132748.00006243@localhost>
References: <555e1c04.iUZP5CxxteUR0DUk%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52708 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbbEXL3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 07:29:18 -0400
In-Reply-To: <555e1c04.iUZP5CxxteUR0DUk%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> The lpfc driver does not issue RFF_ID and RFT_ID in the correct sequence
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 2500f15..f2db89f 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -3868,11 +3868,11 @@ out:
>  
>  	if (vport->port_state < LPFC_VPORT_READY) {
>  		/* Link up discovery requires Fabric registration. */
> -		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0); /* Do this first! */
>  		lpfc_ns_cmd(vport, SLI_CTNS_RNN_ID, 0, 0);
>  		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
>  		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
>  		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
> +		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0);
>  
>  		/* Issue SCR just before NameServer GID_FT Query */
>  		lpfc_issue_els_scr(vport, SCR_DID, 0);

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>

Sebastian
