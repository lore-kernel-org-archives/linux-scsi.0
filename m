Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C6DC18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 03:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9777222C3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 03:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gTQgSD0L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCKDKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 23:10:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgCKDKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 23:10:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B38w8G133922;
        Wed, 11 Mar 2020 03:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=FfO35PJq9jvL0setca5WXq+KdeRzxTD55FXS7tg0JvQ=;
 b=gTQgSD0LAmZWhzwpfCIvVRLIe2VS2s2KbV2SRNeNvg5RJoUAYlDmpvPVmzd++e4JYIY7
 XNCGHlKFzXvSzp3vPIX+V/NvqCvGs+zF9N4r72jgkGL8DX09Vh62HTNMNtTe4/hQ/uU/
 4CJLd1fEbJiKwJYynq/BMklQ4tq4IhIMn/6uglDaXueUCuTXTpiNy0DoeVz7A8jucVMW
 YZsjpkpdhynlFrNm2iRwQ5ccjWDuP5B7LjgMThtUlmMah5sDtnFCKRSdgL3CQandUjUx
 jJpF+XvhcXJM/ykkavwv0kzVTsemb4/MEhTedOlG6i3WrTxj7iyyylpsU9JcVue7obrm Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v643xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 03:10:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B38JEQ030440;
        Wed, 11 Mar 2020 03:10:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yp8pvt1w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 03:10:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B3AfZt009521;
        Wed, 11 Mar 2020 03:10:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 20:10:40 -0700
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        axboe@kernel.dk, dgilbert@interlog.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com,
        Ryan Attard <ryanattard@ryanattard.info>
Subject: Re: [PATCH 1/1 RESEND] Allow non-root users to perform ZBC commands.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200226170518.92963-1-ryanattard@ryanattard.info>
        <20200226170518.92963-2-ryanattard@ryanattard.info>
Date:   Tue, 10 Mar 2020 23:10:37 -0400
In-Reply-To: <20200226170518.92963-2-ryanattard@ryanattard.info> (Ryan
        Attard's message of "Wed, 26 Feb 2020 11:05:19 -0600")
Message-ID: <yq17dzrr3gy.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=3 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien: Please opine.

> Allow users with read permissions to issue REPORT ZONE commands and
> users with write permissions to manage zones on block devices supporting
> the ZBC specification.
>
> Signed-off-by: Ryan Attard <ryanattard@ryanattard.info>
> ---
>  block/scsi_ioctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index b4e73d5dd5c2..ef722f04f88a 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -193,6 +193,10 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>  	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
>  	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
>  	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
> +
> +	/* ZBC Commands */
> +	__set_bit(ZBC_OUT, filter->write_ok);
> +	__set_bit(ZBC_IN, filter->read_ok);
>  }
>  
>  int blk_verify_command(unsigned char *cmd, fmode_t mode)

-- 
Martin K. Petersen	Oracle Linux Engineering
