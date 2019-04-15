From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date: Mon, 15 Apr 2019 20:29:08 +1000
Message-ID: <0dad01d4f376$113df2b0$33b9d810$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-2-alastair@au1.ibm.com>
 <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
 <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org>
 <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz>
Content-Language: en-au
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: 'Petr Mladek' <pmladek@suse.com>
Cc: linux-fbdev@vger.kernel.org, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'David Airlie' <airlied@linux.ie>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, 'Jassi Brar' <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, 'Jani Nikula' <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, 'Steven Rostedt' <rostedt@goodmis.org>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'Benson Leung' <bleung@chromium.org>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Karsten Keil' <isdn@linux-pingi.de>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>, linux-wireless@vger.kernel.
List-Id: linux-scsi@vger.kernel.org

<snip>
> > > On Wed 2019-04-10 13:17:17, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > >
> > > > With modern high resolution screens, we can display more data,
> > > > which makes life a bit easier when debugging.
> > >
> > > I have quite some doubts about this feature.
> > >
> > > We are talking about more than 256 characters per-line. I wonder if
> > > such a long line is really easier to read for a human.
> >
> > It's basically 2 separate panes of information side by side, the
> > hexdump and the ASCII version.
> >
> > I'm using this myself when dealing with the pmem labels, and it works
> > quite nicely.
> 
> I am sure that it works for you. But I do not believe that it would be
useful in
> general.

I do, and I believe the choice of the output length should be in the hands
of the caller.

On further thought, it would make more sense to remove the hardcoded list of
sizes and just enforce a power of 2. The function shouldn't dictate what the
caller can and can't do beyond the technical limits of it's implementation.

Other print/debug functions don't restrict the output size, and I can't see
a good justification why hexdump should either.

> > > I am not expert but there is a reason why the standard is 80
> > > characters
> > per-
> > > line. I guess that anything above 100 characters is questionable.
> > > https://en.wikipedia.org/wiki/Line_length
> > > somehow confirms that.
> > >
> > > Second, if we take 8 pixels per-character. Then we need
> > > 2048 to show the 256 characters. It is more than HD.
> > > IMHO, there is still huge number of people that even do not have HD
> > display,
> > > especially on a notebook.
> >
> > The intent is to make debugging easier when dealing with large chunks
> > of binary data. I don't expect end users to see this output.
> 
> How is it supposed to be used then? Only by your temporary patches?

Let me rephrase that, I don't expect end users to *use* this data.

Current usage of the hexdump functions are predominantly centred around
logging and debugging, and clearly targeted at someone intimately familiar
with the relevant subsystem. I expect future use would be similar.

Debugging may be as part of active development, or from a log supplied from
an end user. In either case, it should be up to the author (as a
representative for the consumers of the data) to decide how it should be
formatted.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
