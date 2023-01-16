Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E186C54EBE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 18:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbjAPS0t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 13:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjAPS0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 13:26:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B0E305C0;
        Mon, 16 Jan 2023 10:13:11 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHhYUp023270;
        Mon, 16 Jan 2023 18:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RuvwMj53r/00eZXb3IrNdFLFpoF8emu2KQBG97uvGyA=;
 b=Wq8Fk/O2QWxelOyFT9z67GCmMBpP1cyUTNHy3XbiAVQVaYutRxog5Q0ovP7x6UBIYU4n
 luwxLxI8HYXJ1IFAlWHoTW9/f/N8dD3GSZ/tnW6pxSNDXx9W3d9lGgdd7QFhFuHHW5a4
 KRj2qjju0+eqW8b4rGppx1Gu94u2xfe6nmDay3HVctdhipINH3fEHz5IxVruuuXItGTi
 O5Oo9YqSzdsZOcP4t880rF1KEK9D2tQ+DHs/jHUvCI6+A0Q7h2uO+6vOWaww+R8Od7Ja
 dyYr/NvAxNRwfqnSEvOrsE82pshkc3TBEeMvnFV1QY5gDqudY4W7sIHFFEQWHPA30WNR MQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n54r9trg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:13:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GGR4ax006324;
        Mon, 16 Jan 2023 18:13:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfjs7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:13:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GICqoW49414564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:12:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 371D920040;
        Mon, 16 Jan 2023 18:12:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 917E82004E;
        Mon, 16 Jan 2023 18:12:51 +0000 (GMT)
Received: from [9.179.29.96] (unknown [9.179.29.96])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:12:51 +0000 (GMT)
Message-ID: <61abebf1-4c92-a6eb-5d27-5ad223d85f46@linux.ibm.com>
Date:   Mon, 16 Jan 2023 19:12:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
 <228d2351-e0ff-e743-6005-3ac0f0daf637@acm.org>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <228d2351-e0ff-e743-6005-3ac0f0daf637@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GXi027sBLsp8nAseKqNV_ZD2O5ahZqt3
X-Proofpoint-ORIG-GUID: GXi027sBLsp8nAseKqNV_ZD2O5ahZqt3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301160135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 1/16/23 18:55, Bart Van Assche wrote:
> On 1/16/23 06:59, Steffen Maier wrote:
>> since a few days/weeks, we sometimes see below alua and sleep related kernel 
>> BUG and WARNING (with panic_on_warn) in our CI.
>>
>> It reminds me of
>> [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
>> https://lore.kernel.org/linux-scsi/166986602290.2101055.17397734326843853911.b4-ty@oracle.com/
>>
>> which I thought was the fix and went into 6.2-rc(1?) on 2022-12-14 with
>> [GIT PULL] first round of SCSI updates for the 6.1+ merge window
>> https://lore.kernel.org/linux-scsi/b2e824bbd1e40da64d2d01657f2f7a67b98919fb.camel@HansenPartnership.com/T/#u
>>
>> Due to limited history, I cannot tell exactly when problems started and 
>> whether it really correlates to above.
>>
>> Test workload are all kinds of coverage tests for zfcp recovery including 
>> scsi device removal and/or rescan.
>>
>> [ 4569.045992] BUG: sleeping function called from invalid context at 
>> drivers/scsi/device_handler/scsi_dh_alua.c:992

> Thanks for your report and also for having included this call trace. Is my 
> understanding correct that alua_rtpg_queue+0x3c refers to the might_sleep() 
> near the start of alua_rtpg_queue()? If so, please help with testing the 
> following patch:
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c 
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 49cc18a87473..79afa7acdfbc 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -989,8 +989,6 @@ static bool alua_rtpg_queue(struct alua_port_group
>       int start_queue = 0;
>       unsigned long flags;
> 
> -    might_sleep();
> -
>       if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
>           return false;
> 
> 
> I'm proposing this change because the context from which a request is queued 
> should hold a reference on 'sdev' while a request is in progress so 
> alua_check_sense() should not trigger the scsi_device_put() call in 
> alua_rtpg_queue().

How would removing this check solve the other and seemingly more fatal (even 
without panic_on_warn) WARNING?:

[ 4760.878107] do not call blocking ops when !TASK_RUNNING; state=2 set at 
[<000000017ed2c0fa>] __wait_for_common+0xa2/0x240


FWIW, it seems we only seem to get such reports for debug kernel builds (not 
sure which kconfig options are relevant) but not for production / performance 
builds.

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

