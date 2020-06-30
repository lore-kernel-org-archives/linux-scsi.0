Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07072C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 18:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEAE920768
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 18:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="tC66ocRB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390549AbgF3SBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:01:23 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:48345 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388845AbgF3SBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 14:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593540078; i=@ts.fujitsu.com;
        bh=MkC8nFP94Vc4I7A8NkJ2DTj1UAGsIbLVUmiwY+8XuxE=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=tC66ocRBKfulKfg65WxtsFHd5FZCoFpa9PrjZkbH7A0mdY/fuhkjgJ7sfjKJXyxGv
         7Gy1WRIjKMNuBuyQ1VdBfzDKsEJXtRXMr0eoiTTWuYrt6H9NM+Se1kNgAf5jdVP48A
         DccjBFvyPtgs9vqT7Pm8Tcd7jSiUk+MAzQZUVY7aFSSlFCsNU/3HkQfejAQ8W10Noh
         02QRZb1vg5Jd6JaxqLjRQ/QCvYwfA8QMjBcDUaf1+gQY50D+oGJ1AjaKugZJqYxcX5
         Yk+R9rXl75nkJkrX9Z1bCti4I9XtvdrPQwAS5zb1qpc6Eq6OcBAxNz5Egly8hLN1mK
         vvUlJSC6BQSDw==
Received: from [100.113.1.118] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id 96/20-07993-EED7BFE5; Tue, 30 Jun 2020 18:01:18 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRWlGSWpSXmKPExsViZ8MRqvuu9ne
  cwZxt/BYb+zksuq/vYLNYfvwfk8XfSTdYLVqXvmVyYPWYNukUm8fHp7dYPD5vkgtgjmLNzEvK
  r0hgzZiy5Dl7wRL+ir6ZGg2MO3i6GLk4hAQmM0o8eH+eGcLpZ5T4fGYSSxcjJ4ewgJ/Ets0Pw
  RIiAm8ZJbYt7GaFqLoFVDXvPCNIFZuAgcSKSffBOngFHCVWnZrEDGKzCKhKLHw3E8jm4BAVCJ
  d4tsIfokRQ4uTMJ2DlnAI2ElePNTGB2MwCZhLzwJaB2OISt57Mh4rLS2x/O4d5AiPfLCTts5C
  0zELSMgtJywJGllWMlklFmekZJbmJmTm6hgYGuoaGxrpA0thAL7FKN1EvtVQ3OTWvpCgRKKuX
  WF6sV1yZm5yTopeXWrKJERjiKYUMTTsY3736oHeIUZKDSUmU90/17zghvqT8lMqMxOKM+KLSn
  NTiQ4wyHBxKEryuwKgREixKTU+tSMvMAcYbTFqCg0dJhHdlDVCat7ggMbc4Mx0idYpRUUqcdz
  dIQgAkkVGaB9cGi/FLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYR5u0Gm8GTmlcBNfwW0mAl
  o8TWtXyCLSxIRUlINTBXyv66Vd50SqFvsZPv5hrJOP9cur0zN+bLCJl9+lEY8Mn0RUuIb+Dp8
  XtDTGB+HyqkxzhKRf7tTNv92Uj6pXMvvfmyPcYx/Z7pOfZdawqveQweCzzanTAu9vmKpuWjB1
  XtiIQfM3mTx1NtVs9hu3tJ7cHLGCvmrXQvtb/5KuDLvR47A9xMiDc1X/HZzfp49ezdL/YKI9m
  CtPXOqc6P3F9XpbV8U4GRfl6Zn3WXDJHJMuEkmRmHejps7Z9VceBj0jo95p6trffBNzaWCmp/
  Ukx85a7D82f45oFjM/vImXs9+dsEQgRNz/3j5zFNU+XRiiVDTVWHPn/nf86/fPb9iqsXNS1I2
  H3ZmK9t3G1xTYinOSDTUYi4qTgQAC2MNt2wDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-8.tower-226.messagelabs.com!1593540077!967431!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 32236 invoked from network); 30 Jun 2020 18:01:18 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-8.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 18:01:18 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UI1DOZ003093;
        Tue, 30 Jun 2020 19:01:13 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 55F5420251;
        Tue, 30 Jun 2020 20:01:03 +0200 (CEST)
Subject: Re: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit kernel
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
 <1593535964.4124.2.camel@HansenPartnership.com>
 <2cc4fd9e-e96d-725b-c047-4bd26af604a6@ts.fujitsu.com>
 <1593538071.4124.7.camel@HansenPartnership.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <b1452aaf-d5f2-3342-a723-b2cc788ed4b0@ts.fujitsu.com>
Date:   Tue, 30 Jun 2020 20:00:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593538071.4124.7.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020-06-30 19:27, James Bottomley wrote:
> On Tue, 2020-06-30 at 19:17 +0200, Bodo Stroesser wrote:
>> On 2020-06-30 18:52, James Bottomley wrote:
>>> On Tue, 2020-06-30 at 18:49 +0200, Bodo Stroesser wrote:
> [...]
>>>> So we can compile a 32-bit application that works on 64-bit
>>>> kernel without need to manipulate the include file prepared by
>>>> the kernel.
>>>>
>>>> What do you think? Do you know a better solution?
>>>
>>> Can you not use something similar to the compat_ioctl
>>> mechanism?  the job of the compat layer is to re-layout the input
>>> and output structures to impedance match between 32 and 64 bit.
>>>
>>> James
>>>
>>
>> struct tcmu_cmd_entry is prepared by kernel and exposed to userspace
>> via an mmap()ed uio device. From tcmu module point of view it is
>> vmalloc area.
>>
>> So there is no 'glue' code that could do conversion.
> 
> OK, so can't you do it like a vdso then?  For them we detect on mmap
> what the architectural model is and map different areas depending on
> that, so effectively you have a 64 and a 32 bit layout area and which
> one you map depends on the architecture type you see coming into the
> setup call.  You expect only one to be mapped and you only do extra
> conversions on the impedance mismatch case.

I think, vdso and tcmu's uio mmaps are different in vdso AFAIK being
constant code while the uio mmap contains data (e.g. tcmu_cmd_entries) 
that is written and read by tcmu module and userspace. So kernel needs 
to know what format of entries userspace expects.
Additionally, the data is preserved over close and re-open of the uio
device and mapping. So it would be necessary to re-format data existing
in a ring buffer according to the appl arch. I don't like this idea.
But alternatively on architecture change we could flush the ring buffer.

Hmm. tcmu is called during mmap() for the uio-device. If we can
determine the appl arch at that time, it would work. Let me check.

Bodo
