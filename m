From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Thu, 27 Jun 2002 22:41:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10206272241.ZM1032399@classic.engr.sgi.com>
References: <20020619014048.B8623@redhat.com>
	<20020619134436.A27002@devserv.devel.redhat.com>
	<20020619142554.G8854@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Doug Ledford <dledford@redhat.com>
        "Re: [PATCH + RFC] Beginning of some updates to scsi mid layer" (Jun 19,  2:25pm)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Jun 19,  2:25pm, Doug Ledford wrote:
> 
> This is actually from the runtime code, part of my interrupt handler.  It 
> notices that we might get a lot of QUEUE_FULLs from a device all at the 
> same queue depth, and in that case it reduces the queue depth to the new 
> depth.  So, in short, it's not backwards, it's actually taking the depth 
> down based upon solid feedback from the drive.

Is there any accounting for the following condition:

   An array with multiple logical units can accept 256 commands (for
   argument purposes) from all initiators for all luns.  Therefore,
   the number of commands that you can queue to sdX is dependent
   on how many commands queued by this initiator to other sds, as well
   as how many commands other initiators have issued to this sd and
   others.

This may not be an issue so much with parallel SCSI RAIDs, but it does
come up with Fibrechannel.

It is theoretically possible to get QUEUE_FULL when the host has no other
commands in progress on a logical unit.  Would the host driver then believe
that it could issue 0 or 1 command only, or is there some lower limit?

jeremy
