From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] scsi_transport_sas: add 'scsi_target_id' sysfs
 attribute
Date: Mon, 14 Mar 2016 08:44:33 -0500
Message-ID: <56E6C041.3070703@linux.vnet.ibm.com>
References: <1457948588-14558-1-git-send-email-hare@suse.de>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:33654 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945AbcCNNnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 09:43:51 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Mon, 14 Mar 2016 09:43:50 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id B25B238C8041
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 09:43:48 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2EDhmE831981804
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 13:43:48 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2EDhlSQ016622
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 09:43:48 -0400
In-Reply-To: <1457948588-14558-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Hannes:

Thanks for correcting the last argument.

Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

---
Manoj Kumar

On 3/14/2016 4:43 AM, Hannes Reinecke wrote:
> There is no way to detect the scsi_target_id for any given SAS
> remote port, so add a new sysfs attribute 'scsi_target_id'.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_sas_internal.h  | 2 +-
>   drivers/scsi/scsi_transport_sas.c | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_sas_internal.h b/drivers/scsi/scsi_sas_internal.h
> index 6266a5d..e659912 100644
> --- a/drivers/scsi/scsi_sas_internal.h
> +++ b/drivers/scsi/scsi_sas_internal.h
> @@ -4,7 +4,7 @@
>   #define SAS_HOST_ATTRS		0
>   #define SAS_PHY_ATTRS		17
>   #define SAS_PORT_ATTRS		1
> -#define SAS_RPORT_ATTRS		7
> +#define SAS_RPORT_ATTRS		8
>   #define SAS_END_DEV_ATTRS	5
>   #define SAS_EXPANDER_ATTRS	7
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 80520e2..b6f958193 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1286,6 +1286,7 @@ sas_rphy_protocol_attr(identify.target_port_protocols, target_port_protocols);
>   sas_rphy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
>   		unsigned long long);
>   sas_rphy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
> +sas_rphy_simple_attr(scsi_target_id, scsi_target_id, "%d\n", u32);
>
>   /* only need 8 bytes of data plus header (4 or 8) */
>   #define BUF_SIZE 64
> @@ -1886,6 +1887,7 @@ sas_attach_transport(struct sas_function_template *ft)
>   	SETUP_RPORT_ATTRIBUTE(rphy_device_type);
>   	SETUP_RPORT_ATTRIBUTE(rphy_sas_address);
>   	SETUP_RPORT_ATTRIBUTE(rphy_phy_identifier);
> +	SETUP_RPORT_ATTRIBUTE(rphy_scsi_target_id);
>   	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_enclosure_identifier,
>   				       get_enclosure_identifier);
>   	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_bay_identifier,
>

