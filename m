Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0026CC5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CA6221EB
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aG2863Dj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgK0RsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 12:48:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbgK0RsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 12:48:05 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHWNPb112582;
        Fri, 27 Nov 2020 12:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0sHAXLDpFTxzUwp6vvLLQnlpWArFxVVqHBd4xj7FGlA=;
 b=aG2863DjaXjhWSpMoyf8Rw8QScc7BRLBkHuOljpkJ2NoPmwJk3bZpgvxE/E41J7HFXry
 AVBrGhsUfM11fPQGfWGP2RMjE/4pQZKMdJkKOaivdYP6l5aXnnks/G0Ph+Ua6FN6qcqB
 sV5WArpQ8JMey9EFfevMbwwvfW7ZogfHX/tV+ltNMPRXflmcUQuuXG6Yg+5J9Ij7RYsk
 T1NJFJaLsaNNUsytOlOiqLpNNhd/tTkAbaRNi9Q1l4L7OC8jKxaeWFTfPXP95FuzfVVr
 0hNwdEggDRHpOJUy2UtI7WK/UCAccqlTQol2hAIMQDlZp9lUpMXWp9KoPlWCZqxPUlRC 6g== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352y6um49x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 12:47:59 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHfnjY030800;
        Fri, 27 Nov 2020 17:47:58 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 34xtha4a5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 17:47:58 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARHloHJ11338384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 17:47:50 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFD17C6057;
        Fri, 27 Nov 2020 17:47:56 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E3EC6055;
        Fri, 27 Nov 2020 17:47:56 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.79.105])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 17:47:55 +0000 (GMT)
Subject: Re: [PATCH 06/13] ibmvfc: add handlers to drain and complete Sub-CRQ
 responses
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
 <20201126014824.123831-7-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <b3737660-4e13-8675-b4be-71283e2dcf99@linux.vnet.ibm.com>
Date:   Fri, 27 Nov 2020 11:47:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201126014824.123831-7-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_10:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=2 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/20 7:48 PM, Tyrel Datwyler wrote:
> The logic for iterating over the Sub-CRQ responses is similiar to that
> of the primary CRQ. Add the necessary handlers for processing those
> responses.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 72 ++++++++++++++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 6eaedda4917a..a8730522920e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -3371,6 +3371,78 @@ static int ibmvfc_toggle_scrq_irq(struct ibmvfc_sub_queue *scrq, int enable)
>  	return rc;
>  }
>  
> +static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
> +{
> +	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
> +
> +	switch (crq->valid) {
> +	case IBMVFC_CRQ_CMD_RSP:
> +		break;
> +	default:
> +		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);

Is this correct? Can't we get transport events here as well?

> +		return;
> +	}
> +
> +	/* The only kind of payload CRQs we should get are responses to
> +	 * things we send. Make sure this response is to something we
> +	 * actually sent
> +	 */
> +	if (unlikely(!ibmvfc_valid_event(&vhost->pool, evt))) {
> +		dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid!\n",
> +			crq->ioba);
> +		return;
> +	}
> +
> +	if (unlikely(atomic_read(&evt->free))) {
> +		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
> +			crq->ioba);
> +		return;
> +	}
> +
> +	del_timer(&evt->timer);
> +	list_del(&evt->queue);
> +	ibmvfc_trc_end(evt);
> +	evt->done(evt);
> +}
> +



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

