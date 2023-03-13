Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49F1C7618D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 23:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCMXnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 19:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCMXnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 19:43:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F6E6A9D9;
        Mon, 13 Mar 2023 16:43:49 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DLDu18002184;
        Mon, 13 Mar 2023 23:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : subject; s=pp1;
 bh=Gv6BzKgYo3dK7DSYQXcTqKfNpyn4PfO3sRW07kk10AE=;
 b=EWb6Vu+I/vDE4xptqm4lUwkTX1UlJm2fy9kQOPhKXtrGyQm+rUZTdHdy7PQhCYBIkyeZ
 UMXivuWKirgX74uut0tFK65bi2SvLbvv8Xzdx9odM51OGg2sUJ30/C+0VQiHToCBr96P
 YMEg6+Hdiljk6q77AQkV7h2r5gI6AK0k0vQFNesCCdDGzQZsxwt+Sj7UkNLvtl45CYpu
 YjEOhWoCuUiU8L1YQjVyng4geMAtFNkFEFO1gQvFR4QZtnFOpd6Ri6eWsH82RgRyZAID
 6GWmnvefvcFgguEey45sR4T9BdCIdsn7z5aE0UmYTatg7CZecNWen6r6lS/Wq7VKbuhY Yw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pabjgk39u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 23:43:43 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32DKjpdK017165;
        Mon, 13 Mar 2023 23:43:43 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3p8h97gm9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 23:43:43 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DNhgpu10093134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 23:43:42 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 127E658054;
        Mon, 13 Mar 2023 23:43:42 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CD1A5805A;
        Mon, 13 Mar 2023 23:43:41 +0000 (GMT)
Received: from [9.163.74.216] (unknown [9.163.74.216])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 23:43:41 +0000 (GMT)
Message-ID: <bd593f83-4aa2-3a6c-9e87-fe3cba0e7782@linux.vnet.ibm.com>
Date:   Mon, 13 Mar 2023 18:43:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
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
 <b7c0f38b-b56f-761b-9ce7-7b3d67a564d0@linux.vnet.ibm.com>
 <afaf9f0e-b29d-123b-68f0-38e4a741e07d@oracle.com>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <afaf9f0e-b29d-123b-68f0-38e4a741e07d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iLaWMFuqTZYAQ_syPCrRukGt4urhLA7_
X-Proofpoint-ORIG-GUID: iLaWMFuqTZYAQ_syPCrRukGt4urhLA7_
Subject: RE: Do we still need the scsi IPR driver ?
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_11,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303130186
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/10/23 3:56 AM, John Garry wrote:
> On 13/10/2022 04:36, Brian King wrote:
>>>> I've made some progress. I was able to dig up the code to move ipr to use error_handler
>>>> and have gotten it to compile, but haven't gotten to trying it in the lab yet.
>>>>
>>> Hmm. In which machines can I find an IPR installed? I could go hunting in our lab, maybe I can locate one and aid testing/development ...
>> Any Power 9 or older generation PowerVM based system would have an IPR installed as the boot device.
>> Additionally, on Power 10 systems, ipr SAS controllers are available as an add in card.
>>
>> However, the SATA support in ipr was only used to attach the onboard SATA DVD. Power 8 systems were
>> the last generation of systems that had an onboard SATA DVD. So, to do any testing with a
>> SATA DVD, you'd need a Power 8 or older system.
>>
>> Right now I have a patch that removes the SATA support from ipr completely and a patch that changes
>> to use the error_handler libata support. The one that changes to use the error_handler libata API
>> adds a bit of complexity for a function that should have few or no users that would need this support
>> on a current upstream kernel, since only Power 8 and older systems use this support. I'm getting
>> a system setup to try out both patches, but at this point I'm leaning towards the patch that
>> removes the libata dependency from ipr.
> 
> Hi Brian,
> 
> I was just wondering did you ever get to test these patches you mention? Or any other update on this topic?

Yes. I've been running both patches in the lab. I'm still leaning towards the patch that just
removes the libata dependency from ipr, since that is the simpler patch. I'll try to get something sent
out soon.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


