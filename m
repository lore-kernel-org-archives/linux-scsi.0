Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11045C55179
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 16:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF7AB2192A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 16:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e6hVhwK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751413AbgJWQPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 12:15:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbgJWQPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2020 12:15:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NGAIUN007203;
        Fri, 23 Oct 2020 16:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=bigP06vlnL6tUn2wOGRAfk/n5JU1se02HuCAzmd4niw=;
 b=e6hVhwK9uwq20kT/FKe02sTlElaiN7sRPjIiElhTIs4elxq8AqDdH9wDM57upNCc1qaK
 EMdeptZQiFF8/kVpHyLt7Lm+EbfahsqGRjPB9Fa4W4RNc5Nn2P/lRGCems4p43NbpHwK
 7ZJ4RHNqqRSi5zS4mrRZBEqG4KXsUa1IYz6FHf3C8t2vQ+9U2MlzVkwbYnLJNk6F7l1R
 3w/u0lDaeEoT+CLAAlUHBf2qRSLCrcXGpCch2P5n17xcU3BZoNcfzTjMzdpUzhS0BKOm
 W9/cbkm723ZzecVSU7F84ZLW6uP2pEIi9CNbH5dmP1ht8uDYP/J11TsGNQZ4AmZBrIWo rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16vaa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 16:15:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NGB5VM035298;
        Fri, 23 Oct 2020 16:15:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 348aj14t6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 16:15:49 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09NGFm47003253;
        Fri, 23 Oct 2020 16:15:48 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 09:15:48 -0700
Subject: Re: [PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
Message-ID: <8663f5b8-d743-2a75-4bf1-350e3690957b@oracle.com>
Date:   Fri, 23 Oct 2020 11:15:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/20 7:34 PM, Mike Christie wrote:
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 86617bb..63ba363 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1632,14 +1632,17 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>   		vqs[i] = &vs->vqs[i].vq;
>   		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
>   	}
> -	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
> -		       VHOST_SCSI_WEIGHT, 0, true, NULL);
> +	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
> +			   VHOST_SCSI_WEIGHT, 0, true, NULL))


> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index f40205f..a1a35e1 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -630,9 +630,10 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>   	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
>   	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
>   
> -	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
> -		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
> -		       VHOST_VSOCK_WEIGHT, true, NULL);
> +	if (vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
> +			   UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
>

Just giving myself a review comment, so it doesn't happen like last time 
where multiple people waste their time and hit the same issue :)

I will fix this one found by the kernel test robot and fix up a similar 
scsi.c case where the return value is not propagated above.
