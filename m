From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: standards revisions
Date: Sun, 07 Oct 2012 10:31:37 -0700
Message-ID: <1349631097.13843.5.camel@haakon2.linux-iscsi.org>
References: <20121007014900.GA30316@infradead.org>
	 <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
	 <20121007145154.GA30586@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36104 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2JGRbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 13:31:48 -0400
In-Reply-To: <20121007145154.GA30586@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <roland@kernel.org>

On Sun, 2012-10-07 at 10:51 -0400, Christoph Hellwig wrote: 
> On Sat, Oct 06, 2012 at 11:11:50PM -0700, Nicholas A. Bellinger wrote:
> > On Sat, 2012-10-06 at 21:49 -0400, Christoph Hellwig wrote:
> > > Currenly all non-pscsi bakcneds report their standards version as
> > > SPC 2 via ->get_device_rev.
> > 
> > No, the proper on-the-wire bits to signal SPC-3 compliance are already
> > being returned by virtual backend drivers within standard INQUIRY
> > payload data.  
> 
> I missed that, but it doesn't matter for the point I was making, which
> is the code to special case the SCSI_2 case, which can't happen for
> any virtual backend.

Regardless of if an virtual backend reports a SPC-3 version (0x05) in
INQUIRY response, an initiator is still allowed to fall back to using
legacy SCSI-2 reservations instead of SPC-3 persistent reservations.  I
can think of at least one mainstream SCSI initiator that does this.

Also, I think your mistaken about ALUA and SCSI-2 compatibility.  ALUA
is an SPC-3 and above specific feature.

> In addition it also can't happen for pscsi as
> we don't wire up any command emulation but REPORT LUNS for it any more,
> effectively making it dead code.
> 

pSCSI has always NOP'ed the reservation + ALUA function pointers within
core_setup_reservations() and core_setup_alua().

--nab

