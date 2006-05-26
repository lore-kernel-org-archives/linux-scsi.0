From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PATCH: Bogus disk geometry on large disks
Date: Fri, 26 May 2006 12:20:02 -0600
Message-ID: <20060526182002.GG19587@parisc-linux.org>
References: <1148660965.20856.35.camel@localhost.localdomain> <20060526175713.GB19587@parisc-linux.org> <1148667738.20856.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52425 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751236AbWEZSUD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 14:20:03 -0400
Content-Disposition: inline
In-Reply-To: <1148667738.20856.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

On Fri, May 26, 2006 at 07:22:18PM +0100, Alan Cox wrote:
> On Gwe, 2006-05-26 at 11:57 -0600, Matthew Wilcox wrote:
> > On Fri, May 26, 2006 at 05:29:25PM +0100, Alan Cox wrote:
> > > =20
> > > -	if (ret =3D=3D -1) {
> > > +	if (ret =3D=3D -1 && capacity < (1ULL << 32)) {
> > >  		/* pick some standard mapping with at most 1024 cylinders,
> >=20
> > won't that provoke a gcc warning when sector_t is 32-bit?  how abou=
t ...
>=20
> I don't believe it will as the type is forced to "1ULL"

gcc disagrees with you ;-)

$ cat test.c=20
unsigned int y;

int main(void)
{
        if (y < (1ULL << 32))
                return 0;
        return 1;
}
$ gcc -O2 -W -Wall -o test test.c
test.c: In function =E2=80=98main=E2=80=99:
test.c:5: warning: comparison is always true due to limited range of da=
ta type

$ cat test.c=20
unsigned int y;

int main(void)
{
        if (((y >> 16) >> 16) > 0)
                return 0;
        return 1;
}
$ gcc -O2 -W -Wall -o test test.c

(anyone know how you turn off that fucking UTF8 crap that gcc insists
on putting into its warning/error messages?  Who thought that was a
good idea?)

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
