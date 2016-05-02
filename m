From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Mon, 02 May 2016 06:44:32 -0700
Message-ID: <1462196672.2665.5.camel@linux.vnet.ibm.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
	 <5727266E.7040905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47876 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbcEBNok (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 09:44:40 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Mon, 2 May 2016 07:44:39 -0600
In-Reply-To: <5727266E.7040905@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jinpu Wang <jinpu.wang@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Mon, 2016-05-02 at 12:05 +0200, Hannes Reinecke wrote:
> On 04/29/2016 02:49 PM, Jinpu Wang wrote:
> > Hi, all
> > 
> > We hit IO error on fsync, it turns out was because sd treat
> > succeeded
> > SYNC as error. From what I checked in SBC spec there is no
> > indication
> > we should fail IO in this case, so we create this patch.
> > 
> > 
> > Best Regards,
> > 
> > Jack Wang
> > 
> > v2:
> > No change on patch itself, only resend in body as suggested by
> > Bart,
> > still keep the attachment in case mail client break the format.
> > 
> > From 5d1f72d9643ce61cd9f3d312377378c43f171d0c Mon Sep 17 00:00:00
> > 2001
> > From: Jack Wang <jinpu.wang@profitbricks.com>
> > Date: Mon, 25 Apr 2016 12:05:22 +0200
> > Subject: [PATCH] sd: Don't treat succeeded SYNC as error
> > 
> > We hit IO error in our production on multipath devices during
> > resize
> > device on target side, the problem turns out sd driver passes up as
> > IO
> > error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
> > Capacity data has changed, even storage side sync the data
> > properly.
> > 
> > In order to fix this check in sd_done, report success if condition
> > matches.
> > 
> > Sebastian Parschauer report/analyze the bug here:
> > https://sourceforge.net/p/scst/mailman/message/34953416/
> > 
> > Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > ---
> >  drivers/scsi/sd.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> Well.
> Is there anything which guarantees us that 'capacity data has
> changed' will be the only sense code which we'll be seeing as a
> response to SYNCHRONIZE CACHE?
> I sincerely doubt so.
> So why don't you fall back to the default action (ie retry the
> command) whenever you hit an UNIT ATTENTION?
> This way we would cove any resulting sense code, _and_ would get rid
> of the rather ugly special case here.

Actually, why are we getting here at all?  should we be eating this
unit attention once we've reported it in scsi_check_sense()?

I also don't quite understand why the normal retry mechanism in
scsi_io_completion() (called after drv->done()) isn't handling this. 
 We set retries on a flush command and we give sd_sync_cache three
goes.  Any one of those should also cause the CC/UA to be ignored.

James


