From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Transport affected timeouts...
Date: Thu, 22 Apr 2004 14:54:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C016E2@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:18431 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264639AbUDVSyz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 14:54:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Brian King' <brking@us.ibm.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Brian,

To be honest, it's probably both.  The folks that performed the
trouble-shooting in the past blamed much of the problem on the latency, and
used link timer values to resolve it. However, since the qual was
predominantly raid arrays, I'd bet that it was heavily influenced by the
target as you indicate. (note: the resulting timeout based on r_a_tov value
is very close to just doubling the timeout). Note: I was rather surprised to
see the timeout value of sd to be 30 seconds. I know when I was in Tru64, we
had 60 seconds as a minimum.

One question though - how does the LLD really know what the timeout should
be ?  It doesn't identify a target as a raid device does it ? or what raid
level it's using ?

-- James S
 

> -----Original Message-----
> From: Brian King [mailto:brking@us.ibm.com]
> Sent: Thursday, April 22, 2004 2:15 PM
> To: Smart, James
> Cc: 'James Bottomley'; Linux SCSI Reflector
> Subject: Re: Transport affected timeouts...
> 
> 
> We are really trying to solve two different problems here. 
> The problem I am
> trying to solve with the patch I submitted is that the 
> existing r/w timeouts
> are too short for RAID array devices. Since a single read or 
> write may end
> up resulting in multiple ops in RAID 5 arrays this timeout 
> becomes far too
> short. In this scenario the LLD has the best knowledge as to 
> what this timeout
> value needs to be. A delta value here really does not make sense.
> 
> The problem you are trying to solve is more related to the 
> latencies you may
> experience due to the transport. I'm not sure my patch is the 
> best way to fix
> your problem. Updating the st driver to use this rw_timeout 
> does not sound like
> a good solution as the LLD really has no idea what the total 
> timeout for a
> read or write should be for a tape.
> 
> Option 2 works best for the ipr driver, option 3 works best 
> for you. Since we
> are really solving two different problems, how about using 
> both options?
> 
> -Brian
> 
> 
> > Potential options:
> > 1) Change the base driver timeout.  (base drivers defined 
> to be sd, st, etc)
> > 
> > I dislike this mainly because it fails (a) and (c). Also 
> concerned about
> > abilities to tune all base drivers.
> > 
> > 2) Allow the scsi-host to provide a timeout value that can 
> override the base
> > driver.
> > The IBM proposed patch does this. I dislike the patch as : 
> scsi host has no
> > input as to what the base driver timeout is; there are 
> multiple base driver
> > timeouts (sd, st, etc); thus apriori knowledge is required 
> to determine a
> > maximum. Also, application of timeout change is inconsistent.
> > 
> > 3) Allow the scsi-host to provide a transport-specific 
> increment that can be
> > added to the base driver timeout.
> > Just a refinement of (2) to hopefully remove my dislikes. 
> Still has faults
> > as the exact relationship of topology/configuration/devices 
> to needed
> > timeout is not exact/determinable.
> 
> 
> -- 
> Brian King
> eServer Storage I/O
> IBM Linux Technology Center
> 
