From: Andy Grover <agrover@redhat.com>
Subject: Re: old linux scsi headers
Date: Tue, 27 Jan 2015 11:42:32 -0800
Message-ID: <54C7EA28.5090204@redhat.com>
References: <54B0122A.9050509@redhat.com> <20150110101012.GA27454@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbbA0Tml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 14:42:41 -0500
In-Reply-To: <20150110101012.GA27454@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: libc-alpha@sourceware.org, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

On 01/10/2015 02:10 AM, Christoph Hellwig wrote:
> On Fri, Jan 09, 2015 at 09:38:50AM -0800, Andy Grover wrote:
>> Hello glibc people,
>>
>> This concerns sysdeps/unix/sysv/linux/scsi/{scsi, scsi_ioctl, sg}.h
>>
>> They define common SCSI values, as well as Linux's SCSI-related ioctls.
>>
>> Apparently they were copied from the Linux kernel tree back in 1999, so
>> they're pretty stale.
>>
>> I'm wondering if I should submit a patch to update these to what's current
>> from the Linux tree, or if maybe it wouldn't be better to have users just
>> directly get these as "uapi" headers from the Linux kernel source directly?
>>
>> The latter method has issues with being a breaking change for code that
>> relies on what's in glibc now, which may or may not be something we can
>> ease, but would ensure the headers would not become stale again in the
>> future.
>>
>> What do you think about the best way to proceed?
>
> FYI, I'd like to repeat my propsal from the scsi list here, and a
> few alternatives:
>
> (1) separate namespaces (my proposal):
>
>   - we add uapi linux/scsi_ioctl.h and linux/sg.h files that just
>     add the ioctl defintions and data structures required for them.
>   - because they are linux/ instead of scsi/ are not required to keep
>     things like the old opcode or SCSI-2 defintions, which glibc
>     can keep in the scsi/* wrappers, and hopefully slowly deprecate
>     over the long run

Fine by me. This lets the kernel publish up-to-date headers, and lets 
glibc handle the old headers at its own pace.

I'll post a patch shortly.

Regards -- Andy

>
> (2) just export what we have in the kernel now (Andys patch):
>
>   - add uapi scsi/scsi.h and scsi/scsi_ioctl.h (and scsi/sg.h for v2),
>     exporting what we have in them right now, which might be a little
>     different from glibc
>   - remove glibcs scsi/*.h
>
> (2a)
>
>   - like 2, but only export the ioctls APIs, the other constants
>     will go away at this point
>
> (2b)
>
>   - like 2a, but also add defines compatible to glibc under
>     #ifndef __KERNEL__ to the uapi headers.
>

