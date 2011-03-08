From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Mon, 07 Mar 2011 18:18:17 -0600
Message-ID: <1299543497.15955.108.camel@mulgrave.site>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
	 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
	 <20110307201610.GA9032@mako-laptop>
	 <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Sender: linux-next-owner@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-07 at 15:54 -0800, Bhanu Gollapudi wrote:
> On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote:=20
> > On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing poin=
ter to incomplete type
> > > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: =E2=80=98MODULE_ST=
ATE_LIVE=E2=80=99 undeclared (first use in this function)
> >=20
> > Hm. Still there in next-20110307. Is this patch wrong or..?
> >=20
>=20
> James,
>=20
> Here is my ack for this patch.

OK, so the patch is actually wrong because adding #ifdefs on modules in
files really impedes readability.  The bug is using a direct deref on
module state instead of one of the APIs which work in the non-modular
case, namely try_module_get(). That means the other two need to come ou=
t
and be reworked (plus all the others in fcoe).

Reworked looks like it might be a bigger item than bnx2fc.  If any of
those tests is ever relevant, it means we have a race in the
fcoe_transport because it shouldn't be calling function pointers on a
dying module (unless it wants to trigger an oops).

So, why are you trying to do this in the first place?

James
