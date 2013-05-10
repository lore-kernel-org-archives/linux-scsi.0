From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 16:22:19 +0300
Message-ID: <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:47655 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3EJNWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 09:22:40 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so2272454ead.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 May 2013 06:22:39 -0700 (PDT)
In-Reply-To: <1368189791.3319.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne <emilne@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, michaelc <michaelc@cs.wisc.edu>

On Fri, May 10, 2013 at 3:43 PM, Ewan Milne <emilne@redhat.com> wrote:
>
> On Thu, 2013-05-09 at 23:11 -0400, Martin K. Petersen wrote:
> > Introduce eh_timeout which can be used for error handling purposes. This
> > was previously hardcoded to 10 seconds in the SCSI error handling
> > code. However, for some fast-fail scenarios it is necessary to be able
> > to tune this as it can take several iterations (bus device, target, bus,
> > controller) before we give up.
> >
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> >
>
> Thanks for posting this.  It will be very helpful to have this
> capability, particularly when alternate paths to the device exist.
>
> Acked-by: Ewan D. Milne <emilne@redhat.com>


I would argue that waiting for the eh to timeout before you switch to
another path is most likely to be wrong. If you did the first pass of
error recovery (task abort) and that failed the
path/hba/logical-device is doomed. If you will switch to another path
it will either work (meaning the path/hba were bad) or not (logical
device was the culprit).

Actually reducing the timeouts is probably not a good approach since
it will cause the host to take a more radical approach without waiting
sufficiently for a potential recovery. In addition the more radical
error handlings such as host reset will destroy other paths for
completely unrelated devices/links, from my experience a host reset is
usually not required and the Linux kernel currently reaches to this
big hammer too fast.

Not that I have any qualms about the patch itself, I've been down this
path myself and was proven wrong by real life. Though my experience
was mostly on the SAS network rather than the FC network.

Baruch
