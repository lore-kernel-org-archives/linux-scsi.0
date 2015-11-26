From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/3] arcmsr: Split dma resource allocation to a new
 function
Date: Thu, 26 Nov 2015 11:46:14 -0800
Message-ID: <1448567174.18647.19.camel@perches.com>
References: <1448538075.10768.47.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448538075.10768.47.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-11-26 at 19:41 +0800, Ching Huang wrote:
> split dma resource allocation and io register assignment from get_config to a new function arcmsr_alloc_io_queue.

trivia:

> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
[]
> +static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
> +{
[]
> +		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
> +			&dma_coherent_handle, GFP_KERNEL);
> +		if (!dma_coherent){
> +			pr_notice("arcmsr%d: DMA allocation failed.\n", acb->host->host_no);
> +			return false;
> +		}
> +		memset(dma_coherent, 0, acb->roundup_ccbsize);
> 

There is a dma_zalloc_coherent

(and even more trivially)

Most all of your error messages don't use periods.
