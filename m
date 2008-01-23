From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Wed, 23 Jan 2008 11:23:29 -0800
Message-ID: <da824cf30801231123k68e9fe4cn3d581bf20dcaaa1a@mail.gmail.com>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:14624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYAWTXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 14:23:42 -0500
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m0NJNUru026919
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:23:30 GMT
Received: from rv-out-0910.google.com (rvbl15.prod.google.com [10.140.88.15])
	by zps77.corp.google.com with ESMTP id m0NJNPG7024952
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 11:23:29 -0800
Received: by rv-out-0910.google.com with SMTP id l15so2628851rvb.50
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 11:23:29 -0800 (PST)
In-Reply-To: <4796BB5A.9090003@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ke Wei <kewei.mv@gmail.com>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

On Jan 22, 2008 7:58 PM, Jeff Garzik <jeff@garzik.org> wrote:

> > +#define READ_PORT_CONFIG_DATA(i) \
> > +       ((i > 3)?mr32(P4_CFG_DATA + (i - 4) * 8):mr32(P0_CFG_DATA + i * 8))
> > +#define WRITE_PORT_CONFIG_DATA(i,tmp) \
> > +       {if (i > 3)mw32(P4_CFG_DATA + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_CFG_DATA + i * 8, tmp); }
> > +#define WRITE_PORT_CONFIG_ADDR(i,tmp) \
> > +       {if (i > 3)mw32(P4_CFG_ADDR + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_CFG_ADDR + i * 8, tmp); }
> > +
> > +#define READ_PORT_PHY_CONTROL(i) \
> > +       ((i > 3)?mr32(P4_SER_CTLSTAT + (i - 4) * 4):mr32(P0_SER_CTLSTAT+i * 4))
> > +#define WRITE_PORT_PHY_CONTROL(i,tmp) \
> > +       {if (i > 3)mw32(P4_SER_CTLSTAT + (i - 4) * 4, tmp); \
> > +       else \
> > +               mw32(P0_SER_CTLSTAT + i * 4, tmp); }
> > +
> > +#define READ_PORT_VSR_DATA(i) \
> > +       ((i > 3)?mr32(P4_VSR_DATA + (i - 4) * 8):mr32(P0_VSR_DATA+i*8))
> > +#define WRITE_PORT_VSR_DATA(i,tmp) \
> > +       {if (i > 3)mw32(P4_VSR_DATA + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_VSR_DATA + i*8, tmp); }
> > +#define WRITE_PORT_VSR_ADDR(i,tmp) \
> > +       {if (i > 3)mw32(P4_VSR_ADDR + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_VSR_ADDR + i * 8, tmp); }
> > +
> > +#define READ_PORT_IRQ_STAT(i) \
> > +       ((i > 3)?mr32(P4_INT_STAT + (i - 4) * 8):mr32(P0_INT_STAT + i * 8))
> > +#define WRITE_PORT_IRQ_STAT(i,tmp) \
> > +       {if (i > 3)mw32(P4_INT_STAT + (i-4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_INT_STAT + i * 8, tmp); }
> > +#define READ_PORT_IRQ_MASK(i) \
> > +       ((i > 3)?mr32(P4_INT_MASK + (i-4) * 8):mr32(P0_INT_MASK+i*8))
> > +#define WRITE_PORT_IRQ_MASK(i,tmp) \
> > +       {if (i > 3)mw32(P4_INT_MASK + (i-4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_INT_MASK + i * 8, tmp); }
>
>
> make these macros readable, by breaking each C statement into a separate
> line

I'd prefer these all be written as static functions. Let the compiler do
the type checking instead of assuming we've got it right. There is no
performance difference AFAIK.

>
>
>
>
> > @@ -260,13 +368,33 @@ enum hw_register_bits {
> >        PHYEV_RDY_CH            = (1U << 0),    /* phy ready changed state */
> >
> >        /* MVS_PCS */
> > +       PCS_EN_SATA_REG         = (16),         /* Enable SATA Register Set*/
> > +       PCS_EN_PORT_XMT_START   = (12),         /* Enable Port Transmit*/
> > +       PCS_EN_PORT_XMT_START2  = (8),          /* For 6480*/
> >        PCS_SATA_RETRY          = (1U << 8),    /* retry ctl FIS on R_ERR */
> >        PCS_RSP_RX_EN           = (1U << 7),    /* raw response rx */
> >        PCS_SELF_CLEAR          = (1U << 5),    /* self-clearing int mode */
> >        PCS_FIS_RX_EN           = (1U << 4),    /* FIS rx enable */

What's the difference between PCS_FIS_RX_EN and PCS_EN_SATA_REG?
Grouping them together implies they define bits/commands for the same register.

The three new entries collide with the existing definitions and it's
not obvious what
the intended usage is.

Later, jeff pointed out drivers should be using dev_dbg() instead of splattering
"MVS_PRINTK" alll over the place. I'd like to strongly encourage that.

hth,
grant
