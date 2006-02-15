From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc_transport: stop creating duplicate rport entries.
Date: Wed, 15 Feb 2006 08:54:58 -0500
Message-ID: <43F332B2.4000901@emulex.com>
References: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:5545 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1945944AbWBONzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2006 08:55:11 -0500
In-Reply-To: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Good Catch!

-- james s

Andrew Vasquez wrote:
> Current fc_transport consumers initially register rports
> with an UNKNOWN role-state and follow-up with a call to
> fc_remote_port_rolechg().  Modify code in
> fc_remote_port_add() to scan the fc_host_rport_bindings()
> array for consistent bindings regardless of role-type.
> Original code would only scan bindings array for targets,
> causing duplicate fc_remote_ports/rport-X:Y-Z entries to be
> created for the yet-to-be-role-changed rports.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
> This should go into 2.6.16.
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index f2c9acf..929032e 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -1498,8 +1498,7 @@ fc_remote_port_add(struct Scsi_Host *sho
>  	}
>  
>  	/* Search the bindings array */
> -	if (likely((ids->roles & FC_RPORT_ROLE_FCP_TARGET) &&
> -		(fc_host_tgtid_bind_type(shost) != FC_TGTID_BIND_NONE))) {
> +	if (fc_host_tgtid_bind_type(shost) != FC_TGTID_BIND_NONE) {
>  
>  		/* search for a matching consistent binding */
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
