From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] BISECTED x86: avoid qword access in memcpy_*io
Date: Thu, 22 Jul 2010 10:23:11 +0900
Message-ID: <4C479D7F.2070204@jp.fujitsu.com>
References: <4C464BA0.20609@jp.fujitsu.com> <4C465FF0.1030407@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37533 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0GVBYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2010 21:24:16 -0400
In-Reply-To: <4C465FF0.1030407@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Brian Gerst <brgerst@gmail.com>

(2010/07/21 11:48), H. Peter Anvin wrote:
> On 07/20/2010 06:21 PM, Hidetoshi Seto wrote:
>> With v2.6.35-rc5, my x86-64 server doesn't boot but reports a
>> Completer Abort on lpfc card.
>>
>> The result of git-bisect is:
>>   6175ddf06b6172046a329e3abfd9c901a43efd2e is the first bad commit
>>   commit 6175ddf06b6172046a329e3abfd9c901a43efd2e
>>   Author: Brian Gerst <brgerst@gmail.com>
>>   Date:   Fri Feb 5 09:37:07 2010 -0500
>>     x86: Clean up mem*io functions.
>>
>> What I found are:
>>  - memcpy for 64bit uses movq if count >= 64 (arch/x86/lib/memcpy_64.S)
>>  - memcpy_toio and memcpy_fromio have changed to use this memcpy by
>>    the above commit.
>>  - my debug shows that lpfc calls memcpy_toio with not-qword-aligned
>>    addresses and count >= 64, e.g.:
>>      memcpy_toio(0xffffc900118de004, 0xffff88047293d614, 124);
>>    and it seems that it comes from:
>>    [drivers/scsi/lpfc/lpfc_sli.c]
>>     4929   /* First copy mbox command data to HBA SLIM, skip past first
>>     4930      word */
>>     4931   to_slim = phba->MBslimaddr + sizeof (uint32_t);
>>     4932   lpfc_memcpy_to_slim(to_slim, &mb->un.varWords[0],
>>     4933               MAILBOX_CMD_SIZE - sizeof (uint32_t));
>>
>> Still I'm not sure what is wrong in software or hardware, however
>> I suppose that qword access to iomem is not always safe, so it will
>> be OK to back to use __inline_memcpy which uses movsl.
>>
>> I confirmed that my server (w/ lpfc) boots with 35-rc5 + this patch.
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> A driver should not use the memcpy-like instructions if it isn't set up
> to act as memory (meaning it can handle arbitrary byte enables.)

So then is this a problem of lpfc driver?
James, could you agree on that?

> The function it should be using is called, fairly counterintuitively,
> __iowrite32_copy().  It really should be called memcpy_toio32() or
> something similar.
> 
> 	-hpa

It seems that lpfc already implemented lpfc_memcpy_{to,from}_slim()
as such memcpy_*io32, but limited use of it to on big endian platforms
only.  Now lpfc can move to use it always, right?


Thanks,
H.Seto

