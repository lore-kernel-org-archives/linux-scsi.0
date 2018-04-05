From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/21] Allow compile-testing NO_DMA (drivers)
Date: Wed, 4 Apr 2018 19:32:53 -0500
Message-ID: <CAL_JsqJMppYaz31Gg8BH2OaAxs56dnjZ4y+nzBBp-Tt2odaqCw@mail.gmail.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1521208314-4783-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" <linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-ALSA <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Linux I2C <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:SERIAL DRIVERS" <linux-serial@>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 16, 2018 at 8:51 AM, Geert Uytterhoeven
<geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
>         Hi all,
>
> If NO_DMA=y, get_dma_ops() returns a reference to the non-existing
> symbol bad_dma_ops, thus causing a link failure if it is ever used.
>
> The intention of this is twofold:
>   1. To catch users of the DMA API on systems that do no support the DMA
>      mapping API,
>   2. To avoid building drivers that cannot work on such systems anyway.
>
> However, the disadvantage is that we have to keep on adding dependencies
> on HAS_DMA all over the place.
>
> Thanks to the COMPILE_TEST symbol, lots of drivers now depend on one or
> more platform dependencies (that imply HAS_DMA) || COMPILE_TEST, thus
> already covering intention #2.  Having to add an explicit dependency on
> HAS_DMA here is cumbersome, and hinders compile-testing.

The same can be said for CONFIG_IOMEM and CONFIG_OF. Any plans to
remove those too? CONFIG_IOMEM is mostly just a !CONFIG_UM option.

Rob
