From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 20:55:35 +0300
Message-ID: <CAC9+anLYv5RvwLDuQ-Dxg87Ojx3vshmyuJJ0jDNQjE7-CSMS3A@mail.gmail.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain>
 <CAC9+anJ9Y-SnCOK6EOCavTNJwx=xhAbL_X__MsEsL7DroawaJg@mail.gmail.com> <yq1k3n6dgy2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48455 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3EJRz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 13:55:56 -0400
Received: by mail-ea0-f176.google.com with SMTP id h14so2420032eak.21
        for <linux-scsi@vger.kernel.org>; Fri, 10 May 2013 10:55:55 -0700 (PDT)
In-Reply-To: <yq1k3n6dgy2.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: emilne <emilne@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, michaelc <michaelc@cs.wisc.edu>

On Fri, May 10, 2013 at 5:53 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Baruch" == Baruch Even <baruch@ev-en.org> writes:
>
> Baruch> Actually reducing the timeouts is probably not a good approach
> Baruch> since it will cause the host to take a more radical approach
> Baruch> without waiting sufficiently for a potential recovery.
>
> Reducing the eh timeout is a requirement in many clustered setups. We've
> been shipping a predecessor to this patch in our kernels for a long
> time.

> Baruch> In addition the more radical error handlings such as host reset
> Baruch> will destroy other paths for completely unrelated devices/links,
> Baruch> from my experience a host reset is usually not required and the
> Baruch> Linux kernel currently reaches to this big hammer too fast.
>
> I'm also working on a patch to add some heuristics to avoid the HBA and
> bus resets if I/O is completing successfully on other attached
> targets. But that's an orthogonal issue.

Why?

In my experience (again, SAS based inside a storage device) the
reduced eh timeout is more likely to cause escalated problems rather
than resolve the issue.

I actually find that the higher level should have a small timeout of
its own to do its own recovery work, which normally entails going to
other copies of the data where available and let the device try to get
the IO done if possible. Not sure how applicable it is to the kernel
itself but I do feel it could be relevant.

Baruch
