From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v3 10/20] lpfc: Fix provide host name and OS name in
 RSNN-NN FC-GS command
Date: Wed, 15 Apr 2015 00:02:18 +0200
Message-ID: <20150415000218.00007e7c@localhost>
References: <55242ae6.b7GjnkXu1bXVHKz1%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56713 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbbDNWCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2015 18:02:25 -0400
In-Reply-To: <55242ae6.b7GjnkXu1bXVHKz1%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Fix provide host name and OS name in RSNN-NN FC-GS command
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 61a32cd..5fb431a 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1074,8 +1074,25 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
>  
>  	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
>  
> -	n = snprintf(symbol, size, "Emulex %s FV%s DV%s",
> -		vport->phba->ModelName, fwrev, lpfc_release_version);
> +	n = snprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
> +
> +	if (size < n)
> +		return n;
> +	n += snprintf(symbol + n, size - n, " FV%s", fwrev);
> +
> +	if (size < n)
> +		return n;
> +	n += snprintf(symbol + n, size - n, " DV%s", lpfc_release_version);
> +
> +	if (size < n)
> +		return n;
> +	n += snprintf(symbol + n, size - n, " HN:%s", init_utsname()->nodename);
> +
> +	/* Note :- OS name is "Linux" */
> +	if (size < n)
> +		return n;
> +	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
> +
>  	return n;
>  }

Does this actually "fix" anything? If not maybe drop "fix" from the
patch subject and description.

Sebastian
