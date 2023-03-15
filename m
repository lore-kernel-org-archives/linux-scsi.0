Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A89C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 10:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjCOKGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 06:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjCOKFk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 06:05:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7C259E47;
        Wed, 15 Mar 2023 03:04:56 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F9Cefn029844;
        Wed, 15 Mar 2023 10:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wm6XrG90RA3+jZ6n23uggt2rMBObnN4VNBwJHfOpGTE=;
 b=M44Xqnl31paXV/L6fzU/kv1+TckR4GM33EjTNJwlLwfFKkPYY+mhuqwHgWlcvE+sPOyR
 uMcz05rEHIjqfgFlf5oE0i1hM48skicjimHl4MGGS+wNx66Dildwo7lOEewbdDJ20ttN
 XoSsGW5VGFgizJ4uFYswHwPQc8PVAprz4Z/uHtc98zecjF28B8l2pNkHYXbt8o0uG5qi
 b1wEWmjLRIdFeIM6cCksZSrjuMht4XcNfuv40NZDNZSeMBupQu7POG3bd8lilsuACAfC
 cjuI3CEyqRc2REIdtJzpVKTCzdeApEFpUJKBD3aAaGk4wKSczmcCZxbCpRPcKEadlO99 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbb67hbx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 10:04:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32F9VHqX017522;
        Wed, 15 Mar 2023 10:04:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbb67hbw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 10:04:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32F3UQXO008910;
        Wed, 15 Mar 2023 10:04:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pb29t0gh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 10:04:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FA4Nsf46596788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 10:04:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 845BF2006B;
        Wed, 15 Mar 2023 10:04:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24C1220063;
        Wed, 15 Mar 2023 10:04:23 +0000 (GMT)
Received: from [9.152.212.230] (unknown [9.152.212.230])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 10:04:23 +0000 (GMT)
Message-ID: <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
Date:   Wed, 15 Mar 2023 11:04:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Jan Hoeppner <hoeppner@linux.ibm.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
Content-Language: en-US
From:   Stefan Haberland <sth@linux.ibm.com>
Subject: Re: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
In-Reply-To: <20230314171119.GB6780@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gm8knda4ABLDpRDHcHrrp25yIqxkZsPd
X-Proofpoint-GUID: mK6UREPnREctSNluacMB5DE7veYDb5Ae
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_04,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150086
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 14.03.23 um 18:11 schrieb Christoph Hellwig:
> On Fri, Feb 24, 2023 at 11:44:46AM -0600, Mike Christie wrote:
>> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts or in dasd's
>> case something similar. This renames BLK_STS_NEXUS so it better reflects
>> this.
> I like this rename a lot.
>
>> diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
>> index a9c2a8d76c45..a2899d9690d4 100644
>> --- a/drivers/s390/block/dasd.c
>> +++ b/drivers/s390/block/dasd.c
>> @@ -2723,7 +2723,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
>>   	else if (status == 0) {
>>   		switch (cqr->intrc) {
>>   		case -EPERM:
>> -			error = BLK_STS_NEXUS;
>> +			error = BLK_STS_RESV_CONFLICT;
>>   			break;
> But is this really a reservation conflict?  Or should the DASD code
> maybe use a different error code here?
>

This also fits for the DASD case. We use this error code for a
reservation/locking conflict of the DASD device when the lock we
previously held was stolen.

Acked-by: Stefan Haberland <sth@linux.ibm.com>

