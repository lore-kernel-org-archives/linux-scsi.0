Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A191CC433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 13:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 847DD206F0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 13:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgIANcp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 09:32:45 -0400
Received: from elvis.franken.de ([193.175.24.41]:45627 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgIANby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 09:31:54 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kD6NY-0001cg-00; Tue, 01 Sep 2020 15:31:16 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id A31F7C0E44; Tue,  1 Sep 2020 15:29:05 +0200 (CEST)
Date:   Tue, 1 Sep 2020 15:29:05 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 06/28] lib82596: move DMA allocation into the callers of
 i82596_probe
Message-ID: <20200901132905.GA11506@alpha.franken.de>
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819065555.1802761-7-hch@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 19, 2020 at 08:55:33AM +0200, Christoph Hellwig wrote:
> This allows us to get rid of the LIB82596_DMA_ATTR defined and prepare
> for untangling the coherent vs non-coherent DMA allocation API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/net/ethernet/i825xx/lasi_82596.c | 24 ++++++++++------
>  drivers/net/ethernet/i825xx/lib82596.c   | 36 ++++++++----------------
>  drivers/net/ethernet/i825xx/sni_82596.c  | 19 +++++++++----
>  3 files changed, 40 insertions(+), 39 deletions(-)
> 
> [...]
> diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
> index 22f5887578b2bd..e80e790ffbd4d4 100644
> --- a/drivers/net/ethernet/i825xx/sni_82596.c
> +++ b/drivers/net/ethernet/i825xx/sni_82596.c
> @@ -24,8 +24,6 @@
>  
>  static const char sni_82596_string[] = "snirm_82596";
>  
> -#define LIB82596_DMA_ATTR	0
> -
>  #define DMA_WBACK(priv, addr, len)     do { } while (0)
>  #define DMA_INV(priv, addr, len)       do { } while (0)
>  #define DMA_WBACK_INV(priv, addr, len) do { } while (0)
> @@ -134,10 +132,19 @@ static int sni_82596_probe(struct platform_device *dev)
>  	lp->ca = ca_addr;
>  	lp->mpu_port = mpu_addr;
>  
> +	lp->dma = dma_alloc_coherent(dev->dev.parent, sizeof(struct i596_dma),
> +				     &lp->dma_addr, GFP_KERNEL);

this needs to use &dev->dev as device argument otherwise I get a

WARNING: CPU: 0 PID: 1 at linux/kernel/dma/mapping.c:416 dma_alloc_attrs+0x64/0x98

(coherent_dma_mask is set correctly).

dev->dev.parent was correct when going from netdevice to underlying device,
but now allocation is done via platform_device probe. I wonder why this works
for parisc.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
