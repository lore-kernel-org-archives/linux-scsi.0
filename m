From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] fdomain: Resurrect driver (core)
Date: Tue, 23 Apr 2019 23:02:12 -0700
Message-ID: <20190424060212.GA5506@infradead.org>
References: <20190422173323.15365-1-linux@zary.sk>
 <20190422173323.15365-2-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190422173323.15365-2-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +/* FIFO_COUNT: The host adapter has an 8K cache (host adapters based on the
> + * 18C30 chip have a 2k cache).  When this many 512 byte blocks are filled by
> + * the SCSI device, an interrupt will be raised.  Therefore, this could be as
> + * low as 0, or as high as 16.  Note, however, that values which are too high
> + * or too low seem to prevent any interrupts from occurring, and thereby lock
> + * up the machine.
> + */

Normally we use

/*
 * ...
 */

style comments.  I'm not sure it is worth bothering to change it in this
driver, though.

> +		cmd->SCp.ptr += len;
> +		cmd->SCp.this_residual -= len;
> +		if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
> +			--cmd->SCp.buffers_residual;
> +			++cmd->SCp.buffer;
> +			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);

This isn't safe on highmem systems.  At very least we need a depends on
!HIGHMEM for the drivers selecting this core driver.  If you feel like
doing the work it should use scsi_kmap_atomic_sg and
scsi_kunmap_atomic_sg.

> +static void fdomain_work(struct work_struct *work)
> +{
> +	struct fdomain *fd = container_of(work, struct fdomain, work);
> +	struct Scsi_Host *sh = container_of((void *)fd, struct Scsi_Host,
> +					    hostdata);

This looks odd.  We should never need a void cast for container_of.

> +	/* Abort calls fdomain_finish_cmd, so we do nothing here. */
> +	if (cmd->SCp.phase & aborted)
> +		;

This is a no-op..

> +	if (fd->chip == tmc1800 && !cmd->SCp.have_data_in
> +	    && (cmd->SCp.sent_command >= cmd->cmd_len)) {

&& goes on the first line, no need for the inner braces on the second
line.

> +int fdomain_host_reset(struct scsi_cmnd *cmd)

Should be static.

> +struct scsi_host_template fdomain_template = {

Should be marked const.

> +	if (fdomain_test_loopback(base))
> +		return NULL;
> +
> +	if (!irq) {
> +		if (dev_is_pci(dev)) {
> +			dev_err(dev, "PCI card has no IRQ assigned");
> +			return NULL;
> +		}
> +		irq = irqs[(inb(base + Configuration1) & 0x0e) >> 1];

The irqs lookup should probably go into the callers that need it.

> +	else if (sig && (sig->bios_major > 0) &&

No need for the inner braces.

> +EXPORT_SYMBOL(fdomain_create);

EXPORT_SYMBOL_GPL for internals like this and fdomain_destroy.
