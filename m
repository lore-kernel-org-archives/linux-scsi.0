From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support -
	revised II
Date: Thu, 30 Oct 2008 08:39:34 -0500
Message-ID: <1225373974.3250.0.camel@localhost.localdomain>
References: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com>
	 <20081030131825M.fujita.tomonori@lab.ntt.co.jp>
	 <4909678C.1010908@panasas.com>
	 <20081030172537K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51681 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbYJ3Njk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 09:39:40 -0400
In-Reply-To: <20081030172537K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, seokmann.ju@qlogic.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Thu, 2008-10-30 at 17:29 +0900, FUJITA Tomonori wrote:
> On Thu, 30 Oct 2008 09:51:40 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > Do you know what is the difference between "req->error =" and the error
> > passed to blk_end_xxx_request(req, error, ...) ?
> 
> I guess that blk_end_xxx_request(req, error, ...) is common Linux
> error code, -EIO, etc. req->error carries protocol specific errors;
> SAM_STAT_*, DID_*, etc in the case of SCSI. But I'm not confident.

Yes, that's it precisely.  The blk_end_request() carries a translated
UNIX error code for the user (usually -EIO).  req->error carries the
transport error in its full glory (although it may lack pieces that
won't fit into 32 bits).

James


