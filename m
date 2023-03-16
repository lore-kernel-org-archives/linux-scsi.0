Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39306C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 10:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCPKRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 06:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCPKRg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 06:17:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EE5B5FDC;
        Thu, 16 Mar 2023 03:17:34 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GA3MOu036254;
        Thu, 16 Mar 2023 10:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZACa85eTwIwEbxbh2jnmGok+PA4RgqK2zsPjWVAbaO0=;
 b=VQBVVa0hVeaAMk/VLdWbaFLmkZr79x2Qaj5JxbSj2bsBMF9E47wbJYb+QgX0DYA8IQke
 kAnRYwBqVrdDsGZt/TDhcyIFTAp4eHS7mCljB+RhKUi3WtkmPKfSWaHpdmzk6rA+N8Ln
 KJp6Ia2PDBMv646TzkudQeAM2i12YE/67nGslrFbqG78+hD+xBSNy/AWeR4MdmU2WfJ0
 yyICMCVsQeA7RYNnNkd86Sqxy42lusaGUAUqumCohL6zzJCWNb3TkbjV6E0ZUBGf6evo
 XxpLlSY5TyUVEf+S7noPXRc08Ch7mVBXNm9NSw0nciTpoOhRNu7agdbyT/uUrKzy1SeL rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbpx4x9bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 10:17:12 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32G9uM4w036034;
        Thu, 16 Mar 2023 10:17:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbpx4x9b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 10:17:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32G230aA028037;
        Thu, 16 Mar 2023 10:17:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pbsyxrd8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 10:17:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32GAH7cl21561864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 10:17:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8422F20040;
        Thu, 16 Mar 2023 10:17:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 224D820065;
        Thu, 16 Mar 2023 10:17:07 +0000 (GMT)
Received: from [9.152.212.230] (unknown [9.152.212.230])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Mar 2023 10:17:07 +0000 (GMT)
Message-ID: <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
Date:   Thu, 16 Mar 2023 11:17:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Jan Hoeppner <hoeppner@linux.ibm.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
Content-Language: en-US
From:   Stefan Haberland <sth@linux.ibm.com>
Subject: Re: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
In-Reply-To: <20230315133039.GA24533@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7Lu1Tb2Scs24OFho49SszeZQEQtjCy3_
X-Proofpoint-ORIG-GUID: e5UmNwL8IYAtm8F-8DT0dsS5_CITZfXA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_06,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160081
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 15.03.23 um 14:30 schrieb Christoph Hellwig:
> On Wed, Mar 15, 2023 at 11:04:22AM +0100, Stefan Haberland wrote:
>> This also fits for the DASD case. We use this error code for a
>> reservation/locking conflict of the DASD device when the lock we
>> previously held was stolen.
> But that's not really a reservation conflict in the sense
> of the reservation API.  Given that DASD doesn't support it it
> might not matter.  Do you have applications that checks for
> the translated errno value?  We'll probably at least want
> a comment documenting this status code.

Well, I might completely misunderstand the use case for this error code.
Sorry if that is the case.

Beside that I thought that the return codes are generic blocklayer 
return codes
and not bound to a specific API. I am not familiar with the reservation 
API you
are talking about.

What I understood from the reservation in NVMe context is that a namespace
might be reserved to a host. If there is a conflict with this reservation
this error code is provided for the IO request.

For DASDs we have the possibility to reserve a disk for a host. If there 
is a
conflict with this platform specific reservation we would present this 
error
for an IO request.

This sounded quite similar for me.

I am completely open to using another return code and I am not aware of an
application checking for this specific return code.

Is there any that would fit better from your point of view?

