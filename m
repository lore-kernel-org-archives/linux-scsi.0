Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EA7C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 14:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A36964E07
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 14:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhBPO7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 09:59:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229864AbhBPO7V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Feb 2021 09:59:21 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11GEnctk014819;
        Tue, 16 Feb 2021 09:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vCXzb5OpCKLaHDVmWut1qFi4BxjtzdfHygiEhaPanUU=;
 b=goCISUI7PndlL4FJ7okkCp5O1fn6oUQQueIOCD4PoY0mHq+yJ+QKn1X5J2Ge4r64/YIf
 f5X/vdbFZtgiam/MS6xq1CKdQZSyRsk6F7X+0CNXuyECD7yXHAUFEPymkkC1yYfm1wgF
 q519qcqEqjtuujHWBMQciVDKOiU52IxwtvIlAohS2Dp21XYN7rvyPbF7hsl1BBVmxo/D
 Hek1R2JNM8fQ46GlAnekwLLEa2OhQDO9x0mvO4YL4ieZ/0t8bh1DQz1YZ9apSSm92Wg0
 N58K30S+hgp4q4odfn4yAO43Pt3bDSNT5Vu0gJcbvHwGKHXqa4qgLq4y5ImP5kla/LLS rA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36rg570716-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 09:58:34 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11GEqYTh018382;
        Tue, 16 Feb 2021 14:58:33 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 36p6d9mr0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 14:58:33 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11GEwWxr33489364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 14:58:32 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A70A6112065;
        Tue, 16 Feb 2021 14:58:32 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C46AA112062;
        Tue, 16 Feb 2021 14:58:31 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.23.155])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Feb 2021 14:58:31 +0000 (GMT)
Subject: Re: [PATCH 4/4] ibmvfc: store return code of H_FREE_SUB_CRQ during
 cleanup
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210211185742.50143-1-tyreld@linux.ibm.com>
 <20210211185742.50143-5-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <94321ded-7970-258c-cee9-222f7b2b511f@linux.vnet.ibm.com>
Date:   Tue, 16 Feb 2021 08:58:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211185742.50143-5-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_04:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/21 12:57 PM, Tyrel Datwyler wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index ba6fcf9cbc57..23b803ac4a13 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -5670,7 +5670,7 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
>  
>  irq_failed:
>  	do {
> -		plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
> +		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
>  	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));

Other places in the driver where we get a busy return code back we have an msleep(100).
Should we be doing that here as well?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

