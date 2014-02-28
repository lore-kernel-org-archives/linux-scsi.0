From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH] scsi_dh_alua: Requeue another not ready check condition
 at ML
Date: Fri, 28 Feb 2014 20:20:28 +0000
Message-ID: <1393618828.13153.11.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC8B21D@SACEXCMBX04-PRD.hq.netapp.com>
	 <530FED5B.60803@cs.wisc.edu> <5310A7EF.7060902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx11.netapp.com ([216.240.18.76]:16381 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaB1UUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2014 15:20:34 -0500
In-Reply-To: <5310A7EF.7060902@suse.de>
Content-Language: en-US
Content-ID: <754D48FDA100764E965C4DDF38564A20@hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Stewart, Sean" <Sean.Stewart@netapp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

On Fri, 2014-02-28 at 16:14 +0100, Hannes Reinecke wrote:
> On 02/28/2014 02:58 AM, Mike Christie wrote:
> > On 02/27/2014 06:14 PM, Stewart, Sean wrote:
> >> This allows the sd driver to retry commands like read capacity until a
> >> LUN is ready, rather than giving up after three retries.
> >>
> >> In NetApp E-Series, a controller can return not ready like this when it
> >> quiesces I/O on the controller that just came on the network, during a
> >> firmware upgrade procedure, and retrying the command at the midlayer
> >> will allow the discovery to complete, successfully.
> >>
> >> Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
> >> ---
> >>  drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> >> index 5248c88..95d87fe 100644
> >> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> >> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> >> @@ -454,6 +454,11 @@ static int alua_check_sense(struct scsi_device *sdev,
> >>  {
> >>  	switch (sense_hdr->sense_key) {
> >>  	case NOT_READY:
> >> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
> >> +			/*
> >> +			 * LUN Not Ready -- In process of becoming ready
> >> +			 */
> >> +			return ADD_TO_MLQUEUE;
> > 
> > It seems like the check_sense callout is being used to work around
> > scsi-ml in a lot of the additions that are not alua specific. If this is
> > meant for a specific target then it should not be here. If this is
> > non-alua specific behavior then it should also not be here either.
This sounds reasonable to me.  Originally, our target would return a
vendor-specific check condition, and I knew we wouldn't be able to get
the alua handler to retry that.  I also saw if we could get this
condition to return 02/04/0A so we'd be covered, but it wouldn't
accurately describe what's going on, so we set the target to return
02/04/01.

In any case, without having the device handler do ADD_TO_MLQUEUE, I see
the command come back with the check condition, return SUCCESS, then the
read_capacity_10 function burns through it's three retries:
        int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;

I captured this with scsi midlayer debugging to show what's going on.
Feb 28 13:51:44 wica-fo-stone kernel: sd 2:0:2:0: Send:
0xffff880420259cc0
Feb 28 13:51:44 wica-fo-stone kernel: sd 2:0:2:0: CDB: Read
Capacity(10): 25 00 00 00 00 00 00 00 00 00
Feb 28 13:51:45 wica-fo-stone kernel: sd 2:0:2:0: Done:
0xffff880420259cc0 SUCCESS

The same scsi_cmnd comes back with SUCCESS twice more, then:
Feb 28 13:51:46 wica-fo-stone kernel: sd 2:0:2:0: [sdd] READ CAPACITY
failed

> > 
> > If the IO was not a REQ_TYPE_BLOCK_PC request, then it would retried by
> > scsi_io_completion. Same with the other ones like inquiry data changed,
> > report luns data changed, etc.
> > 
> > Are we sure we don't want to fix the REQ_TYPE_BLOCK_PC/scsi_execute*
> > users to retry, or to add some new flag that those users can use that
> > tells scsi-ml to retry like it normally would so callers do not have to
> > check for all these errors, or just add these to scsi_decide_disposition?
> > 
> Yes, that's definitely a better idea. I've stumbled across this
> issue several times now.
Same..  This actually seems to have come up a lot.  We had basically the
same problem when we have a new VID/PID, but a customer uses an OS
without the VID/PID in the RDAC handler.  It can cause a lot of
headaches.

I think it should be possible for us to approach this in such a way that
a transient state on the target won't render the SCSI disk unusable (as
is done here).  So, by a flag, do you mean we could add something to the
request flags field?  We could use this to signify a command that should
keep retrying in the way that I'm looking for here (commands related to
initial discovery, like read capacities, are what I'm thinking of).


Thanks,
Sean


