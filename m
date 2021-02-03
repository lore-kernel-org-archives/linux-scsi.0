Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A7FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 16:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8C8A64E06
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 16:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhBCQQp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 11:16:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235022AbhBCQQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 11:16:16 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 113G3kjN127279;
        Wed, 3 Feb 2021 11:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=BNM9JvtW+RyxAq84lpcHao/hy2NtoqvRw3xk8Ueu+24=;
 b=eY8Hgb5gl13cofX0y8wcg/e4+t/i2UCsWat1iI2/8/QZGwwHp2XTk/0of5bx+BVgIjyc
 ofnBFhOoSid6f6dxXMAxzRv9cFQxLUVCNTyn8w7noP9vN4etFqPMWqI6RKGO1Yow0oaG
 T8R6lS+rbDVQM7gcPjrjyL7LoN74NhiRcIYNqW8GVl3WTfzVNriPMzR8QykxwFx3jELq
 b0nh62uffOcqVwWVX8uAvLqCVqCXNXk9bGorygkELS//TQDb5u9lvClS8ALJOARhmB+c
 a6hW9d5FiaugC3Ei7zo7p2dsOLnWTDh5eKtyeXUO/gfq4yzTA7a3CRcVpZA6h06KbWnn XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36fxq4s8cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 11:15:28 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 113G5YOh136314;
        Wed, 3 Feb 2021 11:15:27 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36fxq4s8cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 11:15:27 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113FqKxH027428;
        Wed, 3 Feb 2021 16:15:26 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 36eu8qrvyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 16:15:26 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113GFPnJ22282728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 16:15:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BA317805C;
        Wed,  3 Feb 2021 16:15:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E4E278069;
        Wed,  3 Feb 2021 16:15:23 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.153.205])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 16:15:23 +0000 (GMT)
Message-ID: <a6093892d7201fb940e14a571bc853829e704d0f.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: isci: convert sysfs sprintf/snprintf family to
 sysfs_emit
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        intel-linux-scu@intel.com
Cc:     artur.paszkiewicz@intel.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 03 Feb 2021 08:15:22 -0800
In-Reply-To: <1612341806-30230-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1612341806-30230-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_06:2021-02-03,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-02-03 at 16:43 +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
>  ./drivers/scsi/isci/init.c:140:8-16: WARNING: use scnprintf or
> sprintf.
> 
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/scsi/isci/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index c452849..741a98e 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -137,7 +137,7 @@ static ssize_t isci_show_id(struct device *dev,
> struct device_attribute *attr, c
>  	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
>  	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost),
> sas_ha);
>  
> -	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
> +	return sysfs_emit(buf, "%d\n", ihost->id);

What's the point of doing this change?  We'd have to have 13,600 bit
integer types before this could ever possibly overflow and the
difference between snprintf and scnprintf actually matter from a
practical point of view.  Perhaps the coccinelle check should be
updated to account for these common impossible to overflow situations.

James


