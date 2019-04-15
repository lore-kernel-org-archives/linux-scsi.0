From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date: Mon, 15 Apr 2019 20:44:39 +1000
Message-ID: <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz> <093301d4f187$da0756a0$8e1603e0$@d-silva.org> <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz> <0da301d4f373$01d5bb80$05813280$@d-silva.org> <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
Content-Language: en-au
Sender: linux-kernel-owner@vger.kernel.org
To: 'David Laight' <David.Laight@ACULAB.COM>, 'Petr Mladek' <pmladek@suse.com>
Cc: 'Alastair D'Silva' <alastair@au1.ibm.com>, 'Jani Nikula' <jani.nikula@linux.intel.com>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'David Airlie' <airlied@linux.ie>, 'Daniel Vetter' <daniel@ffwll.ch>, 'Karsten Keil' <isdn@linux-pingi.de>, 'Jassi Brar' <jassisinghbrar@gmail.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'Benson Leung' <bleung@chromium.org>, 'Enric Balletbo i Serra' <enric.balletbo@collabora.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: David Laight <David.Laight@ACULAB.COM>
> Sent: Monday, 15 April 2019 8:21 PM
> To: 'Alastair D'Silva' <alastair@d-silva.org>; 'Petr Mladek'
> <pmladek@suse.com>
> Cc: 'Alastair D'Silva' <alastair@au1.ibm.com>; 'Jani Nikula'
> <jani.nikula@linux.intel.com>; 'Joonas Lahtinen'
> <joonas.lahtinen@linux.intel.com>; 'Rodrigo Vivi' =
<rodrigo.vivi@intel.com>;
> 'David Airlie' <airlied@linux.ie>; 'Daniel Vetter' <daniel@ffwll.ch>; =
'Karsten
> Keil' <isdn@linux-pingi.de>; 'Jassi Brar' <jassisinghbrar@gmail.com>; =
'Tom
> Lendacky' <thomas.lendacky@amd.com>; 'David S. Miller'
> <davem@davemloft.net>; 'Jose Abreu' <Jose.Abreu@synopsys.com>; 'Kalle
> Valo' <kvalo@codeaurora.org>; 'Stanislaw Gruszka' =
<sgruszka@redhat.com>;
> 'Benson Leung' <bleung@chromium.org>; 'Enric Balletbo i Serra'
> <enric.balletbo@collabora.com>; 'James E.J. Bottomley'
> <jejb@linux.ibm.com>; 'Martin K. Petersen' =
<martin.petersen@oracle.com>;
> 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>; 'Alexander Viro'
> <viro@zeniv.linux.org.uk>; 'Sergey Senozhatsky'
> <sergey.senozhatsky@gmail.com>; 'Steven Rostedt'
> <rostedt@goodmis.org>; 'Andrew Morton' <akpm@linux-foundation.org>;
> intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; =
linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> hex_dump_to_buffer with flags
>=20
> From: Alastair D'Silva
> > Sent: 15 April 2019 11:07
> ...
> > In the above example the author only wants the hex output, while in
> > other situations, both hex & ASCII output is desirable. If you just
> > want ASCII output, the caller should just use a printk or one of =
it's
> wrappers.
>=20
> Hexdump will 'sanitise' the ASCII.
>=20

This is functionality that doesn't exist in the current hexdump =
implementation (you always get the hex version).

I think a better option would be to factor out the sanitisation and =
expose that as a separate function.

> Although I think you'd want a 'no hex' flag to suppress the hex.
>=20
> Probably more useful flags are ones to suppress the address column.

This is already supported by the prefix_type parameter - are you =
proposing that we eliminate the parameter & combine it with flags?

> I've also used flags to enable (or disable) suppression of multiple =
lines of
> zeros of constant bytes.
> In that case you may want hexdump to return the flags for the next =
call when
> a large buffer is being dumped in fragments.
=20
I'm afraid I don't quite follow here, hex_dump_to_buffer doesn't alter =
the flags, so the caller already knows it.=20

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
