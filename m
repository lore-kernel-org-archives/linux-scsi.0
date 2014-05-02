From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 16/16] arcmsr: support new adapter ARC12x4
Date: Fri, 2 May 2014 12:34:18 +0300
Message-ID: <20140502093418.GH4963@mwanda>
References: <1398858378.6930.67.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398858378.6930.67.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 30, 2014 at 07:46:18PM +0800, ching wrote:
> +	acb->pmuD = reg;
> +	reg->chip_id = (u32 __iomem *)((unsigned long)acb->mem_base0 +
> +		ARCMSR_ARC1214_CHIP_ID);
> +	reg->cpu_mem_config = (u32 __iomem *)((unsigned long)
> +		acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);

These casts aren't needed because acb->mem_base0 is a void __iomem *.
You could just do:

	reg->cpu_mem_config = acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION;

Or you could change ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION to:

#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION(acb) (acb->mem_base0 + 0x00008)

So it would be:

	reg->cpu_mem_config = ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION(acb);


> +	reg->i2o_host_interrupt_mask = (u32 __iomem *)((unsigned long)
> +		acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
> +	reg->sample_at_reset = (u32 __iomem *)((unsigned long)
> +		acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);
> +	reg->reset_request = (u32 __iomem *)((unsigned long)

regards,
dan carpenter
