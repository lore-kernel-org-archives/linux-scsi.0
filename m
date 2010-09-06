From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
Date: Mon, 6 Sep 2010 07:48:20 -0700
Message-ID: <AANLkTimhHt78GFbxxjy1tosmebMVg-vKCNoJuqVa+iLH@mail.gmail.com>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
	<20100905203006.GD18411@core.coreip.homeip.net>
	<1283723479.556.135.camel@haakon2.linux-iscsi.org>
	<20100906050816.GD17212@core.coreip.homeip.net>
	<20100906051703.GA2891@suse.de>
	<1283750480.556.196.camel@haakon2.linux-iscsi.org>
	<20100906053845.GG17212@core.coreip.homeip.net>
	<1283752861.556.200.camel@haakon2.linux-iscsi.org>
	<20100906062625.GI17212@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40532 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0IFOsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 10:48:21 -0400
In-Reply-To: <20100906062625.GI17212@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Greg KH <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Sun, Sep 5, 2010 at 11:26 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sun, Sep 05, 2010 at 11:01:01PM -0700, Nicholas A. Bellinger wrote=
:
>> On Sun, 2010-09-05 at 22:38 -0700, Dmitry Torokhov wrote:
>> > On Sun, Sep 05, 2010 at 10:21:20PM -0700, Nicholas A. Bellinger wr=
ote:
>> > > On Sun, 2010-09-05 at 22:17 -0700, Greg KH wrote:
>> > > > On Sun, Sep 05, 2010 at 10:08:16PM -0700, Dmitry Torokhov wrot=
e:
>> > > > > On Sun, Sep 05, 2010 at 02:51:19PM -0700, Nicholas A. Bellin=
ger wrote:
>> > > > > > On Sun, 2010-09-05 at 13:30 -0700, Dmitry Torokhov wrote:
>> > > > > > > On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Be=
llinger wrote:
>> > > > > > > > +
>> > > > > > > > +static void tcm_loop_primary_release(struct device *d=
ev)
>> > > > > > > > +{
>> > > > > > > > + =A0 =A0 =A0 return;
>> > > > > > > > +}
>> > > > > > > > +
>> > > > > > > > +static struct device tcm_loop_primary =3D {
>> > > > > > > > + =A0 =A0 =A0 .init_name =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 "tcm_loop_0",
>> > > > > > > > + =A0 =A0 =A0 .release =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
=3D tcm_loop_primary_release,
>> > > > > > > > +};
>> > > > > > > > +
>> > > > > > >
>> > > > > > > No, you can not have statically allocated devices and du=
mmy release
>> > > > > > > functions.
>> > > > > > >
>> > > > > >
>> > > > > > Last time I checked this is still what mainline
>> > > > > > drivers/scsi/scsi_debug.c is doing for struct device pseud=
o_primary:
>> > > > > >
>> > > > > > static void pseudo_0_release(struct device *dev)
>> > > > > > {
>> > > > > > =A0 =A0 =A0 =A0 if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts=
)
>> > > > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "scsi_deb=
ug: pseudo_0_release() called\n");
>> > > > > > }
>> > > > > >
>> > > > > > static struct device pseudo_primary =3D {
>> > > > > > =A0 =A0 =A0 =A0 .init_name =A0 =A0 =A0=3D "pseudo_0",
>> > > > > > =A0 =A0 =A0 =A0 .release =A0 =A0 =A0 =A0=3D pseudo_0_relea=
se,
>> > > > > > };
>> > > > > >
>> > > > > > so for these type of things in TCM_Loop I tend to follow w=
hat scsi_debug does,
>> > > > > > =A0so I don't exactly see a issue here atm. =A0Anybody els=
e have comments..?
>> > > > >
>> > > > > The kobject embedded in the device structure is refcounted a=
nd it's
>> > > > > lifetime may be different from lifetime of your module. If s=
omebody
>> > > > > happen to hold reference to the driver while your module is =
being
>> > > > > unloaded bad things will happen.
>> > > > >
>> > > > > I am sure Greg has something on this topic ready for cut-and=
-paste.
>> > > >
>> > > > Documentation/kobject.txt :)
>> > >
>> > > I still don't get it..? =A0Does this mean that scsi_debug and TC=
M_Loop are
>> > > currently broken wrt to this item or not..?
>> > >
>> >
>> > Yes they are broken.
>>
>> Hi Dmitry and Greg,
>>
>> Would you mind giving a bit more specific idea as to what a patch to=
 fix
>> this issue would involve for an emulated struct device usage..? =A0I=
 would
>> be happy to generate patches for scsi_debug and TCM_loop to resolve =
this
>> issue, but I need a bit more information what I should be looking at=
=2E
>>
>
> I think what you need is root_device_create() which will allocate a
> device structure and assign ->release() that is implemented outside o=
f
> your module. This way your module may be unloaded even if there are
> outstanding references to tcm_loop_primary device.

I am embarrassed to admit that scst_local (or whatever its new name
will be) probably has the same fault, as it too was based on
scsi_debug ...

However, I did a search of the 2.6.24.1 source tree and could not find
any instances of root_device_create() being called nor defined. I just
double and triple checked the spelling.

Ahhh, I see why. A slightly different search suggests that it is
root_device_register(const char *name).

=46rom include/linux/device.h:

static inline struct device *root_device_register(const char *name)
{
	return __root_device_register(name, THIS_MODULE);
}

Was that the one you were thinking of?

> The rest of devices you create needs to increment module counter or
> otherwise ensure that their methods stay available until they are
> cleaned up (->release() is called).

OK, I need to check out how this is done.

> Hope this helps.

Sure does.

--=20
Regards,
Richard Sharpe
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
