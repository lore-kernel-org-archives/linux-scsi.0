From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Tue, 24 Apr 2007 09:53:29 -0400
Message-ID: <1177422810.6284.67.camel@mulgrave.il.steeleye.com>
References: <20070423.151322.111205472.davem@davemloft.net>
	 <20070424122235.GA26242@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070424122235.GA26242@infradead.org>
Sender: sparclinux-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-04-24 at 13:22 +0100, Christoph Hellwig wrote:
> > +static void esp_build_sync_msg(struct esp *esp, u8 period, u8
> offset)
> >  {
> > +     esp->msg_out[0] = EXTENDED_MESSAGE;
> > +     esp->msg_out[1] = 3;
> > +     esp->msg_out[2] = EXTENDED_SDTR;
> > +     esp->msg_out[3] = period;
> > +     esp->msg_out[4] = offset;
> > +     esp->msg_out_len = 5;
> > +}
> >  
> > +static void esp_build_wide_msg(struct esp *esp, int wide)
> > +{
> > +     esp->msg_out[0] = EXTENDED_MESSAGE;
> > +     esp->msg_out[1] = 2;
> > +     esp->msg_out[2] = EXTENDED_WDTR;
> > +     esp->msg_out[3] = (wide ? 1 : 0);
> > +     esp->msg_out_len = 4;
> >  }
> 
> These might actually be worth putting into the spi transport
> class, taking an u8 * as first argument.  After all all
> SPI drivers without smart firmware will need them.

This was going to be my comment ... they're already there:

int spi_populate_width_msg(unsigned char *msg, int width);
int spi_populate_sync_msg(unsigned char *msg, int period, int offset);
int spi_populate_ppr_msg(unsigned char *msg, int period, int offset, int width,
		int options);

James


