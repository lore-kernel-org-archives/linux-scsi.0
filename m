From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Fri, 25 Mar 2011 20:49:17 +0100
Message-ID: <AANLkTincjuy6gThJKrewnWnt_UNEY-JeOMghTSR6__UG@mail.gmail.com>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
 <20110324074600L.fujita.tomonori@lab.ntt.co.jp> <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
 <20110324102939R.fujita.tomonori@lab.ntt.co.jp> <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
 <1301012333.4087.24.camel@mulgrave.site> <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
 <1301065611.4073.7.camel@mulgrave.site> <AANLkTims4pYwuwU7UeOvgiXvr6CRBRUk8+juLKA3DpWm@mail.gmail.com>
 <1301081698.4073.32.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60710 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1CYTtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 15:49:41 -0400
Received: by vxi39 with SMTP id 39so1040397vxi.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2011 12:49:40 -0700 (PDT)
In-Reply-To: <1301081698.4073.32.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, Mar 25, 2011 at 8:34 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Fri, 2011-03-25 at 19:44 +0100, Bart Van Assche wrote:
>> On Fri, Mar 25, 2011 at 4:06 PM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > Explain first what lock inversion problems you see ... those usual=
ly
>> > only happen if you have the in the kernel upcall thread waiting fo=
r
>> > completion.
>>
>> In this context asynchronous upcalls have their problems too: the
>> in-kernel and the user space visible state may become inconsistent.
>> What will happen if processing of such notifications is delayed and
>> concurrently attempts are made from user space to act on these objec=
ts
>> ? I'm afraid that could result in horrible race conditions.
>
> What race conditions? =A0The current exemplar is udev which uses the
> uevent mechanism. =A0The usual way of coping with use before init is =
to
> key visibility off completion ... at least that's the way we do it in
> sysfs.

A storage target subsystem is more demanding than e.g. udev. As an
example, for the session reassignment logic in SCST it is necessary to
remove and create user space visible objects synchronously and under
lock. Both are necessary - the locking and the synchronous
manipulation of user space objects. I'm not sure it is possible to
convert such an approach to something based on asynchronous userspace
upcalls.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
