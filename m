From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 12 Nov 2010 10:44:24 -0800
Message-ID: <20101112184424.GD1224@core.coreip.homeip.net>
References: <20101022185437.GA9103@kroah.com>
 <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <AANLkTikA7GRDR2Y3nUfQYxLHCWVLfzVPJmZED_whuCWD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikA7GRDR2Y3nUfQYxLHCWVLfzVPJmZED_whuCWD@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 12, 2010 at 01:09:48PM +0100, Bart Van Assche wrote:
> On Fri, Nov 12, 2010 at 2:23 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Thu, Nov 11, 2010 at 11:50:01PM +0300, Vladislav Bolkhovitin wro=
te:
> > > [ ... ]
> > >
> > > This is the last internal put. All other references are from outs=
iders.
> > > So, we are waiting for all them to put before we go on.
> >
> > The question is why do you need to wait here? I presume it is modul=
e
> > unloading path, but then it is quite bad - you can easily wedge you=
r
> > subsystem if you make something to take a reference to your kobject
> > while module is trying to be unloaded. Back when sysfs attributes t=
ied
> > kobjects the easiest thing was to do:
> >
> > =A0 =A0 =A0 =A0rmmod <module> < / sys/devices/..../attribute
> >
> > If you are done with the kobject - just proceed with what you were =
doing
> > and let it die its own peaceful death some time later. You just nee=
d to
> > make sure release code sticks around to free it and your subsystem =
core
> > can be tasked with this. Use module counter to prevent unloading of=
 the
> > subsystem core until all kobjects belonging to the subsystem are
> > destroyed.
>=20
> Do you mean keeping a kref object in the kernel module, invoking
> kref_get() every time a kobject has been created and invoking
> kref_put() from the kobject/ktype release method ? That would help to
> reduce the race window but would not eliminate all races: as soon as
> the last kref_put() has been invoked from the release method, the
> module can get unloaded. And module unloading involves freeing all
> module code sections, including the section that contains the
> implementation of the release method. Which is a race condition.

No, you do not add a kref, but rather manipulate module use counter:

static void blah_blah_release(struct kobject *kobj)
{
	struct blah_blah *b =3D to_blah_blah(kobj);

	...
	kfree(kobj);

	module_put(THIS_MODULE);
}

int blah_blah_register(struct blah_blah *blah)
{
	...

	__module_get(THIS_MODULE);

	...

	return 0;
}

The above should reside in subsystem _core_ and it will pin the core
module until last kobject belonging to the subsystem is released.
Once all users are gone module counter will go to 0 and rmmod will
allow core to unload. Note that no new kobjects will be created while
module usage count is 0 because there are no users of the core - all of
them have to be unloaded already, otherwise module loader would have
bumped up usage count as well.

>=20
> I'm not sure that it is even possible with the current kobject
> implementation to solve this race.

It is possible and it is solved in most (all?) mainline subsystems.

> I haven't found any information
> about this race in Documentation/kobject.txt. And it seems to me that
> the code in samples/kobject/kobject-example.c is vulnerable to this
> race: methods like foo_show() and foo_store() can access statically
> allocated memory ("static int foo") after the module has been
> unloaded. Although the race window is small, this makes me wonder
> whether module unloading been overlooked at the time the kobject
> subsystem has been designed and implemented ?
>=20
> Bart.

--=20
Dmitry
