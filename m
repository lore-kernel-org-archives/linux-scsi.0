From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi command status bug
Date: Mon, 08 Jul 2002 20:36:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D2A3015.9AFB6D9D@torque.net>
References: <000301c226c0$ffcd0dc0$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org

Tony Battersby wrote:
> 
> Hello,
> 
> I have tracked down a problem with incorrect status being returned for a
> command sent through sg and ide-scsi.  I am using vanilla 2.4.17.  Here is
> what is happening:
> 
> The device returns CHECK CONDITION for a command sent to it from sg and
> ide-scsi.
> The following line executes in idescsi_end_request() in ide-scsi.c:
> pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
> ide-scsi calls the callback completion function.
> An internal request sense is queued.
> The request sense completes successfully.
> The following line executes in idescsi_end_request() in ide-scsi.c:
> pc->scsi_cmd->result = (DID_OK << 16)
> ide-scsi calls the callback completion function for the request sense
> command.
> 
> In my userspace program, sg_io_hdr_t { status, masked_status } are both
> zero, but sg_io_hdr_t { driver_status } & DRIVER_SENSE is set and the sense
> data is valid.  It appears to me as if the status from the request sense
> command overwrote the original CHECK CONDITION status.  I verified this by
> forcing all request sense commands to return a status of 0x01 (reserved bit
> set) in idescsi_end_request() in ide-scsi.c, and sure enough, I got a status
> of 0x01 for the failed command in sg_io_hdr_t { status }.
> 
> I have not tested any other kernel versions.  I am working around the
> problem for now by faking a CHECK CONDITION status when driver_status &
> DRIVER_SENSE in my program.

Tony,
I tried to document around this bug in the sg driver howto:
	http://tldp.org/HOWTO/SCSI-Generic-HOWTO/x255.html
The ide-scsi driver is probably the only lower level driver that 
has this unfortunate property.

It's a minor dilemma for the sg driver: whether to pass through
this information or correct it on the way passed.

Doug Gilbert
