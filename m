From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Tue, 10 May 2016 08:08:18 -0700
Message-ID: <1462892898.2320.18.camel@linux.vnet.ibm.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
	 <5727266E.7040905@suse.de> <1462196672.2665.5.camel@linux.vnet.ibm.com>
	 <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com>
	 <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
	 <CAMGffEnM_w8us49dCJWHU=UeDhyk53DRt5AD=sdezY3=Rv=omQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:49550 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbcEJPIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 11:08:31 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Tue, 10 May 2016 09:08:28 -0600
In-Reply-To: <CAMGffEnM_w8us49dCJWHU=UeDhyk53DRt5AD=sdezY3=Rv=omQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Tue, 2016-05-10 at 16:48 +0200, Jinpu Wang wrote:
> On Mon, May 9, 2016 at 6:41 PM, Jinpu Wang <
> jinpu.wang@profitbricks.com> wrote:
> > On Wed, May 4, 2016 at 7:02 PM, Jinpu Wang <
> > jinpu.wang@profitbricks.com> wrote:
> > > On Mon, May 2, 2016 at 3:44 PM, James Bottomley <
> > > jejb@linux.vnet.ibm.com> wrote:
> > > > On Mon, 2016-05-02 at 12:05 +0200, Hannes Reinecke wrote:
> > > > > On 04/29/2016 02:49 PM, Jinpu Wang wrote:
> > > > > > Hi, all
> > > > > > 
> > > > > > We hit IO error on fsync, it turns out was because sd treat
> > > > > > succeeded
> > > > > > SYNC as error. From what I checked in SBC spec there is no
> > > > > > indication
> > > > > > we should fail IO in this case, so we create this patch.
> > > > > > 
> > > > > > 
> > > > > > Best Regards,
> > > > > > 
> > > > > > Jack Wang
> > > > > > 
> > > > > > v2:
> > > > > > No change on patch itself, only resend in body as suggested
> > > > > > by
> > > > > > Bart,
> > > > > > still keep the attachment in case mail client break the
> > > > > > format.
> > > > > > 
> > > > > > From 5d1f72d9643ce61cd9f3d312377378c43f171d0c Mon Sep 17
> > > > > > 00:00:00
> > > > > > 2001
> > > > > > From: Jack Wang <jinpu.wang@profitbricks.com>
> > > > > > Date: Mon, 25 Apr 2016 12:05:22 +0200
> > > > > > Subject: [PATCH] sd: Don't treat succeeded SYNC as error
> > > > > > 
> > > > > > We hit IO error in our production on multipath devices
> > > > > > during
> > > > > > resize
> > > > > > device on target side, the problem turns out sd driver
> > > > > > passes up as
> > > > > > IO
> > > > > > error when sense data is UNIT_ATTENTION and ASC && ASCQ
> > > > > > indicate
> > > > > > Capacity data has changed, even storage side sync the data
> > > > > > properly.
> > > > > > 
> > > > > > In order to fix this check in sd_done, report success if
> > > > > > condition
> > > > > > matches.
> > > > > > 
> > > > > > Sebastian Parschauer report/analyze the bug here:
> > > > > > https://sourceforge.net/p/scst/mailman/message/34953416/
> > > > > > 
> > > > > > Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> > > > > > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > > > > > ---
> > > > > >  drivers/scsi/sd.c | 13 +++++++++++++
> > > > > >  1 file changed, 13 insertions(+)
> > > > > > 
> > > > > Well.
> > > > > Is there anything which guarantees us that 'capacity data has
> > > > > changed' will be the only sense code which we'll be seeing as
> > > > > a
> > > > > response to SYNCHRONIZE CACHE?
> > > > > I sincerely doubt so.
> > > > > So why don't you fall back to the default action (ie retry
> > > > > the
> > > > > command) whenever you hit an UNIT ATTENTION?
> > > > > This way we would cove any resulting sense code, _and_ would
> > > > > get rid
> > > > > of the rather ugly special case here.
> > > > 
> > > > Actually, why are we getting here at all?  should we be eating
> > > > this
> > > > unit attention once we've reported it in scsi_check_sense()?
> > > > 
> > > > I also don't quite understand why the normal retry mechanism in
> > > > scsi_io_completion() (called after drv->done()) isn't handling
> > > > this.
> > > >  We set retries on a flush command and we give sd_sync_cache
> > > > three
> > > > goes.  Any one of those should also cause the CC/UA to be
> > > > ignored.
> > > > 
> > > > James
> > > > 
> > > > 
> > > 
> > > Sorry for delay, I agree safer to retry this command.
> > > I checked the code path, in scsi_io_completion, we call
> > > __scsi_error_from_host_byte for FLUSH request,
> > > and we set error to EIO by default, somehow the code report error
> > > directly to user space without retry.
> > > [  647.206270] sd 1:0:0:0: [sdb] tag#0 Send: scmd
> > > 0xffff8800b6558480
> > > [  647.206422] sd 1:0:0:0: [sdb] tag#0 CDB: Synchronize Cache(10)
> > > 35
> > > 00 00 00 00 00 00 00 00 00
> > > [  647.209748] sd 1:0:0:0: Capacity data has changed
> > > [  647.209896] sd 1:0:0:0: [sdb] tag#0 Done: SUCCESS Result:
> > > hostbyte=DID_OK driverbyte=DRIVER_OK
> > > [  647.210157] sd 1:0:0:0: [sdb] tag#0 CDB: Synchronize Cache(10)
> > > 35
> > > 00 00 00 00 00 00 00 00 00
> > > [  647.210419] sd 1:0:0:0: [sdb] tag#0 Sense Key : Unit Attention
> > > [current]
> > > [  647.210567] sd 1:0:0:0: [sdb] tag#0 Add. Sense: Capacity data
> > > has changed
> > > [  647.210741] sd 1:0:0:0: [sdb] tag#0 scsi host busy 1 failed 0
> > > [  647.210888] sd 1:0:0:0: Notifying upper driver of completion
> > > (result 8000002)
> > > [  647.211035] sd 1:0:0:0: [sdb] tag#0 sd_done: completed 0 of 0
> > > bytes
> > > [  647.211182] sd 1:0:0:0: [sdb] tag#0 0 sectors total, 0 bytes
> > > done, error -5
> > > [  647.211330] blk_update_request: I/O error, dev sdb, sector 0
> > > 
> > > Will figure out why retry doesn't work.
> > > 
> > > Thanks James and Hannes for all your input.
> > > 
> > > Regards,
> > > Jack
> > 
> > Hi James, Hannes and all,
> > 
> > I find out it's code below which report error directly back to user
> > space without any retry.
> >  913         /*
> >  914          * If we finished all bytes in the request we are done
> > now.
> >  915          */
> >  916         if (!scsi_end_request(req, error, good_bytes, 0))
> >  917                 return;
> > 
> > But not sure, what's the best way to fix the behavior to let it
> > retry,
> >  maybe add condition with sense key && asc && ascq direct go to
> > requeue before line 913?
> > 
> > Thanks
> > Jack
> 
> 
> Hi James , Hannes and all,
> 
> I created a patch below, I did basic test on my test machines. Please
> share your comments!
> 
> Thanks,
> Jack
> From 72ab860811e14e37db81fb409abf0fa7e7fe32cb Mon Sep 17 00:00:00
> 2001
> From: Jack Wang <jinpu.wang@profitbricks.com>
> Date: Tue, 10 May 2016 10:10:59 +0200
> Subject: [PATCH] scsi: requeue command on capacity data has changed
> 
> We hit IO error in our production on multipath devices during resize
> device on target side, the problem turns out scsi driver passes up as
> IO
> error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
> Capacity data has changed, even storage side sync the data properly.
> 
> To fix this, when condition met, we simply requeue the command.
> 
> Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/scsi_lib.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..b00310f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -910,6 +910,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
>   error = 0;
>   }
> 
> + if (sense_valid && (sshdr.sense_key == UNIT_ATTENTION)) {
> + if ((sshdr.asc == 0x2a && sshdr.ascq == 0x09))
> + goto requeue;
> + }
> +

Actually, I think this is symptomatic of a much bigger problem.  Now
that the FS can send zero length non BLOCK_PC request, we're not
treating failure correctly.  blk_update_request() will always finish
them becuase they have no bytes outstanding (not having any in the
first case).  So I think we need a special exception for all zero
length commands which complete with a failure to allow them to retry
(if required).

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..5a97866 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	/*
-	 * If we finished all bytes in the request we are done now.
+	 * special case: failed zero length commands always need to
+	 * drop down into the retry code. Otherwise, if we finished
+	 * all bytes in the request we are done now.
 	 */
-	if (!scsi_end_request(req, error, good_bytes, 0))
+	if (!(good_bytes == 0 && blk_rq_bytes(req) == 0 && result != 0) &&
+	    !scsi_end_request(req, error, good_bytes, 0))
 		return;
 
 	/*

