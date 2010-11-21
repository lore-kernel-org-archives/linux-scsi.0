From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
Date: Sat, 20 Nov 2010 16:03:35 -0800
Message-ID: <AANLkTi=_r2YvDv0wj6qY_DqXntvHwfKNavTv8AKF+iXm@mail.gmail.com>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
 <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com>
 <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
 <AANLkTim1MChiEa9rBL0ZfSCak6G2x4ivK47Svd6swEBS@mail.gmail.com> <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1011202127131.24071@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 20, 2010 at 12:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> Ok, I tried doing that (see patch below)

Actually, you kind of chose exactly the reverse of the functions I'd
have chosen.

Try doing the added parameter to the small static helper functions.
Those are the ones that tend to get inlined, and then the parameter
should actually result in _fewer_ pointer reloads.

So the ones like this:

> =A0static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> =A0{
> - =A0 =A0 =A0 if (!scmd->device->host->hostt->eh_abort_handler)
> + =A0 =A0 =A0 struct scsi_host_template *hostt =3D scmd->device->host=
->hostt;
> + =A0 =A0 =A0 if (!hostt->eh_abort_handler)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return FAILED;
> -
> - =A0 =A0 =A0 return scmd->device->host->hostt->eh_abort_handler(scmd=
);
> + =A0 =A0 =A0 return hostt->eh_abort_handler(scmd);
> =A0}

Where the function is trivial, and almost all it does is to just
dereference those pointers.

If that function got the "host" pointer as an argument, it should make
it much smaller. Because half of that function is that
"scmd->device->host" lookup.

(ok, that's exaggerated, but not by much).

                Linus
