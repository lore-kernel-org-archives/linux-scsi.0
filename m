From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 15:48:52 -0800
Message-ID: <1488325732.11610.9.camel@linux.vnet.ibm.com>
References: <20170227152955.1362aabb@xeon-e3>
         <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
         <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
         <1488301573.3046.9.camel@linux.vnet.ibm.com>
         <20170228105741.6253bb8a@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751378AbdCAB5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 20:57:02 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1SNn7bp100668
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 18:49:10 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28wk448arp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 18:49:08 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 28 Feb 2017 18:49:00 -0500
In-Reply-To: <20170228105741.6253bb8a@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Tue, 2017-02-28 at 10:57 -0800, Stephen Hemminger wrote:
> On Tue, 28 Feb 2017 09:06:13 -0800
> James Bottomley <jejb@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 2017-02-28 at 08:32 -0700, Jens Axboe wrote:
> > > On 02/28/2017 07:08 AM, Christoph Hellwig wrote:  
> > > > On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger
> > > > wrote:  
> > > > > Fixes: ee5242360424 ("scsi: zero per-cmd driver data before
> > > > > each
> > > > > I/O")
> > > > > 
> > > > > but that is already in linux-next.
> > > > > 
> > > > > Noticed another place where memset(of the data was being done
> > > > > not
> > > > > the extra bits.
> > > > > Tried this, but didn't fix it either...  
> > > > 
> > > > Are you using blk-mq or the legacy request code?  
> > > 
> > > Stephen doesn't have MQ set in the config he posted, I'm assuming
> > > he 
> > > didn't boot with scsi_mod.use_blk_mq=true. In a previous email, I
> > > asked if turning on MQ makes a difference.  
> > 
> > OK, since we're not making much progress, Stephen, could you insert
> > some debugging into the storvsc driver?  The trace clearly shows
> > we're
> > getting zeros back in the buffer when we should have data from the
> > initial scan.  Firstly, does the vmbus think it's transferring any
> > data
> > for the INQUIRY and READ_CAPACITY commands (looks like
> > storvsc_command_completion() data_transfer_length)?  If it does,
> > there's probably an issue initialising the sg list.  If it doesn't,
> > we're probably sending bogus commands.
> > 
> > James
> > 
> 
> The following code in storvsc looks suspicious
> 
> static void storvsc_on_io_completion(struct storvsc_device
> *stor_device,
> 				  struct vstor_packet *vstor_packet,
> 				  struct storvsc_cmd_request *request)
> {
> 	struct vstor_packet *stor_pkt;
> 	struct hv_device *device = stor_device->device;
> 
> 	stor_pkt = &request->vstor_packet;
> 
> 	/*
> 	 * The current SCSI handling on the host side does
> 	 * not correctly handle:
> 	 * INQUIRY command with page code parameter set to 0x80
> 	 * MODE_SENSE command with cmd[2] == 0x1c
> 	 *
> 	 * Setup srb and scsi status so this won't be fatal.
> 	 * We do this so we can distinguish truly fatal failues
> 	 * (srb status == 0x4) and off-line the device in that case.
> 	 */
> 
> 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
> 	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
> 		vstor_packet->vm_srb.scsi_status = 0;
> 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
> 	}
> 
> If SCSI layer is sending inquiry about devices to do scanning then 
> wouldn't this workaround break things?  Maybe a better to fully test 
> for the broken command.

Let's concentrate on INQUIRY since that's the first command in the
probe sequence.  I think it's completing successfully because your
hyperv layer says it has 36 bytes of transfer and that's the size of a
successful initial INQUIRY, so the fact that the code above would break
stuff if the INQUIRY failed is orthogonal to the the current problem.

can you print out some of the DMA buffer in storvsc_on_io_completion()?

I think just the stor_pkt->vm_srb.cdb[0] (to identify the command
completing) and byte 5 of the buffer will tell us what we need to know.
 It's going to be complex to get byte 5, you'll need to do a
kmap_atomic_pfn on request->payload->range.pfn_array[0] and then look
at byte 5.  If that's zero it means there's some problem with hyperv
writing to the pfn if it's 0x24 (expected value for an initial inquiry)
we've got a problem somewhere in bio completion not copying the value
back.

James
