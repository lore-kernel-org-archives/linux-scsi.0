Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36FECCA483
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 21:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355541AbiFUVFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 17:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356211AbiFUVD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 17:03:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022113585B;
        Tue, 21 Jun 2022 13:53:27 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LK3XOr024830;
        Tue, 21 Jun 2022 20:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=l2WbDNq6sdrdY3ONOHicSbBuRhEnS9WPbcWjZaiMTmk=;
 b=B2FEPkgDLQfsCcuoqtu2OjAYIlmDqgD6i41nLxCRrDc4Y2vsmih7Nd5tqLIsuemjN4p0
 MT+xUmTk7YJDuHsH7n43W8NYc5Z6ugbiBA/OZmHCd3O2MiLv9zwImkYTFzJQZIKSxe2s
 bQZbQlUDDsIqjlGHjb4DOCxXctweTY6Fdka3L4pq57XZ/Y78VS98y4uJZ1B6Q8c8Pk9q
 y/E/UE6rQ0xsHLHrn+FPZkniFHLaErdnDXrOI0u83BXwNsVpjgJo5NIzuwpKdmYEyjFs
 3JnW6nxaq44QObgtqkN7nRFYbEzW2iZK+EBcJrz22HDFl2c3SnRQIShtmownjq7iSVlo Fw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gumpm19a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:52:21 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LKpuUe012653;
        Tue, 21 Jun 2022 20:52:21 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3gs6b9v7ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:52:21 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LKqKC422020484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 20:52:20 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65C4EB2064;
        Tue, 21 Jun 2022 20:52:20 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCCA1B205F;
        Tue, 21 Jun 2022 20:52:19 +0000 (GMT)
Received: from [9.211.124.46] (unknown [9.211.124.46])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 20:52:19 +0000 (GMT)
Message-ID: <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
Date:   Tue, 21 Jun 2022 15:52:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
From:   Brian King <brking@linux.vnet.ibm.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
In-Reply-To: <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oc0I6NpZB01zGH688zD-XOKWPfUQuj3d
X-Proofpoint-ORIG-GUID: oc0I6NpZB01zGH688zD-XOKWPfUQuj3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_09,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210086
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/21/22 3:36 PM, Brian King wrote:
> On 6/19/22 11:48 PM, Damien Le Moal wrote:
>>
>> Polling people here: Do we still need the scsi IPR driver for IBM Power
>> Linux RAID adapters (IBM iSeries: 5702, 5703, 2780, 5709, 570A, 570B
>> adapters) ?
>>
>> The reason I am asking is because this driver is the *only* libsas/ata
>> driver that does not define a ->error_handler port operation. If this
>> driver is removed, or if it is modified to use a ->error_handler operation
>> to handle failed commands, then a lot of code simplification can be done
>> in libata, which I am trying to do to facilitate the processing of some
>> special error completion for commands using a command duration limit.
> 
> We still need it around for now. IBM still sells these adapters
> and they can still be ordered even on our latest Power 10 systems.

At one point I did look into modifying ipr to use an ->error_handler.
I recall I ran into some issues that resulted in this getting put
on the shelf, but its been a while. I'll go dig that code up and
see what it looks like.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

