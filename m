Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C18C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 03:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJMDg4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiJMDgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 23:36:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BDBB6003;
        Wed, 12 Oct 2022 20:36:53 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29D1LjVk003299;
        Thu, 13 Oct 2022 03:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : to :
 references : from : in-reply-to : content-type : content-transfer-encoding
 : mime-version : subject; s=pp1;
 bh=XvcB7nbWn5WAazAz23zsmp4CmY1g3aGu3VBCW9YbgRA=;
 b=RTkh0TkdWqygDQoDXAlal+t/L6zNzJPBknb1Jz47i0acWCSZ9lNbRFrGAF902iMdvCkJ
 aCAheTOaWo2SC4mBTjpVL4ItzXCckXwLYy8a9d38yVm24YG8lsYzcfWBsYHCRoceEw7j
 rLJHs2SRJ2GdQAUYbB3fYarCgl9OAkCjH52uepFbUNKsQoUYQP3OJpkM1vgwoyaN5iUg
 BP1I9OUd8IS8mt9b4zJXJFBLweIZHEcvYIW06udL8Oz8TxxXLRu4x0XA5JRntX6Cs0cj
 glHMPT/C5aSRmi6nn5rMf3aEBIwGmQS6zK40IkX6aqC4LxT8H4sDeDYvNQ9uqGrJDRsP JA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k68xsjj40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 03:36:42 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29D3a1l7024866;
        Thu, 13 Oct 2022 03:36:41 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3k30uacf0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 03:36:41 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29D3acJZ42008868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 03:36:38 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 419F658068;
        Thu, 13 Oct 2022 03:36:40 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E15AB58056;
        Thu, 13 Oct 2022 03:36:39 +0000 (GMT)
Received: from [9.163.31.186] (unknown [9.163.31.186])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Oct 2022 03:36:39 +0000 (GMT)
Message-ID: <b7c0f38b-b56f-761b-9ce7-7b3d67a564d0@linux.vnet.ibm.com>
Date:   Wed, 12 Oct 2022 22:36:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
 <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
 <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
 <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
 <6c1f12d2-9211-85ef-dfd5-e091ea1559d7@suse.de>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <6c1f12d2-9211-85ef-dfd5-e091ea1559d7@suse.de>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6Hctqqy_aExJDRgmmZHkV1rVivZPJGgU
X-Proofpoint-GUID: 6Hctqqy_aExJDRgmmZHkV1rVivZPJGgU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
Subject: RE: Do we still need the scsi IPR driver ?
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-13_02,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210130020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/22 2:35 AM, Hannes Reinecke wrote:
> On 10/5/22 19:20, Brian King wrote:
>> On 9/20/22 8:07 AM, John Garry wrote:
>>> On 21/06/2022 23:12, Damien Le Moal wrote:
>>>>>> We still need it around for now. IBM still sells these adapters
>>>>>> and they can still be ordered even on our latest Power 10 systems.
>>>>> At one point I did look into modifying ipr to use an ->error_handler.
>>>>> I recall I ran into some issues that resulted in this getting put
>>>>> on the shelf, but its been a while. I'll go dig that code up and
>>>>> see what it looks like.
>>>> Thanks. It would be really great if you can convert to using
>>>> error_handler. This is really the last ata/libsas driver that does not use
>>>> this.
>>>>
>>>
>>> Hi Brian,
>>>
>>> I am wondering if there is any update here?
>>>
>>> As you may have seen in [0], I think that we need to make progress on this topic first to keep the solution there a bit simpler.
>>>
>>> [0] https://lore.kernel.org/linux-scsi/1663669630-21333-1-git-send-email-john.garry@huawei.com/T/#mf890cb4f1627112652831524dca62cbde4a0a637  
>>
>> I've made some progress. I was able to dig up the code to move ipr to use error_handler
>> and have gotten it to compile, but haven't gotten to trying it in the lab yet.
>>
> Hmm. In which machines can I find an IPR installed? I could go hunting in our lab, maybe I can locate one and aid testing/development ...

Any Power 9 or older generation PowerVM based system would have an IPR installed as the boot device.
Additionally, on Power 10 systems, ipr SAS controllers are available as an add in card. 

However, the SATA support in ipr was only used to attach the onboard SATA DVD. Power 8 systems were
the last generation of systems that had an onboard SATA DVD. So, to do any testing with a
SATA DVD, you'd need a Power 8 or older system. 

Right now I have a patch that removes the SATA support from ipr completely and a patch that changes
to use the error_handler libata support. The one that changes to use the error_handler libata API
adds a bit of complexity for a function that should have few or no users that would need this support
on a current upstream kernel, since only Power 8 and older systems use this support. I'm getting
a system setup to try out both patches, but at this point I'm leaning towards the patch that
removes the libata dependency from ipr.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


