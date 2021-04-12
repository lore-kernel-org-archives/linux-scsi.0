Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C53CC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 14:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCCE36128B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 14:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242104AbhDLOE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 10:04:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241422AbhDLOE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 10:04:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CE2mTi146236;
        Mon, 12 Apr 2021 10:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=D+Pr044Sc37k2/xacVMJIRTA9aojRfwKHjljGaysKTM=;
 b=BOQHsE68Vk+Kk5ONmvB4O1ZN99VkPSjrYhm6HbryT/dnb/SEyRCSf5082pIXZDNLeVOZ
 xbzMQe8pnwCtXSvmv/MsD2e1GI2bNLS9Taf8hzk79MlVp+d45U0fwbs1XZQW0OH/IRIj
 BAUvxNVbyY2zAaos2y0JXILHa7kqpRoDjdOW3D2rO1p8b/Ae/Y+8nA/2kj4xmanLEX5d
 R0RM1kf7idRUlSa0BJ8Asqhgh5EVBN+ik0IRVJaVwHkk9fEuspFqWxyuESwfF1RS1Rla
 O9uyKFiiZXvgw2XuaQDSky5xaUwTIi776q1CFcQLn3hHGWHV6rBxKElrOe/uiuziVAxT fw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vk4hauxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 10:04:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CDwLND012027;
        Mon, 12 Apr 2021 14:04:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n89vcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 14:04:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CE48t646137724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 14:04:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74890AE04D;
        Mon, 12 Apr 2021 14:04:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCBE5AE059;
        Mon, 12 Apr 2021 14:04:07 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.171.61.4])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 14:04:07 +0000 (GMT)
Subject: Re: [PATCH 5/8] scsi: remove the unchecked_isa_dma flag
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210331073001.46776-1-hch@lst.de>
 <20210331073001.46776-6-hch@lst.de>
 <2fa7fad0-2689-24c9-d356-50f98ca3535d@linux.ibm.com>
 <20210410065231.GA16173@lst.de>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <ad37abab-6a23-bd44-f2d7-47dde4a21ac3@linux.ibm.com>
Date:   Mon, 12 Apr 2021 16:04:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210410065231.GA16173@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xQM5eLtUSXFNfB5O3WkIogvWQMCctilV
X-Proofpoint-GUID: xQM5eLtUSXFNfB5O3WkIogvWQMCctilV
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_10:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120096
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/10/21 8:52 AM, Christoph Hellwig wrote:
> On Fri, Apr 09, 2021 at 05:46:09PM +0200, Steffen Maier wrote:
>> Is it OK to remove a long standing sysfs attribute?
>> Was there any deprecation phase?
>>
>> I just noticed it in our CI reporting fails due to this change since at
>> least linux-next 20210409. Suppose it came via
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.13/block&id=aaff5ebaa2694f283b7d07fdd55fb287ffc4f1e9
>>
>> Wanted to ask before I adapt the test cases.
> 
> What does your CI do with it?

We check almost all zfcp-related sysfs attributes for returning expected values 
(depending on possible error inject state transitions as well as steady state).
The Scsi_Host's unchecked_isa_dma is just checked to return '0'.

> It would be kinda of sad to carry around this baggage, but if real
> userspace is broken by the chance we'll have to do it.  I'm just not
> entirely sure testcases qualify as real userspace yet.

I was more pondering whether sysfs is considered stable API.

I'm not aware of any issues with real userspace if unchecked_isa_dma is absent.
Have adapted our test case to accept a missing unchecked_isa_dma sysfs attribute.

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
