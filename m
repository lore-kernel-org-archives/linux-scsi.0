From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 14 Apr 2006 17:33:27 -0500
Message-ID: <1145054008.3520.69.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23773 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965183AbWDNWde (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 18:33:34 -0400
In-Reply-To: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Sebastian Frei <Sebastian@schnapsleichen.de>, Fredrik Roubert <roubert@df.lth.se>, lenehan@twibble.org

On Sun, 2006-04-02 at 21:57 +0200, Guennadi Liakhovetski wrote:
> +                               if (fc == 0x40 &&
> (srb->dcb->sync_period & WIDE_SYNC)) {
> +                                       /* Read the last byte ... */
> +                                       if (srb->total_xfer_length >
> 0) {
> +                                               u8 byte =
> DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
> +
> +                                               *virt++ = byte;
> +                                               srb->total_xfer_length--;
> +                                               if
> (debug_enabled(DBG_PIO))
> +                                                       printk(" %
> 02x", byte);
> +                                       }
> +
> +                                       DC395x_write8(acb,
> TRM_S1040_SCSI_CONFIG2, 0);
> +                               }
> +
> +                               if (srb->cmd->use_sg) {
> +                                       scsi_kunmap_atomic_sg(base);

I put this in, but just a warning here.  You're modifying a kmapped
page, so you need to call flush_kernel_dcache_page() before unmapping it
otherwise user space may not see the change on VIPT or VIVT CPU (the
data may be in a non congruent cache line).

James


