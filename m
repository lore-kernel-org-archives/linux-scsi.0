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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BCEC8300F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 19:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76487205F4
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 19:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgLBT14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:27:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57504 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731084AbgLBT1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 14:27:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JPRwh030640;
        Wed, 2 Dec 2020 19:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=87lthsip4IiiAZqUix6X3fi43G6/rcARtSiR/tLsvKc=;
 b=wXStjpXLJcUtI6M7Xh0JAn4U2a11DuZ6mwBjYn0sUhfa9jTam6sPakywOqRjHaSwURgA
 eV9nD2MW4UNX2APhqnfqDPlsSpA4As+K1r97srGBOAKFwdgiIPHbz2JNseaML9uxCwDo
 oVkwXbYgsVXoN+2XrwEePQUtYBSwCx9ZCx0DCk8CYcDrtI0DIYOLfeMTokBfnEKVkzNg
 1PHC7Ryod+jpzHzBy3SEfxVCHfGmzyC0mlwia4TptDycTGEYq/mAgb8O/h9Xum/OBBs5
 5b50w9wBph/zZwIS7gVIgti/34qOYTq++UYWWUG/HZ5ijbbzOXyrqHRYAbam8zIJJnPb aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqtb1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 19:27:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JPNqF186528;
        Wed, 2 Dec 2020 19:27:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540g09tmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 19:27:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B2JR2xQ012128;
        Wed, 2 Dec 2020 19:27:02 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 11:27:01 -0800
Subject: Re: [PATCH] scsi: qedi: fix missing destroy_workqueue() on error in
 __qedi_probe
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201109091518.55941-1-miaoqinglang@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c359603c-b26a-44f9-fce5-2dc4816b1400@oracle.com>
Date:   Wed, 2 Dec 2020 13:27:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201109091518.55941-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=2 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 3:15 AM, Qinglang Miao wrote:
> Add the missing destroy_workqueue() before return from
> __qedi_probe in the error handling case when fails to
> create workqueue qedi->offload_thread.
> 
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 61fab01d2d52..f5fc7f518f8a 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2766,7 +2766,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
>  			QEDI_ERR(&qedi->dbg_ctx,
>  				 "Unable to start offload thread!\n");
>  			rc = -ENODEV;
> -			goto free_cid_que;
> +			goto free_tmf_thread;
>  		}
>  
>  		INIT_DELAYED_WORK(&qedi->recovery_work, qedi_recovery_handler);
> @@ -2790,6 +2790,8 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
>  
>  	return 0;
>  
> +free_tmf_thread:
> +	destroy_workqueue(qedi->tmf_thread);
>  free_cid_que:
>  	qedi_release_cid_que(qedi);
>  free_uio:
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
