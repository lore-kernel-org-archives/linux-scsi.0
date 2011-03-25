From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Fri, 25 Mar 2011 21:05:40 +0100
Message-ID: <AANLkTikzn5H_PjHQ02G4FfLheOFd+Q_mQJyNFNyVt3UL@mail.gmail.com>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
 <20110324074600L.fujita.tomonori@lab.ntt.co.jp> <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
 <20110324102939R.fujita.tomonori@lab.ntt.co.jp> <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
 <1301012333.4087.24.camel@mulgrave.site> <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
 <1301065611.4073.7.camel@mulgrave.site> <AANLkTims4pYwuwU7UeOvgiXvr6CRBRUk8+juLKA3DpWm@mail.gmail.com>
 <1301081698.4073.32.camel@mulgrave.site> <AANLkTincjuy6gThJKrewnWnt_UNEY-JeOMghTSR6__UG@mail.gmail.com>
 <1301082878.4073.35.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43924 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1CYUGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 16:06:01 -0400
Received: by vxi39 with SMTP id 39so1051582vxi.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2011 13:06:00 -0700 (PDT)
In-Reply-To: <1301082878.4073.35.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, Mar 25, 2011 at 8:54 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Fri, 2011-03-25 at 20:49 +0100, Bart Van Assche wrote:
>> A storage target subsystem is more demanding than e.g. udev. As an
>> example, for the session reassignment logic in SCST it is necessary =
to
>> remove and create user space visible objects synchronously and under
>> lock. Both are necessary - the locking and the synchronous
>> manipulation of user space objects. I'm not sure it is possible to
>> convert such an approach to something based on asynchronous userspac=
e
>> upcalls.
>
> Really, no ... this is an example of an a-priori design fault. =A0Wha=
t it
> implies is that the user and kernel share locks for state access, whi=
ch
> always leads to deadlocks. =A0A correctly separated event driven mode=
l
> shouldn't need state locks across event subsystems.
>
> Just because SCST couldn't get it right, doesn't mean that no-one els=
e
> can.

Hi James,

There seems to be a misunderstanding. There is no design fault at all
in SCST in this area - since SCST uses sysfs the session reassignment
code doesn't trigger any lock inversion at all. Such lock inversion
would only be triggered if someone would try to convert that code to
configfs.

Also, the reason I mentioned that example was not to invite criticism
on that specific example but to illustrate that in a storage target
some algorithms can only be implemented correctly by synchronously
updating the internal state and the state of a self-describing
interface like sysfs or configfs. It's not because udev doesn't need
this that no other subsystem needs this.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
