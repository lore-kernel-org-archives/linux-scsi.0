Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F5FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 19:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA57611ED
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 19:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhJNT2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 15:28:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48906 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhJNT2A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 15:28:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EHlw7K022386;
        Thu, 14 Oct 2021 15:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=T+FTQs9iC3vHNPf7SovINCy/F5ijYl2mOFuFPVuo+m8=;
 b=fmK5trA1WcDRh89vftUEbaYc4LjT13bWDgpCHbpTAHJmiaOVq2wL7kKpy4bOc74ajVMZ
 awr6WQ1yL0BX14Js9Vi2pifEIcPtniFv8eaZVCiSWr42bg2wnxeqzCaurNHOmuUFXiCN
 YtC48atOTq2dq9ASO+lnaHmcgy9fCgVudSiKSR1dg9RRGwK0K0FUZ3KzwW8XQ5RNbzZ1
 cf0u4aAY+gfCptZYzu4andUr5M7LrMkbEOa49vVeYDAnYer99yKQfOPFO34zf1OrHNej
 ka/v9g0DXHYALdA9MSbPcDl8faF0MX5e39gCVPAbXWxb9ZFggHX6Ijk+wdhCvKoiG3oy hQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bps921xy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 15:25:36 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EJHofj016595;
        Thu, 14 Oct 2021 19:25:35 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3bkeq8smdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 19:25:35 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EJPXeA47644970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 19:25:33 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 677916A054;
        Thu, 14 Oct 2021 19:25:33 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 447F06A051;
        Thu, 14 Oct 2021 19:25:33 +0000 (GMT)
Received: from localhost (unknown [9.211.53.229])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 19:25:33 +0000 (GMT)
From:   Nathan Lynch <nathanl@linux.ibm.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] scsi: ibmvscsi: Use dma_alloc_noncoherent() instead
 of get_zeroed_page/dma_map_single()
In-Reply-To: <20211012032317.2360-1-caihuoqing@baidu.com>
References: <20211012032317.2360-1-caihuoqing@baidu.com>
Date:   Thu, 14 Oct 2021 14:25:32 -0500
Message-ID: <878ryvz9w3.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Fwemt4NK7GdPjxbk-RoXEt7GPzNnhFpZ
X-Proofpoint-GUID: Fwemt4NK7GdPjxbk-RoXEt7GPzNnhFpZ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_10,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=849
 lowpriorityscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cai Huoqing <caihuoqing@baidu.com> writes:
> @@ -331,18 +329,12 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
>  	int retrc;
>  	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
>  
> -	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
> -
> -	if (!queue->msgs)
> -		goto malloc_failed;
>  	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
> -
> -	queue->msg_token = dma_map_single(hostdata->dev, queue->msgs,
> -					  queue->size * sizeof(*queue->msgs),
> -					  DMA_BIDIRECTIONAL);
> -
> -	if (dma_mapping_error(hostdata->dev, queue->msg_token))
> -		goto map_failed;
> +	queue->msgs = dma_alloc_noncoherent(hostdata->dev,
> +					    PAGE_SIZE, &queue->msg_token,
> +					    DMA_BIDIRECTIONAL, GFP_KERNEL);
> +	if (!queue->msg)
> +		goto malloc_failed;


This version appears to retain the build breakage from v1 which was
reported here:

https://lore.kernel.org/linuxppc-dev/202110121452.nWPHZeZg-lkp@intel.com/

   drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'ibmvscsi_init_crq_queue':
>> drivers/scsi/ibmvscsi/ibmvscsi.c:334:21: error: 'struct crq_queue' has no member named 'msg'; did you mean 'msgs'?
     334 |         if (!queue->msg)
         |                     ^~~
         |                     msgs
   drivers/scsi/ibmvscsi/ibmvscsi.c:388:60: error: 'struct crq_queue' has no member named 'msg'; did you mean 'msgs'?
     388 |         dma_free_coherent(hostdata->dev, PAGE_SIZE, queue->msg, queue->msg_token);
         |                                                            ^~~
         |                                                            msgs

