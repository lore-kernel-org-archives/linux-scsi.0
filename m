From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: [SCSI] sun3x_esp: convert to esp_scsi
Date: Sun, 10 Feb 2008 10:38:15 +0100
Message-ID: <1202636295.2814.31.camel@kars.perseus.home>
References: <200802080259.m182xDkb014716@hera.kernel.org>
	 <Pine.LNX.4.64.0802080932220.18242@anakin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47656 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYBJKSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 05:18:53 -0500
In-Reply-To: <Pine.LNX.4.64.0802080932220.18242@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On vr, 2008-02-08 at 09:33 +0100, Geert Uytterhoeven wrote:
> On Fri, 8 Feb 2008, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0bb67f181834044db6e9b15c7d5cc3cce0489bfd
> > Commit:     0bb67f181834044db6e9b15c7d5cc3cce0489bfd
> > Parent:     f8d9d654fcc7dd87f5d0b222e233eaab15d650c4
> > Author:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > AuthorDate: Fri Feb 1 00:13:34 2008 +0100
> > Committer:  James Bottomley <James.Bottomley@HansenPartnership.com>
> > CommitDate: Thu Feb 7 18:02:33 2008 -0600
> > 
> >     [SCSI] sun3x_esp: convert to esp_scsi
> >     
> >     Converted sun3x_esp driver to use esp_scsi.c
> >     
> >     Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/Kconfig     |    1 +
> >  drivers/scsi/Makefile    |    2 +-
> >  drivers/scsi/sun3x_esp.c |  708 +++++++++++++++++++++-------------------------
> >  3 files changed, 318 insertions(+), 393 deletions(-)
> 
> But the first one is back! Thank you, Thomas!

Thomas, can't you use ioreadxx() and friends instead of rolling your own
memory mapped I/O handlers? readxx() and friends are only to be used on
PCI-like buses.

Unfortunately, a simple conversion like this didn't work for me on the
Blizzard SCSI IV. The driver gets stuck when probing devices:

esp: esp0, regs[80ea8000:80eb0000] irq[2]
esp: esp0 is a 53CF94/96-2, 40 MHz (ccf=0), SCSI ID 7
scsi0 : esp
ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
ESP: start data addr[78e76590] len[36] write(1)
ESP: data done flgs[1] sent[36]
ESP: Command done status[0] message[0]
ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 86 00 ]
ESP: start data addr[78e76590] len[134] write(1)
ESP: data done flgs[1] sent[134]
ESP: Command done status[0] message[0]
scsi 0:0:0:0: Direct-Access     QUANTUM  FIREBALL_TM2110S 300N PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 86 00 ]
ESP: Got msgin byte 4
ESP: Disconnecting tgt[0] tag[20:0]
ESP: reconnect tag, IRQ(0:10:97), <3>esp: esp0: Reconnect IRQ2 timeout
ESP: esp_schedule_reset() from 00127ad2
 target0:0:0: Domain Validation Initial Inquiry Failed
 target0:0:0: Ending Domain Validation
ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
ESP: Got msgin byte 7
ESP: Sending message [ 06 ]
...
ESP: Got msgin byte 7
ESP: Sending message [ 06 ]
...

The "Reconnect IRQ2 timeout" thing seemed wrong, so I modified it to
never timeout there (perhaps the timer was a bit short on m68k). This
causes it to get completely stuck, so the chip is apparently not in the
mood to generate any interrupt ever. I wonder whether this is because a
DMA operation is done with only 2 bytes...
The Blizzard DMA engine is rather simplistic (no byte counters). It's
also undocumented.

The old driver used to use PIO for small transfers (like message in and
SCSI commands). David, any ideas on this?


Kind regards,

Kars.


