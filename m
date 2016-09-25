From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/3] g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio
Date: Sun, 25 Sep 2016 16:55:42 -0700
Message-ID: <20160925235542.GD7312@infradead.org>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org>
 <1474832360-23261-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474832360-23261-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 25, 2016 at 09:39:20PM +0200, Ondrej Zary wrote:
> Merge the PIO and MMIO code (with the help of ioport_map) in g_NCR5380 and
> delete g_NCR5380_mmio.

Awesome!  this looks great to me, but we probably should thrown
in a MODULE_ALIAS for g_NCR5380_mmio so that existing module
configurations keep working.

>  #define NCR5380_read(reg) \
> +	ioread8(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
> +		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
> +		(reg))
>  #define NCR5380_write(reg, value) \
> -	outb(value, instance->io_port + (reg))
> +	iowrite8(value, ((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
> +		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
> +		(reg))

Can we make these #defines point to inline helper functions that avoid
the casting magic, e.g. something like

static inline void g_NCR5380_write(struct Scsi_Host *instance, u32 reg,
		u8 value)
{
	struct NCR5380_hostdata *host = shost_priv(instance);

	iowrite8(value, host->iomem, host->offset + reg);
}

#define NCR5380_write(reg, value)
	g_NCR5380_write(instance, reg, value)
