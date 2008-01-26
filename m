From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] use the cmd_type of a leading request for
	scsi_init_sgtable
Date: Sat, 26 Jan 2008 11:28:28 +0900
Message-ID: <20080126112829Y.tomof@acm.org>
References: <20080126095738U.tomof@acm.org>
	<1201313155.3119.100.camel@localhost.localdomain>
	<20080126112247N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38161 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYAZC24 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 21:28:56 -0500
In-Reply-To: <20080126112247N.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bharrosh@panasas.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp

On Sat, 26 Jan 2008 11:22:47 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> On Fri, 25 Jan 2008 20:05:55 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Sat, 2008-01-26 at 09:57 +0900, FUJITA Tomonori wrote:
> > > This is against the scsi-bidi tree.
> > > 
> > > We need to use the cmd_type of a leading request for scsi_init_sgtable
> > > to set up scsi_data_buffer:length of a bidi request properly.
> > > 
> > > An alternative approach is setting the cmd_type of a leading request
> > > and its bidi request (*1). But the block layer and scsi-ml don't
> > > expect that the leading request and its sub-requests have the
> > > different command types.
> > > 
> > > Note that scsi_debug's XDWRITEREAD_10 support is fine without this
> > > patch since req->nr_sectors works for it but req->nr_sectors doesn't
> > > work for everyone.
> > > 
> > > (*1)
> > > 
> > > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12669.html
> > > 
> > > =
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Subject: [PATCH] use the cmd_type of a leading request for scsi_init_sgtable
> > > 
> > > We need to use the cmd_type of a leading request for scsi_init_sgtable
> > > to set up scsi_data_buffer:length of its bidi request properly.
> > 
> > This seems to be a very convoluted work around for the fact that we
> > forgot to set the cmd_type on the subordinate request.
> > 
> > Wouldn't this be a better fix?
> 
> I'm fine with this. I have no big preference in this issue.
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> 
> I just thought that the approach (the block layer and scsi-ml look at
> only the type of a leading request) show better how the block layer
> and scsi-ml see a leading request and its subordinate requests (all
> the requests need to have the same command type).

I meant that the block layer and scsi-ml use its subordinate requests
just to hook data buffer.


Anyway, I'm fine with your patch.
