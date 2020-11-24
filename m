Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD47BC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A815206C0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P4oMmewp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403815AbgKXRnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:43:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgKXRnB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 12:43:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHeYGv113002;
        Tue, 24 Nov 2020 17:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Pj6aFG522HTK2O+nZBQpXmZczUvG+SAK5w/01TmFfss=;
 b=P4oMmewpaKdNI1CC1BqCqkftFcRRFnxnH6zuX2rpLPR+R6moCJc4sjyxMHAxR57HABiN
 R09LltD03dQggfjO0OgKj5NZwp16pfdGt76n8KxXQHMJC7agdTjw4+UsxJl7+VmbGl7c
 yFBrO/2Rx0Kr3m2NsgS50IrgwcG38GndHnsqOfQSaZE9ehh5C0iumYUeKBpzXPUJulep
 SaArxVLzcFmUwe8gCvn7G11ww4pi4u0SfYvJg9OJuGmDKpbYv3aHYmJ1i7nDjqsxMK6D
 WX7pVtkpXsVsHkNEBvEaw7l9J+t6WhyW1v13xBkvWcqNRpKvTGimapj/j7YU5Oxeee3D eA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34xtum42vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 17:42:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHe0v8104153;
        Tue, 24 Nov 2020 17:42:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34ycfnmqvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:42:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AOHgqpT028909;
        Tue, 24 Nov 2020 17:42:52 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Nov 2020 09:42:52 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 1/5] scsi: Added a new error code
 DID_TRANSPORT_MARGINAL in scsi.h
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1605070685-20945-2-git-send-email-muneendra.kumar@broadcom.com>
Date:   Tue, 24 Nov 2020 11:42:50 -0600
Cc:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <955440FA-FBF0-410D-88C0-86AA2727F70D@oracle.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-2-git-send-email-muneendra.kumar@broadcom.com>
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
 phishscore=0 clxscore=1011 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 10, 2020, at 10:58 PM, Muneendra <muneendra.kumar@broadcom.com> =
wrote:
>=20
> Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
> errors in scsi.h
>=20
> Added a code in scsi_result_to_blk_status to translate
> a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
> i.e BLK_STS_TRANSPORT
>=20
> Added DID_TRANSPORT_MARGINAL case to scsi_decide_disposition
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v7:
> Rearranged the patch by moving the DID_TRANSPORT_MARGINAL
> and the changes with respect to the same to this patch
> from the previous patch2 in v6
>=20
> Removed the previuos patch patch1 in v6 as in the
> current approach there is no need of this bit SCMD_NORETRIES_ABORT
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
> drivers/scsi/scsi_error.c | 6 ++++++
> drivers/scsi/scsi_lib.c   | 1 +
> include/scsi/scsi.h       | 1 +
> 3 files changed, 8 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f11f51e2465f..28056ee498b3 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1861,6 +1861,12 @@ int scsi_decide_disposition(struct scsi_cmnd =
*scmd)
> 		 * the fast io fail tmo fired), so send IO directly =
upwards.
> 		 */
> 		return SUCCESS;
> +	case DID_TRANSPORT_MARGINAL:
> +		/*
> +		 * caller has decided not to do retries on
> +		 * abort success, so send IO directly upwards
> +		 */
> +		return SUCCESS;
> 	case DID_ERROR:
> 		if (msg_byte(scmd->result) =3D=3D COMMAND_COMPLETE &&
> 		    status_byte(scmd->result) =3D=3D =
RESERVATION_CONFLICT)
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 20a357563d3d..ce1e2adaca36 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -629,6 +629,7 @@ static blk_status_t =
scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
> 			return BLK_STS_OK;
> 		return BLK_STS_IOERR;
> 	case DID_TRANSPORT_FAILFAST:
> +	case DID_TRANSPORT_MARGINAL:
> 		return BLK_STS_TRANSPORT;
> 	case DID_TARGET_FAILURE:
> 		set_host_byte(cmd, DID_OK);
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5339baadc082..5b287ad8b727 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
> 				 * paths might yield different results =
*/
> #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device =
failed */
> #define DID_MEDIUM_ERROR  0x13  /* Medium error */
> +#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
> #define DRIVER_OK       0x00	/* Driver status                         =
  */
>=20
> /*
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

