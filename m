From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi_transport_sas: add 'scsi_target_id' sysfs attribute
Date: Fri, 11 Mar 2016 12:53:39 -0600
Message-ID: <56E31433.3070009@linux.vnet.ibm.com>
References: <1457710401-37716-1-git-send-email-hare@suse.de>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:53108 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbcCKSxD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 13:53:03 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 11 Mar 2016 13:53:02 -0500
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id E2F346E804D
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 13:39:50 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2BIr0Iv33226974
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 18:53:00 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2BIqwAe028548
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 13:52:59 -0500
In-Reply-To: <1457710401-37716-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 3/11/2016 9:33 AM, Hannes Reinecke wrote:
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
> index 80520e2..deb3fde 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1286,6 +1286,7 @@ sas_rphy_protocol_attr(identify.target_port_protocols, target_port_protocols);
>   sas_rphy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
>   		unsigned long long);
>   sas_rphy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
> +sas_rphy_simple_attr(scsi_target_id, scsi_target_id, "%d\n", u8);

Hannes:

Shouldn't the last argument be u32?

- Manoj Kumar


