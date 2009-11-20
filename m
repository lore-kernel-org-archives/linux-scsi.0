From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: add TRIM support
Date: Fri, 20 Nov 2009 12:46:24 +0000
Message-ID: <20091120124624.63ac0b9a@lxorguk.ukuu.org.uk>
References: <20091116154343.GA6672@infradead.org>
	<4B02AD86.8010304@rtr.ca>
	<20091117143507.GC588@infradead.org>
	<20091117145239.768072c9@lxorguk.ukuu.org.uk>
	<20091117150012.GA10748@infradead.org>
	<4B04BD01.5090706@rtr.ca>
	<20091119102346.3c656b99@lxorguk.ukuu.org.uk>
	<4B0554A2.9060404@rtr.ca>
	<4B05DE00.3020707@gmail.com>
	<20091120001829.354abfc0@lxorguk.ukuu.org.uk>
	<4B05E3D1.1000904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B05E3D1.1000904@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Mark Lord <liml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

> > For those that pee themselves you don't need a host flag, you need a
> > qc_issue hook - you need that hook for the purpose of actually making the
> > command work, so in the short term making it just return AC_ERR_DEV isn't
> > exactly hard. Not having the flag and fixing those odd few drivers would
> > be far more productive.
> 
> We are talking about chips whose command set is essentially fixed at 
> manufacture time.

There are only two of those I know of
- IT821x which already uses qc_issue to filter.
- pata_st412, which uses qc_issue and isn't in tree anyway and probably
  never will be.

The SIL ones jut need babysitting. The older Promise at least only snoop
SET_FEATURES and the transfer lengths for some DMA ops. We disable the
features snooping (its there to make driverless windows stuff work well I
assume), and we babysit the transfer lengths for the chip as per the
documentation for issuing LBA48 etc.

> So the alternative is to create a table of known-working commands in 
> each driver, and fail all commands outside that table.  In the case of

For most drivers all commands just work. There are very few with command
tables. LBA48 confused some not because of command tables but because the
double load of the taskfile was a sequence they couldn't hack or because
they snooped the transfer length. The latter is kept correctly by the new
commands.

> SiI and Promise at least, I think that command table will be the same 
> (ATA-7 commands).

It's certainly not quite that simple. A table wouldn't be too bad for
just kernel issued commands as we don't issue very many but for the
general case it would not be pretty at all. The command list for SII is
btw not ATA-7 its a bit more complicated, which is another reason not to
do a command filter but to worry about feature sets we care about.

> At that point, whether it's a common function (is_ata7_command) or a 
> command flag (ATA_HFLAG_NO_NEW_COMMANDS) is largely a point of taste.

SII controllers support a subset of commands based on legacy (WD1010),
ATA and bits of CF. However they also support things like a subset of
smart commands and some extensions. That means a command table isn't
sufficient for the general case, you actually have to parse the features
field if you want to do every case right (ick ick ick)

You don't actually want to do that filtering on SII controllers
anyway because their default behaviour is to abort an unsupported command.
So it all "just works" because the stack sees an abort and assumes the
drive replied with command not supported status (see 10.3.4.2). The chip
designers got that one right.

The SII anyhow supports telling the controller the command behaviour
required, which means that a filter isn't what you need anyway. You need
to set up the command table to allow TRIM through. That means we don't
need a filter, the driver just needs enhancing to fix that quirk.

So who will actually use this flag ? Which other drivers have problems
in this area ? Rather than blindly implement a flag we need to work
through those that *actually* have a problem.

As far as I can see the TRIM stuff will just work as it is right now. The
problem controllers like the IT821x will return AC_ERR_DEV on qc_issue and
the SII controllers will fake a drive abort for command unknown. The
older Promise at least will handle the command.

Alan
