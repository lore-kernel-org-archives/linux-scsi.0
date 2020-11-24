Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B8BC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E785A206C0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jqVzqsHg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404008AbgKXRrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:47:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60004 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403935AbgKXRrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 12:47:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHeZ2J016959;
        Tue, 24 Nov 2020 17:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=SrC1MPaeb8YIM01kqo1k2A7vhURfg43IGThsDyqfzSs=;
 b=jqVzqsHgvcQ04wy+zJSkuMgbvj/nmWXxvSkIpux+W5lwKYxqZlNwgZLj75GJg+wna50l
 nFTz9GLG7PurGEFdRZVUUzPZ3B5cmdNXr7hyHgM55CMZcZXPj3LZt3QOkeHVIJN8hTMq
 njseZgC9ZY9iA5BLNBqwA8/pIbyVT3YwJ5jYdQd+9Tw9KsfpSwdF/lqujFa+O8e5jIGn
 mjxy5DserYKek7aOpRJY+ogvUvNaxOvuKeo3j5Ek/Tf2Dqo7OAa2hNHtGVUs3tzRsz/q
 W4vju03Lm3jJ0RRXLEACzwqcfxE+8v37wQrt2Rz682dN2mPu6Y043s6bGOUUEv3nJiKh Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34xrdav957-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 17:45:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHev1N117360;
        Tue, 24 Nov 2020 17:43:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34yctwt9rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:43:14 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AOHhDaI012336;
        Tue, 24 Nov 2020 17:43:13 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Nov 2020 09:43:13 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 2/5] scsi: No retries on abort success
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
Date:   Tue, 24 Nov 2020 11:43:13 -0600
Cc:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <81652DA5-494A-413C-AB85-914909167855@oracle.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 10, 2020, at 10:58 PM, Muneendra <muneendra.kumar@broadcom.com> =
wrote:
>=20
> Added a new optional routine eh_should_retry_cmd
> in scsi_host_template that allows the transport to decide if a
> cmd is retryable.Return true if the transport is in a state the
> cmd should be retried on.
>=20
> Added a new interface scsi_eh_should_retry_cmd which checks and
> calls the new routine eh_should_retry_cmd.
>=20
> Made changes in scmd_eh_abort_handler and scsi_eh_flush_done_q which
> calls the scsi_eh_should_retry_cmd to check whether the
> command needs to be retried.
>=20
> The above changes were done based on a patch by Mike Christie.
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v7:
> Added New routine in scsi_host_template to decide if a cmd is
> retryable instead of checking the same using  SCMD_NORETRIES_ABORT
> bit as the cmd retry part can be checked by validating the port state.
>=20
> Moved the DID_TRANSPORT_MARGINAL changes to previous patch
> for reordering
>=20
> v6:
> Rearranged the patch by merging second hunk of the patch2 in v5
> to this patch
>=20
> v5:
> added the DID_TRANSPORT_MARGINAL case to
> scsi_decide_disposition
> v4:
> Modified the comments in the code appropriately
>=20
> v3:
> Merged  first part of the previous patch(v2 patch3) with
> this patch.
>=20
> v2:
> set the hostbyte as DID_TRANSPORT_MARGINAL instead of
> DID_TRANSPORT_FAILFAST.
> ---
> drivers/scsi/scsi_error.c | 17 +++++++++++++++--
> include/scsi/scsi_host.h  |  6 ++++++
> 2 files changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 28056ee498b3..1cdfa5a8ca09 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -124,6 +124,17 @@ static bool scsi_cmd_retry_allowed(struct =
scsi_cmnd *cmd)
> 	return ++cmd->retries <=3D cmd->allowed;
> }
>=20
> +static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_device *sdev =3D cmd->device;
> +	struct Scsi_Host *host =3D sdev->host;
> +
> +	if (host->hostt->eh_should_retry_cmd)
> +		return  host->hostt->eh_should_retry_cmd(cmd);
> +
> +	return true;
> +}
> +
> /**
>  * scmd_eh_abort_handler - Handle command aborts
>  * @work:	command to be aborted.
> @@ -159,7 +170,8 @@ scmd_eh_abort_handler(struct work_struct *work)
> 						    "eh timeout, not =
retrying "
> 						    "aborted =
command\n"));
> 			} else if (!scsi_noretry_cmd(scmd) &&
> -				   scsi_cmd_retry_allowed(scmd)) {
> +				   scsi_cmd_retry_allowed(scmd) &&
> +				scsi_eh_should_retry_cmd(scmd)) {
> 				SCSI_LOG_ERROR_RECOVERY(3,
> 					scmd_printk(KERN_WARNING, scmd,
> 						    "retry aborted =
command\n"));
> @@ -2111,7 +2123,8 @@ void scsi_eh_flush_done_q(struct list_head =
*done_q)
> 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
> 		list_del_init(&scmd->eh_entry);
> 		if (scsi_device_online(scmd->device) &&
> -		    !scsi_noretry_cmd(scmd) && =
scsi_cmd_retry_allowed(scmd)) {
> +		    !scsi_noretry_cmd(scmd) && =
scsi_cmd_retry_allowed(scmd) &&
> +			scsi_eh_should_retry_cmd(scmd)) {
> 			SCSI_LOG_ERROR_RECOVERY(3,
> 				scmd_printk(KERN_INFO, scmd,
> 					     "%s: flush retry cmd\n",
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 701f178b20ae..e30fd963b97d 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -314,6 +314,12 @@ struct scsi_host_template {
> 	 * Status: OPTIONAL
> 	 */
> 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
> +	/*
> +	 * Optional routine that allows the transport to decide if a cmd
> +	 * is retryable. Return true if the transport is in a state the
> +	 * cmd should be retried on.
> +	 */
> +	bool (*eh_should_retry_cmd)(struct scsi_cmnd *scmd);
>=20
> 	/* This is an optional routine that allows transport to initiate
> 	 * LLD adapter or firmware reset using sysfs attribute.
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

