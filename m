From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 01/12] lib: create common ascii hex array
Date: Tue, 13 May 2008 09:53:27 -0700
Message-ID: <1210697607.5938.1.camel@brick>
References: <1210619134.24092.51.camel@brick>
	 <Pine.LNX.4.64.0805122218240.14152@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:61385 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760320AbYEMQx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 12:53:29 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2817530wfd.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 May 2008 09:53:28 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0805122218240.14152@wrl-59.cs.helsinki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide <linux-ide@vger.kernel.org>, linux-netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>, David Howells <dhowells@redhat.com>, "ralf@linux-mips.org" <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>

On Tue, 2008-05-13 at 12:55 +0300, Ilpo J=C3=A4rvinen wrote:
> On Mon, 12 May 2008, Harvey Harrison wrote:
>=20
> > Add a common hex array in hexdump.c so everyone can use it.
> >=20
> > Add a common hi/lo helper to avoid the shifting masking that is
> > done to get the upper and lower nibbles of a byte value.
> >=20
> > Pull the pack_hex_byte helper from kgdb as it is opencoded many
> > places in the tree that will be consolidated.
> >=20
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > =20
> > -#define hex_asc(x)	"0123456789abcdef"[x]
> > +
> > +extern const char hex_asc[];
> > +#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
> > +#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
> > +
> > +static inline char *pack_hex_byte(char *buf, u8 byte)
> > +{
> > +	*buf++ =3D hex_asc_hi(byte);
> > +	*buf++ =3D hex_asc_lo(byte);
> > +	return buf;
> > +}
>=20
> Any idea how much this will bloat kernel once it has, lets say 100=20
> users? 5k, 10k?
>=20

No more than the existing users do open-coding the same thing all over
the place.  If it becomes a problem, this can be out-of-lined, but
the savings are not much.

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
