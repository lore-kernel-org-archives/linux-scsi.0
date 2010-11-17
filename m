From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: Convert scsi_host->cmd_serial_number to odd
 numbered atomic_t counter
Date: Wed, 17 Nov 2010 10:10:06 -0600
Message-ID: <1290010206.4736.47.camel@mulgrave.site>
References: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
	 <1289490783.2982.33.camel@mulgrave.site>
	 <1289511475.2867.138.camel@haakon2.linux-iscsi.org>
	 <1289512549.2982.44.camel@mulgrave.site>
	 <20101111223650.GA10257@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934779Ab0KQQKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 11:10:11 -0500
In-Reply-To: <20101111223650.GA10257@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>

On Thu, 2010-11-11 at 14:36 -0800, Mike Anderson wrote:
> James Bottomley <James.Bottomley@suse.de> wrote:
> > On Thu, 2010-11-11 at 13:37 -0800, Nicholas A. Bellinger wrote:
> > >
> > >  ..snip..
> > >
> > > Sounds good to me, but you will recall the last attempt to make
> > > scsi_cmd_get_serial() optional for the special case LLDs, that we
> > > started running quickly in the legacy usage of cmd->serial_number in
> > > scsi_softirq_done() and the side effects in scsi_try_to_abort_cmd(), who
> > > use is complex enough that we have not found a proper resolution
> > > sufficent to andmike discussed here:
> > 
> > Yes, that's what I meant by "eliminate the overloading of the serial
> > number zero value" above.  This needs fixing before the serial number
> > can be dumped for fast hba drivers.
> > 
> 
> In the last email referenced below I believed that since
> scsi_softirq_done is calling scsi_eh_scmd_add without the
> SCSI_EH_CANCEL_CMD flag set this will stop scsi_try_to_abort_cmd from
> being called. Since scsi_softirq_done is the one setting serial_number
> to 0 I do not believe we can hit the serial number == 0 check in
> scsi_try_to_abort_cmd anymore.
> 
> > > http://marc.info/?l=linux-scsi&m=128820726325009&w=2

I buy this.  The REQ_ATOM_COMPLETE flag in the block layer now mediates
timer vs completion atomically ... so either one or the other is allowed
to occur.

James


