Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1378C4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 18:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 939AE2085B
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 18:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DCspPbt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbgJBSIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 14:08:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJBSIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 14:08:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092HtDDp118788;
        Fri, 2 Oct 2020 18:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8KUXiP5mPalx+8Bxxg62tIom5BlWJ1xMsNx3w4Odrp8=;
 b=DCspPbt0m/wgH2ckjpQQxqOzST18AU3/pTvGODGDxaIQnCf+mv+v+VZuaxUXxTk/o8tU
 WB40kaS670VS+mBjYfeyrCkh3Dalg6p7wkkwBRrz8JQg92zvVNflzxM7qgqt7+NLIZQJ
 +KSTpAN1RLCNHRP9VojKSs2vDNmtCVf+JtfTS5rUoWQYORjVtv8TRbFwG8IT8R74OVP0
 YLc8i8RGv9iEGVCxmGIvFWCNx6cUDIr+SYdHCv722Vy83ZZ5cP7APnM2Y2XW0iGcKogg
 Hv6nzqLlgZslZbAxZyAZ0aDAnVHb2wwn3zi67yOHYHm7LSgYEZcxWeHhv4re5xgos0nE HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9nm78p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 18:08:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092HoaxT095930;
        Fri, 2 Oct 2020 18:06:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfj3dbg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 18:06:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092I69V5011613;
        Fri, 2 Oct 2020 18:06:09 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 11:06:08 -0700
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list
 corruption early"
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
References: <20201002073341.12470-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <dc48abf2-0b54-0241-6931-e2041c5dbc40@oracle.com>
Date:   Fri, 2 Oct 2020 13:06:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002073341.12470-1-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=2 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/20 2:33 AM, Maurizio Lombardi wrote:
> This reverts commit b0055acaedf56a2717a6e2a4b700f1959a1b60df.
> 
> This warning is duplicated because the very same condition
> is already checked in __iscsit_free_cmd().
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_util.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 45ba07c6ec27..ff7830ddbd7b 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -764,8 +764,6 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>  	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>  	int rc;
>  
> -	WARN_ON(!list_empty(&cmd->i_conn_node));
> -
>  	__iscsit_free_cmd(cmd, shutdown);
>  	if (se_cmd) {
>  		rc = transport_generic_free_cmd(se_cmd, shutdown);
> 

Maurizio, are you hitting these WARN()s?

Patch looks ok.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
