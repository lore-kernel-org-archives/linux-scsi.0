From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [patch net-next 0/3] net/sched: Improve getting objects by indexes
Date: Wed, 16 Aug 2017 10:19:53 +0100
Message-ID: <150287519355.15499.3124883464555211520__39224.6026000523$1502888120$gmane$org@mail.alporthouse.com>
References: <1502849538-14284-1-git-send-email-chrism@mellanox.com>
 <144b87a3-bbe4-a194-ed83-e54840d7c7c2@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <144b87a3-bbe4-a194-ed83-e54840d7c7c2@amd.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Chris Mi <chrism@mellanox.com>, netdev@vger.kernel.org
Cc: lucho@ionkov.net, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com, wsa@the-dreams.de, markb@mellanox.com, tom.leiming@gmail.com, stefanr@s5r6.in-berlin.de, zhi.a.wang@intel.com, nsekhar@ti.com, dri-devel@lists.freedesktop.org, bfields@fieldses.org, linux-sctp@vger.kernel.org, paulus@samba.org, jinpu.wang@profitbricks.com, pshelar@ovn.org, sumit.semwal@linaro.org, AlexBin.Xie@amd.com, david1.zhou@amd.com, linux-samsung-soc@vger.kernel.org, maximlevitsky@gmail.com, sudarsana.kalluru@qlogic.com, marek.vasut@gmail.com, linux-atm-general@lists.sourceforge.net, dtwlin@gmail.com, michel.daenzer@amd.com, dledford@redhat.com, tpmdd-devel@lists.sourceforge.net, stern@rowland.harvard.edu, longman@redhat.com, niranjana.vishwanathapura@intel.com, philipp.reisner@linbit.com, shli@kernel.org, linux@roeck-us.net, ohad@wizery.com, pmladek@suse.com, dick.kennedy@broadcom.comlinux-
List-Id: linux-scsi@vger.kernel.org

Quoting Christian K=C3=B6nig (2017-08-16 08:49:07)
> Am 16.08.2017 um 04:12 schrieb Chris Mi:
> > Using current TC code, it is very slow to insert a lot of rules.
> >
> > In order to improve the rules update rate in TC,
> > we introduced the following two changes:
> >          1) changed cls_flower to use IDR to manage the filters.
> >          2) changed all act_xxx modules to use IDR instead of
> >             a small hash table
> >
> > But IDR has a limitation that it uses int. TC handle uses u32.
> > To make sure there is no regression, we also changed IDR to use
> > unsigned long. All clients of IDR are changed to use new IDR API.
> =

> WOW, wait a second. The idr change is touching a lot of drivers and to =

> be honest doesn't looks correct at all.
> =

> Just look at the first chunk of your modification:
> > @@ -998,8 +999,9 @@ int bsg_register_queue(struct request_queue *q, str=
uct device *parent,
> >   =

> >       mutex_lock(&bsg_mutex);
> >   =

> > -     ret =3D idr_alloc(&bsg_minor_idr, bcd, 0, BSG_MAX_DEVS, GFP_KERNE=
L);
> > -     if (ret < 0) {
> > +     ret =3D idr_alloc(&bsg_minor_idr, bcd, &idr_index, 0, BSG_MAX_DEV=
S,
> > +                     GFP_KERNEL);
> > +     if (ret) {
> >               if (ret =3D=3D -ENOSPC) {
> >                       printk(KERN_ERR "bsg: too many bsg devices\n");
> >                       ret =3D -EINVAL;
> The condition "if (ret)" will now always be true after the first =

> allocation and so we always run into the error handling after that.

ret is now purely the error code, so it doesn't look that suspicious.

> I've never read the bsg code before, but that's certainly not correct. =

> And that incorrect pattern repeats over and over again in this code.
> =

> Apart from that why the heck do you want to allocate more than 1<<31 =

> handles?

And more to the point, arbitrarily changing the maximum to ULONG_MAX
where the ABI only supports U32_MAX is dangerous. Unless you do the
analysis otherwise, you have to replace all the end=3D0 with end=3DINT_MAX
to maintain existing behaviour.
-Chris
