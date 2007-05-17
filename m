From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 22:43:06 +0530
Message-ID: <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
References: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
	 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	 <20070516025121.GK10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:39182 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXEQRNK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 13:13:10 -0400
Received: by wr-out-0506.google.com with SMTP id 76so690827wra
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2007 10:13:07 -0700 (PDT)
In-Reply-To: <20070516025121.GK10562@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

Hi Matthew,

On 5/16/07, Matthew Wilcox <matthew@wil.cx> wrote:
> [...]
> > /sys/module/scsi_mod/parameters/wait_for_async_scans (?)
> > Doesn't really matter, but perhaps who created the sysfs namespace
> > for scsi in /sys/module/scsi_mod/... could be the best person to suggest.
>
> No, it does matter.  Your suggestion doesn't work, because
> /sys/module/scsi_mod/parameters/ belongs to the module code.  To create
> a new attribute there, you use the module_param() code -- and there's
> no way to have code called when your parameter is changed.

Ok, thanks for pointing out that /sys/module/scsi_mod/parameters/wait...
is _wrong_. Could you suggest something that would be _right_?

> > OK, I'll get really silly here myself. I don't want even that half a second
> > of
> > overhead when that module is being _built_ (during make modules), not
> > the overhead of copying / installing at modules_install time.
>
> You're claiming that 0.7 second (I just timed it on a 3 year old
> laptop) *inconveniences* you?

...

On 5/16/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
OK, I'll get really silly here myself. ...

...

On 5/16/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
It's not _inconvenient_. Just that writing/building a module for accomplishing
something like that ... is just not _right_.

...

On 5/16/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
static int __init wait_scan_init(void)
{
        scsi_complete_async_scans();
        return 0;
/* BTW this could've been return scsi_complete_async_scans();
 * I see scsi_complete_async_scans() never fails, but still. */
}
late_initcall(wait_scan_init);
... does _not_ deserve to be a module, and writing/building a module
for something like this (just to run a function in some kernel subsytem)
does not seem to be the proper way to solve the problem either.

...

> This whole thing is such a tempest in a teapot.  I really don't
> understand why you care so much.

You're almost right here. But IMHO this is simply a case of
doing something in some kernel subsystem in a proper/better
way than it is being done presently.

Anyway, like I said on another thread, discussions here tend to be
most productive only over code, so I'll try and make a patch to do
this some other way.

Thanks,
Satyam
