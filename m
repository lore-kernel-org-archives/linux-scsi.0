From: Brian King <brking@us.ibm.com>
Subject: Re: Transport affected timeouts...
Date: Thu, 22 Apr 2004 13:14:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40880B97.4080705@us.ibm.com>
References: <3356669BBE90C448AD4645C843E2BF2802C016DC@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:21951 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264614AbUDVSPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 14:15:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

We are really trying to solve two different problems here. The problem I am
trying to solve with the patch I submitted is that the existing r/w timeouts
are too short for RAID array devices. Since a single read or write may end
up resulting in multiple ops in RAID 5 arrays this timeout becomes far too
short. In this scenario the LLD has the best knowledge as to what this timeout
value needs to be. A delta value here really does not make sense.

The problem you are trying to solve is more related to the latencies you may
experience due to the transport. I'm not sure my patch is the best way to fix
your problem. Updating the st driver to use this rw_timeout does not sound like
a good solution as the LLD really has no idea what the total timeout for a
read or write should be for a tape.

Option 2 works best for the ipr driver, option 3 works best for you. Since we
are really solving two different problems, how about using both options?

-Brian


> Potential options:
> 1) Change the base driver timeout.  (base drivers defined to be sd, st, etc)
> 
> I dislike this mainly because it fails (a) and (c). Also concerned about
> abilities to tune all base drivers.
> 
> 2) Allow the scsi-host to provide a timeout value that can override the base
> driver.
> The IBM proposed patch does this. I dislike the patch as : scsi host has no
> input as to what the base driver timeout is; there are multiple base driver
> timeouts (sd, st, etc); thus apriori knowledge is required to determine a
> maximum. Also, application of timeout change is inconsistent.
> 
> 3) Allow the scsi-host to provide a transport-specific increment that can be
> added to the base driver timeout.
> Just a refinement of (2) to hopefully remove my dislikes. Still has faults
> as the exact relationship of topology/configuration/devices to needed
> timeout is not exact/determinable.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

