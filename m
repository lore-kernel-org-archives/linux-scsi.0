From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Tue, 3 Feb 2015 11:18:09 -0500
Message-ID: <20150203161809.GG19463@htj.dyndns.org>
References: <1422900439-5541-1-git-send-email-stripathi@apm.com>
 <1422900439-5541-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422900439-5541-2-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 02, 2015 at 11:37:19PM +0530, Suman Tripathi wrote:
> This patch addresses the issue with ATA_CMD_SMART pio mode
> command for enumeration and device detection with ATA devices.
> The X-Gene AHCI controller has an errata in which it cannot clear
> the BSY bit after the PIO setup FIS. The dma state machine enters
> CMFatalErrorUpdate state and locks up. It is the same issue as
> in the commit 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016 (ahci-xgene:

The right format is 2a0bdff6b958 ("ahci-xgene: fix the dma state
machine lockup for the IDENTIFY DEVICE PIO mode command").

> fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
> command).
> 
> For example :  without this patch it results in READ DMA command failure
> as shown below :
> 
>  [  126.700072] ata2.00: exception Emask 0x0 SAct 0x0
> 		SErr 0x0 action 0x6 frozen
>  [  126.707089] ata2.00: failed command: READ DMA
>  [  126.711426] ata2.00: cmd c8/00:08:00:55:57/00:00:00:00:00/e1 tag 1
>                 dma 4096 in
>  [  126.711426]  res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
> 		0x4 (timeout)
>  [  126.725956] ata2.00: status: { DRDY }
> 
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> Reported-by:   Mark Langsdorf <mlangsdo@redhat.com>

Applied to libata/for-3.19-fixes.

Thanks.

-- 
tejun
