From: Torsten Luettgert <ml-lkml@enda.eu>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
 746650160
Date: Mon, 13 Apr 2015 20:28:29 +0200
Message-ID: <20150413202829.580e3801@goldlack.schiller106>
References: <20150408183333.493607a3@goldlack.schiller106>
	<20150413174105.GA14988@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150413174105.GA14988@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 13 Apr 2015 19:41:05 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Can you run gdb on your vmlinux file and send the output of the
> following command in gdb
> 
> l *(scsi_dma_unmap+0x54)

Thanks for looking into it! Here is what gdb says:

Reading symbols
from /opt/kvm/bisect/vmlinux-3.16.0-74665016086615bb+...done.
(gdb) l *(scsi_dma_unmap+0x54)
0xffffffff8146a0b4 is in scsi_dma_unmap
(drivers/scsi/scsi_lib_dma.c:50).
45 struct device *dev = cmd->device->host->dma_dev;
46
47 dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
48 cmd->sc_data_direction);
49		}
50	}
51	EXPORT_SYMBOL(scsi_dma_unmap);

Regards,
Torsten
