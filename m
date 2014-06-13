From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Fri, 13 Jun 2014 11:43:18 -0700
Message-ID: <CAHdzE-9VmcKw2bFs7JSripx57BUfSEqcSR0xOmDZnVbn3HXKKA@mail.gmail.com>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
	<539B44F7.6050803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63732 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaFMSnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2014 14:43:19 -0400
Received: by mail-ie0-f169.google.com with SMTP id at1so2851410iec.14
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2014 11:43:19 -0700 (PDT)
In-Reply-To: <539B44F7.6050803@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: hch@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Fri, Jun 13, 2014 at 11:37 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 06/13/2014 07:58 PM, Venkatesh Srinivas wrote:
>>
>> Hi,
>>
>> In Linux 3.14+, SCSI timeouts are handled first without invoking EH;
>> this behavior is on by default but can be disabled with the
>> per-shost-template no_async_abort flag.
>>
>> When a SCSI target is attached to a virtio-scsi HBA and is under I/O
>> stress (lots of concurrent I/O + some I/O running slowly), we see
>> Linux issue commands with duplicate tags, sometimes with tags matching
>> commands which are in the process of being aborted; we see this
>> readily in the Google Compute Engine hypervisor.
>>
>> This behaviour is not seen on Linux <= 3.13 and is not seen if 3.14's
>> virtio_scsi driver has no_async_abort set to 1.
>>
>> An ordering we have seen, from the device perspective:
>> t0: I/O with tag 18446612135224154432 issued
>> t1: TMF Abort for tag 18446612135224154432
>> t2: Another I/O with the same tag, 18446612135224154432, issued; same
>> offset/size as at t0
>> [neither the t0 I/O nor the TMF ABORT have yet returned!]
>>
>> Another ordering we have seen, from the device perspective:
>> t0: I/O with tag 18446612135454768576 issued
>> t1: TMF ABORT for tag 18446612135454768576
>> t2: I/O 18446612135454768576 completes with appropriate cancelled status
>> t3: TMF ABORT completes with OK status
>> t4: New I/O with tag 18446612135454768576, matching size/offset as t0
>> t5...: [Some other I/Os issued to the same SCSI target]
>> t6...: [TMF ABORT for one of the new I/Os; proper return sequence]
>> t7...: New I/O with tag 18446612135454768576.
>>    [Tag 18446612135454768576 has neither completed nor has it been
>> aborted by Linux.]
>>
>> CC-ing stable as 3.14 and 3.15 are affected; a conservative fix is to
>> enable no_async_abort until the problem is better-understood.
>>
> Paolo, you had some fixes for virtio_scsi which should solve this, right?

The outstanding patches for virtio_scsi would not explain this bug,
its dependence on Linux 3.14+, or that it does not repro with
no_async_abort=1.

Thanks,
-- vs;
