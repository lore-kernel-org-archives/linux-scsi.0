From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/7] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date: Fri, 27 Jun 2014 12:47:55 +0200
Message-ID: <53AD4BDB.2040707@linux.vnet.ibm.com>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:60631 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaF0KsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 06:48:08 -0400
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 27 Jun 2014 11:48:06 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id DBD9317D8056
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 11:49:32 +0100 (BST)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5RAm4DE32309302
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 10:48:04 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5RAlxXi028182
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 04:48:03 -0600
In-Reply-To: <1403850425-89297-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/27/2014 08:27 AM, Hannes Reinecke wrote:
> Issuing a host reset should not rely on any commands.
> So use Scsi_Host as argument for eh_host_reset_handler.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

>   drivers/s390/scsi/zfcp_scsi.c             |  3 +-

>   69 files changed, 289 insertions(+), 379 deletions(-)

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_s=
csi.c
> index dc42c93..fe50f69 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -281,13 +281,14 @@ static int zfcp_scsi_eh_target_reset_handler(st=
ruct scsi_cmnd *scpnt)
>   	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
>   }
>
> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>   {
>   	struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->device);

Scpnt argument no longer exists, so this line must likely go away to=20
compile.

>   	struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;

This needs the assignment from the added line below since zfcp_sdev no=20
longer exists.
Alternatively, drop the assignment here, only have the auto variable=20
definition, and do the assignment below with the added line.

>   	struct fc_rport *rport =3D zfcp_sdev->port->rport;
>   	int ret;
>
> +	adapter =3D (struct zfcp_adapter *)host->hostdata[0];
>   	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>   	zfcp_erp_wait(adapter);
>   	ret =3D fc_block_scsi_eh(rport);

A question just for my understanding: Calling fc_block_scsi_eh at the=20
end *after* our adapter recovery is OK to wait for rports to become=20
unblocked (or fast_io_failed)?
I would guess so.

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
