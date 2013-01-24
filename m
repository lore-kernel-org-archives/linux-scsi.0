From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/13] sg_io: reorganize list of allowed commands
Date: Thu, 24 Jan 2013 14:42:03 -0800
Message-ID: <20130124224203.GA2373@mtj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1359039649-17734-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 24, 2013 at 04:00:38PM +0100, Paolo Bonzini wrote:
> +#define sgio_bitmap_set(cmd, mask, rw) \
> +	if ((mask) != 0) __set_bit((cmd), filter->rw##_ok)
> +
> +#define D (1u << TYPE_DISK)           /* Direct Access Block Device (SBC-3) */
> +#define T (1u << TYPE_TAPE)           /* Sequential Access Device (SSC-3) */
> +#define L (1u << TYPE_PRINTER)        /* Printer Device (SSC) */
> +#define P (1u << TYPE_PROCESSOR)      /* Processor Device (SPC-2) */
> +#define W (1u << TYPE_WORM)           /* Write Once Block Device (SBC) */
> +#define R (1u << TYPE_ROM)            /* C/DVD Device (MMC-6) */
> +#define S (1u << TYPE_SCANNER)        /* Scanner device (obsolete) */
> +#define O (1u << TYPE_MOD)            /* Optical Memory Block Device (SBC) */
> +#define M (1u << TYPE_MEDIUM_CHANGER) /* Media Changer Device (SMC-3) */
> +#define C (1u << TYPE_COMM)           /* Communication devices (obsolete) */
> +#define A (1u << TYPE_RAID)           /* Storage Array Device (SCC-2) */
> +#define E (1u << TYPE_ENCLOSURE)      /* SCSI Enclosure Services device (SES-2) */
> +#define B (1u << TYPE_RBC)            /* Simplified Direct-Access (Reduced Block) device (RBC) */
> +#define K (1u << 0x0f)                /* Optical Card Reader/Writer device (OCRW) */
> +#define V (1u << 0x10)                /* Automation/Device Interface device (ADC-2) */

Can we please add TYPE_* constants for these two too?

> +#define F (1u << TYPE_OSD)            /* Object-based Storage Device (OSD-2) */
> +
> +	/* control, universal except possibly RBC, read */
> +
> +	sgio_bitmap_set(0x00, -1                             , read);  // TEST UNIT READY

Hmmm... why are we not using symbolic constants for commands?  If it's
because of horizontal real estate, we can abbreviate
sgio_bitmap_set(), no?  Also, wouldn't it be better to have ALL
instead of -1?  Also, the custom formatting is nice but can we at
least not use //?

One other thing is I would much prefer if the table was made static
const first.  As we only allow compile-time defined tables, there's no
point in dynamically initializing these and the above can be static
initializers.

Thanks.

-- 
tejun
