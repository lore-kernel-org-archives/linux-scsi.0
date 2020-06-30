Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F50C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 17:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DA8120772
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 17:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="j9clD1g5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387761AbgF3RRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:17:33 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:55901 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390153AbgF3RRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 13:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593537447; i=@ts.fujitsu.com;
        bh=HFWA5kriCy33CKu0gYuoNKwZm2HEN9r/kckXl9RH9Vw=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=j9clD1g5hKoVK4nI5ME8Cf+98LvUfZJKKNS+s3Gxr/B0ec2THoN65xEd+pbrGVQDR
         mIeCQPh8GimJb1Vh/pe/KQxwSPUP7SsjdFLk8jw3iEEqRa9zWRf1SyrL39XZRo7xAM
         jVoIsBmvp8/RH77gfHT84PXDLCvjvoqeEgGdIuT+4T7+ieI02RnD4sgZjQuC8pe+E4
         kG6TY+4VfkT0ZyMA9a2oUt0XqGuRbuzvFqVZ0g3Tl0Mur/oSyZ7Ybs02PagUH8tPKY
         65CCqFzonkiNdus7BLk8elTclc/5PaAvHIRtwy6M1GEq9iUHZLha8lOieZkoUfOAbc
         m6gXjrubUzw3g==
Received: from [100.112.192.163] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id 45/33-15509-7A37BFE5; Tue, 30 Jun 2020 17:17:27 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRWlGSWpSXmKPExsViZ8MRoru8+He
  cwdoXTBYb+zksuq/vYLNYfvwfk8XfSTdYLVqXvmVyYPWYNukUm8fHp7dYPD5vkgtgjmLNzEvK
  r0hgzfjxaCNLwULNitMNjYwNjJ2KXYxcHEICkxklTt06zwrh9DNKzOq/AeRwcggL+Els2/yQG
  SQhIvCWUWLbwm6whJBAkcTpo9PAbDYBA4kVk+6zgNi8Ao4SZ89NAouzCKhK/J95grGLkYNDVC
  Bc4tkKf4gSQYmTM5+AlXMK2Ei0PJjEDGIzC6hL/Jl3CcoWl7j1ZD4ThC0vsf3tHOYJjHyzkLT
  PQtIyC0nLLCQtCxhZVjFaJBVlpmeU5CZm5ugaGhjoGhoa6RpamuoaGZrqJVbpJuqlluqWpxaX
  6BrqJZYX6xVX5ibnpOjlpZZsYgQGeErB4es7GG+9/qB3iFGSg0lJlPdy0u84Ib6k/JTKjMTij
  Pii0pzU4kOMMhwcShK8fwuAcoJFqempFWmZOcBog0lLcPAoifCKFwGleYsLEnOLM9MhUqcYFa
  XEeRVAEgIgiYzSPLg2WIRfYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTMywEyhSczrwRu+iu
  gxUxAi69p/QJZXJKIkJJqYOLRelO7Q5ipJnDTXb0fFkZ2t5aeMpGoWBYpcPnmtqOTPL6k5K3+
  yn8qusLC5seeyGaFnPTGfBkR2/qzb12v5r64Mit58j93H+bDUSxPlY88Zvyf8GiO0Kf3PNNyH
  bi2WwjtkQ2SkWJ5bW2h7atdmiJym02f9ef56fOvMS7gXt//+9qtD3UCdwp01939JDNjnePWrx
  /5t3LNEdp1ytvU9f23xpgFga52neaqSaf2zNS6GVBcfCR3L5v3uvM2qjZ/D9Zlsjcu7learFX
  nwDU19gDLnT2N4nv/twonN13uslB4dnT1yqm6KyKmiMwXOff01nrGRqFu5qkf356/uSpI9uyE
  2/M9V6+U/6C9RyLibKESS3FGoqEWc1FxIgD0I/KuawMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-10.tower-271.messagelabs.com!1593537446!898415!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30355 invoked from network); 30 Jun 2020 17:17:26 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-10.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 17:17:26 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UHHKFP008127;
        Tue, 30 Jun 2020 18:17:20 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 36E7820251;
        Tue, 30 Jun 2020 19:17:12 +0200 (CEST)
Subject: Re: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit kernel
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
 <1593535964.4124.2.camel@HansenPartnership.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <2cc4fd9e-e96d-725b-c047-4bd26af604a6@ts.fujitsu.com>
Date:   Tue, 30 Jun 2020 19:17:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593535964.4124.2.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-30 18:52, James Bottomley wrote:
> On Tue, 2020-06-30 at 18:49 +0200, Bodo Stroesser wrote:
>> Hi,
>>
>> When using tcmu it might happen, that userspace application cannot be
>> built as 64 bit program even on a 64 bit host due to existing 32 bit
>> libraries that must be used, e.g. for compression, encryption,
>> deduplication, ...
>>
>> Currently this only works with manual changes in userspace include
>> file target_core_user.h due to a missing padding field in
>> struct tcmu_cmd_entry.
>>
>> Here are field offsets printed by a small program on a 64 bit host,
>> compiled as 64 bit program and as 32 bit:
>>
>> Devel:~ # gcc -o print_offsets print_offsets.c
>> Devel:~ # ./print_offsets
>> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
>> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
>> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
>> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
>>
>> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
>> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
>> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
>> Offset of tcmu_cmd_entry.req.cdb_off         = 0018
>> Offset of tcmu_cmd_entry.req.iov[0]          = 0030
>>
>> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
>> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
>> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
>>
>> Size of struct tcmu_cmd_entry = 0070
>>
>>
>> Devel:~ # gcc -m32 -o print_offsets print_offsets.c
>> Devel:~ # ./print_offsets
>> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
>> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
>> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
>> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
>>
>> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
>> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
>> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
>> Offset of tcmu_cmd_entry.req.cdb_off         = 0014
>> Offset of tcmu_cmd_entry.req.iov[0]          = 002c
>>
>> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
>> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
>> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
>>
>> Size of struct tcmu_cmd_entry = 0070
>>
>>
>> The offset of the fields req.cdb_off and req.iov differ for 64-bit
>> and 32-bit compilation.
>>
>> That means:
>>   - 64-bit application on 64-bit host works well
>>   - 32-bit application on 32-bit host works well
>>   - 32-bit application on 64-bit host fails.
>>
>> Unfortunately I don't see a way to fix this problem such, that
>> 32-bit application runs fine on 32-bit and 64-bit host without
>> breaking compatibility.
>>
>> So I'm wondering whether the following change would be a viable
>> solution:
>>
>> diff --git a/include/uapi/linux/target_core_user.h
>> b/include/uapi/linux/target_core_user.h
>> --- a/include/uapi/linux/target_core_user.h
>> +++ b/include/uapi/linux/target_core_user.h
>> @@ -114,6 +114,9 @@ struct tcmu_cmd_entry {
>>   			__u32 iov_cnt;
>>   			__u32 iov_bidi_cnt;
>>   			__u32 iov_dif_cnt;
>> +#ifdef APPL32BIT_ON_KERNEL64BIT
>> +			__u32 __pad9;
>> +#endif
>>   			__u64 cdb_off;
>>   			__u64 __pad1;
>>   			__u64 __pad2;
>>
>>
>> Using this change we can do:
>>
>> Devel:~ # gcc -m32 -DAPPL32BIT_ON_KERNEL64BIT -o print_offsets
>> print_offsets.c
>> Devel:~ # ./print_offsets
>> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
>> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
>> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
>> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
>>
>> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
>> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
>> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
>> Offset of tcmu_cmd_entry.req.cdb_off         = 0018
>> Offset of tcmu_cmd_entry.req.iov[0]          = 0030
>>
>> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
>> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
>> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
>>
>> Size of struct tcmu_cmd_entry = 0070
>>
>>
>> So we can compile a 32-bit application that works on 64-bit kernel
>> without need to manipulate the include file prepared by the kernel.
>>
>> What do you think? Do you know a better solution?
> 
> Can you not use something similar to the compat_ioctl mechanism?  the
> job of the compat layer is to re-layout the input and output structures
> to impedance match between 32 and 64 bit.
> 
> James
> 

struct tcmu_cmd_entry is prepared by kernel and exposed to userspace via
an mmap()ed uio device. From tcmu module point of view it is vmalloc
area.

So there is no 'glue' code that could do conversion.

I'm not sure whether there is a way for tcmu to find out, what kind of
userspace application is running. If it would know, it probably could
prepare the entries accordingly.

But worst case it could happen that entries prepared for 32-bit, after
application stop and start, then are read by a new application version
that is 64-bit ...

Maybe we could add an configFS attribute allowing userspace to configure
tcmu accordingly. A change of this attribute could also flush existing
tcmu_cmd_entries. But that would mean that userspace application has to
take care.

Isn't the compiler definition easier to use?

Bodo
