Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F672C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 18:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DEF20878
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 18:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D3LqzgcW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392020AbgJPShp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 14:37:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392000AbgJPShp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2020 14:37:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GIY6w3081555;
        Fri, 16 Oct 2020 18:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=etjT+Xi33EXFoG0uB+tor0jvH1wNBjcrH/05fvukJu4=;
 b=D3LqzgcW5IC01Oclp8dJaUXYUxMd4mAHh03Ztck7UiJScAwfV7+PZ4rMEURzV5/1VBEJ
 TzLq2Q+pBTMYkSMY2M6l8WftBhITOXB4GQZVafNji13+V1oLGJcYbzQCDI3ddHfYMvXK
 bYeI42jRukzWHVdK/AZLQg/cnNI+TSU2HUArKfkrbLtAgO58qf7WxG6MP+wfJtdi8Dl+
 WfMo0skUcBIGZdhOyAye0Zoqu/csRtXultIoJOqeTAUiRuzuP+oRcyrFrsBbaQI0dLfA
 jChPE59KbRSv8FAJFEDcQInlOkR+QfDxU/HnTAVSlQ0KDpcnByRUFaI0jqEUaTR+ABA3 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 343vaeshrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Oct 2020 18:37:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GIZqwT065903;
        Fri, 16 Oct 2020 18:37:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 343phst8en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 18:37:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09GIbZEU028318;
        Fri, 16 Oct 2020 18:37:35 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 11:37:34 -0700
Subject: Re: [PATCH v3 03/17] scsi: No retries on abort success
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <3f4a9066-b2b0-80f9-133c-6c42c3831aca@oracle.com>
Date:   Fri, 16 Oct 2020 13:37:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1602732462-10443-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/20 10:27 PM, Muneendra wrote:
> Made an additional check in scsi_noretry_cmd to verify whether user has
> decided not to do retries on abort success by setting the
> SCMD_NORETRIES_ABORT bit
> 
> If SCMD_NORETRIES_ABORT bit is set we are making sure there won't be any
> retries done on the same path and also setting the host byte as
> DID_TRANSPORT_MARGINAL so that the error can be propogated as recoverable
> transport error to the blk layers.
> 
> Added a code in scsi_result_to_blk_status to translate
> a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
> i.e BLK_STS_TRANSPORT
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v3:
> Merged  first part of the previous patch(v2 patch3) with
> this patch.
> 
> v2:
> set the hostbyte as DID_TRANSPORT_MARGINAL instead of
> DID_TRANSPORT_FAILFAST.
> ---
>   drivers/scsi/scsi_error.c | 10 ++++++++++
>   drivers/scsi/scsi_lib.c   |  1 +
>   2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ae80daa5d831..aa30c1c9e9db 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1763,6 +1763,16 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   		return 0;
>   
>   check_type:
> +	/*
> +	 * Check whether caller has decided not to do retries on
> +	 * abort success by setting the SCMD_NORETRIES_ABORT bit

The comment seems wrong here because we are not setting that bit.

> +	 */
> +	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
> +		return 1;
> +	}
> +
>   	/*
>   	 * assume caller has checked sense and determined
>   	 * the check condition was retryable.
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2b5dea07498e..9606bad1542f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -629,6 +629,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
>   			return BLK_STS_OK;
>   		return BLK_STS_IOERR;
>   	case DID_TRANSPORT_FAILFAST:
> +	case DID_TRANSPORT_MARGINAL:
>   		return BLK_STS_TRANSPORT;
>   	case DID_TARGET_FAILURE:
>   		set_host_byte(cmd, DID_OK);
> 

