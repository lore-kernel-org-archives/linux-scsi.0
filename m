Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0921BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 22:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB60564F2C
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 22:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBYWOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:14:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233902AbhBYWOr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 17:14:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PM2mgN004827;
        Thu, 25 Feb 2021 17:13:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OF+xJHlYMnB7oeiL0q32FeC0pfWAxPe/KrGKJazKw3I=;
 b=iJ1pOHs8SUhK0cmRFP9x51TQedcFBstEEqTYR/1JZTn65j0UvpwoB/vrXPXUPC4oHqC5
 fkogjiExeZVOFLh8tWSfddhfTqiTUUTMlsyIWa7EnjmINXzoLNdC7RIKHMXQtS1XRr+M
 X9o5vkJFd0+bGOFRqwIRYmA6mIW7aVjwRB91ids7RcazgabtNx495oKdC5WPpNbKmqYz
 14NSrPe8TYK52hAKQ8bvDfeC+oBymmYABn9b83449l15ezR9gZoln3WZpnP2Fx4rEQNr
 vt8ndGqd1T+3ZuU8YHzru/Lq9tc6ppEaQlUodb6a3Wl5cWi4P2hDq0Tw6sZFiLaJxQxE PQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xfcxhp3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 17:13:33 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PMCDcF002387;
        Thu, 25 Feb 2021 22:13:32 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 36tt2a20qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 22:13:32 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PMDV8r12190114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 22:13:31 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E0ABBE051;
        Thu, 25 Feb 2021 22:13:31 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD3DBE04F;
        Thu, 25 Feb 2021 22:13:29 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.44.137])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 22:13:29 +0000 (GMT)
Subject: Re: [PATCH v3 2/5] ibmvfc: fix invalid sub-CRQ handles after hard
 reset
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210225214237.22400-1-tyreld@linux.ibm.com>
 <20210225214237.22400-3-tyreld@linux.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <c4e0c5db-2743-ea2e-8dd4-6dc4bdc9d572@linux.ibm.com>
Date:   Thu, 25 Feb 2021 14:13:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210225214237.22400-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_14:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/21 1:42 PM, Tyrel Datwyler wrote:
> A hard reset results in a complete transport disconnect such that the
> CRQ connection with the partner VIOS is broken. This has the side effect
> of also invalidating the associated sub-CRQs. The current code assumes
> that the sub-CRQs are perserved resulting in a protocol violation after
> trying to reconnect them with the VIOS. This introduces an infinite loop
> such that the VIOS forces a disconnect after each subsequent attempt to
> re-register with invalid handles.
> 
> Avoid the aforementioned issue by releasing the sub-CRQs prior to CRQ
> disconnect, and driving a reinitialization of the sub-CRQs once a new
> CRQ is registered with the hypervisor.
> 
> fixes: faacf8c5f1d5 ("ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ Channels")
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> Reviewed-by: Brian King <brking@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 384960036f8b..2cca55f2e464 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -158,6 +158,9 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *);
>  static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
>  static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
>  
> +static void ibmvfc_release_sub_crqs(struct ibmvfc_host *);
> +static void ibmvfc_init_sub_crqs(struct ibmvfc_host *);
> +
>  static const char *unknown_error = "unknown error";
>  
>  static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
> @@ -926,8 +929,8 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>  	unsigned long flags;
>  	struct vio_dev *vdev = to_vio_dev(vhost->dev);
>  	struct ibmvfc_queue *crq = &vhost->crq;
> -	struct ibmvfc_queue *scrq;
> -	int i;
> +
> +	ibmvfc_release_sub_crqs(vhost);
>  
>  	/* Close the CRQ */
>  	do {
> @@ -936,6 +939,8 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>  		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
>  	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>  
> +	ibmvfc_init_sub_crqs(vhost);

This has the same issue as patch 5 in that if fail to set up sub-crqs do_enquiry
will be set to zero, but the locked code region below will then flip it back to
one which we don't want.

-T

> +
>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>  	spin_lock(vhost->crq.q_lock);
>  	vhost->state = IBMVFC_NO_CRQ;
> @@ -947,16 +952,6 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>  	memset(crq->msgs.crq, 0, PAGE_SIZE);
>  	crq->cur = 0;
>  
> -	if (vhost->scsi_scrqs.scrqs) {
> -		for (i = 0; i < nr_scsi_hw_queues; i++) {
> -			scrq = &vhost->scsi_scrqs.scrqs[i];
> -			spin_lock(scrq->q_lock);
> -			memset(scrq->msgs.scrq, 0, PAGE_SIZE);
> -			scrq->cur = 0;
> -			spin_unlock(scrq->q_lock);
> -		}
> -	}
> -
>  	/* And re-open it again */
>  	rc = plpar_hcall_norets(H_REG_CRQ, vdev->unit_address,
>  				crq->msg_token, PAGE_SIZE);
> @@ -966,6 +961,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>  		dev_warn(vhost->dev, "Partner adapter not ready\n");
>  	else if (rc != 0)
>  		dev_warn(vhost->dev, "Couldn't register crq (rc=%d)\n", rc);
> +
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>  
> @@ -5692,6 +5688,7 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
>  
>  	free_irq(scrq->irq, scrq);
>  	irq_dispose_mapping(scrq->irq);
> +	scrq->irq = 0;
>  
>  	do {
>  		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
> 

