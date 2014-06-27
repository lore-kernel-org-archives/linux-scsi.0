From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh
Date: Fri, 27 Jun 2014 14:46:30 +0200
Message-ID: <53AD67A6.9060503@linux.vnet.ibm.com>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:39560 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaF0Mqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 08:46:44 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 27 Jun 2014 13:46:42 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3957E1B08040
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 13:47:12 +0100 (BST)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5RCkdHZ31916054
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 12:46:39 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5RCkYKC022129
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 06:46:38 -0600
In-Reply-To: <1403850425-89297-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

On 06/27/2014 08:27 AM, Hannes Reinecke wrote:
> fc_block_scsi_eh() works on a remote port, so we should be using
> that as an argument and not the scsi command.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@emulex.com>
> ---
>   drivers/s390/scsi/zfcp_scsi.c     |  9 ++++++---

>   10 files changed, 56 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_s=
csi.c
> index 7b35364..dc42c93 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -173,6 +173,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi=
_cmnd *scpnt)
>   	struct zfcp_adapter *adapter =3D
>   		(struct zfcp_adapter *) scsi_host->hostdata[0];
>   	struct zfcp_fsf_req *old_req, *abrt_req;
> +	struct fc_rport *rport =3D starget_to_rport(scsi_target(scpnt->devi=
ce));
>   	unsigned long flags;
>   	unsigned long old_reqid =3D (unsigned long) scpnt->host_scribble;
>   	int retval =3D SUCCESS, ret;
> @@ -199,7 +200,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi=
_cmnd *scpnt)
>   			break;
>
>   		zfcp_erp_wait(adapter);
> -		ret =3D fc_block_scsi_eh(scpnt);
> +		ret =3D fc_block_scsi_eh(rport);
>   		if (ret) {
>   			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
>   			return ret;
> @@ -234,6 +235,7 @@ static int zfcp_task_mgmt_function(struct scsi_cm=
nd *scpnt, u8 tm_flags)
>   {
>   	struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->device);
>   	struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;
> +	struct fc_port *rport =3D zfcp_sdev->port->rport;

typo: struct fc_port =3D> struct fc_rport

>   	struct zfcp_fsf_req *fsf_req =3D NULL;
>   	int retval =3D SUCCESS, ret;
>   	int retry =3D 3;
> @@ -244,7 +246,7 @@ static int zfcp_task_mgmt_function(struct scsi_cm=
nd *scpnt, u8 tm_flags)
>   			break;
>
>   		zfcp_erp_wait(adapter);
> -		ret =3D fc_block_scsi_eh(scpnt);
> +		ret =3D fc_block_scsi_eh(rport);
>   		if (ret)
>   			return ret;
>
> @@ -283,11 +285,12 @@ static int zfcp_scsi_eh_host_reset_handler(stru=
ct scsi_cmnd *scpnt)
>   {
>   	struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->device);
>   	struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;
> +	struct fc_rport *rport =3D zfcp_sdev->port->rport;
>   	int ret;
>
>   	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>   	zfcp_erp_wait(adapter);
> -	ret =3D fc_block_scsi_eh(scpnt);
> +	ret =3D fc_block_scsi_eh(rport);
>   	if (ret)
>   		return ret;
>

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
