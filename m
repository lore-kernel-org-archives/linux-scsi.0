From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 01/14] lpfc: The lpfc driver does not issue RFF_ID and
 RFT_ID in the correct sequence
Date: Tue, 21 Apr 2015 13:23:12 +0200
Message-ID: <20150421132312.00006862@localhost>
References: <55350588.xwtuh+7l3U0CWLLy%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53337 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbbDULXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 07:23:13 -0400
In-Reply-To: <55350588.xwtuh+7l3U0CWLLy%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> The lpfc driver does not issue RFF_ID and RFT_ID in the correct sequence
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
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

Can you please elaborate on the correct command order?
SLI_CTNS_RFF_ID was added last in 2fb9bd8 and moved to the top in
92d7f7b with the comment "Do this first!". Now it's moved back.

The libfc code suggests this is correct because it uses the same order.
qla2xxx on the other hand uses RFT_ID, RFF_ID, RNN_ID, RSNN_NN, but in
any case RFF_ID follows RFT_ID.

Sebastian
