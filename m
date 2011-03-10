From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Thu, 10 Mar 2011 09:32:56 -0600
Message-ID: <1299771177.10246.41.camel@mulgrave.site>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
	 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
	 <20110307201610.GA9032@mako-laptop>
	 <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
	 <1299543497.15955.108.camel@mulgrave.site> <1299546546.1689.40.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1299546546.1689.40.camel@fritz>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Bhanu Gollapudi <bprakash@broadcom.com>, Mariusz Kozlowski <mk@lab.zgora.pl>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-07 at 17:09 -0800, Robert Love wrote:
> On Mon, 2011-03-07 at 16:18 -0800, James Bottomley wrote:
> > On Mon, 2011-03-07 at 15:54 -0800, Bhanu Gollapudi wrote:
> > > On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote:=20
> > > > On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wro=
te:
> > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing =
pointer to incomplete type
> > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: =E2=80=98MODUL=
E_STATE_LIVE=E2=80=99 undeclared (first use in this function)
> > > >=20
> > > > Hm. Still there in next-20110307. Is this patch wrong or..?
> > > >=20
> > >=20
> > > James,
> > >=20
> > > Here is my ack for this patch.
> >=20
> > OK, so the patch is actually wrong because adding #ifdefs on module=
s in
> > files really impedes readability.  The bug is using a direct deref =
on
> > module state instead of one of the APIs which work in the non-modul=
ar
> > case, namely try_module_get(). That means the other two need to com=
e out
> > and be reworked (plus all the others in fcoe).
> >=20
> > Reworked looks like it might be a bigger item than bnx2fc.  If any =
of
> > those tests is ever relevant, it means we have a race in the
> > fcoe_transport because it shouldn't be calling function pointers on=
 a
> > dying module (unless it wants to trigger an oops).
> >=20
> > So, why are you trying to do this in the first place?
> >=20
> First, fcoe.c started with these checks. Here is a comment in fcoe.c =
at
> the point of one of the checks.
>=20
> /*
>  * Make sure the module has been initialized, and is not about to be
>  * removed.  Module paramter sysfs files are writable before the
>  * module_init function is called and after module_exit.
>  */
>=20
> I don't know the correct way to fix that race is, but we may be past =
the
> need to fix it in the LLDs.

Well, what you've done isn't even fixing the race ... it's just
narrowing the window.  count checks on refcounted objects are almost
always wrong.  To see this just think what happens if the module goes
dead the instruction cycle after you do the check.

I don't understand the problem with the comments above.  The way we
solve the sysfs race in most systems (including modules) is to make sur=
e
they're initialised with the module and torn down as part of its exit
process ... modules.c follows this pattern.  The parameters are suppose=
d
to be initialised before the module has any state (because the init cod=
e
may rely on them).

I think the problem is you have what are essentially functional sysfs
files done as module parameters in fcoe_transport.c ... this looks to b=
e
wrong.  What you should have is these added as group attributes once th=
e
module is capable of processing them; that way you control the
lifetimes.

James


> Next, the fcoe transport was added. Since it (libfcoe.ko) is now call=
ing
> what used to be the fcoe.ko sysfs entry points I don't think the prob=
lem
> exists in fcoe.c or in bnx2fc_fcoe.c, the problem should be in the fc=
oe
> transport code, as James suggested.
>=20
> The fcoe transport code already has these checks to protect against
> sysfs files being writable before module initialization is complete. =
It
> uses the ft_mutex to protect the list of transports(LLDs) so when
> 'create' is called it knows that the transport is still there to call
> down to. It holds the ft_mutex until the LLD's 'create' routine retur=
ns.
> The transports(LLDs) should be detaching themselves from the fcoe
> transport layer before they exit. fcoe_transport_detach will try to
> acquire the ft_mutex and block until the 'create' call returns and
> releases the ft_mutex. I think this ensures that the transport(LLD) w=
ill
> be fine when the fcoe transport calls it.
>=20
> My feeling is that these checks are still needed in the fcoe transpor=
t,
> but not in the LLDs. If someone can suggest a better way to protect
> against writable sysfs files when the module hasn't finished
> initializing, we should do that instead of the ifdefs.
>=20
> Hope this helps,
>=20
> //Rob
>=20
> FYI: mnc asked about this code and the trylock code in fcoe and libfc=
oe.
> I have patches in our internal validation to remove the trylock usage=
,
> but I don't have patches to fix the module state checking.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
