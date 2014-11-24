From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 2/3] wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver
Date: Mon, 24 Nov 2014 21:34:43 +0100
Message-ID: <201411242134.43508.linux@rainbow-software.org>
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org> <1416831074-24282-3-git-send-email-linux@rainbow-software.org> <54732F83.6070306@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54732F83.6070306@suse.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Monday 24 November 2014 14:15:47 Hannes Reinecke wrote:
> On 11/24/2014 01:11 PM, Ondrej Zary wrote:
> > Introduce wd719x, a driver for Western Digital WD7193, WD7197 and WD7296
> > PCI SCSI controllers based on WD33C296A chip.
> > Tested with WD7193 card.
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

[...]

> > +	result = wd719x_send_scb(scb);
> > +	if (result != DID_OK) {
> > +		dev_warn(&wd->pdev->dev, "can't queue SCB\n");
> > +		wd719x_finish_cmd(cmd, result);
> > +	}
> > +
> > +	spin_unlock_irqrestore(wd->sh->host_lock, flags);
> > +
> > +	return 0;
> > +}
>
> Why did you use 'wait_ready' here?
> Any sane HBA driver should set the queue depth parameters
> correctly to avoid this from happening.
> Wouldn't it be far better to just return HOST_BUSY here if
> the command register isn't free and submit the command
> directly otherwise?

It probably comes from the original driver. Will send a new version.

-- 
Ondrej Zary
