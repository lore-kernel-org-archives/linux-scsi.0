From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 16:39:29 -0600
Message-ID: <1201300769.3119.78.camel@localhost.localdomain>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
	 <479727D5.8060901@garzik.org>
	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40525 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbYAYWjg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 17:39:36 -0500
In-Reply-To: <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

On Sat, 2008-01-26 at 00:43 +0800, Ke Wei wrote:

>  struct mvs_phy {
>         struct mvs_port         *port;
>         struct asd_sas_phy      sas_phy;
> +       struct sas_identify identify;
> +       __le32          dev_info;
> +       __le64          dev_sas_addr;
> +       __le32          att_dev_info;
> +       __le64          att_dev_sas_addr;
> +       u32             type;
> +       __le32          phy_status;
> +       __le32          irq_status;
> +       u8              wide_port_phymap;
> +       u32             frame_rcvd_size;
> +       u8              frame_rcvd[32];
>  
> -       u8                      frame_rcvd[24 + 1024];
>  };

These __le quantites don't look right ... they're all read in by readl,
which will convert little endian to CPU anyway.


> @@ -437,27 +586,55 @@ struct mvs_info {
>         dma_addr_t              rx_dma;
>         u32                     rx_cons;        /* RX consumer idx */
>  
> -       __le32                  *rx_fis;        /* RX'd FIS area */
> +       void                    *rx_fis;        /* RX'd FIS area */

Now the received FIS, on the other hand, provided you're storing it in
wire format (which you look to be) *is* little endian data by definition
in the ATA spec.


> -static void mvs_tag_clear(struct mvs_info *mvi, unsigned int tag)
> +static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
>  {
> -       mvi->tags[tag / sizeof(unsigned long)] &=
> -               ~(1UL << (tag % sizeof(unsigned long)));
> +       mvi->tag_in = (mvi->tag_in + 1) & (MVS_SLOTS - 1);
> +       mvi->tags[mvi->tag_in] = tag;
>  }
>  
> -static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
> +static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
>  {
> -       mvi->tags[tag / sizeof(unsigned long)] |=
> -               (1UL << (tag % sizeof(unsigned long)));
> +       mvi->tag_out = (mvi->tag_out - 1) & (MVS_SLOTS - 1);
>  }
>  
> -static bool mvs_tag_test(struct mvs_info *mvi, unsigned int tag)
> +static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
>  {
> -       return mvi->tags[tag / sizeof(unsigned long)] &
> -               (1UL << (tag % sizeof(unsigned long)));
> +       if (mvi->tag_out != mvi->tag_in) {
> +               *tag_out = mvi->tags[mvi->tag_out];
> +               mvi->tag_out = (mvi->tag_out + 1) & (MVS_SLOTS - 1);
> +               return 0;
> +       }
> +       return -EBUSY;

I really don't think you should be doing this.  That single ring governs
all the potential tag slots for everything in this device.  If you do a
simple head tail allocation, what can happen is that you get a slow tag
(attached to a format command, or a tape command) and then the ring head
will hit the slow tag and the entire device will halt.  I think you need
a bitmap based allocation algorithm to ensure that if you have a free
tag anywhere, you'll use it.

If you look at the aic94xx index functions in aic94xx_hwi.h you'll see
asd_tc_index_get() and asd_tc_index_release() doing exactly what you
want with the native linux bitmap functions (the aic also uses a single
issue queue with indexes into it).

James


