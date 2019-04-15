From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date: Mon, 15 Apr 2019 21:12:15 +1000
Message-ID: <0dcb01d4f37c$17b948a0$472bd9e0$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz> <093301d4f187$da0756a0$8e1603e0$@d-silva.org> <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz> <0da301d4f373$01d5bb80$05813280$@d-silva.org> <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com> <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org> <42fb90eb9c8f4ede8a56a09be90218e3@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <42fb90eb9c8f4ede8a56a09be90218e3@AcuMS.aculab.com>
Content-Language: en-au
Sender: netdev-owner@vger.kernel.org
To: 'David Laight' <David.Laight@ACULAB.COM>, 'Petr Mladek' <pmladek@suse.com>
Cc: 'Alastair D'Silva' <alastair@au1.ibm.com>, 'Jani Nikula' <jani.nikula@linux.intel.com>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'David Airlie' <airlied@linux.ie>, 'Daniel Vetter' <daniel@ffwll.ch>, 'Karsten Keil' <isdn@linux-pingi.de>, 'Jassi Brar' <jassisinghbrar@gmail.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'Benson Leung' <bleung@chromium.org>, 'Enric Balletbo i Serra' <enric.balletbo@collabora.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: David Laight <David.Laight@ACULAB.COM>
> Sent: Monday, 15 April 2019 9:04 PM
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
> > Sent: 15 April 2019 11:45
> ...
> > > Although I think you'd want a 'no hex' flag to suppress the hex.
> > >
> > > Probably more useful flags are ones to suppress the address =
column.
> >
> > This is already supported by the prefix_type parameter - are you
> > proposing that we eliminate the parameter & combine it with flags?
>=20
> I was looking at the flags on one of my hexdump() functions...
>=20
> > > I've also used flags to enable (or disable) suppression of =
multiple
> > > lines of zeros of constant bytes.
> > > In that case you may want hexdump to return the flags for the next
> > > call when a large buffer is being dumped in fragments.
> >
> > I'm afraid I don't quite follow here, hex_dump_to_buffer doesn't =
alter
> > the flags, so the caller already knows it.
>=20
> If you are suppressing lines of zeros and dumping a buffer in several =
blocks
> then subsequent calls need to know that the last line of the previous =
call was
> suppressed zeros - and carry on with the same suppressed block.

Why wouldn't you do this with a single call to print_hex_dump? (that is =
where the repeated lines are suppressed)

That will already take chunks of the buffer until the whole thing is =
output, in what situation do you see a caller chunking the access =
themselves?

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
