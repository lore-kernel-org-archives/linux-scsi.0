Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F951CA9EB9
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 12:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503F8218AE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 12:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388277AbfJVMfc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 08:35:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388095AbfJVMfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 08:35:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9MCX8Oa107789
        for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2019 08:35:30 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vt1f2156q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2019 08:35:30 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 22 Oct 2019 13:35:27 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 22 Oct 2019 13:35:25 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9MCYqks40763716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 12:34:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CEE94C050;
        Tue, 22 Oct 2019 12:35:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA8E14C052;
        Tue, 22 Oct 2019 12:35:24 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.97.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Oct 2019 12:35:24 +0000 (GMT)
Subject: Re: [PATCH 06/24] scsi: change status_byte() to return the standard
 SCSI status
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-7-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 22 Oct 2019 14:35:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-7-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102212-0020-0000-0000-0000037C8120
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102212-0021-0000-0000-000021D2BD84
Message-Id: <f550062f-45e1-66f9-4452-f1d3c6473092@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910220115
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/19 11:53 AM, Hannes Reinecke wrote:
> Instead of returning the linux-special status (which is shifted
> by 1 to the right) change the status_byte() macro to return the
> correct SCSI standard status.
> And audit all callers to handle this change.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/53c700.c        |  6 +++---
>   drivers/scsi/NCR5380.c       |  2 +-
>   drivers/scsi/arm/acornscsi.c | 10 ++++-----
>   drivers/scsi/arm/fas216.c    | 10 ++++-----
>   drivers/scsi/dc395x.c        |  8 +++-----
>   drivers/scsi/scsi.c          |  2 +-
>   drivers/scsi/scsi_error.c    | 48 ++++++++++++++++++++++----------------------
>   drivers/scsi/scsi_lib.c      |  2 +-
>   drivers/scsi/sg.c            |  4 ++--
>   include/scsi/scsi.h          |  2 +-
>   10 files changed, 46 insertions(+), 48 deletions(-)
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5339baadc082..de52632c6022 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -207,7 +207,7 @@ static inline int scsi_is_wlun(u64 lun)
>    *      host_byte   = set by low-level driver to indicate status.
>    *      driver_byte = set by mid-level.
>    */
> -#define status_byte(result) (((result) >> 1) & 0x7f)
> +#define status_byte(result) (((result)) & 0xff)

drop the now unnecessary additional parentheses pair around (result)?:

+#define status_byte(result) ((result) & 0xff)

>   #define msg_byte(result)    (((result) >> 8) & 0xff)
>   #define host_byte(result)   (((result) >> 16) & 0xff)
>   #define driver_byte(result) (((result) >> 24) & 0xff)
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

