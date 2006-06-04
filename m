From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] SCSI: add cpu cache flushes after kmapping and modifying a page
Date: Sun, 4 Jun 2006 09:20:35 +0100
Message-ID: <20060604082035.GB29696@infradead.org>
References: <1149392479501-git-send-email-htejun@gmail.com> <11493924803460-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932154AbWFDIUp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11493924803460-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, rmk@arm.linux.org.uk, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 04, 2006 at 12:41:20PM +0900, Tejun Heo wrote:
>  			local_irq_save(flags);
>  			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
>  			memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
> +			flush_kernel_dcache_page(kmap_atomic_to_page(buf - sg->offset));
>  			kunmap_atomic(buf - sg->offset, KM_IRQ0);
>  			local_irq_restore(flags);

all these should switch to scsi_kmap_atomic_sg which should do the
flush_kernel_dcache_page call for you.
