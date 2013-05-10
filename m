From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 20:51:42 +0300
Message-ID: <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain>
 <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41231 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab3EJRwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 13:52:04 -0400
Received: by mail-ee0-f48.google.com with SMTP id c4so1841335eek.7
        for <linux-scsi@vger.kernel.org>; Fri, 10 May 2013 10:52:02 -0700 (PDT)
In-Reply-To: <1368194460.3319.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, michaelc <michaelc@cs.wisc.edu>

On Fri, May 10, 2013 at 5:01 PM, Ewan Milne <emilne@redhat.com> wrote:
> On Fri, 2013-05-10 at 16:22 +0300, Baruch Even wrote:
>> On Fri, May 10, 2013 at 3:43 PM, Ewan Milne <emilne@redhat.com> wrote:
>> >
>> > On Thu, 2013-05-09 at 23:11 -0400, Martin K. Petersen wrote:
>> > > Introduce eh_timeout which can be used for error handling purposes. This
>> > > was previously hardcoded to 10 seconds in the SCSI error handling
>> > > code. However, for some fast-fail scenarios it is necessary to be able
>> > > to tune this as it can take several iterations (bus device, target, bus,
>> > > controller) before we give up.
>> > >
>> > > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>> > >
>> >
>> > Thanks for posting this.  It will be very helpful to have this
>> > capability, particularly when alternate paths to the device exist.
>> >
>> > Acked-by: Ewan D. Milne <emilne@redhat.com>
>>
>>
>> I would argue that waiting for the eh to timeout before you switch to
>> another path is most likely to be wrong. If you did the first pass of
>> error recovery (task abort) and that failed the
>> path/hba/logical-device is doomed. If you will switch to another path
>> it will either work (meaning the path/hba were bad) or not (logical
>> device was the culprit).
>
> It is necessary to either know the disposition of a command or
> else wait for a defined amount of time before retrying the command on
> another path.  Otherwise you run the risk that the command will
> eventually complete on the first path.  So yes, we need to do the abort
> (and its timeout).
>
>>
>> Actually reducing the timeouts is probably not a good approach since
>> it will cause the host to take a more radical approach without waiting
>> sufficiently for a potential recovery. In addition the more radical
>> error handlings such as host reset will destroy other paths for
>> completely unrelated devices/links, from my experience a host reset is
>> usually not required and the Linux kernel currently reaches to this
>> big hammer too fast.
>
> I believe that Hannes is working on a better error handling algorithm
> that e.g. does not cause an emulated bus reset in an FC environment
> by resetting all the targets (and affecting I/O to unrelated targets in
> the process).

The error handling I have in mind (admittedly, not fully thought out)
should work for both FC and SAS. Currently the error recovery
progresses at the host level regardless of if the errors are on one
device or all of them, it also stops the IOs on all devices and LUNs.
It would be nice if that was taken into account. My ideas may be more
suitable to the environment I work in (enterprise storage devices
rather than hosts) but I believe the same approach would benefit the
hosts as well.

It would be interesting to see what approach the new error handling will take.

Baruch
