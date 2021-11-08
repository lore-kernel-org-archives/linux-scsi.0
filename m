Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0922CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 14:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB41061076
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 14:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhKHOTV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 09:19:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236213AbhKHOTV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 09:19:21 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CdjCt004463;
        Mon, 8 Nov 2021 14:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=lbRT2x8gmpe/Umgyul24pIBJy6sapRjt+6I0ar72wMw=;
 b=p+bpuEH94xOnyhZ0K4YrGPeLsQj+Tuvew0nbQqyTOh6JX8jcEjiToGoITQx6GO+HuOJK
 mGqYkUcBDu85ALA16FBqjhfOwJNtcrcKpjQTIFBfvPIYGskgoHhBXyUqtXOPDi8/Q3Jy
 oY8TxW7BtbwkY5wd/3yYl8cR7io+Q+rx4Sj1xRwnNErRMv+WnCtLCBsN6+z8zOAHCrOP
 SsQsuH+39SPAo8M7Jh0Ejba0L/oyosUnK+HuX2Kt4TG7XWfw1/yUK4zCIGjuT2c9hgbm
 pQKYxccxx5P10KLZyjIkTcDucuWHLM50IpkXlUkrVn/+on2673MPIrmOj5/x6jqDp9+e WQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66b00ejq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:16:32 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8E3hAb030048;
        Mon, 8 Nov 2021 14:16:31 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3c5hbac4k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:16:31 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8EGUQf34734346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 14:16:30 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC836B2066;
        Mon,  8 Nov 2021 14:16:30 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65B32B2071;
        Mon,  8 Nov 2021 14:16:30 +0000 (GMT)
Received: from [9.65.231.116] (unknown [9.65.231.116])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 14:16:30 +0000 (GMT)
Message-ID: <3bca3296-d998-98a5-bf8f-53b0720869d3@linux.vnet.ibm.com>
Date:   Mon, 8 Nov 2021 08:16:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
Content-Language: en-US
To:     Justin Piszcz <jpiszcz@lucidpixels.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
 <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
 <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com>
 <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com>
 <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com>
 <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com>
 <e0c2935d-d961-11a0-1b4c-580b55dc6b59@acm.org>
 <002401d7d305$082971b0$187c5510$@lucidpixels.com>
 <CAO9zADzWcpwZkfJ5VZGZZJT39KQEUr9yGqqCnP18mk7ZAZxbBw@mail.gmail.com>
From:   Douglas Miller <dougmill@linux.vnet.ibm.com>
In-Reply-To: <CAO9zADzWcpwZkfJ5VZGZZJT39KQEUr9yGqqCnP18mk7ZAZxbBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wmt0OWq8KvYGzw82ozJAc39g0SZ2ORlW
X-Proofpoint-GUID: wmt0OWq8KvYGzw82ozJAc39g0SZ2ORlW
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080087
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit I referenced earlier does point back to the commit that 
caused the problem (that I saw). There was a series of commits related 
to IRQ domains, this one seems to have actually caused the problem I saw:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a5f3d2c17b07


On 11/7/21 07:46, Justin Piszcz wrote:
> On Sat, Nov 6, 2021 at 7:54 AM Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> -----Original Message-----
>> From: Bart Van Assche <bvanassche@acm.org>
>> Sent: Wednesday, November 3, 2021 12:23 PM
>> To: Justin Piszcz <jpiszcz@lucidpixels.com>; Douglas Miller <dougmill@linux.vnet.ibm.com>
>> Cc: LKML <linux-kernel@vger.kernel.org>; linux-scsi@vger.kernel.org
>> Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out, resetting card
>>
>> On 11/3/21 9:18 AM, Justin Piszcz wrote:
>>> Thanks!-- Has anyone else reading run into this issue and/or are there
>>> any suggestions how I can troubleshoot this further (as all -rc's have
>>> the same issue)?
>> How about bisecting this issue
>> (https://www.kernel.org/doc/html/latest/admin-guide/bug-bisect.html)?
>>
>> [ .. ]
>>
>> I was having some issues finding a list of changes with git bisect, so I started checking the kernel .config and boot parameters:
>>
>> I found the option that was causing the system not to boot (tested with 5.15.0 and latest linux-git as of 6 NOV 2021)
>> append="3w-sas.use_msi=1"
>>
>> 3w-sas.use_msi defaults to 0 (so now it is using IR-IO-APIC instead of MSI but now the machine boots using 5.15)
>> https://lwn.net/Articles/358679/
>>
>> Something between 5.14 and 5.15 changed regarding x86_64's handling of Message Signaled Interrupts.
>> ... which causes the kernel to no longer boot when 3w-sas.use_msi=1 is specified starting with 5.15.
> This only partially fixes the issues, trying to reboot also results in
> a hard lockup on cpu 1 (this is semi-reproducible)
> https://installkernel.tripod.com/5.15-reboot-lockup.jpg
>
> Back to 5.14.x for now...
>
>
>
> Justin.
