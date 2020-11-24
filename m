Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13C5C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB7B206F7
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zEKAJy/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403940AbgKXRnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:43:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403887AbgKXRnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 12:43:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHecQa113065;
        Tue, 24 Nov 2020 17:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=jsIk56DnCkj7IJv1XqL5o2mPcH87gUVi8d40/kXkwk8=;
 b=zEKAJy/gdRypIYhh5+59CvgzUyyoh2PM0TWhHOibJUEKhzOI7TwYd+JVjTWhffOtnbND
 /NB9YBhoBDwXZ9H8xOg1cvL3oGO8qWE5qO0A1bn2dTHaWn7S6+qPYEHeMOJHeYruVR77
 agcrWTcOmA8pOWXFhsX9JF01iD2Kz4J1RNpjRRhTbiys6+hpMaaCfsskgrGgshOPZuFS
 Ayewc77D0tMWqIzjgJf+RHUhGqRkYQXkHMsWVAMCotlk2TNdqIOTOfMldWxva79rR3qv
 8+eVrIfnZ26f1hPAEYOFCR/46zI+xEDNhb1//Ly+cVYAKST0llxLNeIaKgM+7a+RGSZA iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34xtum431y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 17:43:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHdxNH103997;
        Tue, 24 Nov 2020 17:43:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34ycfnmrw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:43:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AOHhf3j008609;
        Tue, 24 Nov 2020 17:43:41 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Nov 2020 09:43:41 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 3/5] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1605070685-20945-4-git-send-email-muneendra.kumar@broadcom.com>
Date:   Tue, 24 Nov 2020 11:43:40 -0600
Cc:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>, hare@suse.de,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <360897A0-5FEB-46F4-8E09-8AC5356A29B0@oracle.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-4-git-send-email-muneendra.kumar@broadcom.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 10, 2020, at 10:58 PM, Muneendra <muneendra.kumar@broadcom.com> =
wrote:
>=20
> Added a new rport state FC_PORTSTATE_MARGINAL.
>=20
> Added a new interface fc_eh_should_retry_cmd which Checks if the cmd
> should be retried or not by checking the rport state.
> If the rport state is marginal it returns
> false to make sure there won't be any retries on the cmd.
>=20
> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> fc_timeout_deleted_rport functions  to handle the new rport state
> FC_PORTSTATE_MARGINAL.
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v7:
> Removed the changes related to SCMD_NORETRIES_ABORT bit.
>=20
> Added a new function fc_eh_should_retry_cmd to check whether the cmd
> should be retried based on the rport state.
>=20
> v6:
> No change
>=20
> v5:
> Made changes to clear the SCMD_NORETRIES_ABORT bit if the port_state
> has changed from marginal to online due to port_delete and port_add
> as we need the normal cmd retry behaviour
>=20
> Made changes in fc_scsi_scan_rport as we are checking =
FC_PORTSTATE_ONLINE
> instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL
>=20
> v4:
> Made changes in fc_eh_timed_out to call =
fc_rport_chkmarginal_set_noretries
> so that SCMD_NORETRIES_ABORT bit in cmd->state is set if rport state
> is marginal.
>=20
> Removed the newly added scsi_cmd argument to fc_remote_port_chkready
> as the current patch handles only SCSI EH timeout/abort case.
>=20
> v3:
> Rearranged the patch so that all the changes with respect to new
> rport state is part of this patch.
> Added a new argument to scsi_cmd  to fc_remote_port_chkready
>=20
> v2:
> New patch
> ---
> drivers/scsi/scsi_transport_fc.c | 62 +++++++++++++++++++++++---------
> include/scsi/scsi_transport_fc.h |  4 ++-
> 2 files changed, 49 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index a926e8f9e56e..ffd25195ae62 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -148,20 +148,23 @@ fc_enum_name_search(host_event_code, =
fc_host_event_code,
> static struct {
> 	enum fc_port_state	value;
> 	char			*name;
> +	int			matchlen;
> } fc_port_state_names[] =3D {
> -	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
> -	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
> -	{ FC_PORTSTATE_ONLINE,		"Online" },
> -	{ FC_PORTSTATE_OFFLINE,		"Offline" },
> -	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
> -	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
> -	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
> -	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
> -	{ FC_PORTSTATE_ERROR,		"Error" },
> -	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
> -	{ FC_PORTSTATE_DELETED,		"Deleted" },
> +	{ FC_PORTSTATE_UNKNOWN,		"Unknown", 7},
> +	{ FC_PORTSTATE_NOTPRESENT,	"Not Present", 11 },
> +	{ FC_PORTSTATE_ONLINE,		"Online", 6 },
> +	{ FC_PORTSTATE_OFFLINE,		"Offline", 7 },
> +	{ FC_PORTSTATE_BLOCKED,		"Blocked", 7 },
> +	{ FC_PORTSTATE_BYPASSED,	"Bypassed", 8 },
> +	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics", 11 },
> +	{ FC_PORTSTATE_LINKDOWN,	"Linkdown", 8 },
> +	{ FC_PORTSTATE_ERROR,		"Error", 5 },
> +	{ FC_PORTSTATE_LOOPBACK,	"Loopback", 8 },
> +	{ FC_PORTSTATE_DELETED,		"Deleted", 7 },
> +	{ FC_PORTSTATE_MARGINAL,	"Marginal", 8 },
> };
> fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
> +fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
> #define FC_PORTSTATE_MAX_NAMELEN	20
>=20
>=20
> @@ -2509,7 +2512,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint =
channel, uint id, u64 lun)
> 		if (rport->scsi_target_id =3D=3D -1)
> 			continue;
>=20
> -		if (rport->port_state !=3D FC_PORTSTATE_ONLINE)
> +		if ((rport->port_state !=3D FC_PORTSTATE_ONLINE) &&
> +			(rport->port_state !=3D FC_PORTSTATE_MARGINAL))
> 			continue;
>=20
> 		if ((channel =3D=3D rport->channel) &&
> @@ -3373,7 +3377,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
>=20
> 	spin_lock_irqsave(shost->host_lock, flags);
>=20
> -	if (rport->port_state !=3D FC_PORTSTATE_ONLINE) {
> +	if ((rport->port_state !=3D FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state !=3D FC_PORTSTATE_MARGINAL)) {
> 		spin_unlock_irqrestore(shost->host_lock, flags);
> 		return;
> 	}
> @@ -3515,7 +3520,8 @@ fc_timeout_deleted_rport(struct work_struct =
*work)
> 	 * target, validate it still is. If not, tear down the
> 	 * scsi_target on it.
> 	 */
> -	if ((rport->port_state =3D=3D FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state =3D=3D FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state =3D=3D FC_PORTSTATE_MARGINAL)) &&
> 	    (rport->scsi_target_id !=3D -1) &&
> 	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
> 		dev_printk(KERN_ERR, &rport->dev,
> @@ -3658,7 +3664,8 @@ fc_scsi_scan_rport(struct work_struct *work)
> 	struct fc_internal *i =3D to_fc_internal(shost->transportt);
> 	unsigned long flags;
>=20
> -	if ((rport->port_state =3D=3D FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state =3D=3D FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state =3D=3D FC_PORTSTATE_MARGINAL)) &&
> 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
> 	    !(i->f->disable_target_scan)) {
> 		scsi_scan_target(&rport->dev, rport->channel,
> @@ -3731,6 +3738,28 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
> }
> EXPORT_SYMBOL(fc_block_scsi_eh);
>=20
> +/*
> + * fc_eh_should_retry_cmd - Checks if the cmd should be retried or =
not
> + * @scmd:        The SCSI command to be checked
> + *
> + * This checks the rport state to decide if a cmd is
> + * retryable.
> + *
> + * Returns: true if the rport state is not in marginal state.
> + */
> +bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
> +{
> +	struct fc_rport *rport =3D =
starget_to_rport(scsi_target(scmd->device));
> +
> +	if ((rport->port_state !=3D FC_PORTSTATE_ONLINE) &&
> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
> +		return false;
> +	}
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(fc_eh_should_retry_cmd);
> +
> /**
>  * fc_vport_setup - allocates and creates a FC virtual port.
>  * @shost:	scsi host the virtual port is connected to.
> @@ -4162,7 +4191,8 @@ static blk_status_t fc_bsg_rport_prep(struct =
fc_rport *rport)
> 	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
> 		return BLK_STS_RESOURCE;
>=20
> -	if (rport->port_state !=3D FC_PORTSTATE_ONLINE)
> +	if ((rport->port_state !=3D FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state !=3D FC_PORTSTATE_MARGINAL))
> 		return BLK_STS_IOERR;
>=20
> 	return BLK_STS_OK;
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index c759b29e46c7..14214ee121ad 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -67,6 +67,7 @@ enum fc_port_state {
> 	FC_PORTSTATE_ERROR,
> 	FC_PORTSTATE_LOOPBACK,
> 	FC_PORTSTATE_DELETED,
> +	FC_PORTSTATE_MARGINAL,
> };
>=20
>=20
> @@ -742,7 +743,6 @@ struct fc_function_template {
> 	unsigned long	disable_target_scan:1;
> };
>=20
> -
> /**
>  * fc_remote_port_chkready - called to validate the remote port state
>  *   prior to initiating io to the port.
> @@ -758,6 +758,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
>=20
> 	switch (rport->port_state) {
> 	case FC_PORTSTATE_ONLINE:
> +	case FC_PORTSTATE_MARGINAL:
> 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
> 			result =3D 0;
> 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
> @@ -839,6 +840,7 @@ int fc_vport_terminate(struct fc_vport *vport);
> int fc_block_rport(struct fc_rport *rport);
> int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
> enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
> +bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd);
>=20
> static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
> {
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

