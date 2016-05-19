From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: Re: [PATCH] scsi: ultrastor.c depends on ISA_DMA_API
Date: Thu, 19 May 2016 15:14:00 -0400
Message-ID: <20160519191400.GA16573@sophia>
References: <20160519164501.4cc8bc4f@canb.auug.org.au>
 <573DFE8B.2070808@infradead.org>
 <20160519185335.GA18253@sophia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160519185335.GA18253@sophia>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 19, 2016 at 02:53:35PM -0400, William Breathitt Gray wrote:
>Although request_dma and free_dma are conditionally dependent on
>CONFIG_ISA_DMA_API inside the arch/x86/include/asm/dma.h file, they are
>defined inside the kernel/dma.c file which depends on
>CONFIG_GENERIC_ISA_DMA in order to build on X86. Therefore,
>GENERIC_ISA_DMA should be in the depends line for SCSI_ULTRASTOR instead
>of ISA_DMA_API.
>
>William Breathitt Gray

My apologies, I was too quick to send and didn't realize
CONFIG_GENERIC_ISA_DMA is "def_bool y" in X86. In that case, ISA_DMA_API
should suffice; thus the line becomes:

    depends X86 && SCSI && ISA_DMA_API

William Breathitt Gray
