Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4853C64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 17:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26DA207F7
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 17:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JxsVuMeN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgK3R06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 12:26:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64518 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726897AbgK3R05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 12:26:57 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUHDWxM091139;
        Mon, 30 Nov 2020 12:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g6iMkPFw8NFXQFPi6jTuMBsBCW+yakWb4p7XimClNwc=;
 b=JxsVuMeN6lfQOk2wcnW/ZaDk9fPYuViNRQHoTCrSfZUNUlw4Y0VaLzxNZE6eH8yvCc8V
 clqPivzaIA2AUErUlEYysw5+ZVDae1jACKJaO5HxsEf+N6a/QzsFwt9muUt8+HKrDgRe
 ZERDrVjJfNb6oPvdAnXIAzqVLF6/X9p81z/ZC/GzkvzuiBQIPo4HwUwvFESHcctlUTmx
 Em/s1p41yrHiFLO/1b9thP3RfYQHOKD0pnTCJGyFAFjm+FNu6RKYSBbS9YCtmyUnLZlM
 zzUcxRQV0LDCIaFXKgbKHAHSRxgj/6UV1DqhmgWAJ49kbKec9P/s0LKWxODQUqc7maeY Ow== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3554xq0e0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 12:26:10 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUHNLat005907;
        Mon, 30 Nov 2020 17:26:09 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 353e69dmgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 17:26:09 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUHQ9P05964452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 17:26:09 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE89112066;
        Mon, 30 Nov 2020 17:26:08 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7700111207C;
        Mon, 30 Nov 2020 17:26:06 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.215.138])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 17:26:06 +0000 (GMT)
Subject: Re: [PATCH 04/13] ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ
 Channels
To:     Brian King <brking@linux.vnet.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
 <20201126014824.123831-5-tyreld@linux.ibm.com>
 <0c308b76-c744-0257-d5ba-3ffd0e6073a3@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <0eeac30f-07bd-d4c5-fe21-d5092ca3fd62@linux.ibm.com>
Date:   Mon, 30 Nov 2020 09:26:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0c308b76-c744-0257-d5ba-3ffd0e6073a3@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_06:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 suspectscore=2 priorityscore=1501 clxscore=1015 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/20 9:46 AM, Brian King wrote:
> On 11/25/20 7:48 PM, Tyrel Datwyler wrote:
>> Allocate a set of Sub-CRQs in advance. During channel setup the client
>> and VIOS negotiate the number of queues the VIOS supports and the number
>> that the client desires to request. Its possible that the final channel
>> resources allocated is less than requested, but the client is still
>> responsible for sending handles for every queue it is hoping for.
>>
>> Also, provide deallocation cleanup routines.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 115 +++++++++++++++++++++++++++++++++
>>  drivers/scsi/ibmvscsi/ibmvfc.h |   1 +
>>  2 files changed, 116 insertions(+)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index 260b82e3cc01..571abdb48384 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -4983,6 +4983,114 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
>>  	return retrc;
>>  }
>>  
>> +static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
>> +				  int index)
>> +{
>> +	struct device *dev = vhost->dev;
>> +	struct vio_dev *vdev = to_vio_dev(dev);
>> +	struct ibmvfc_sub_queue *scrq = &vhost->scsi_scrqs.scrqs[index];
>> +	int rc = -ENOMEM;
>> +
>> +	ENTER;
>> +
>> +	scrq->msgs = (struct ibmvfc_sub_crq *)get_zeroed_page(GFP_KERNEL);
>> +	if (!scrq->msgs)
>> +		return rc;
>> +
>> +	scrq->size = PAGE_SIZE / sizeof(*scrq->msgs);
>> +	scrq->msg_token = dma_map_single(dev, scrq->msgs, PAGE_SIZE,
>> +					 DMA_BIDIRECTIONAL);
>> +
>> +	if (dma_mapping_error(dev, scrq->msg_token))
>> +		goto dma_map_failed;
>> +
>> +	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
>> +			   &scrq->cookie, &scrq->hw_irq);
>> +
>> +	if (rc) {
>> +		dev_warn(dev, "Error registering sub-crq: %d\n", rc);
>> +		dev_warn(dev, "Firmware may not support MQ\n");
>> +		goto reg_failed;
>> +	}
>> +
>> +	scrq->hwq_id = index;
>> +	scrq->vhost = vhost;
>> +
>> +	LEAVE;
>> +	return 0;
>> +
>> +reg_failed:
>> +	dma_unmap_single(dev, scrq->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
>> +dma_map_failed:
>> +	free_page((unsigned long)scrq->msgs);
>> +	LEAVE;
>> +	return rc;
>> +}
>> +
>> +static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
>> +{
>> +	struct device *dev = vhost->dev;
>> +	struct vio_dev *vdev = to_vio_dev(dev);
>> +	struct ibmvfc_sub_queue *scrq = &vhost->scsi_scrqs.scrqs[index];
>> +	long rc;
>> +
>> +	ENTER;
>> +
>> +	do {
>> +		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
>> +					scrq->cookie);
>> +	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>> +
>> +	if (rc)
>> +		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
>> +
>> +	dma_unmap_single(dev, scrq->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
>> +	free_page((unsigned long)scrq->msgs);
>> +	LEAVE;
>> +}
>> +
>> +static int ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>> +{
>> +	int i, j;
>> +
>> +	ENTER;
>> +
>> +	vhost->scsi_scrqs.scrqs = kcalloc(vhost->client_scsi_channels,
>> +					  sizeof(*vhost->scsi_scrqs.scrqs),
>> +					  GFP_KERNEL);
>> +	if (!vhost->scsi_scrqs.scrqs)
>> +		return -1;
>> +
>> +	for (i = 0; i < vhost->client_scsi_channels; i++) {
>> +		if (ibmvfc_register_scsi_channel(vhost, i)) {
>> +			for (j = i; j > 0; j--)
>> +				ibmvfc_deregister_scsi_channel(vhost, j - 1);
>> +			kfree(vhost->scsi_scrqs.scrqs);
>> +			LEAVE;
>> +			return -1;
>> +		}
>> +	}
>> +
>> +	LEAVE;
>> +	return 0;
>> +}
>> +
>> +static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>> +{
>> +	int i;
>> +
>> +	ENTER;
>> +	if (!vhost->scsi_scrqs.scrqs)
>> +		return;
>> +
>> +	for (i = 0; i < vhost->client_scsi_channels; i++)
>> +		ibmvfc_deregister_scsi_channel(vhost, i);
>> +
>> +	vhost->scsi_scrqs.active_queues = 0;
>> +	kfree(vhost->scsi_scrqs.scrqs);
> 
> Do you want to NULL this out after you free it do you don't keep
> a reference to a freed page around?

This isn't actually a page, but a dynamically allocated array of
ibmvfc_sub_queues, but it should be NULL'ed regardless.

-Tyrel

> 
>> +	LEAVE;
>> +}
>> +
>>  /**
>>   * ibmvfc_free_mem - Free memory for vhost
>>   * @vhost:	ibmvfc host struct
> 
> 
> 

