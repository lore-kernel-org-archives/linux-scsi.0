From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] ide: add cpu cache flushes after kmapping and modifying a page
Date: Sun, 4 Jun 2006 09:17:34 +0100
Message-ID: <20060604081734.GA29696@infradead.org>
References: <1149392479501-git-send-email-htejun@gmail.com> <1149392480987-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1149392480987-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, rmk@arm.linux.org.uk, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 04, 2006 at 12:41:20PM +0900, Tejun Heo wrote:
>  			data = bvec_kmap_irq(bvec, &flags);
>  			drive->hwif->atapi_input_bytes(drive, data, count);
> +			flush_kernel_dcache_page(kmap_atomic_to_page(data));
>  			bvec_kunmap_irq(data, &flags);

shouldn't bvec_kunmap_irq do the flush_kernel_dcache_page call?

