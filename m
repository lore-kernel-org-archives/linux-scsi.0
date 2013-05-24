From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization of
 the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 17:02:50 +0900
Message-ID: <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
References: <20130522134134.GA15189@mtj.dyndns.org>
	<519CD234.40608@redhat.com>
	<20130522143019.GA18541@mtj.dyndns.org>
	<519CDDA4.2050100@redhat.com>
	<20130522193009.GA23845@mtj.dyndns.org>
	<519D360D.4050309@redhat.com>
	<20130522221737.GA12339@mtj.dyndns.org>
	<519DC926.4000106@redhat.com>
	<20130523090222.GA26592@mtj.dyndns.org>
	<519DE5AD.7080303@redhat.com>
	<20130524014405.GB16882@mtj.dyndns.org>
	<519F12FF.6090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:32973 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907Ab3EXICv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 May 2013 04:02:51 -0400
In-Reply-To: <519F12FF.6090809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 24, 2013 at 4:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> The same filtering table being applied to different classes of
>> hardware is a software bug, but my point is that the practive
>> essentially entrusts non-insignificant part of security enforcement to
>> the hardware itself.  The variety of hardware in question is very wide
>> and significant portion has historically been known to be flaky.
>
> Unproven theory, and contradicted by actual practice.  Bugs are more
> common in the handling of borderline conditions, not in the handling of
> unimplemented commands.
>
> If you want to be secure aginst buggy firmware, the commands you have to
> block are READ and WRITE.  Check out the list of existing USB quirks.

Well, I'd actually much prefer disabling CDB whitelisting for all !MMC
devices if at all possible. You're basically arguing that because what
we have is already broken, it should be okay to break it further.
Also, RW commands having more quirks doesn't necessarily indicate that
they tend to be more broken. They just get hammered on a lot in
various ways so problems on those commands tend to be more noticeable.

> You need to allow more commands.
> The count-me-out knob allows all commands.
> You cannot always allow all commands.
> Ergo, you cannot always use the count-me-out knob.

The thing is that both approaches aren't perfect here so you can make
similar type of argument from the other side. If the system wants to
give out raw hardware access to VMs, requiring it to delegate the
device fully could be reasonable. Not ideal but widening direct
command access by default is pretty nasty too.

--
tejun
