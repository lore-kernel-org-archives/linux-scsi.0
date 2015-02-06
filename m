From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 10/21] lpfc: Fix provide host name and OS name in RSNN-NN
 FC-GS command
Date: Fri, 06 Feb 2015 13:20:29 +0100
Message-ID: <54D4B18D.2070306@redhat.com>
References: <1423164268.7917.34.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbbBFMUc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 07:20:32 -0500
In-Reply-To: <1423164268.7917.34.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org

On 02/05/2015 08:24 PM, James Smart wrote:
> ---
>  drivers/scsi/lpfc/lpfc_ct.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 61a32cd..5091184 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1070,12 +1070,29 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
>  	size_t size)
>  {
>  	char fwrev[FW_REV_STR_SIZE];
> -	int n;
> +	int n = 0;

No need for this^ initialisation , as 'n' is directly set  two lines later

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
> +	/* Note :- OS name is "Linux" as per requirement BZ168199. */
> +	if (size < n)
> +		return n;
> +	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
> +
>  	return n;
>  }
>  

