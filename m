From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Sat, 13 Nov 2010 11:52:12 +0100
Message-ID: <AANLkTi=VwCj2MRTFM79aT78rov5XsiRo4KXHpw+EiDFi@mail.gmail.com>
References: <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
 <AANLkTikA7GRDR2Y3nUfQYxLHCWVLfzVPJmZED_whuCWD@mail.gmail.com> <20101112184424.GD1224@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57558 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0KMKwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Nov 2010 05:52:34 -0500
In-Reply-To: <20101112184424.GD1224@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

On Fri, Nov 12, 2010 at 7:44 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> [ ... ]
>
> No, you do not add a kref, but rather manipulate module use counter:
>
> static void blah_blah_release(struct kobject *kobj)
> {
> =A0 =A0 =A0 =A0struct blah_blah *b =3D to_blah_blah(kobj);
>
> =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0kfree(kobj);
>
> =A0 =A0 =A0 =A0module_put(THIS_MODULE);
> }
>
> int blah_blah_register(struct blah_blah *blah)
> {
> =A0 =A0 =A0 =A0...
>
> =A0 =A0 =A0 =A0__module_get(THIS_MODULE);
>
> =A0 =A0 =A0 =A0...
>
> =A0 =A0 =A0 =A0return 0;
> }
>
> The above should reside in subsystem _core_ and it will pin the core
> module until last kobject belonging to the subsystem is released.
> Once all users are gone module counter will go to 0 and rmmod will
> allow core to unload. Note that no new kobjects will be created while
> module usage count is 0 because there are no users of the core - all =
of
> them have to be unloaded already, otherwise module loader would have
> bumped up usage count as well.
>
> > I'm not sure that it is even possible with the current kobject
> > implementation to solve this race.
>
> It is possible and it is solved in most (all?) mainline subsystems.

Thanks for replying, but sorry, it's still not clear to me. The use
counter of which module should be manipulated ? Manipulating the use
counter of the module that contains the kobject/ktype callback
function implementations would make it impossible to unload that
module because rmmod refuses to unload any module whose use counter is
above zero. And manipulating the use counter of a parent module would
not help in any way.

It would help if you could tell us where in the kernel tree we can
find a good example. I have tried to find such an example, but all I
found are examples of kobject release method implementations in which
no attempt is made to prevent the aforementioned race:
* iscsi_boot_kobj_release() in drivers/scsi/iscsi_boot_sysfs.c
* pkt_kobj_release() in drivers/block/pktcdvd.c

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
