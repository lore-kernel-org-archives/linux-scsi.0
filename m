Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDC2C38142
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 13:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjAXNGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 08:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbjAXNGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 08:06:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F050A10ED
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 05:06:21 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OCvMhL024005;
        Tue, 24 Jan 2023 13:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HG5et/GuVIrnqa5s8+tFONCLjp1VVb0JfY8UMktdq/Q=;
 b=gb7vMWRsVj91VHLSUTLLjxHLz2yw3Yi5BB8EVGRkJ35nadwnbdoGW6nYvSs4bqfdlcsi
 WMwhUJ+k0l7oHQprj7MbIFh4pH2+fnZ9gaUpDpTjG2ujVSQY0hCZXvMs3yzCcbdqZIZw
 BFdsZU+KjA9ooxKv/T7tB5apM0Z2cMqrutNgpyT6rlviqwk4G62AGCOAQLITupHZGxd3
 GXghpkKNh12sK9nfFeCpC6trt5hHRWiDVcvMRf0jmNedaTzLcG5QdNAuGWrvD0PPzzo3
 1Kx3BPRBMHL6LP/16xhVwTXAIKqEgtnyNXxWGmrU902Ztk+w88bP8huPCVgeu4sHtKnQ Lg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3na838b0bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 13:06:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30O6b4ap002140;
        Tue, 24 Jan 2023 13:06:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n87p62rbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 13:06:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30OD61DO24576450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 13:06:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54C0C2004B;
        Tue, 24 Jan 2023 13:06:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08E7F20040;
        Tue, 24 Jan 2023 13:06:01 +0000 (GMT)
Received: from [9.152.212.243] (unknown [9.152.212.243])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 24 Jan 2023 13:06:00 +0000 (GMT)
Message-ID: <e801e08b-e824-af67-65e2-9feffa23d3ec@linux.ibm.com>
Date:   Tue, 24 Jan 2023 14:06:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: add non-sleeping variant of scsi_device_put() and
 use it in alua
Content-Language: en-US
To:     mwilck@suse.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20230124120734.15806-1-mwilck@suse.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20230124120734.15806-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vyV6D_wx1_kErzInn1yEcWpu4xXXiA9h
X-Proofpoint-ORIG-GUID: vyV6D_wx1_kErzInn1yEcWpu4xXXiA9h
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 13:07, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since the might_sleep() annotation was added in scsi_device_put() and
> alua_rtpg_queue(), we have seen repeated reports of "BUG: sleeping function
> called from invalid context" [1], [2]. alua_rtpg_queue() is always called
> from contexts where the caller must hold at least one reference to the
> scsi device in question. This means that the reference taken by
> alua_rtpg_queue() itself can't be the last one, and thus can be dropped
> without entering the code path in which scsi_device_put() might actually
> sleep.
> 
> Add a new helper function, scsi_device_put_nosleep() for cases like this,
> where a device reference is put from atomic context, and at the same time
> it is certain that this reference is not the last one, and use it from
> alua_rtpg_queue().
> 
> [1] https://lore.kernel.org/linux-scsi/b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com/
> [2] https://lore.kernel.org/linux-scsi/55c35e64-a7d4-9072-46fd-e8eae6a90e96@linux.ibm.com/
> 
> Fixes: f93ed747e2c7 ("scsi: core: Release SCSI devices synchronously")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sachin Sant <sachinp@linux.ibm.com>
> Cc: Benjamin Block <bblock@linux.ibm.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Steffen Maier <maier@linux.ibm.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c |  4 +---
>   drivers/scsi/scsi.c                        | 23 ++++++++++++++++++----
>   include/scsi/scsi_device.h                 |  1 +
>   3 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 49cc18a87473..bdfcea1c16cb 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -989,8 +989,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
>   	int start_queue = 0;
>   	unsigned long flags;
>   
> -	might_sleep();
> -
>   	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
>   		return false;
>   

I think Martin and James have already picked this hunk from Bart's last fixup 
[1] and sent a pull request including it to Linus [2].

At least, your patch did not apply cleanly for me, as I also had removed those 
two lines in my tree already.
Am applying the remaining parts to see how it performs in our CI (although this 
seems to occur seldomly so it'll be hard to tell whether it fixes the "problem").

[1] https://lore.kernel.org/linux-scsi/20230118180557.1212577-1-bvanassche@acm.org/
[2] 
https://lore.kernel.org/linux-scsi/87b5e16ec007de3523fd78534a48d6244bda3f46.camel@HansenPartnership.com/

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

