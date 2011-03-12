From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Fri, 11 Mar 2011 18:03:19 -0800
Message-ID: <1299895399.19083.241.camel@fritz>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
	 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
	 <20110307201610.GA9032@mako-laptop>
	 <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
	 <1299543497.15955.108.camel@mulgrave.site> <1299546546.1689.40.camel@fritz>
	 <1299771177.10246.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1299771177.10246.41.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bhanu Gollapudi <bprakash@broadcom.com>, Mariusz Kozlowski <mk@lab.zgora.pl>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-03-10 at 07:32 -0800, James Bottomley wrote:
> On Mon, 2011-03-07 at 17:09 -0800, Robert Love wrote:
> > On Mon, 2011-03-07 at 16:18 -0800, James Bottomley wrote:
> > > On Mon, 2011-03-07 at 15:54 -0800, Bhanu Gollapudi wrote:
> > > > On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote:=20
> > > > > On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski w=
rote:
> > > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencin=
g pointer to incomplete type
> > > > > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: =E2=80=98MOD=
ULE_STATE_LIVE=E2=80=99 undeclared (first use in this function)
> > > > >=20
> > > > > Hm. Still there in next-20110307. Is this patch wrong or..?
> > > > >=20
> > > >=20
> > > > James,
> > > >=20
> > > > Here is my ack for this patch.
> > >=20
> > > OK, so the patch is actually wrong because adding #ifdefs on modu=
les in
> > > files really impedes readability.  The bug is using a direct dere=
f on
> > > module state instead of one of the APIs which work in the non-mod=
ular
> > > case, namely try_module_get(). That means the other two need to c=
ome out
> > > and be reworked (plus all the others in fcoe).
> > >=20
> > > Reworked looks like it might be a bigger item than bnx2fc.  If an=
y of
> > > those tests is ever relevant, it means we have a race in the
> > > fcoe_transport because it shouldn't be calling function pointers =
on a
> > > dying module (unless it wants to trigger an oops).
> > >=20
> > > So, why are you trying to do this in the first place?
> > >=20
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
>=20
> Well, what you've done isn't even fixing the race ... it's just
> narrowing the window.  count checks on refcounted objects are almost
> always wrong.  To see this just think what happens if the module goes
> dead the instruction cycle after you do the check.
>=20
> I don't understand the problem with the comments above.  The way we
> solve the sysfs race in most systems (including modules) is to make s=
ure
> they're initialised with the module and torn down as part of its exit
> process ... modules.c follows this pattern.  The parameters are suppo=
sed
> to be initialised before the module has any state (because the init c=
ode
> may rely on them).
>=20
> I think the problem is you have what are essentially functional sysfs
> files done as module parameters in fcoe_transport.c ... this looks to=
 be
> wrong.  What you should have is these added as group attributes once =
the
> module is capable of processing them; that way you control the
> lifetimes.

You're right, this is our problem. Unfortunately, we're in a bit of a
"chicken and egg" situation.

=46or SW FCoE, we don't know which netdevice the user wants to run FCoE
traffic on so we don't create any devices or other sysfs entries until
the user tells us to 'create'. The user passes the netdevice name to ou=
r
sysfs file and then we create the scsi_host/fc_host.

I am not sure what I would attach a group of attributes (create,
destroy, etc...) to. If I had per-instance devices I could add
attributes to them, but I need the 'create' interface before I can
create any per-instance devices.

One option would be to go back to what we used to do (pre-mainline
acceptance) which is the following:

static const struct kobj_attribute fcoe_destroyattr =3D \
	__ATTR(destroy, S_IWUSR, NULL, fcoe_destroy);
static const struct kobj_attribute fcoe_createattr =3D \
	__ATTR(create, S_IWUSR, NULL, fcoe_create);

static int __init fcoe_init(void)
{
=2E..
rc =3D sysfs_create_file(&THIS_MODULE->mkobj.kobj,
		       &fcoe_destroyattr.attr);
if (!rc)
	rc =3D sysfs_create_file(&THIS_MODULE->mkobj.kobj,
			       &fcoe_createattr.attr)
=2E..
}

I think this is bad because we're manipulating kobjects too directly,
right?

A second option would be to keep everything the same but use an atomic
bit to signify when the module has completed initialization. We'd still
need a check in each of the sysfs entries store routines, but we
wouldn't be checking against the module state.

A third option is to do something like bonding does, where it creates
a /sys/class/net/bonding_masters entry. My guess is that this would be
controversial; adding fcoe interfaces class/net could be considered
polluting the networking space with storage information.

A fourth option would be to drop sysfs all together and use netlink,
like iSCSI. Currently we don't need an extensive kernel/user interface,
so I look at this as overkill.

I suppose the second option would solve the current race. I realize it
doesn't necessarily fix the fact that we're adding usable sysfs files
prematurely, but I'm not sure where I'd attach the attributes if I were
do do it at the end of libfcoe's module_init routine. I'll mail my patc=
h
for comments.

Thanks, //Rob
