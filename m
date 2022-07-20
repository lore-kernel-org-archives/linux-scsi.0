Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FE4C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 08:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbiGTITh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 04:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiGTITg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 04:19:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C4445F52;
        Wed, 20 Jul 2022 01:19:35 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26K7RJbV022970;
        Wed, 20 Jul 2022 08:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KOCwHeadE/oMbxq2JBe4TjRQ/Hb4D12jZplqoyY1WME=;
 b=Xjb7rXuuf/EkmIMlxjXol3/LNfEvwefHLVe1IQ14NOwdagTBFpcC4+jU8nqfIAeT3uyx
 Y+Nxj3/3LhfJ/YQPwdsNPW2YmtkrzqdUhDR/pbmVRFaC9FLQpztBfmM/91fskG53c++n
 5UxU2WlTPVK5TxqXCGqUubDXY4ZsqNY69wW4KepITJEdwuFqZopBbUiUr1L3UqRnB3Tv
 iPZtOmuSaLt1et8d77YUcoeE3DHUTCHTmq7qDNxRDdeHQ2zzoYRzqxqnYnwQLXPL1FMM
 RULugGbFqr9gv9cVk3cmT1Cbtt/E9197ZrkjNTjSa/pY15877TeCNbgXbqfofTp+NjJX uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hedb49pm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 08:19:34 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26K7T8qt032256;
        Wed, 20 Jul 2022 08:19:34 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hedb49pks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 08:19:34 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26K86mPK020054;
        Wed, 20 Jul 2022 08:19:33 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3hbmy9pjy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 08:19:33 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26K8JWCu23331314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 08:19:32 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B0C7124055;
        Wed, 20 Jul 2022 08:19:32 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02C2A124054;
        Wed, 20 Jul 2022 08:19:29 +0000 (GMT)
Received: from [9.43.112.189] (unknown [9.43.112.189])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jul 2022 08:19:29 +0000 (GMT)
Message-ID: <59642c8d-adbf-cbfd-ffee-3f3b31613e05@linux.vnet.ibm.com>
Date:   Wed, 20 Jul 2022 13:49:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [linux-next] [5.19.0-rc1] kernel crashes while performing driver
 bind/unbind test with SLUB_DEBUG enabled
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        abdhalee@linux.vnet.ibm.com, mputtash@linux.vnet.com,
        sachinp@linux.vnet.com
References: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
 <Yqksbtth8zzEmjp4@T590>
 <d789d8f6-71c3-3927-7708-141b43c3ba0b@linux.vnet.ibm.com>
 <Ys7EXeoVbLRZj9CL@T590>
From:   Tasmiya Nalatwad <tasmiya@linux.vnet.ibm.com>
In-Reply-To: <Ys7EXeoVbLRZj9CL@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C6Y7Nv445Ywi2oLmL8ylqw3RMu5xVhhm
X-Proofpoint-ORIG-GUID: xJElMXN19Tba3c02ohfit4DIqeLtnkDu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_04,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=964 phishscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Greetings,

Sure I will verify, could you please provide me the code patch.

On 7/13/22 18:41, Ming Lei wrote:
> On Wed, Jul 13, 2022 at 03:49:05PM +0530, Tasmiya Nalatwad wrote:
>> Greetings,
>>
>> While running plain bind/unbind test on scsi I had enabled slub_debug
>>
>> System has FC adapter with multipath enabled.
>>
>> Step 1 : Added slub_debug in /etc/default/grub saved the configuration and
>> rebooted the machine.
>> Step 2 : Performed normal driver bind/unbind test.
> 
> Hello,
> 
> Can you try the following patches and see if they are helpful?
> 
> 
> Thanks,
> Ming
> 

-- 
Regards,
Tasmiya Nalatwad
IBM Linux Technology Center
