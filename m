Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C50C64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 15:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CACE21D7A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 15:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgLBP5Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 10:57:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726178AbgLBP5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 10:57:16 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2Fl0ml193613;
        Wed, 2 Dec 2020 10:56:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fIq6N6+4QBCiz2UKO/SQtbQHbwq6LD6ldQZR4ZK3QTI=;
 b=aavXsClQxhArBCvfFzXz/xw+WEd9m8mXLqqc5igYp3SCP77oM6HRvU6rT7Mk6a1pEelT
 XSwzynBIzD5d2EaO/8NVg+4jFYgtzeAqDYm4dKs0S503ZIbQP3aaUV8FfN5nm8Iyhqdk
 AKQ1ChHbpU1BNvzYMn2WdQiTujhl1Z3Ku1zrbihlK4HBt0+s4F6nOy3ID2PhNsV6J44L
 8/WTg91GOO6mtvGmivpcEbOaPPuIxlQOuZh/6q0BOIOc/MG7lyawNDiZEh9FX1Qr24nE
 1S97NugYN830a46+659tbatNg7SgeKmgFwXgHwL3LDESRESy+Tfoyz6gOyzoUgDJJl+v vw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3568cwceuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 10:56:29 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2FXScf011719;
        Wed, 2 Dec 2020 15:56:28 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 354ysujjwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 15:56:28 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2FuSNI7340768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 15:56:28 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0973BAE05C;
        Wed,  2 Dec 2020 15:56:28 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35E8AAE05F;
        Wed,  2 Dec 2020 15:56:27 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.78.151])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 15:56:27 +0000 (GMT)
Subject: Re: [PATCH v2 06/17] ibmvfc: add handlers to drain and complete
 Sub-CRQ responses
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201202005329.4538-1-tyreld@linux.ibm.com>
 <20201202005329.4538-7-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <8a3c6a0b-ebf5-581a-e3e9-748c09373d92@linux.vnet.ibm.com>
Date:   Wed, 2 Dec 2020 09:56:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201202005329.4538-7-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 suspectscore=2 mlxlogscore=999 impostorscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 6:53 PM, Tyrel Datwyler wrote:
> +static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
> +{
> +	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
> +	unsigned long flags;
> +
> +	switch (crq->valid) {
> +	case IBMVFC_CRQ_CMD_RSP:
> +		break;
> +	case IBMVFC_CRQ_XPORT_EVENT:
> +		return;
> +	default:
> +		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
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
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	del_timer(&evt->timer);
> +	list_del(&evt->queue);
> +	ibmvfc_trc_end(evt);

Another thought here... If you are going through ibmvfc_purge_requests at the same time
as this code, you could check the free bit above, then have ibmvfc_purge_requests
put the event on the free queue and call scsi_done, then you come down and get the host
lock here, remove the command from the free list, and call the done function again,
which could result in a double completion to the scsi layer.

I think you need to grab the host lock before you check the free bit to avoid this race.

> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +	evt->done(evt);
> +}
> +


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

