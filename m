Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA202C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 09:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CED561354
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 09:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhDTJYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 05:24:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230168AbhDTJYj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 05:24:39 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13K9542D052303;
        Tue, 20 Apr 2021 05:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=edfggjBTOd+ZxgqXsTN5TyOAX0dfhbz/zfwEUVHBkbs=;
 b=kHv+2XWw+hxpr6qhd86x6viAidI6Q0g9kANL4hkc6ZjMwoLb1Ok//B9V7aljxmmzg2rf
 EoS6ZUJWbw27X9TjmjBwQkcbfOnLXqeRvLEXnC2/ueO1oyQiKB6QrhvPp6DYVOwJW1Le
 3ArrCtHgYDHBvNt6ZbqXrtM1n828rbDk1UNs7ZRT0jvto7qKIKEldm7+OK5A2qTDisK5
 udzjUHi8wjkYtlXxfJVN1/mOefMVOa71xZnOruvVEyG8uim141QSA8KlDw2egdy3Z0Xq
 +q3M04nTL8SPTEKz97uAixydnEfHJjZBJ5B/qUJ5GljpHzCfDoEkbKUg95Jar8Wo1DN6 NA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381kspbev7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 05:23:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13K9LbZQ004742;
        Tue, 20 Apr 2021 09:23:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 37yqa88vbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 09:23:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13K9NpWH44040606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 09:23:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFBB5A405C;
        Tue, 20 Apr 2021 09:23:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BBF9A405B;
        Tue, 20 Apr 2021 09:23:51 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.171.30.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 09:23:51 +0000 (GMT)
Subject: Re: [PATCH 002/117] Introduce enums for the SAM, message, host and
 driver status codes
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-3-bvanassche@acm.org>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <e2d93fe3-13ad-a1cd-2066-936562d097d5@linux.ibm.com>
Date:   Tue, 20 Apr 2021 11:23:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210420000845.25873-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hrATPOYnRR-JLAIIDmptqO9rvHYVOGET
X-Proofpoint-ORIG-GUID: hrATPOYnRR-JLAIIDmptqO9rvHYVOGET
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_02:2021-04-19,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 clxscore=1011 mlxscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200067
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 2:06 AM, Bart Van Assche wrote:
> Allow the compiler to verify whether SAM, message, host and driver status
> codes are used correctly. Add the attribute "__packed" to these enum
> definitions such that instances of the new enum types only occupy a single
> byte.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_error.c  |  2 +
>   include/scsi/scsi.h        | 84 ++---------------------------------
>   include/scsi/scsi_cmnd.h   | 11 +++--
>   include/scsi/scsi_proto.h  | 53 ++++++++++++----------
>   include/scsi/scsi_status.h | 91 ++++++++++++++++++++++++++++++++++++++
>   5 files changed, 133 insertions(+), 108 deletions(-)
>   create mode 100644 include/scsi/scsi_status.h
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 9afd65eb2c8b..54213c37806b 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1775,6 +1775,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   		fallthrough;
>   	case DID_SOFT_ERROR:
>   		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
> +	default:
> +		break;

Remind me, what are the compiler warnings we use during build?
Adding a default case seems OK for me if we use -Wswitch-enum, but I'm not sure 
if we only have -Wswitch because then we would not get static build warnings if 
we ever were to add new enum values but forgot to address them here?

>   	}
> 
>   	if (status_byte(scmd->result) != CHECK_CONDITION)



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
