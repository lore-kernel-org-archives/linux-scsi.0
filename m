Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BB1C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 19:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB91322203
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 19:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgLBTgP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:36:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49904 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgLBTgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 14:36:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JZJD5081809;
        Wed, 2 Dec 2020 19:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Uw/G6EZJX4YmYr9zvI3PxyPsOjo4URTdPNU+xzFSpbI=;
 b=mUvVUxfUeAmdBNWskzbjHiey6o43hvXms+gLOXLAck+v0d7lt03gUQEaCOL640/LjciN
 +fneCgdzzmLW4Jq6t7nOF/itlITNpklr25XcjcL+xXlxJMLfXYs4hGnqN+aYVR+PGGO4
 QWtUYfHQS+eV8mND3PD+VL74LMPoz5EW/q4rJ2a0hK3xcQwyhx0zHqNRumWMZPrj0PWM
 mDJdW3edyYHvc4r/axxNEergyug8lifElv204LI+vnQAGAsRITXKkOq772dQtKxAUJB7
 2d4zR1/pR2jWo6j10RbOe3TXcsi9GGORoCJkb9KGrRyY9RNwIZN7wNTENNerFwJWoxSD hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b2etx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 19:35:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JUTr0151963;
        Wed, 2 Dec 2020 19:35:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404psauy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 19:35:19 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B2JZIEV006449;
        Wed, 2 Dec 2020 19:35:18 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 11:35:17 -0800
Subject: Re: [PATCH] scsi: iscsi: fix inappropriate use of put_device
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201120074852.31658-1-miaoqinglang@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <331a17b8-3219-cb73-90c8-4b814202a78f@oracle.com>
Date:   Wed, 2 Dec 2020 13:35:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201120074852.31658-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/20 1:48 AM, Qinglang Miao wrote:
> kfree(conn) is called inside put_device(&conn->dev) so that
> another one would cause use-after-free. Besides, device_unregister
> should be used here rather than put_device.
> 
> Fixes: f3c893e3dbb5 ("scsi: iscsi: Fail session and connection on transport registration failure")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 2eb3e4f93..2e68c0a87 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2313,7 +2313,9 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>  	return conn;
>  
>  release_conn_ref:
> -	put_device(&conn->dev);
> +	device_unregister(&conn->dev);
> +	put_device(&session->dev);
> +	return NULL;
>  release_parent_ref:
>  	put_device(&session->dev);
>  free_conn:
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

