Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10F0CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 14:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D068E222C6
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 14:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634011AbfJROYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:24:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35420 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731923AbfJROYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 10:24:42 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9IEJ9Ko006828
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 10:24:41 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vq0hab37c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 10:24:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Fri, 18 Oct 2019 15:24:33 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 18 Oct 2019 15:24:29 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9IEOSTX43188264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 14:24:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52B88A4055;
        Fri, 18 Oct 2019 14:24:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14C06A404D;
        Fri, 18 Oct 2019 14:24:28 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.98.163])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Oct 2019 14:24:28 +0000 (GMT)
Subject: Re: [PATCH] scsi: fixup scsi_device_from_queue()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191018140355.108106-1-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Fri, 18 Oct 2019 16:24:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018140355.108106-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19101814-0008-0000-0000-000003234E35
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101814-0009-0000-0000-00004A427052
Message-Id: <a77b6501-3ce8-69f7-9f30-2c4d9de3175e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-18_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910180134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hannes, this is already in 
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=5.4/scsi-postmerge 
from 
https://lore.kernel.org/linux-block/20190807144948.28265-1-maier@linux.ibm.com/T/ 
and Martin just sent a pull request to Linus 
https://lore.kernel.org/linux-scsi/yq1pniui429.fsf@oracle.com/T/#m91f5b9098c369dc0d9bfef84aa53ee35533a31be

On 10/18/19 4:03 PM, Hannes Reinecke wrote:
> After commit 8930a6c20791 ("scsi: core: add support for request batching")
> scsi_device_from_queue() will not work for devices implementing the
> new scsi_mq_ops_no_commit template.
> Hence multipath is not able to detect the underlying scsi devices
> and multipath startup will fail.
> 
> Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_lib.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c1c2998297b2..cd3e21a0098c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1924,7 +1924,8 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
>   {
>   	struct scsi_device *sdev = NULL;
> 
> -	if (q->mq_ops == &scsi_mq_ops)
> +	if (q->mq_ops == &scsi_mq_ops ||
> +	    q->mq_ops == &scsi_mq_ops_no_commit)
>   		sdev = q->queuedata;
>   	if (!sdev || !get_device(&sdev->sdev_gendev))
>   		sdev = NULL;
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

