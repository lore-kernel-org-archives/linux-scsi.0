From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 03:37:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020628033704.B23044@redhat.com>
References: <20020619014048.B8623@redhat.com> <20020619134436.A27002@devserv.devel.redhat.com> <20020619142554.G8854@redhat.com> <dledford@redhat.com> <10206272241.ZM1032399@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10206272241.ZM1032399@classic.engr.sgi.com>; from jeremy@classic.engr.sgi.com on Thu, Jun 27, 2002 at 10:41:31PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Thu, Jun 27, 2002 at 10:41:31PM -0700, Jeremy Higdon wrote:
> Is there any accounting for the following condition:
> 
>    An array with multiple logical units can accept 256 commands (for
>    argument purposes) from all initiators for all luns.  Therefore,
>    the number of commands that you can queue to sdX is dependent
>    on how many commands queued by this initiator to other sds, as well
>    as how many commands other initiators have issued to this sd and
>    others.

That's (currently) on a per driver basis.  My driver would account for 
this situation just fine.  Others might not.  That is one of the things I 
plan to change in the mid layer very soon now.

> This may not be an issue so much with parallel SCSI RAIDs, but it does
> come up with Fibrechannel.
> 
> It is theoretically possible to get QUEUE_FULL when the host has no other
> commands in progress on a logical unit.  Would the host driver then believe
> that it could issue 0 or 1 command only, or is there some lower limit?
> 
> jeremy

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
