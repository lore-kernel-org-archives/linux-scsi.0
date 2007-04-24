From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Tue, 24 Apr 2007 07:42:11 -0600
Message-ID: <20070424134211.GC32449@parisc-linux.org>
References: <20070423.151322.111205472.davem@davemloft.net> <20070424122235.GA26242@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33971 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422653AbXDXNmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 09:42:14 -0400
Content-Disposition: inline
In-Reply-To: <20070424122235.GA26242@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org

On Tue, Apr 24, 2007 at 01:22:35PM +0100, Christoph Hellwig wrote:
> > +static void esp_build_sync_msg(struct esp *esp, u8 period, u8 offset)
> >  {
> > +	esp->msg_out[0] = EXTENDED_MESSAGE;
> > +	esp->msg_out[1] = 3;
> > +	esp->msg_out[2] = EXTENDED_SDTR;
> > +	esp->msg_out[3] = period;
> > +	esp->msg_out[4] = offset;
> > +	esp->msg_out_len = 5;
> > +}
> >  
> > +static void esp_build_wide_msg(struct esp *esp, int wide)
> > +{
> > +	esp->msg_out[0] = EXTENDED_MESSAGE;
> > +	esp->msg_out[1] = 2;
> > +	esp->msg_out[2] = EXTENDED_WDTR;
> > +	esp->msg_out[3] = (wide ? 1 : 0);
> > +	esp->msg_out_len = 4;
> >  }
> 
> These might actually be worth putting into the spi transport
> class, taking an u8 * as first argument.  After all all
> SPI drivers without smart firmware will need them.

Already done -- spi_populate_sync_msg, spi_populate_width_msg and
spi_populate_ppr_msg.

> (the lundata management looks inspired by sym53c8xx, but it's probably
>  not the best driver to be inspired by :))

*cough*.

> > +static int esp_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> 
> It would be nice to call this esp_queuecommand to match the name of
> the method.
> 
> > +{
> > +	struct scsi_device *dev = cmd->device;
> > +	struct esp *esp = host_to_esp(dev->host);
> > +	struct esp_cmd_priv *spriv;
> > +	struct esp_cmd_entry *ent;
> >  
> > +	cmd->scsi_done = done;
> >  
> > +	if (dev->id == esp->scsi_id) {
> > +		cmd->result = DID_NO_CONNECT << 16;
> > +		cmd->scsi_done(cmd);
> > +		return 0;
> > +	}
> 
> This can't happen, no need to check for it.  (And yes, I know some
> drivers like sym53x8xx still have the checks despite me submitting
> patches to get rid of it)

I think the last time you sent me a patch to get rid of that is was part
of a larger patchset and the whole thing failed to work.

