Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58EEC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Oct 2022 17:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJERUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Oct 2022 13:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJERUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2022 13:20:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1F657E22;
        Wed,  5 Oct 2022 10:20:21 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295G712e027431;
        Wed, 5 Oct 2022 17:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kgWtuerSCQwFGO3aGCOydrv5sKJ9yZuy2fQbBXnHm7I=;
 b=nKG/GAxveXMJjfFu46P5YIeWBd3+6kgxTk8nPGR6df7HMnjkk3T2jHv38u+I14qXkieM
 gDmYwUxYNdoEaz7DUni06pukZLR3GSSe6CzrlbZ7P3fFuXay3VzjptSCzODGCPb/UmXH
 Tq3zpJ2yhPh4k3TcQ2UPzCN01ayu/frz8t7mX72DMa8AhaXzDK7ejcI0gkIpPF1fnZqJ
 t5Drm5bhK3jRdFgN1ZBJMR3BSOlVIHie7mAgQmA5Zs7Kp65L4DaFCJbAeAYwRNFYPjPP
 pGRvre54QxUSjc7C88JcJFmeDOZ0v/vXitlsqwJRTqEGAjGrk59IAFfXhNRR1XwWzCQP HQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1ap2fnwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 17:20:08 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295H6mxn015553;
        Wed, 5 Oct 2022 17:20:07 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3jxd6ac2n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 17:20:07 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295HK56E20906524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 17:20:05 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A1E558063;
        Wed,  5 Oct 2022 17:20:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2FC658056;
        Wed,  5 Oct 2022 17:20:05 +0000 (GMT)
Received: from [9.163.15.61] (unknown [9.163.15.61])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 17:20:05 +0000 (GMT)
Message-ID: <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
Date:   Wed, 5 Oct 2022 12:20:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
 <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
 <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3WXBF-qBINAahv2zMapjlTXEzNrFLBEy
X-Proofpoint-GUID: 3WXBF-qBINAahv2zMapjlTXEzNrFLBEy
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 suspectscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210050106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/22 8:07 AM, John Garry wrote:
> On 21/06/2022 23:12, Damien Le Moal wrote:
>>>> We still need it around for now. IBM still sells these adapters
>>>> and they can still be ordered even on our latest Power 10 systems.
>>> At one point I did look into modifying ipr to use an ->error_handler.
>>> I recall I ran into some issues that resulted in this getting put
>>> on the shelf, but its been a while. I'll go dig that code up and
>>> see what it looks like.
>> Thanks. It would be really great if you can convert to using
>> error_handler. This is really the last ata/libsas driver that does not use
>> this.
>>
> 
> Hi Brian,
> 
> I am wondering if there is any update here?
> 
> As you may have seen in [0], I think that we need to make progress on this topic first to keep the solution there a bit simpler.
> 
> [0] https://lore.kernel.org/linux-scsi/1663669630-21333-1-git-send-email-john.garry@huawei.com/T/#mf890cb4f1627112652831524dca62cbde4a0a637

I've made some progress. I was able to dig up the code to move ipr to use error_handler
and have gotten it to compile, but haven't gotten to trying it in the lab yet.

-Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

