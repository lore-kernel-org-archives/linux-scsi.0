Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C95C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BAE422D75
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbhAGQuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:50:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbhAGQuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 11:50:05 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107GQNQ3188422;
        Thu, 7 Jan 2021 11:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=1gtN3u26Bsq09BfBJpwRqxGvE3ooyFd7ceUSH5JwSgA=;
 b=DqCzI7qrmTmHf+kEuHdWy8jm9tydq3oL/mnyM+e/2XnJer685zMJZ41VM+LE18sCxWKs
 J60W/+BdGCc7GSF6+gJZfWNIn0XzXnKPQBb8q+V6yl+4+BtpukqGVk5uLzsKqHhZbKr4
 n9xK15+JexhcjbusbQJtELJfr0aRc0NGMLwnemN09Ysl4MxHCgMpW0x5aHfa16ipxElg
 A7A6lY6ygnx6f6MWNS8vZ8JY61HpwwV47K/5lTf6/u/oupg3LhMRZNmmuG2GyWfVtccC
 5KEXUAjrpzaMdvgLs1WMToGxPNfIJK0H2MQF9J0UBv41QBm7461igpVldlw5Uv3AEfVV qA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x59tspd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 11:49:13 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107Gavfr006476;
        Thu, 7 Jan 2021 16:49:11 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 35tgf9duev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 16:49:11 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107GnAZS12386610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 16:49:10 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C40767805E;
        Thu,  7 Jan 2021 16:49:10 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20B0A7805C;
        Thu,  7 Jan 2021 16:49:09 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.172.80])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 16:49:08 +0000 (GMT)
Message-ID: <3770e4f3025e48759ad64513a457f1276031d900.camel@linux.ibm.com>
Subject: Re: scsi: Add diagnostic log for scsi device reset
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     lijinlin <lijinlin3@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Cc:     linfeilong@huawei.com, liuzhiqiang26@huawei.com
Date:   Thu, 07 Jan 2021 08:49:07 -0800
In-Reply-To: <c391120e-897a-0ee1-d01a-0defe504d6df@huawei.com>
References: <c391120e-897a-0ee1-d01a-0defe504d6df@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=684 impostorscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101070097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-01-07 at 19:43 +0800, lijinlin wrote:
[...]
> -		SCSI_LOG_ERROR_RECOVERY(3,
> +		if (bdr_scmd->request && bdr_scmd->request->rq_disk)
>  			sdev_printk(KERN_INFO, sdev,
> -				     "%s: Sending BDR\n", current-
> >comm));
> +				     "[%s] Sending device reset\n",
> +				     bdr_scmd->request->rq_disk-
> >disk_name);

Not everything is a SCSI disk.  If we apply this patch, we lose traces
for any non-disk device that get reset ... for tapes this can be really
important to know.

James


