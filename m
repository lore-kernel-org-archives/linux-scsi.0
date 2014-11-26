From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [hch-scsi-queue:drivers-for-3.19 174/180] drivers/scsi/wd719x.c:247:2: error: implicit declaration of function 'dma_cache_sync'
Date: Wed, 26 Nov 2014 18:32:48 +0100
Message-ID: <201411261832.48201.linux@rainbow-software.org>
References: <201411252333.lLEJOiQu%fengguang.wu@intel.com> <20141126102843.GB23189@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20141126102843.GB23189@lst.de>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 26 November 2014 11:28:43 Christoph Hellwig wrote:
> Hi sparc folks,
>
> any idea where the build error below comes from?  This new driver pulls
> in <linux/dma-mapping.h>, but still doesn't seem to get a prototype for
> dma_cache_sync on sparc64.

wd819x should probably depend on VIRT_TO_BUS? But that means it will not work 
on sparc. Is there a way to make it work? I have a sparc machine but haven't 
tested it.

> On Tue, Nov 25, 2014 at 11:42:38PM +0800, kbuild test robot wrote:
> > tree:   git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.19
> > head:   38d5c8336e60bf6e53a1da9586befe82fa75171b
> > commit: 48a31030066315a74e6c11153b4382edbf133bb3 [174/180] wd719x:
> > Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver config:
> > sparc64-allyesconfig (attached as .config)
> > reproduce:
> >   wget
> > https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin
> >/make.cross -O ~/bin/make.cross chmod +x ~/bin/make.cross
> >   git checkout 48a31030066315a74e6c11153b4382edbf133bb3
> >   # save the attached .config to linux build tree
> >   make.cross ARCH=sparc64
> >
> > All error/warnings:
> >
> >    drivers/scsi/wd719x.c: In function 'wd719x_queuecommand':
> > >> drivers/scsi/wd719x.c:247:2: error: implicit declaration of function
> > >> 'dma_cache_sync' [-Werror=implicit-function-declaration]
> >
> >      dma_cache_sync(&wd->pdev->dev, cmd->sense_buffer,
> >      ^
> >    cc1: some warnings being treated as errors
> >
> > vim +/dma_cache_sync +247 drivers/scsi/wd719x.c
> >
> >    241		memcpy(scb->CDB, cmd->cmnd, cmd->cmd_len);
> >    242
> >    243		/* map sense buffer */
> >    244		scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
> >    245		cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev,
> > cmd->sense_buffer, 246				SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> >
> >  > 247		dma_cache_sync(&wd->pdev->dev, cmd->sense_buffer,
> >
> >    248				SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> >    249		scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
> >    250
> >


-- 
Ondrej Zary
