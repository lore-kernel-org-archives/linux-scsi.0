From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: wd719x Replace GFP_KERNEL with GFP_ATOMIC in
 wd719x_chip_init
Date: Mon, 14 Jan 2019 07:29:43 -0800
Message-ID: <20190114152943.GA10454@infradead.org>
References: <1547479489-11560-1-git-send-email-wdjjwb@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547479489-11560-1-git-send-email-wdjjwb@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: wangbo <wdjjwb@163.com>
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wang.bo116@zte.com.cn, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 14, 2019 at 11:24:49PM +0800, wangbo wrote:
> wd719x_host_reset get spinlock first then call wd719x_chip_init,
> so replace GFP_KERNEL with GFP_ATOMIC in wd719x_chip_init.

Please move the allocation outside the lock instead.  GFP_ATOMIC
DMA allocations are generally a bad idea and should be avoided where
we can.

More importantly we should never actually trigger the allocation
under the lock as far as fw_virt will always be set already
in that case.

So I think you can safely move the request firmware + allocation
+ memcpy from wd719x_chip_init to wd719x_board_found, but I'd rather
have Ondrej review that plan.
