Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89224C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 20:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3417164E7A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 20:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhBYUzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:55:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6574 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhBYUxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 15:53:34 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PKofCK097139;
        Thu, 25 Feb 2021 15:52:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OkJ8g4z7uO/0ftuLGJT7ZoQdMFGw+WhDvbkOlzHsEU0=;
 b=FZI8YpVQwB9bHvDpQu5t2vD6SmHvmlDPiOLt6iEa5JEQIOKO3n2T9URr0WizpI22JuQ4
 DLYuAmEBw0ELOEZi9p0h50R4FeWjgucnylPOiMaHgPohvOrYcMSNINMfNpC4Nl0vDaaE
 TnT48go//DAVLZUKUBudF3GZeNP3f/99pFBZ/sBHLKiJYg9eswJQNdC0Apgls8M71iip
 G9KRLhE+m/1fsuYSBtE/igPe8Ys/OG3YOvkSHD8olHPI4rpd6nC4mxREeMN0EsiDDHpX
 hVN+Ix5BHOGr238Z5UfNrhQmMu/wPxiNkJsCZob0zD9VLL+vcufc5Aa5uU1kctFXmGjQ ag== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xk6dg7ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 15:52:47 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PKks7W002717;
        Thu, 25 Feb 2021 20:52:47 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 36tt29hgbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 20:52:47 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PKqkKI23724410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 20:52:46 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EC93BE053;
        Thu, 25 Feb 2021 20:52:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 173C5BE051;
        Thu, 25 Feb 2021 20:52:44 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.44.137])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 20:52:44 +0000 (GMT)
Subject: Re: [PATCH v2 5/5] ibmvfc: reinitialize sub-CRQs and perform channel
 enquiry after LPM
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210225204824.14570-1-tyreld@linux.ibm.com>
 <20210225204824.14570-6-tyreld@linux.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <5da10708-c3a0-d985-17a3-f56e9ef851ee@linux.ibm.com>
Date:   Thu, 25 Feb 2021 12:52:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210225204824.14570-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_11:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102250158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/21 12:48 PM, Tyrel Datwyler wrote:
> A live partition migration (LPM) results in a CRQ disconnect similar to
> a hard reset. In this LPM case the hypervisor moslty perserves the CRQ
> transport such that it simply needs to be reenabled. However, the
> capabilities may have changed such as fewer channels, or no channels at
> all. Further, its possible that there may be sub-CRQ support, but no
> channel support. The CRQ reenable path currently doesn't take any of
> this into consideration.
> 
> For simpilicty release and reinitialize sub-CRQs during reenable, and
> set do_enquiry and using_channels with the appropriate values to trigger
> channel renegotiation.
> 
This should of had the same fixes tag as patch 2.

fixes: faacf8c5f1d5 ("ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ Channels")

> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 4ac2c442e1e2..9ae6be56e375 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -903,6 +903,9 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>  {
>  	int rc = 0;
>  	struct vio_dev *vdev = to_vio_dev(vhost->dev);
> +	unsigned long flags;
> +
> +	ibmvfc_release_sub_crqs(vhost);
>  
>  	/* Re-enable the CRQ */
>  	do {
> @@ -914,6 +917,16 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>  	if (rc)
>  		dev_err(vhost->dev, "Error enabling adapter (rc=%d)\n", rc);
>  
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	spin_lock(vhost->crq.q_lock);
> +	vhost->do_enquiry = 1;
> +	vhost->using_channels = 0;
> +
> +	ibmvfc_init_sub_crqs(vhost);
> +
> +	spin_unlock(vhost->crq.q_lock);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +
>  	return rc;
>  }
>  
> 

