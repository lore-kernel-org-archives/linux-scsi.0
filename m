From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 17:45:21 +0900
Message-ID: <20071018174521N.fujita.tomonori@lab.ntt.co.jp>
References: <4717106E.7040404@panasas.com>
	<20071018165723L.fujita.tomonori@lab.ntt.co.jp>
	<471718F6.6070206@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:46433 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbXJRJFe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 05:05:34 -0400
In-Reply-To: <471718F6.6070206@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, tomof@acm.org, matthew@wil.cx, mdharm-scsi@one-eyed-alien.net, rmk@arm.linux.org.uk, stern@rowland.harvard.edu, davem@davemloft.net, hch@infradead.org, linux-scsi@vger.kernel.org, bhalevy@panasas.com, pw@osc.edu

On Thu, 18 Oct 2007 10:27:34 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Thu, Oct 18 2007 at 9:57 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Thu, 18 Oct 2007 09:51:10 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> On Thu, Oct 18 2007 at 1:40 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >>> On Wed, 17 Oct 2007 20:21:15 +0200
> >>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>>
> >>>>   In preparation for bidi we abstract all IO members of scsi_cmnd,
> >>>>   that will need to duplicate, into a substructure.
> >>>>
> >>>>   - Group all IO members of scsi_cmnd into a scsi_data_buffer
> >>>>     structure.
> >>>>   - Adjust accessors to new members.
> >>>>   - scsi_{alloc,free}_sgtable receive a scsi_data_buffer instead of
> >>>>     scsi_cmnd. And work on it.
> >>>>   - Adjust scsi_init_io() and  scsi_release_buffers() for above
> >>>>     change.
> >>>>   - Fix other parts of scsi_lib/scsi.c to members migration. Use
> >>>>     accessors where appropriate.
> >>>>
> >>>>   - Old I/O members are kept for backward compatibility, since
> >>>>     not all of scsi-ml/ul is converted yet. Once done they will
> >>>>     be removed in a closing patch. (Other wise the patchset will
> >>>>     not be bisectable)
> >>> (snip)
> >>>
> >>>> @@ -114,6 +112,22 @@ struct scsi_cmnd {
> >>>>  	int result;		/* Status code from lower level driver */
> >>>>  
> >>>>  	unsigned char tag;	/* SCSI-II queued command tag */
> >>>> +
> >>>> +	union {
> >>>> +		struct scsi_data_buffer sdb;
> >>>> +		/*
> >>>> +		 * FIXME: Here for compatibility with unconverted drivers.
> >>>> +		 *        Must be kept in sync with exact type and order
> >>>> +		 *        of struct scsi_data_buffer members.
> >>>> +		 */
> >>>> +		struct {
> >>>> +			unsigned __deprecated request_bufflen;
> >>>> +			int __deprecated resid;
> >>>> +			unsigned short __deprecated use_sg;
> >>>> +			unsigned short __deprecated place_holder_sg_alloc;
> >>>> +			void __deprecated *request_buffer;
> >>>> +		};
> >>>> +	};
> >>>>  };
> >>> If we add something like this, why couldn't we merge the
> >>> scsi_data_buffer patchset when I submitted last month?
> >>>
> >>> I thought that I wait you to fix all the old LLDs, then will send a
> >>> clean scsi_data_buffer patchset.
> >> We do have all the old LLDs fixed. After this patchset the entire tree
> >> is clean. I have just forgot to send the last [33/33] patch that removes
> >> this. I have just sent it now, sorry.
> >> (The change log above explains exactly why this is done here)
> > 
> > As I said, I can't see why we need this compatibility hack in the
> > first place.
> > 
> > We need to wait patches 1-26 to be merged. After that, we can merge
> > clean scsi_data_buffer patchset (without the compatibility hack).
> > 
> No.
> It is here so we can separate the patches 27 to 32 and still be
> bisect-able and running at each patch. Other wise all 27-32 patches
> must be a single patch.

So why can they be a single patch?
