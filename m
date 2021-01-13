Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EE3C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 18:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CAA222248
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 18:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbhAMS6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 13:58:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728108AbhAMS6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 13:58:20 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DIkdlk006663;
        Wed, 13 Jan 2021 13:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rUYBLnhrDhO8qmzc0rQXr3XHHY/hTcUJuuhQoaRnN4w=;
 b=KxOXvIsGNsR6KC3ckwGcTL9RKy8hmqbNhqaNomzVI73TUi8qWlCQRF6AODJaysmaGUVA
 +wUWRKQ+NTeTuDSPuWnQSIzoiGlgXz/QWIVcAcebCO6ciRTssvwqAWZPYlYUewJ3rVcJ
 933Pw0w+zxsz2M3hblWgT4wyoORV1PpRMdXMvA0iKMAVSnJwQaHOK+SKNKiXiN+Q14rt
 AGCtEBVJYaZh9DdSRSYh52LQ/2pxnDM31icFIVY41Te18m3ZiZRz44vq9ocbTlzyfOAU
 1DINo4WWoDQF4lwAWGXLbEfgehfedQ6gUvfjS7QyxXn4oWen99+vrXWkuB6sZseyt44e Hw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3626eh06rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 13:57:30 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DIma36006607;
        Wed, 13 Jan 2021 18:57:29 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 35y4497mq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 18:57:29 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DIvSdm29688166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 18:57:28 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9FAAB205F;
        Wed, 13 Jan 2021 18:57:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09756B2064;
        Wed, 13 Jan 2021 18:57:27 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.128.152])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 18:57:26 +0000 (GMT)
Subject: Re: [PATCH v4 21/21] ibmvfc: provide modules parameters for MQ
 settings
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
 <20210111231225.105347-22-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <4d5afe7a-31ad-8560-9d00-6e91322bf6b5@linux.vnet.ibm.com>
Date:   Wed, 13 Jan 2021 12:57:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111231225.105347-22-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_09:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/21 5:12 PM, Tyrel Datwyler wrote:
> @@ -5880,12 +5936,13 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  
>  	shost->transportt = ibmvfc_transport_template;
>  	shost->can_queue = max_requests;
> +	shost->can_queue = (max_requests / nr_scsi_hw_queues);

This looks to be in conflict with the fact that the first patch requested a shared tag set, right?

>  	shost->max_lun = max_lun;
>  	shost->max_id = max_targets;
>  	shost->max_sectors = IBMVFC_MAX_SECTORS;
>  	shost->max_cmd_len = IBMVFC_MAX_CDB_LEN;
>  	shost->unique_id = shost->host_no;
> -	shost->nr_hw_queues = IBMVFC_MQ ? IBMVFC_SCSI_HW_QUEUES : 1;
> +	shost->nr_hw_queues = mq_enabled ? nr_scsi_hw_queues : 1;

You might want to range check this, to make sure its sane.
>  
>  	vhost = shost_priv(shost);
>  	INIT_LIST_HEAD(&vhost->targets);
> @@ -5897,8 +5954,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	vhost->log_level = log_level;
>  	vhost->task_set = 1;
>  
> -	vhost->mq_enabled = IBMVFC_MQ;
> -	vhost->client_scsi_channels = IBMVFC_SCSI_CHANNELS;
> +	vhost->mq_enabled = mq_enabled;
> +	vhost->client_scsi_channels = min(nr_scsi_hw_queues, nr_scsi_channels);
>  	vhost->using_channels = 0;
>  	vhost->do_enquiry = 1;
>  
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

