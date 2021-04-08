Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E96C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 14:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C54F461104
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 14:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhDHOaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:30:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31376 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231370AbhDHOaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 10:30:16 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 138E3wPp063832;
        Thu, 8 Apr 2021 10:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MHvXxsqhv6eOfUAfIKzir7ZQLlHDE/uJaelSC5bSowM=;
 b=abtS/zfB0HHiS2OuWFqWrUiC9I4173edKnYBtFfiVgjPOMEWSRZaGxgx6jzPWyWqu0le
 FDGODeAnZpqMEH0t3o/yV2N9LDIqKOmhewFoYu7v9OOAe9RxXsoRoBYUjfa6DNDCvSew
 pzc73Z8GNz5q2fbNZBf0YZuT2BJ2sZFFGh4igTVKXRQ096GwWcqJ5MGpW66IE2173Dan
 Jg6lLfW4UUTDD2/TF56PFLQM/y9JnIprS4eZ1aQBIfHkA9eIT1MMTmNOVCvLT0T9V5L1
 jzP9RcJ0qN/pJfDEr0dcOisoq/3C7DXcF6Kt/l6eWEdCTQyaMZesb5FjfwJWtMrNiYlz UA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvmgkwjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 10:29:56 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 138EPWiE007173;
        Thu, 8 Apr 2021 14:29:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 37rvbw0w02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 14:29:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 138ETqGW31850868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Apr 2021 14:29:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6B54AE04D;
        Thu,  8 Apr 2021 14:29:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13475AE045;
        Thu,  8 Apr 2021 14:29:52 +0000 (GMT)
Received: from linux-2.fritz.box (unknown [9.145.26.3])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  8 Apr 2021 14:29:52 +0000 (GMT)
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210330161727.2297292-1-hch@lst.de>
 <20210330161727.2297292-11-hch@lst.de>
From:   Stefan Haberland <sth@linux.ibm.com>
Subject: Re: [PATCH 10/15] block: move bd_mutex to struct gendisk
Message-ID: <46eb6a23-e2dc-952a-09be-78c017ef1f7f@linux.ibm.com>
Date:   Thu, 8 Apr 2021 16:29:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330161727.2297292-11-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gsq-zXggMDMXGo00yhTtmqJQilb-2hOo
X-Proofpoint-ORIG-GUID: gsq-zXggMDMXGo00yhTtmqJQilb-2hOo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_03:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104080099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 30.03.21 um 18:17 schrieb Christoph Hellwig:
> Replace the per-block device bd_mutex with a per-gendisk open_mutex,
> thus simplifying locking wherever we deal with partitions.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/locking.rst |  2 +-
>  block/genhd.c                         |  3 ++-
>  block/partitions/core.c               | 22 +++++++---------
>  drivers/block/loop.c                  | 14 +++++-----
>  drivers/block/xen-blkfront.c          |  8 +++---
>  drivers/block/zram/zram_drv.c         | 18 ++++++-------
>  drivers/block/zram/zram_drv.h         |  2 +-
>  drivers/md/md.h                       |  6 ++---
>  drivers/s390/block/dasd_genhd.c       |  8 +++---

For dasd:

Acked-by: Stefan Haberland <sth@linux.ibm.com>

Thanks,
Stefan



