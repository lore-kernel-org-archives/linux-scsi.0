From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 10:57:41 -0800
Message-ID: <20170228105741.6253bb8a@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:34344 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbdB1Uz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 15:55:27 -0500
Received: by mail-pg0-f52.google.com with SMTP id p5so10243668pga.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 12:54:20 -0800 (PST)
In-Reply-To: <1488301573.3046.9.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Tue, 28 Feb 2017 09:06:13 -0800
James Bottomley <jejb@linux.vnet.ibm.com> wrote:

> On Tue, 2017-02-28 at 08:32 -0700, Jens Axboe wrote:
> > On 02/28/2017 07:08 AM, Christoph Hellwig wrote:  
> > > On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:  
> > > > Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each
> > > > I/O")
> > > > 
> > > > but that is already in linux-next.
> > > > 
> > > > Noticed another place where memset(of the data was being done not
> > > > the extra bits.
> > > > Tried this, but didn't fix it either...  
> > > 
> > > Are you using blk-mq or the legacy request code?  
> > 
> > Stephen doesn't have MQ set in the config he posted, I'm assuming he 
> > didn't boot with scsi_mod.use_blk_mq=true. In a previous email, I 
> > asked if turning on MQ makes a difference.  
> 
> OK, since we're not making much progress, Stephen, could you insert
> some debugging into the storvsc driver?  The trace clearly shows we're
> getting zeros back in the buffer when we should have data from the
> initial scan.  Firstly, does the vmbus think it's transferring any data
> for the INQUIRY and READ_CAPACITY commands (looks like
> storvsc_command_completion() data_transfer_length)?  If it does,
> there's probably an issue initialising the sg list.  If it doesn't,
> we're probably sending bogus commands.
> 
> James
> 

The following code in storvsc looks suspicious

static void storvsc_on_io_completion(struct storvsc_device *stor_device,
				  struct vstor_packet *vstor_packet,
				  struct storvsc_cmd_request *request)
{
	struct vstor_packet *stor_pkt;
	struct hv_device *device = stor_device->device;

	stor_pkt = &request->vstor_packet;

	/*
	 * The current SCSI handling on the host side does
	 * not correctly handle:
	 * INQUIRY command with page code parameter set to 0x80
	 * MODE_SENSE command with cmd[2] == 0x1c
	 *
	 * Setup srb and scsi status so this won't be fatal.
	 * We do this so we can distinguish truly fatal failues
	 * (srb status == 0x4) and off-line the device in that case.
	 */

	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
		vstor_packet->vm_srb.scsi_status = 0;
		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
	}

If SCSI layer is sending inquiry about devices to do scanning then wouldn't this
workaround break things?  Maybe a better to fully test for the broken command.

Original commit was:

commit 4ed51a21c0f69e1379cf858fc21a9d9022bfe0e7
Author: K. Y. Srinivasan <kys@microsoft.com>
Date:   Sat Aug 27 11:31:26 2011 -0700

    Staging: hv: storvsc: Fixup srb and scsi status for INQUIRY and MODE_SENSE
    
    The current VHD handler on the Windows Host does not correctly handle
    INQUIRY and MODE_SENSE commands with some options. Fixup srb_status
    in these cases since the failure is not fatal.
    
    Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
    Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
