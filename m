From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/7] lib: string: add functions to case-convert
 strings
Date: Tue, 05 Jul 2016 15:56:17 -0700
Message-ID: <1467759377.8360.12.camel@perches.com>
References: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
	 <1467756874.16342.11.camel@perches.com>
	 <CAGt4E5vqiUOVmgqY8OvRPNpoS54hZMOHid6ND4CRyb5p9y5ndw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAGt4E5vqiUOVmgqY8OvRPNpoS54hZMOHid6ND4CRyb5p9y5ndw@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Markus Mayer <markus.mayer@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-pm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-07-05 at 15:36 -0700, Markus Mayer wrote:
> On 5 July 2016 at 15:14, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2016-07-05 at 13:47 -0700, Markus Mayer wrote:
> > > This series introduces a family of generic string case conversion
> > > functions. This kind of functionality is needed in several places=
 in
> > > the kernel. Right now, everybody seems to be implementing their o=
wn
> > > copy of this functionality.
> > >=20
> > > Based on the discussion of the previous version of this series[1]=
 and
> > > the use cases found in the kernel, it does look like having sever=
al
> > > flavours of case conversion functions is beneficial. The use case=
s fall
> > > into three categories:
> > > =A0=A0=A0=A0- copying a string and converting the case while spec=
ifying a
> > > =A0=A0=A0=A0=A0=A0maximum length to mimic strncpy()
> > > =A0=A0=A0=A0- copying a string and converting the case without sp=
ecifying a
> > > =A0=A0=A0=A0=A0=A0length to mimic strcpy()
> > > =A0=A0=A0=A0- converting the case of a string in-place (i.e. modi=
fying the
> > > =A0=A0=A0=A0=A0=A0string that was passed in)
> > >=20
> > > Consequently, I am proposing these new functions:
> > > =A0=A0=A0=A0char *strncpytoupper(char *dst, const char *src, size=
_t len);
> > > =A0=A0=A0=A0char *strncpytolower(char *dst, const char *src, size=
_t len);
> > > =A0=A0=A0=A0char *strcpytoupper(char *dst, const char *src);
> > > =A0=A0=A0=A0char *strcpytolower(char *dst, const char *src);
> > > =A0=A0=A0=A0char *strtoupper(char *s);
> > > =A0=A0=A0=A0char *strtolower(char *s);
> > I think there isn't much value in anything other
> > than strto.
> >=20
> > Using str[n]cpy followed by strto is
> > pretty obvious and rarely used anyway.
> First time around, folks were proposing the "copy" variants when I
> submitted just strtolower() by itself[1]. They just asked for source
> and destination parameters to strtolower(), but looking at the use
> cases that wouldn't have worked so well. Hence it evolved into these =
6
> functions.
>=20
> Here's a breakdown of how the functions are being used (patches 2-7),
> see also [2]:
>=20
> Patch 2: strncpytolower()
> Patch 3: strtolower()
> Patch 4: strncpytolower() and strtolower()
> Patch 5: strtolower()
> Patch 6: strcpytoupper()
> Patch 7: strcpytoupper()
>=20
> So it does look like the copy + change case variant is more frequentl=
y
> used than just strto.

Are these functions useful? =A0<shrug> Not to me, not so much.

None of the functions would have the strcpy performance of
the arch / asm
versions of strcpy and the savings in overall
code isn't significant (or
measured?).

Of course none of the uses are runtime performance important.

This patch also adds always compiled functions that aren't used
in many .configs.

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
