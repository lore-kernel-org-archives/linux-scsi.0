Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEF2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 20:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC2660E52
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 20:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhKAUFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 16:05:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229560AbhKAUFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 16:05:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A1IoOAh024787;
        Mon, 1 Nov 2021 20:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zRo0tUQGtqn8fNaVASvh3k1LNjPoCBMwFk2uomdSQpo=;
 b=ZcnqigQTepVdHp6ccn02aK1/d3w5Ihr6uIFwXbdoLwlzrZ1ddnnZqb36BL141fQITQso
 o8F1JQ9Izhbc+Y03j9GDmfjingsKyM7GI2Cjn8xVrQjczUDoGA2z7SkDW71homVMoea3
 zvqWP1pfhm2NLKo8R9Yk3lAvKjoDhj2eWG+YDAvYxtaBBG7nq6+R8Z/maVHkXJWgVDyM
 mrMxosXLWfaFsig2Er0hbTzefd1I4l3PVvwlY1b4TvwT4WU2Aj2164YAw6ahmAPOCqA7
 PWxG0UWiNhSp9cvrfD5lGglDkgnH0xqWz7ShouglLujP8G8HzbX5yxp8hFjR8GFYpDPa oA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c2k4qvx85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Nov 2021 20:03:07 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A1JvnDE032404;
        Mon, 1 Nov 2021 20:03:06 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3c0wpbcw95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Nov 2021 20:03:06 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A1K34rV9240948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Nov 2021 20:03:04 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A76FCBE04F;
        Mon,  1 Nov 2021 20:03:04 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F0DABE056;
        Mon,  1 Nov 2021 20:03:03 +0000 (GMT)
Received: from [9.65.87.47] (unknown [9.65.87.47])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  1 Nov 2021 20:03:03 +0000 (GMT)
Message-ID: <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com>
Date:   Mon, 1 Nov 2021 15:03:03 -0500
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
From:   Douglas Miller <dougmill@linux.vnet.ibm.com>
In-Reply-To: <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iCQ58pUETFfq9vr72VW8v5kExRmF9EOp
X-Proofpoint-GUID: iCQ58pUETFfq9vr72VW8v5kExRmF9EOp
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-01_07,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 phishscore=0 bulkscore=0 clxscore=1011 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111010107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I have seen a problem, with a different adapter and arch but similar 
symptoms, where 5.14 worked and 5.15 did not. That was tracked down to a 
difference in IRQ domain handling between the two kernels, resulting in 
an IRQ essentially not working anymore. The fix was arch-specific and 
not x86_64, but might be of interest:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5a4b0320783a

On 11/1/21 14:48, Justin Piszcz wrote:
> On Mon, Nov 1, 2021 at 6:36 AM Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> On Sun, Oct 31, 2021 at 7:52 PM Bart Van Assche <bvanassche@acm.org> wrote:
>>> On 10/31/21 16:19, Justin Piszcz wrote:
>>>> Diff between 5.14 and 5.15 .config files-- could it be something to do with
>>>> CONFIG_IOMMU_DEFAULT_DMA_LAZY=y?
>>> That's hard to say. Is CONFIG_MAGIC_SYSRQ enabled? If not, please enable
>>> it and hit Alt-Printscreen-t (dump task list; see also
>>> Documentation/admin-guide/sysrq.rst) and share the contents of the
>>> kernel log. If that would not be convenient, please try to bisect this
>>> issue.
>> [ .. ]
>>
>> It appears at this point in the boot process the keyboard (USB and
>> PS2) are not yet available and/or do not respond in this scenario (I
>> do have CONFIG_MAGIC_SYSRQ enabled+have used it in the past).  I'll
>> build the prior 5.15-rc(1-7) to check where it stopped working and
>> reply back to the list when I have that info.
> [..]
>
> I have tried all of the -rc's and they all hang at boot, keyboard
> input (USB/PS2) is not working at this stage in the boot process.
> Are there any thoughts on how to debug this further?
>
> [9.305954] 3u-sas: scsi0: Found an LSI 3ware 9750-2414e Controller at
> Oxfb760000, IRQ: 45.
> [9.6179701 3u-sas: scsi0: Firmware FH9X 5.12.00.016, BIOS BE9X
> 5.11.00.007, Phys: 28.
> [30.498007] scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12)
> timed out, resetting card
> [71.4419581 scsi 0:0:0:0: WARNING: (0x06: 0x002C): Command (0x0) timed
> out, resetting card.
>
> # lilo
> Added 5.14.8-1
> Added 5.15.0-1 - hangs with the error above
> Added 5.15.0-rc1-1 - hangs with the error above
> Added 5.15.0-rc2-1 - hangs with the error above
> Added 5.15.0-rc3-1 - hangs with the error above
> Added 5.15.0-rc4-1 - hangs with the error above
> Added 5.15.0-rc5-1 - hangs with the error above
> Added 5.15.0-rc6-1 - hangs with the error above
> Added 5.15.0-rc7-1 *  - hangs with the error above
>
> Regards,
>
> Justin.
