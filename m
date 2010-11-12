From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 12 Nov 2010 13:09:48 +0100
Message-ID: <AANLkTikA7GRDR2Y3nUfQYxLHCWVLfzVPJmZED_whuCWD@mail.gmail.com>
References: <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net>
 <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43166 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0KLMKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2010 07:10:09 -0500
In-Reply-To: <20101112012315.GE17097@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

On Fri, Nov 12, 2010 at 2:23 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Nov 11, 2010 at 11:50:01PM +0300, Vladislav Bolkhovitin wrote=
:
> > [ ... ]
> >
> > This is the last internal put. All other references are from outsid=
ers.
> > So, we are waiting for all them to put before we go on.
>
> The question is why do you need to wait here? I presume it is module
> unloading path, but then it is quite bad - you can easily wedge your
> subsystem if you make something to take a reference to your kobject
> while module is trying to be unloaded. Back when sysfs attributes tie=
d
> kobjects the easiest thing was to do:
>
> =A0 =A0 =A0 =A0rmmod <module> < / sys/devices/..../attribute
>
> If you are done with the kobject - just proceed with what you were do=
ing
> and let it die its own peaceful death some time later. You just need =
to
> make sure release code sticks around to free it and your subsystem co=
re
> can be tasked with this. Use module counter to prevent unloading of t=
he
> subsystem core until all kobjects belonging to the subsystem are
> destroyed.

Do you mean keeping a kref object in the kernel module, invoking
kref_get() every time a kobject has been created and invoking
kref_put() from the kobject/ktype release method ? That would help to
reduce the race window but would not eliminate all races: as soon as
the last kref_put() has been invoked from the release method, the
module can get unloaded. And module unloading involves freeing all
module code sections, including the section that contains the
implementation of the release method. Which is a race condition.

I'm not sure that it is even possible with the current kobject
implementation to solve this race. I haven't found any information
about this race in Documentation/kobject.txt. And it seems to me that
the code in samples/kobject/kobject-example.c is vulnerable to this
race: methods like foo_show() and foo_store() can access statically
allocated memory ("static int foo") after the module has been
unloaded. Although the race window is small, this makes me wonder
whether module unloading been overlooked at the time the kobject
subsystem has been designed and implemented ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
