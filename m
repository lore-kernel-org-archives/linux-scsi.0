From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date: Sat, 13 Apr 2019 09:22:05 +1000
Message-ID: <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-2-alastair@au1.ibm.com> <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
Content-Language: en-au
Sender: linux-kernel-owner@vger.kernel.org
To: 'Petr Mladek' <pmladek@suse.com>
Cc: 'Jani Nikula' <jani.nikula@linux.intel.com>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'David Airlie' <airlied@linux.ie>, 'Daniel Vetter' <daniel@ffwll.ch>, 'Karsten Keil' <isdn@linux-pingi.de>, 'Jassi Brar' <jassisinghbrar@gmail.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'Benson Leung' <bleung@chromium.org>, 'Enric Balletbo i Serra' <enric.balletbo@collabora.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Friday, 12 April 2019 11:48 PM
> To: Alastair D'Silva <alastair@au1.ibm.com>
> Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> David S. Miller <davem@davemloft.net>; Jose Abreu
> <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> Andrew Morton <akpm@linux-foundation.org>; intel-
> gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
> 
> On Wed 2019-04-10 13:17:17, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > With modern high resolution screens, we can display more data, which
> > makes life a bit easier when debugging.
> 
> I have quite some doubts about this feature.
> 
> We are talking about more than 256 characters per-line. I wonder if such a
> long line is really easier to read for a human.

It's basically 2 separate panes of information side by side, the hexdump and
the ASCII version.

I'm using this myself when dealing with the pmem labels, and it works quite
nicely.

> 
> I am not expert but there is a reason why the standard is 80 characters
per-
> line. I guess that anything above 100 characters is questionable.
> https://en.wikipedia.org/wiki/Line_length
> somehow confirms that.
> 
> Second, if we take 8 pixels per-character. Then we need
> 2048 to show the 256 characters. It is more than HD.
> IMHO, there is still huge number of people that even do not have HD
display,
> especially on a notebook.

The intent is to make debugging easier when dealing with large chunks of
binary data. I don't expect end users to see this output.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
