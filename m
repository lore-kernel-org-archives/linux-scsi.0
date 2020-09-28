Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C703C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2AD208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HFGyy1Ar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgI1VEr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:04:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49226 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgI1VEr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 17:04:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKxoPE192805;
        Mon, 28 Sep 2020 21:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pZ9T/R+/+7JnsZCgNgymSC9eBk/pp9PcELq2Qz/TXD4=;
 b=HFGyy1Arg3cQ6GhlZjwH5yVZCNPL2M7EIdzNtSrJjjPrDbo8meRsmKa7ek+tBdRxDQ5S
 dt9YjCYNpKWiOnziJ/BXy/Eusb8fma8jovgMAv1cLJaDWI788Ksjld5eus86kCgb0h9V
 ppo+YfwhVBAR1X4VC4+PHXGF6AYGOZyHdm78lkw9x2sQmp4w82+uJiMfCm5mWycB/hmD
 oaObHAY4kir0gB70pt0eiCjlIV++6TJPYitgmrrlUKhu/UUHXFAdGfXe2bBMqzba5OkY
 PCfz7DOf8k7lPkumha0xd4s+gYWBGbqtMdlsya4d2hXoBKBnPLlgEqSrtfO4HgamfKFV Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5aqfeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 21:04:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SL4Ena156330;
        Mon, 28 Sep 2020 21:04:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33tf7kt64e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 21:04:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SL4gEs027143;
        Mon, 28 Sep 2020 21:04:43 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 14:04:42 -0700
Subject: Re: [PATCH 5/7] qla2xxx: fix crash on session cleanup with unload
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-6-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <2430454d-c877-adcf-1ea7-07798da769ac@oracle.com>
Date:   Mon, 28 Sep 2020 16:04:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 12:50 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> On unload, session cleanup prematurely gave the signal for driver
> unload path to advance.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_target.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 7711f95033c0..2a0d3c85766a 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1231,14 +1231,15 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
>   	case DSC_DELETE_PEND:
>   		return;
>   	case DSC_DELETED:
> -		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
> -			wake_up_all(&tgt->waitQ);
> -		if (sess->vha->fcport_count == 0)
> -			wake_up_all(&sess->vha->fcport_waitQ);
> -
>   		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
> -			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
> +			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT]) {
> +			if (tgt && tgt->tgt_stop && tgt->sess_count == 0)
> +				wake_up_all(&tgt->waitQ);
> +
> +			if (sess->vha->fcport_count == 0)
> +				wake_up_all(&sess->vha->fcport_waitQ);
>   			return;
> +		}
>   		break;
>   	case DSC_UPD_FCPORT:
>   		/*q
> 

This needs to go to stable as well.

Please add

Fixes: 726b85487067d  ("qla2xxx: Add framework for async fabric discovery")

otherwise looks good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                         Oracle Linux Engineering
