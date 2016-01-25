From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] mptlan: add checks for dma mapping errors
Date: Mon, 25 Jan 2016 16:36:04 +0100
Message-ID: <56A640E4.2040509@redhat.com>
References: <1453509715-13146-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453509715-13146-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

On 23.1.2016 01:41, Alexey Khoroshilov wrote:
> mpt_lan_sdu_send() and mpt_lan_post_receive_buckets() do not check
> if mapping dma memory succeed.
> The patch adds the checks and failure handling.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/message/fusion/mptlan.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
> index cbe96072a6cc..3b6c8a755713 100644
> --- a/drivers/message/fusion/mptlan.c
> +++ b/drivers/message/fusion/mptlan.c
> @@ -734,6 +734,12 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
>  
>          dma = pci_map_single(mpt_dev->pcidev, skb->data, skb->len,
>  			     PCI_DMA_TODEVICE);
> +	if (pci_dma_mapping_error(mpt_dev->pcidev, dma)) {
> +		netif_stop_queue(dev);

Hi Alexey,
isn't a mpt_put_msg_frame needed here ?
and a similar de-alloc in next chunk too?
-tms

> +
> +		printk (KERN_ERR "%s: dma mapping failed\n", __func__);
> +		return NETDEV_TX_BUSY;
> +	}
>  
>  	priv->SendCtl[ctx].skb = skb;
>  	priv->SendCtl[ctx].dma = dma;
> @@ -1232,6 +1238,14 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
>  
>  				dma = pci_map_single(mpt_dev->pcidev, skb->data,
>  						     len, PCI_DMA_FROMDEVICE);
> +				if (pci_dma_mapping_error(mpt_dev->pcidev, dma)) {
> +					printk (KERN_WARNING
> +						MYNAM "/%s: dma mapping failed\n",
> +						__func__);
> +					priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
> +					spin_unlock_irqrestore(&priv->rxfidx_lock, flags);
> +					break;
> +				}
>  
>  				priv->RcvCtl[ctx].skb = skb;
>  				priv->RcvCtl[ctx].dma = dma;
