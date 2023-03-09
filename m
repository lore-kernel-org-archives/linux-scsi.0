Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C9DC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 18:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjCISxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 13:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCISxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 13:53:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55746284E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 10:53:24 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329HPB2v020082;
        Thu, 9 Mar 2023 18:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zpIh2BnmW2LpReBe8Wa2ABsiF9SQi+S7UmFo9HpAwE0=;
 b=J9d5IgreqMBw3WwkFT/GKOoGiNYSt2keWO+fzFmEfrAJ48SyHoQAC0UXqOk5AzizJI9Q
 xRvhfK05UEAg/S7oZkGKeiYqV5cHjoYsYfda+T1Gq06Fy/VY14pjYvGgWdhn4JhedMEr
 ZiMcGY5mBheJfgMN1Uke1XC02unLqRHFREMqgsTDIdvhRHCaPzme/RZQ2I8DxYNMdyV5
 Whjwcl8CQyeI45KrxQCHc1Cn/+hXJwGwEOgvJmFqtLcR5mpzyHUSzP+r4MmDoibUGqy8
 wVNYk5UcWrKDZRXVrKDCo1Q2g/MLbaRHsNfWd3dmqvY2445OovJtgs+3ch1M0jIP4CGA YQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p7j155qgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 18:53:16 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 329ITS5Y024925;
        Thu, 9 Mar 2023 18:53:15 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3p6g9jaktu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 18:53:15 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 329IrDJv33293018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Mar 2023 18:53:13 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABE7258054;
        Thu,  9 Mar 2023 18:53:13 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2801C58045;
        Thu,  9 Mar 2023 18:53:13 +0000 (GMT)
Received: from [9.163.78.237] (unknown [9.163.78.237])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Mar 2023 18:53:13 +0000 (GMT)
Message-ID: <dbba03ed-90bf-6fe6-357b-c15b8624ba75@linux.vnet.ibm.com>
Date:   Thu, 9 Mar 2023 12:53:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 47/81] scsi: ipr: Declare SCSI host template const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-48-bvanassche@acm.org>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <20230304003103.2572793-48-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2uX4LL_Dqm6cbPwuBdroPZnDfjZ4l6q2
X-Proofpoint-GUID: 2uX4LL_Dqm6cbPwuBdroPZnDfjZ4l6q2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_10,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 6:30 PM, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ipr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index c74053f0b72f..4d3c280a7360 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -6736,7 +6736,7 @@ static const char *ipr_ioa_info(struct Scsi_Host *host)
>  	return buffer;
>  }
> 
> -static struct scsi_host_template driver_template = {
> +static const struct scsi_host_template driver_template = {
>  	.module = THIS_MODULE,
>  	.name = "IPR",
>  	.info = ipr_ioa_info,

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


