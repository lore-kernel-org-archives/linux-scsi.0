From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Tue, 7 Apr 2009 22:15:31 -0700
Message-ID: <ac3eb2510904072215g268956f7i44bd3005be64632@mail.gmail.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	<20090318013621.26548.10529.sendpatchset@chandra-ubuntu> <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	<1237403902.14147.25.camel@chandra-ubuntu> <1237488880.26341.15.camel@chandra-ubuntu>
	<49C3DF49.8050408@redhat.com> <1237846429.14853.6.camel@chandra-ubuntu>
	<1238798590.20924.0.camel@chandra-ubuntu> <20090407232233.GE24591@pentland.suse.de>
	<1239148215.14988.22.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46782 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZDHFPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 01:15:48 -0400
Received: by fxm2 with SMTP id 2so2616604fxm.37
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2009 22:15:46 -0700 (PDT)
In-Reply-To: <1239148215.14988.22.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

On Tue, Apr 7, 2009 at 16:50, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> On Wed, 2009-04-08 at 01:22 +0200, Hannes Reinecke wrote:
>> On Fri, Apr 03, 2009 at 03:43:10PM -0700, Chandra Seetharaman wrote:

>> > If not, Can you accept the patches, please.
>> >
>> The problem here is that module autoloading doesn't work for
>> device_handler. We have to have the callbacks in place _before_
>> driver probing starts as we might need to intercept the I/O
>> requests and/or errors. When using modalias the module loading
>> will be too late and the hooks will only be established after
>> the probing has already happened.
>> (The module autoloading is an asynchronous call in device_add(),
>> where we don't write for it to succeed. So probing will continue
>> and we woulnd't have the callbacks in place when probing
>> starts).
>
> Your analysis is correct.
>
> But, the chicken-n-egg problem you described exists only for the first
> device that is probed, module will be in place for the other devices.
>
> The first device race is handled by acting on the bus notification for
> the BUS_NOTIFY_BOUND_DRIVER event (patch 3/3 in my patch list).

How do you make sure, that the module is initialized when the
BOUND_DRIVER event is happening? The userspace process loading the
module can take any time to load, and I don't see how that is handled.
Care to explain that in detail?

I guess, you either need to implement a "device scan" from the module
loading routine to find all currently unhandled devices, or you need
to issue a blocking request_module() from inside the kernel and try to
find a matching module, and then run the find again. The modalias
seems not like the right solution here.

Thanks,
Kay
