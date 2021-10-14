Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ADAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 23:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC366108B
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 23:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhJNXRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:17:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhJNXRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 19:17:54 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EKdq4B013490;
        Thu, 14 Oct 2021 19:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 subject : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cCbkqufKm/LzI41BMQVYIhYz7oSMXKDVX6lxZMNyusM=;
 b=nJ74ofw8dynrPumFYQsc+E4a4WJRTNOsfgG6LT9QCQG1DCAsLj1gl6Bh4QMyDVuHfj5A
 r85LJYgUqPQIGFvVNPAvnAsJzfAjlcpvamKMt6nwLFP0Nd9dVKZ/gC2ZBBL9axkoW3vy
 h0BN/JwpoMxbFl2u9PbrYgKrJhQ5Ivc995b2BAJvsaVrfBqaoGpc7SINXQPzPciiEvEG
 6hPyAzXbc1kqEpCyn4+FwWYc2PH79yTOHkFazS2QiuUT3gRwk6WYYhTsmCCgOkpznxRm
 BV2CBmUEbkasHQtFQkVmilIuzg6TPUBb2p7fvI8+UhOVGaVSayndqMKhuFwhmc3gTEot UQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bpus8jtx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 19:15:42 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ENDkXw025318;
        Thu, 14 Oct 2021 23:15:39 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3bnm2f15eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 23:15:39 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ENFc9Y41025886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 23:15:38 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F1EDB206C;
        Thu, 14 Oct 2021 23:15:38 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8254DB206E;
        Thu, 14 Oct 2021 23:15:37 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.220.106])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 23:15:37 +0000 (GMT)
To:     tyreld@linux.vnet.ibm.com
Cc:     brking@linux.vnet.ibm.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        martin.petersen@oracle.com
References: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in
 initialize_event_pool
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <bbab1043-ee3a-6d5b-7ff5-ea5ed84e9fb8@linux.ibm.com>
Date:   Thu, 14 Oct 2021 16:15:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2X6hSS2uRndpUdDnPelK54ypMf5nzmcE
X-Proofpoint-ORIG-GUID: 2X6hSS2uRndpUdDnPelK54ypMf5nzmcE
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_11,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140129
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just stumbled upon this trivial little patch that looks to have gotten lost in
the shuffle. Seems it even got a reviewed-by from Brian [1].

So, uh I guess after almost 3 years...ping?

-Tyrel

[1]
https://yhbt.net/lore/all/fd33df0e-012b-e437-c6e9-29cd0883808d@linux.vnet.ibm.com/

On 01/09/2019 08:59 PM, Tyrel Datwyler wrote:
> During driver probe we allocate a dma region for our event pool.
> Currently, zero is passed for the gfp_flags parameter. Driver probe
> callbacks run in process context and we hold no locks so we can sleep
> here if necessary.
>
> Fix by passing GFP_KERNEL explicitly to dma_alloc_coherent().
>
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index cb8535e..10d5e77 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -465,7 +465,7 @@ static int initialize_event_pool(struct event_pool *pool,
>  	pool->iu_storage =
>  	    dma_alloc_coherent(hostdata->dev,
>  			       pool->size * sizeof(*pool->iu_storage),
> -			       &pool->iu_token, 0);
> +			       &pool->iu_token, GFP_KERNEL);
>  	if (!pool->iu_storage) {
>  		kfree(pool->events);
>  		return -ENOMEM;
>
