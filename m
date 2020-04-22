Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EE7C5518B
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 16:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F98E20776
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 16:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDVQT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 12:19:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbgDVQT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 12:19:56 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MG4sHi114180
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 12:19:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrxkrtv7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 12:19:55 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Wed, 22 Apr 2020 17:19:17 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 17:19:14 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03MGJn2O17236050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 16:19:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43E12A4055;
        Wed, 22 Apr 2020 16:19:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD646A4051;
        Wed, 22 Apr 2020 16:19:48 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.145.176.13])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 16:19:48 +0000 (GMT)
Subject: Re: [PATCH] scsi: avoid to run synchronize_rcu for each device in
 scsi_host_block
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Dexuan Cui <decui@microsoft.com>,
        Hannes Reinecke <hare@suse.de>
References: <20200422101433.321581-1-ming.lei@redhat.com>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Wed, 22 Apr 2020 18:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422101433.321581-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042216-0008-0000-0000-000003757B6C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042216-0009-0000-0000-00004A97456D
Message-Id: <540025fc-366b-e895-f4cd-b7ac3fdffbe0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/20 12:14 PM, Ming Lei wrote:
> scsi_host_block() calls scsi_internal_device_block() for each
> scsi_device, and scsi_internal_device_block() calls
> blk_mq_quiesce_queue() for each LUN. However synchronize_rcu is
> run from blk_mq_quiesce_queue().
> 
> This way may become unnecessary slow in case of lots of LUNs.
> 
> So use scsi_internal_device_block() to implement scsi_host_block(),

scsi_internal_device_block()
=?=>
scsi_internal_device_block_nowait()

> and just run once synchronize_rcu() because scsi never supports
> tagset of BLK_MQ_F_BLOCKING.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/scsi_lib.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..089ac92ac6c3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2841,11 +2841,22 @@ scsi_host_block(struct Scsi_Host *shost)
>   	struct scsi_device *sdev;
>   	int ret = 0;
>   
> +	/*
> +	 * Call scsi_internal_device_block_nowait then we can avoid to
> +	 * run synchronize_rcu() one time for every LUN.
> +	 */
>   	shost_for_each_device(sdev, shost) {
> -		ret = scsi_internal_device_block(sdev);
> +		mutex_lock(&sdev->state_mutex);
> +		ret = scsi_internal_device_block_nowait(sdev);
> +		mutex_unlock(&sdev->state_mutex);
>   		if (ret)
>   			break;
>   	}
> +
> +	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
> +
> +	if (!ret)
> +		synchronize_rcu();
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(scsi_host_block);
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

