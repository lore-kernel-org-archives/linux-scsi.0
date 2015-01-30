From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCHv2 5/5] scsi: move scsi/sg.h to uapi/linux/sg.h
Date: Fri, 30 Jan 2015 10:07:17 -0800
Message-ID: <54CBC855.8090908@redhat.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com> <1422579397-18696-6-git-send-email-agrover@redhat.com> <54CBBF44.5060308@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbbA3SHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2015 13:07:31 -0500
In-Reply-To: <54CBBF44.5060308@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de, libc-alpha@sourceware.org, David Howells <dhowells@redhat.com>

On 01/30/2015 09:28 AM, Douglas Gilbert wrote:
> At the moment many user space programs in Linux access the SG_IO
> ioctl related declarations with:
>     #include <scsi/sg.h>
>
> I suspect that file is maintained by the glib folks (because it
> does not match the kernel file but is logically equivalent). Now
> if this change encourages those glib folks to break the above
> include (same applies to '#include <scsi/sg.h>') then that is
> a serious regression.

This is avoided by putting the new kernel-exported headers in linux/* 
instead of scsi/*. Then user programs could move to the new include over 
time, and the old glibc-provided one could be deprecated and eventually 
removed.

> So is this delayed regression likely to happen??

It shouldn't, given the different include path.

> Do we need to speak to the glib folks?

Yes for phase 2 (but CC'd) to get the glibc scsi/* headers deprecated 
and eventually removed, but phase 1 is the kernel exporting proper uapi 
headers, which have just gotten feedback for v2 and I'll be cranking out 
a v3 shortly.

> What is the appropriate include for a user space program to fetch
> sg.h in its new (proposed) location?

#include <linux/sg.h>

> For example my utilities currently use:
>     #include <linux/bsg.h>
> to fetch the bsg header but need some autotools magic to not break
> in the absence of that header (e.g. prior to around lk 2.6.30).

CCing dhowells; something similar would be needed for sg.h I imagine. To 
me it looks like scsi/{scsi, scsi_ioctl, sg}.h should maybe have been 
included in the scripted uapi changes (607ca46).

> Finally isn't the semi-flat nature of the uapi/linux directory
> asking for trouble? IOW why isn't there a uapi/linux/scsi
> directory?
>
>    # cd /usr/src/linux-3.19/include/uapi/linux/
>    # ls | wc
>      440     440    4350
>    # ls -p | grep "/" | wc
>       24      24     204
>
> The last command is counting directories (and really should
> be simpler than that).

I could see #include <linux/scsi/sg.h> as reasonable but I am just a 
worker bee on a quest to not have to define modern scsi opcodes in my 
userspace code.

Regards -- Andy
