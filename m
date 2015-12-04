From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Fri, 4 Dec 2015 19:38:03 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512041857160.13680@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org> <CAGRGNgU=6=XBGxpwe+Z+uU-Pq-L=aTyG2GukkWAqFVnJHTY3Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGRGNgU=6=XBGxpwe+Z+uU-Pq-L=aTyG2GukkWAqFVnJHTY3Og@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Fri, 4 Dec 2015, Julian Calaby wrote:

> > -               if (overrides[current_override].board == BOARD_NCR53C400A) {
> > +               if (overrides[current_override].board == BOARD_NCR53C400A ||
> > +                   overrides[current_override].board == BOARD_DTC3181E) {
> 
> These if statements are starting to get a bit long, would it make
> sense to replace them with a flag or equivalent?

To what end? Shorter lines? As in,

	if (board_is_ncr53c400a || board_is_dtc3181e) {
		/* ... */
	}

I suppose that could be an improvement if new flags would entirely replace 
the override.board struct member and the existing switch statement,

	switch (overrides[current_override].board) {
		/* ... */
	}

Or maybe you meant testing a new flag something like this,

	if (hostdata->ncr53c400_compatible) {
		/* ... */
	}

If your concern is the Don't Repeat Yourself rule, I'm not sure that new 
flag would get tested more than once (?) And it would still have to be 
assigned using an "objectionably" long expression, e.g.

	hostdata->ncr53c400_compatible =
		overrides[current_override].board == BOARD_NCR53C400 ||
		overrides[current_override].board == BOARD_NCR53C400A ||
		overrides[current_override].board == BOARD_DTC3181E;

Rather than add new flags, perhaps a 'switch' statement instead of an 'if' 
statement would be shorter (if the size of the expression is the problem).

-- 
