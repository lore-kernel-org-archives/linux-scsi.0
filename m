From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Wed, 08 Dec 2010 10:24:02 -0600
Message-ID: <1291825442.24312.54.camel@mulgrave.site>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
	 <1291739449.17668.9.camel@mulgrave.site>
	 <1291742693.1638.22.camel@leonhard>  <1291825220.1741.9.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0LHQYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2010 11:24:07 -0500
In-Reply-To: <1291825220.1741.9.camel@leonhard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 2010-12-09 at 01:20 +0900, Namhyung Kim wrote:
> 2010-12-08 (=EC=88=98), 02:24 +0900, Namhyung Kim:
> > 2010-12-07 (=ED=99=94), 10:30 -0600, James Bottomley:
> > > On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> > > > MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MO=
DULE) so
> > > > allyesconfig build always emits the warnings. Possible patch fo=
r this
> > > > would be wraping it up in #ifdefs but when I sent a same patch =
to Greg
> > > > KH he didn't want to add more #ifdefs in .c files.
> > >=20
> > > I didn't mean changing any c files.  I meant fixing the module in=
clude
> > > to make the table used even in the !MODULE case.  That way we onl=
y alter
> > > one file instead of a significant proportion of the drivers.
> > >=20
> >=20
> > It would not be a _significant_ proportion because normal drivers m=
ay
> > refer the table in their driver struct. :)
> >=20
> > Anyway the patch below looks good to me. I'll happily drop my patch=
es if
> > you apply this in your tree.
> >=20
>=20
> Hi,
>=20
> As akpm told me, using DEFINE_PCI_DEVICE_TABLE could also remove the
> warnings (probably by making the table const) but it still requires
> modifying .c files. What do you think?

The warning only appears in the non-modular case, which is pretty
unusual for drivers nowadays, so I think the simplest elimination
solution is the best one (i.e. just kill it at source in the header).

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
