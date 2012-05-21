From: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 0/4] notify userspace of offline->running transitions (v2)
Date: Mon, 21 May 2012 21:15:12 +0200
Message-ID: <CAPXgP13=W34uEaEk0kwCfh-J1=+mxisRbSd89rQ3tpARFasUOA@mail.gmail.com>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
 <4FBA2BF7.7070500@suse.de> <4FBA60C2.20007@cs.wisc.edu> <CAPXgP10t_pMCJuavrBsNcyv1XKy4WThV8CfVBz-4wD=Q_fq_=w@mail.gmail.com>
 <4FBA7595.8020400@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2EUTPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 15:15:33 -0400
Received: by pbbrp8 with SMTP id rp8so7323596pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 21 May 2012 12:15:33 -0700 (PDT)
In-Reply-To: <4FBA7595.8020400@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, May 21, 2012 at 7:04 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> On 05/21/2012 11:49 AM, Kay Sievers wrote:

>>> Kay told me to do it this way :) In this case udev was the app we
>>> discovered the issue with, so maybe that is the diff.
>>
>> Hah, I basically only told you not to use online/offline events. :)
>
> Yeah, I guess you guys got me confused :) Harold said to send an event
> for this issue. Then later you said "please always use change". I
> thought you and Harold were in sync :(

Yeah, Harald and I think that sometimes ourselves, but we are not always. :)

>> Uevents are ok to use if we can be sure there is _never_ a storm of
>> events. Uevents are not meant to handle large amounts of events
>> happening at the same time. They must never be used to handle things
>> like reporting errors which are not limited in their rate, or where
>> many devices might send similar events at the same time in a row.
>
> In this case you can get many devices sending the same events at the
> same time, because when the transport/connection comes back you all the
> device accessed through that connection will be set to running at the
> same time.

The problem would be more the possible highest frequency of the
change. One event per device in a longer time frame would be ok, it's
like coldplug at boot time, where we enumerate all devices once in one
step. That is known though, to take minutes on very large boxes with
thousands of devices.

If we get such state change for lots of devices in a row (the state
flips forth and back for all devices), faster than we handle them (and
they are not that fast on older versions of udev, or if people plugged
silly things into udev rules), things will break or get lost one way
or the other.

> So what is the fix for this case? Just send one event for the host or
> transport/connection then have udev loop over all devices accessed
> through that object and fix things up? If so, what type of event do you
> want? CHANGE event plus some other info to indicate to look at child
> devices?

 We do not really support such logic in udev. And it would cause
exactly the same problem, just at a different layer.

Kay
