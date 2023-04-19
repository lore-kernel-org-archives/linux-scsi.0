Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE42C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 18:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDSS6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 14:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDSS63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 14:58:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3715BB9
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 11:58:28 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JItatd030810;
        Wed, 19 Apr 2023 18:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4TyLhaltm9h3cwkdm2rstjbHAreZQ1g1QJohRqowc3Q=;
 b=sZMXEp8v6cNhLYG5pSVJ45C9w3EQHyBoHYUqABYAqqhUwV8QT+eTh/dbedkVnVwVuH0B
 HPOU/LK2RlsAMYZnsSJ3E81sQYYbbj0qmOIu3N5nQBJeVSndV2CCW5zY2ikEMZMqixdt
 yvDtt4EvemaXvMFTf73P50d9IUn5v86DrAJANhhp7HRubnzbj2Bke2uDepB6jzPCQNSL
 C062rsnghH1ZHV9N7qZtpz4G6+NcENKTBsSTR/LxLt/snD5ruXgoM9QBOJU4I0jlsZ4w
 8RPZpDLOzLdRoXb9L2g1LzGi7P/vDzCBqA44rYbU5k2pP5+GPbu7cLENAjJ39Jk38NCb cA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q28u09thh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 18:58:22 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33JHeShu027048;
        Wed, 19 Apr 2023 18:58:22 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3pykj703d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 18:58:22 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33JIwL7C15467164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 18:58:21 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E992558056;
        Wed, 19 Apr 2023 18:58:20 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 671085803F;
        Wed, 19 Apr 2023 18:58:20 +0000 (GMT)
Received: from [9.163.56.160] (unknown [9.163.56.160])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 18:58:20 +0000 (GMT)
Message-ID: <f667d600-4eee-126e-c14f-60cd64109fae@linux.vnet.ibm.com>
Date:   Wed, 19 Apr 2023 13:58:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] ipr: Remove SATA support
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com,
        wenxiong@linux.ibm.com
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
 <yq1v8hspnww.fsf@ca-mkp.ca.oracle.com>
 <ed208a85-f66d-d70c-d3fb-12e66629863a@kernel.org>
 <yq1cz40ot8n.fsf@ca-mkp.ca.oracle.com>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <yq1cz40ot8n.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DZRr4pD5d9HhV1cxa4UrHExeSmnG3a10
X-Proofpoint-GUID: DZRr4pD5d9HhV1cxa4UrHExeSmnG3a10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_12,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/23 9:17 AM, Martin K. Petersen wrote:
> 
> Damien,
> 
>> There was a build bot warning. Was that fixed ? I did not see a v2...
> 
> I couldn't correlate those build bot warnings to the code changes.  I
> put the patch in staging to see what will get reported there.
> 

I was working on a v2 with fixes for the build bot complaints.
One was a complaint about an used variable that is only unused when
a compile option is turned off, but the reset were valid unused variables
that can be cleaned up. 

Since you've pulled this in, should I just send a new patch on top
for just these minor build bot fixes?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


