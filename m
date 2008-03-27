From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/9][RESEND] mvsas: get phy info.
Date: Thu, 27 Mar 2008 10:13:54 -0700
Message-ID: <1206638034.3662.4.camel@localhost.localdomain>
References: <47EB44E5.9080204@marvell.com>
	 <da824cf30803271004i64a785afn6c0030984dca96eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53222 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758457AbYC0ROA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 13:14:00 -0400
In-Reply-To: <da824cf30803271004i64a785afn6c0030984dca96eb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: kewei@marvell.com, linux-scsi@vger.kernel.org, jeff@garzik.org

On Thu, 2008-03-27 at 10:04 -0700, Grant Grundler wrote:
> On Wed, Mar 26, 2008 at 11:55 PM, Ke Wei <kewei@marvell.com> wrote:
> > removed unused code and attached SATA address makes use of port id.
> >  enable HBA interrupt after calling sas_register_ha();
> 
> just one small nit and one question.
> 
> ...
> >  @@ -2837,20 +2812,34 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
> >                         } else {
> >                                 dev_printk(KERN_DEBUG, &pdev->dev,
> >                                         "No sig fis\n");
> >  +                               phy->phy_type &= ~(PORT_TYPE_SATA);
> 
> shouldn't need '()'s around the constant.
> 
> >  +                               goto out_done;
> >                         }
> >                 }
> >  +               tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
> >  +               memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
> 
> Why does this need to be a memcpy and not just a simple store operation?
> Is it misaligned? (even if it is, the kernel will deal with it. It
> just won't be fast.)

Because if you look in include/scsi/libsas.h, you find the definition:

struct asd_sas_phy {
[...]
	u8   attached_sas_addr[SAS_ADDR_SIZE]; /* class:RO, driver: R/W */


We're annoyingly schizophrenic on this ... most of the time we have a
sas_addr defined as u64, but not in a lot of the libsas code.

James


