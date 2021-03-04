Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A04FC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 18:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524E864F62
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 18:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCDSu1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 13:50:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235111AbhCDSuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 13:50:08 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124IYT4b165664;
        Thu, 4 Mar 2021 13:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NQ12GuvXHspGybmK53e54xawvK/ZlV9uYf88vxw3ECM=;
 b=odAqV6or4D/XdgCrvQUjHalBUcDTF5nSWvzxVozT8X1MDwUzCBKCO6ViQQ93a0nMT1m8
 XV3m8abckFQpvCYUqf3o3GtNjz4ZQ0P61pIyIabuQgjkzF1rAZgoS4A95u/a75taixHu
 T7ZcMZpWel17o55s5b3HAyr+5/QXkR2dXeXX34yC/rw8pIpPzXARd+OrSqd0A+7xT062
 Q+iKc862/loSOLXam4gLacTsJf5+2Ia5J7WSg6Iy6tGslMqUCMpndt0MO43QePinmGZ2
 ys7gcoYTF3p08ZObYs9JuJLNjQJOVno4x6Uv/05Xk9i9duGSeGoVMr7L6bhsrHiuUh8Z cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3734nss34u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 13:49:02 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 124IYdmT166313;
        Thu, 4 Mar 2021 13:49:02 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3734nss33v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 13:49:02 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124IWGrU005854;
        Thu, 4 Mar 2021 18:49:01 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3720r0s3ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 18:49:01 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124Imxle30277932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 18:49:00 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2BC0BE051;
        Thu,  4 Mar 2021 18:48:59 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D03CBE054;
        Thu,  4 Mar 2021 18:48:58 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.44.137])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 18:48:57 +0000 (GMT)
Subject: Re: [PATCH] scsi: ibmvfc: Switch to using the new API kobj_to_dev()
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <1614850124-54111-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <87514c42-eb5a-ee68-ff21-49d08bd42a4e@linux.ibm.com>
Date:   Thu, 4 Mar 2021 10:48:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1614850124-54111-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_05:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 1:28 AM, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3483:60-61: WARNING opportunity for
> kobj_to_dev().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 755313b..e5f1ca7 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -3480,7 +3480,7 @@ static ssize_t ibmvfc_read_trace(struct file *filp, struct kobject *kobj,
>  				 struct bin_attribute *bin_attr,
>  				 char *buf, loff_t off, size_t count)
>  {
> -	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
>  	unsigned long flags = 0;
> 

