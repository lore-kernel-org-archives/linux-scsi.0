Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16CBC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 10:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiGMKTS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiGMKTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 06:19:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4076DAB97;
        Wed, 13 Jul 2022 03:19:12 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DA3XtV028289;
        Wed, 13 Jul 2022 10:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y1cPLcA+CAb0DvNvtaiSf/xYHkYzUGwDbYkQ06zl5tc=;
 b=Q5Xaly10bjsug/92EIOV8ieO0KS8UxBIwePvQKPr4SHTEM2JbHfipGvfYganTK1JPCS5
 RxNHWZ4b8lw9wHSNmH33K+wU+ZPNU8l4CjNEtnmb+cdDztcp8fAsf7cx3WIOOt97hqON
 BGdost3NBpti388hrRRQgVpSZdkJC36+ko+QCC7SzMQoAiaQFjXdRqZL5h9syptvElTb
 n/IFpybb2iRvZ3pJP8ZoaBaRwayz0TX374R46IaDhj19ISiip3mW1pO/oRIbCJFtLYQd
 Yy0zkxq5JlKgEDXLB2w5Ka0PEcnrWPYGFicK7dBuQb8mCLgjS4p0mM7+BWq3L9XnXvW+ eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9uycr84a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:19:11 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DADgau003657;
        Wed, 13 Jul 2022 10:19:11 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9uycr83y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:19:11 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DA869x021417;
        Wed, 13 Jul 2022 10:19:10 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3h71a9kdrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:19:10 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DAJAQc57409850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 10:19:10 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 512442805A;
        Wed, 13 Jul 2022 10:19:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F67428059;
        Wed, 13 Jul 2022 10:19:07 +0000 (GMT)
Received: from [9.43.25.232] (unknown [9.43.25.232])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 10:19:06 +0000 (GMT)
Message-ID: <d789d8f6-71c3-3927-7708-141b43c3ba0b@linux.vnet.ibm.com>
Date:   Wed, 13 Jul 2022 15:49:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [linux-next] [5.19.0-rc1] kernel crashes while performing driver
 bind/unbind test with SLUB_DEBUG enabled
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        abdhalee@linux.vnet.ibm.com, sachinp@linux.vnet.com,
        mputtash@linux.vnet.com
References: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
 <Yqksbtth8zzEmjp4@T590>
From:   Tasmiya Nalatwad <tasmiya@linux.vnet.ibm.com>
In-Reply-To: <Yqksbtth8zzEmjp4@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7i5Vot_3XKQBJOcASeCB9jNJN_Vu-dJg
X-Proofpoint-ORIG-GUID: yKqqSMp6TJZ95UOMHgpIm_MVli3WRpKY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130041
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Greetings,

While running plain bind/unbind test on scsi I had enabled slub_debug

System has FC adapter with multipath enabled.

Step 1 : Added slub_debug in /etc/default/grub saved the configuration 
and rebooted the machine.
Step 2 : Performed normal driver bind/unbind test.

On 6/15/22 06:20, Ming Lei wrote:
> Hello Tasmiya,
> 
> On Tue, Jun 14, 2022 at 03:27:37PM +0530, Tasmiya Nalatwad wrote:
>> Greetings,
>>
>> [linux-next] [5.19.0-rc1-next-20220610] kernel crashes while performing
>> driver bind/unbind test with SLUB_DEBUG enabled
>>
>> Traces :
> 
> I just run plain unbind/bind on scsi_debug, and can't trigger the issue.
> 
> Can you share your exact reproduction steps? Is dm-mpath involved?
> 
> 
> Thanks,
> Ming
> 

-- 
Regards,
Tasmiya Nalatwad
IBM Linux Technology Center
