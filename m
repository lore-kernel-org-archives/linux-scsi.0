From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/7] lib: string: add functions to case-convert
 strings
Date: Tue, 05 Jul 2016 15:14:34 -0700
Message-ID: <1467756874.16342.11.camel@perches.com>
References: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
Sender: target-devel-owner@vger.kernel.org
To: Markus Mayer <mmayer@broadcom.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>
Cc: dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-07-05 at 13:47 -0700, Markus Mayer wrote:
> This series introduces a family of generic string case conversion
> functions. This kind of functionality is needed in several places in
> the kernel. Right now, everybody seems to be implementing their own
> copy of this functionality.
>=20
> Based on the discussion of the previous version of this series[1] and
> the use cases found in the kernel, it does look like having several
> flavours of case conversion functions is beneficial. The use cases fa=
ll
> into three categories:
> =A0=A0=A0=A0- copying a string and converting the case while specifyi=
ng a
> =A0=A0=A0=A0=A0=A0maximum length to mimic strncpy()
> =A0=A0=A0=A0- copying a string and converting the case without specif=
ying a
> =A0=A0=A0=A0=A0=A0length to mimic strcpy()
> =A0=A0=A0=A0- converting the case of a string in-place (i.e. modifyin=
g the
> =A0=A0=A0=A0=A0=A0string that was passed in)
>=20
> Consequently, I am proposing these new functions:
> =A0=A0=A0=A0char *strncpytoupper(char *dst, const char *src, size_t l=
en);
> =A0=A0=A0=A0char *strncpytolower(char *dst, const char *src, size_t l=
en);
> =A0=A0=A0=A0char *strcpytoupper(char *dst, const char *src);
> =A0=A0=A0=A0char *strcpytolower(char *dst, const char *src);
> =A0=A0=A0=A0char *strtoupper(char *s);
> =A0=A0=A0=A0char *strtolower(char *s);

I think there isn't much value in anything other
than strto<upper|lower>.

Using str[n]cpy followed by strto<upper|lower> is
pretty obvious and rarely used anyway.
