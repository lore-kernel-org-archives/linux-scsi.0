From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: RE: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Tue, 8 Mar 2011 12:29:06 -0800
Message-ID: <1299616146.1360.1.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
 <20110307201610.GA9032@mako-laptop>
 <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
 <1299543497.15955.108.camel@mulgrave.site>
 <1299546546.1689.40.camel@fritz>
 <7C88852EF6F99F4EB538472FCFEBE222014F6FE66D@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=cp1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE222014F6FE66D@orsmsx509.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: "Love, Robert W" <robert.w.love@intel.com>, James Bottomley <James.Bottomley@suse.de>, Mariusz Kozlowski <mk@lab.zgora.pl>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-03-08 at 11:36 -0800, Zou, Yi wrote:=20
> > On Mon, 2011-03-07 at 16:18 -0800, James Bottomley wrote:
> > > On Mon, 2011-03-07 at 15:54 -0800, Bhanu Gollapudi wrote:
> > > > On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote:
> > > > > On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski w=
rote:
> > > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencin=
g
> > pointer to incomplete type
> > > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error:
> > =91MODULE_STATE_LIVE=92 undeclared (first use in this function)
> > > > >
> > > > > Hm. Still there in next-20110307. Is this patch wrong or..?
> > > > >
> > > >
> > > > James,
> > > >
> > > > Here is my ack for this patch.
> > >
> > > OK, so the patch is actually wrong because adding #ifdefs on modu=
les in
> > > files really impedes readability.  The bug is using a direct dere=
f on
> > > module state instead of one of the APIs which work in the non-mod=
ular
> > > case, namely try_module_get(). That means the other two need to c=
ome
> > out
> > > and be reworked (plus all the others in fcoe).
> > >
> > > Reworked looks like it might be a bigger item than bnx2fc.  If an=
y of
> > > those tests is ever relevant, it means we have a race in the
> > > fcoe_transport because it shouldn't be calling function pointers =
on a
> > > dying module (unless it wants to trigger an oops).
> > >
> > > So, why are you trying to do this in the first place?
> > >
> > First, fcoe.c started with these checks. Here is a comment in fcoe.=
c at
> > the point of one of the checks.
> >=20
> > /*
> >  * Make sure the module has been initialized, and is not about to b=
e
> >  * removed.  Module paramter sysfs files are writable before the
> >  * module_init function is called and after module_exit.
> >  */
> >=20
> > I don't know the correct way to fix that race is, but we may be pas=
t the
> > need to fix it in the LLDs.
> >=20
> > Next, the fcoe transport was added. Since it (libfcoe.ko) is now ca=
lling
> > what used to be the fcoe.ko sysfs entry points I don't think the pr=
oblem
> > exists in fcoe.c or in bnx2fc_fcoe.c, the problem should be in the =
fcoe
> > transport code, as James suggested.
> >=20
> > The fcoe transport code already has these checks to protect against
> > sysfs files being writable before module initialization is complete=
=2E It
> > uses the ft_mutex to protect the list of transports(LLDs) so when
> > 'create' is called it knows that the transport is still there to ca=
ll
> > down to. It holds the ft_mutex until the LLD's 'create' routine ret=
urns.
> > The transports(LLDs) should be detaching themselves from the fcoe
> > transport layer before they exit. fcoe_transport_detach will try to
> > acquire the ft_mutex and block until the 'create' call returns and
> > releases the ft_mutex. I think this ensures that the transport(LLD)=
 will
> > be fine when the fcoe transport calls it.
> >=20
> > My feeling is that these checks are still needed in the fcoe transp=
ort,
> > but not in the LLDs. If someone can suggest a better way to protect
> > against writable sysfs files when the module hasn't finished
> > initializing, we should do that instead of the ifdefs.
> >=20
> > Hope this helps,
> >=20
> > //Rob
> >=20
> > FYI: mnc asked about this code and the trylock code in fcoe and lib=
fcoe.
> > I have patches in our internal validation to remove the trylock usa=
ge,
> > but I don't have patches to fix the module state checking.
> >=20
> Yeah, this logic was from original fixing race condition in fcoe.ko, =
note
> that we do need check the MODULE_STATE_LIVE, try_module_get() is not =
what
> we wanted, plus module_is_live () checks if it is !GOING. Anyway, I d=
on't
> think this is needed any more for individual fcoe transport driver, e=
=2Eg.,
> fcoe.ko or bnx2fc, as the race is now for sysfs of libfcoe.
>=20
> I will send out a patch to clean up the fcoe.c for this.

I agree. I'll follow it up with bnx2fc patch.

Thanks,
Bhanu=20
>=20
> Thanks,
> yi
>=20
>=20
>=20
>=20
>=20
>=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
