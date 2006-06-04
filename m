From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/5] ide: add cpu cache flushes after kmapping and modifying
 a page
Date: Sun, 04 Jun 2006 18:09:56 +0900
Message-ID: <4482A364.1050006@gmail.com>
References: <1149392479501-git-send-email-htejun@gmail.com> <1149392480987-git-send-email-htejun@gmail.com> <20060604081734.GA29696@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060604081734.GA29696@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, rmk@arm.linux.org.uk, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Jun 04, 2006 at 12:41:20PM +0900, Tejun Heo wrote:
>>  			data = bvec_kmap_irq(bvec, &flags);
>>  			drive->hwif->atapi_input_bytes(drive, data, count);
>> +			flush_kernel_dcache_page(kmap_atomic_to_page(data));
>>  			bvec_kunmap_irq(data, &flags);
> 
> shouldn't bvec_kunmap_irq do the flush_kernel_dcache_page call?
> 

Eventually, yes.  At the moment, not all archs implement 
flush_kernel_dcache_page(), so converting

	kmap();
	modify buffer;
	flush_dcache_page();
	kunmap();

to

	kmap_wrapper();
	modify buffer;
	kunmap_wrapper_which_calls_flush_kernel_dcache_page()

breaks cache coherency on those archs.  The current patches simply add 
calls to flush_kernel_dcache_page() where missing such that it doesn't 
break anything while fixing cache coherency for arm and parisc.  In the 
long term...

1. implement flush_kernel_dcache_page() for all needed archs
2. update kmap interface such that the caller is mandated to specify 
whether the buffer has been modified or not when unmapping (maybe 
addition of simple boolean argument?)
3. update bvec_kmap_*() similarly
4. update all calls to kunmap & friends.

Thanks.

-- 
tejun
