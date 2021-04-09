Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA43C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 15:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1602B610FC
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 15:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhDIPrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:47:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229665AbhDIPrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 11:47:11 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 139FYO6X123737;
        Fri, 9 Apr 2021 11:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WzEOdB6LK30+9mQnToo/4s8yrhr6BPLAUVhvMJLpM/w=;
 b=MCwCzCVY4dRusUYIckrRR7NYPkqWXFhrXsteuhzlmBxQPw3yzSIe7yKeuIxD50S4nTSa
 D7mahGT+lpMoP8ssZs9c1F2OwZLSEAHy0abKoPRFVwT7obnwwbQKt3jN2cbo1wCvzm8p
 W29avHG5vVmSrCOzfZVfH/LQMw9JjRUXMyu3xVHEflrpXa8OoiZIVhdxVNyfz+vRboHb
 v/ox/z6AuZHWjxDdyPHDhadptw0vg6rNBvUL3sFtg5tzdSwK4gFprf+WvkADbJTkkTrq
 SbY9LEm0UEYEKdGfgEfuR6jedz9pkaYcPkaj+g2Z3osFghXDaLdIvJq6EF0fvPiI7lDQ 4g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37t4dywayy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Apr 2021 11:46:15 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 139FXgg8018937;
        Fri, 9 Apr 2021 15:46:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37rvbwaju7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Apr 2021 15:46:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 139FkACu10158364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Apr 2021 15:46:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD41A405C;
        Fri,  9 Apr 2021 15:46:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 128C6A4054;
        Fri,  9 Apr 2021 15:46:10 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.171.81.182])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Apr 2021 15:46:09 +0000 (GMT)
Subject: Re: [PATCH 5/8] scsi: remove the unchecked_isa_dma flag
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210331073001.46776-1-hch@lst.de>
 <20210331073001.46776-6-hch@lst.de>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <2fa7fad0-2689-24c9-d356-50f98ca3535d@linux.ibm.com>
Date:   Fri, 9 Apr 2021 17:46:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210331073001.46776-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k2FTgDviRgsp5uWqV7yH6vzIgwqPR7Hj
X-Proofpoint-ORIG-GUID: k2FTgDviRgsp5uWqV7yH6vzIgwqPR7Hj
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-09_06:2021-04-09,2021-04-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 clxscore=1011 impostorscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/21 9:29 AM, Christoph Hellwig wrote:
> Remove the unchecked_isa_dma now that all users are gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   Documentation/scsi/scsi_mid_low_api.rst |  4 --
>   drivers/scsi/esas2r/esas2r_main.c       |  1 -
>   drivers/scsi/hosts.c                    |  7 +---
>   drivers/scsi/scsi_debugfs.c             |  1 -
>   drivers/scsi/scsi_lib.c                 | 52 +++----------------------
>   drivers/scsi/scsi_scan.c                |  6 +--
>   drivers/scsi/scsi_sysfs.c               |  2 -
>   drivers/scsi/sg.c                       | 10 +----
>   drivers/scsi/sr_ioctl.c                 | 12 ++----
>   drivers/scsi/st.c                       | 20 ++++------
>   drivers/scsi/st.h                       |  2 -
>   include/scsi/scsi_cmnd.h                |  7 ++--
>   include/scsi/scsi_host.h                |  6 ---
>   13 files changed, 25 insertions(+), 105 deletions(-)


> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b6378c8ca783ea..b71ea1a69c8b60 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -373,7 +373,6 @@ shost_rd_attr(cmd_per_lun, "%hd\n");
>   shost_rd_attr(can_queue, "%d\n");
>   shost_rd_attr(sg_tablesize, "%hu\n");
>   shost_rd_attr(sg_prot_tablesize, "%hu\n");
> -shost_rd_attr(unchecked_isa_dma, "%d\n");
>   shost_rd_attr(prot_capabilities, "%u\n");
>   shost_rd_attr(prot_guard_type, "%hd\n");
>   shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
> @@ -411,7 +410,6 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
>   	&dev_attr_can_queue.attr,
>   	&dev_attr_sg_tablesize.attr,
>   	&dev_attr_sg_prot_tablesize.attr,
> -	&dev_attr_unchecked_isa_dma.attr,
>   	&dev_attr_proc_name.attr,
>   	&dev_attr_scan.attr,
>   	&dev_attr_hstate.attr,

Is it OK to remove a long standing sysfs attribute?
Was there any deprecation phase?

I just noticed it in our CI reporting fails due to this change since at least 
linux-next 20210409. Suppose it came via 
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.13/block&id=aaff5ebaa2694f283b7d07fdd55fb287ffc4f1e9

Wanted to ask before I adapt the test cases.

Cf. 
https://lore.kernel.org/linux-scsi/20080224233529.456981B4183@basil.firstfloor.org/T/#u
"An alternative would be to always make it report 0 now."

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
