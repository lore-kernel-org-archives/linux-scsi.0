From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Transport affected timeouts...
Date: Thu, 22 Apr 2004 12:28:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C016DC@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37866 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264511AbUDVQ2O
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 12:28:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

I noted the current behavior - as it is unacceptable, and I'd like a
solution so that we can get rid of it.

The problem we're trying to solve is : there are topologies (long links,
small bb credits, large multi-lun devices thus lots of queued i/o) where the
default timeout values of the base drivers (sd, st, etc) are too short.

The optimal solution:
a) adjusts the timeout only on the scsi devices affected
b) timeout value determined dynamically by best entity (usually the scsi
host) at appropriate times (topology changes).
c) timeout adjustment does not require administrator input, apriori
knowledge, or kernel/driver rebuilds
d) addresses all commands from any source. 

Potential options:
1) Change the base driver timeout.  (base drivers defined to be sd, st, etc)

I dislike this mainly because it fails (a) and (c). Also concerned about
abilities to tune all base drivers.

2) Allow the scsi-host to provide a timeout value that can override the base
driver.
The IBM proposed patch does this. I dislike the patch as : scsi host has no
input as to what the base driver timeout is; there are multiple base driver
timeouts (sd, st, etc); thus apriori knowledge is required to determine a
maximum. Also, application of timeout change is inconsistent.

3) Allow the scsi-host to provide a transport-specific increment that can be
added to the base driver timeout.
Just a refinement of (2) to hopefully remove my dislikes. Still has faults
as the exact relationship of topology/configuration/devices to needed
timeout is not exact/determinable.

If there's not enough consensus to do (3) - then I vote for moving ahead
with the IBM patch (2), and updating the st driver as well.

-- James S

note: we are using the scsi_host_self_blocked interface to bridge reconfig
events, but that's a different topic.


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Wednesday, April 21, 2004 3:21 PM
> To: Smart, James
> Cc: Linux SCSI Reflector
> Subject: RE: Transport affected timeouts...
> 
> 
> On Wed, 2004-04-21 at 12:53, Smart, James wrote:
> > Where do we go from here ?   
> > 
> > What we are doing in our driver is the following:
> > - Cancel the mid-layer timeout
> > - Set timeout to (cmd->timeout_per_command/HZ) + hba_offset
> > - Start timer based on new timeout value
> 
> Well, this is unacceptable.  Only the mid layer should be mucking with
> mid-layer timers.
> 
> > Where hba_offset is: (2 * R_A_TOV) + administrative 
> increment (default 0)
> > Where R_A_TOV is the fabric-reported timeout. R_A_TOV is at 
> least a round
> > trip time, plus 2 times max delivery delay time within the 
> fabric. (default
> > 10 seconds).  This value can change based on fabric 
> reconfiguration or
> > plugging the adapter into a differnet fabric.
> 
> I'm still not clear on what you're trying to achieve.
> 
> the scsi_host_self_blocked interface was created with 
> reconfig events in
> mind...it still won't stop in-progress timers, but I've been 
> considering
> adding that feature for things like FC lip events.
> 
> James
> 
> 
