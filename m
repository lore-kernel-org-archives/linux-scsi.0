From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] Farther clean up of stex.c driver
Date: Fri, 15 Jun 2007 08:52:58 +0900
Message-ID: <20070615085258H.fujita.tomonori@lab.ntt.co.jp>
References: <B70A50D07063384EB9BCE3330D18414F03601207@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:36274 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXFNXwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 19:52:55 -0400
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F03601207@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ed.lin@promise.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 3/3] Farther clean up of stex.c driver
Date: Thu, 14 Jun 2007 16:02:30 -0700

> 
> 
> > -----Original Message-----
> > From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] 
> > Sent: Thursday, June 14, 2007 3:21 PM
> > To: Ed Lin
> > Cc: bharrosh@panasas.com; fujita.tomonori@lab.ntt.co.jp; 
> > g.liakhovetski@gmx.de; linux-scsi@vger.kernel.org
> > Subject: RE: [PATCH 3/3] Farther clean up of stex.c driver
> > 
> > 
> > From: "Ed Lin" <ed.lin@promise.com>
> > Subject: RE: [PATCH 3/3] Farther clean up of stex.c driver
> > Date: Thu, 14 Jun 2007 12:29:05 -0700
> > 
> > > 
> > > 
> > > > -----Original Message-----
> > > > From: Boaz Harrosh [mailto:bharrosh@panasas.com] 
> > > > Sent: Thursday, June 14, 2007 9:34 AM
> > > > To: FUJITA Tomonori; Ed Lin; Guennadi Liakhovetski
> > > > Cc: linux-scsi@vger.kernel.org
> > > > Subject: Re: [PATCH 3/3] Farther clean up of stex.c driver
> > > > 
> > > > 
> > > > From 2b82909202cab8dc35184daef45b4b388f93112a Mon Sep 17 
> > 00:00:00 2001
> > > > From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
> > > > Date: Thu, 14 Jun 2007 19:14:40 +0300
> > > > Subject: [PATCH] Farther clean up of stex.c driver
> > > > 
> > > >  - now that scsi-ml accessors do not allow modifying of 
> > > > sg_count bufflen and
> > > >    sglist. The code in question is open coded to directly 
> > > > hack the scsi_cmnd
> > > >    structure. When implementation changes the driver will 
> > > > need to change with it.
> > > > 
> > > >  - Maintainer of this driver should please review again if we 
> > > > absolutely need this
> > > >    read-sense length fixing. What if less bytes are read and 
> > > > 0 are left at the end.
> > > >    Also no check is made if the buffer is large enough.
> > > > ---
> > > >  drivers/scsi/stex.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> > > > index adda296..d784b58 100644
> > > > --- a/drivers/scsi/stex.c
> > > > +++ b/drivers/scsi/stex.c
> > > > @@ -719,7 +719,7 @@ static void stex_ys_commands(struct 
> > st_hba *hba,
> > > > 
> > > >  	if (ccb->cmd->cmnd[0] == MGT_CMD &&
> > > >  		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
> > > > -		scsi_bufflen(ccb->cmd) =
> > > > +		ccb->cmd->request_bufflen =
> > > >  			le32_to_cpu(*(__le32 *)&resp->variable[0]);
> > > >  		return;
> > > >  	}
> > > > -- 
> > > > 1.5.0.4.402.g8035
> > > > 
> > > > 
> > > > 
> > > 
> > > The software allocates a big enough buffer(so don't worry 
> > about this),
> > > and it trims the data size based on returned length. So it needs the
> > > actual data length.
> > 
> > What's the software? I mean that who trims the data size based on
> > returned length?
> > 
> 
> The management software provided by Promise.

Any chance to use the resid field to tell a returned length to the
software?


> > > I wonder whether the following will go upstream:
> > > #define scsi_sg_count(cmd) ((cmd)->sg_table ? 
> > (cmd)->sg_table->sg_count
> > > : 0)
> > > #define scsi_sglist(cmd) ((cmd)->sg_table ? 
> > (cmd)->sg_table->sglist :
> > > NULL)
> > > #define scsi_bufflen(cmd) ((cmd)->sg_table ? 
> > (cmd)->sg_table->length :
> > > 0)
> > > 
> > > For this particular case, because there is data exchange, so
> > > (cmd)->sg_table is not NULL, so we can have something like:
> > > 		ccb->cmd->sg_table->length =
> > >   			le32_to_cpu(*(__le32 *)&resp->variable[0]);
> > > Although I am not sure whether the software can work without change
> > > after the scsi_sgtable approach becomes upstream. But I 
> > just wonder why
> > > we use some code that is known to be temporary even before its
> > > introduction.
> > 
> > I think that it would be better to apply Boaz patchset with scsi-bidi
> > support (not now). Then you can avoid adding temporary hack.
> > 
> 
> Does the scsi_sgtable above belong to the scsi-bidi patchset?

Yeah.

> If it does, then this patch is just a temporary hack.

Yeah. That's why I prefer to apply this patch with the scsi-bidi
patchset as I said in the previous mail.


> The code needs to be changed again at that time. This is stated in
> the comment of this patch.
