From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: sd: Resize-fsync() race fails IO
Date: Thu, 24 Mar 2016 10:46:08 +0100
Message-ID: <56F3B760.2060309@profitbricks.com>
References: <56EBEFAA.9040501@profitbricks.com>
 <56F011BE.9030403@profitbricks.com> <56F20A8C.4010202@vlnb.net>
 <56F25C8F.9040801@profitbricks.com> <56F368EA.1010607@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35398 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbcCXJqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2016 05:46:10 -0400
Received: by mail-wm0-f42.google.com with SMTP id l68so229259650wml.0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2016 02:46:09 -0700 (PDT)
In-Reply-To: <56F368EA.1010607@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Scst-devel <Scst-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On 24.03.2016 05:11, Vladislav Bolkhovitin wrote:
[snip]
>>>> +CC: linux-scsi, hch
>>>>
>>>> Hi SCSI developers,
>>>>
>>>> I've debugged this further with a v4.5 kernel and full SCSI command
>>>> logging enabled on the initiator side. It seems to be a SCSI issue. SCSI
>>>> commands succeed but result 8000002 is reported to the upper driver
>>>> which seems to fail IO.
>>>>
>>>> What does result 8000002 mean?
>>>
>>> It is driver_byte() DID_RESET and status_byte() CHECK_CONDITION (see the corresponding
>>> kernel's functions). It sounds like you have timeouts and resets somewhere.
>>
>> Thanks for the hint! But it is definitely not DID_RESET. It is
>> DRIVER_SENSE and CHECK_CONDITION then. The host byte is DID_OK.
>>
>> If Unit Attention and "Capacity data has changed" is part of a read or a
>> write, then the result is the same but this is handled correctly and IO
>> is not failed. But with a zero bytes fsync()/flush resulting in
>> SYNCHRONIZE_CACHE_16, it fails IO as the sd driver doesn't handle this
>> correctly it seems.
> 
> I'm not sure, what is not handled correctly? Zero length SYNCHRONIZE_CACHE is perfectly
> legal, and vdisk_fsync() should never see data_len 0.

The issue is located in the SCSI stack. I think the problem is located
in the sd driver. It can't handle zero length SYNCHRONIZE_CACHE together
with UA and "Capacity data changed". The race exists to which SCSI
command UA is put to.

> There should be no race around virt_dev->file_size, because assignments to 64-bit
> integers are atomic, the compiler supposed to align it to 64-bit boundaries and it's
> never assigned to any invalid value. At worst, accesses to it should be covered by
> ACCESS_ONCE(), but I'm not sure it is really needed, so would prefer to keep it away
> from the fast path. Although, probably, vdisk_synchronize_cache() is not too fast path.

SCST is fine. I couldn't break it with my tests. It succeeds the
commands but the sd driver fails IO because of the sense data.

So discussion should be moved to the linux-scsi list again.
I've changed the prefix in the subject from "scst_vdisk" to "sd".

[snip]

