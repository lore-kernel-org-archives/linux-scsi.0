From: Brian Auld <bauld@lefthandnetworks.com>
Subject: Re: Question about the use of PERSISTENT RESERVATION IN/OUT
Date: Thu, 01 Apr 2004 15:20:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406C95C2.5010600@lefthandnetworks.com>
References: <53CF1076699CD711B7DD0002A51363F102AD7F70@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lefthandnetworks.com ([207.174.0.250]:11660 "EHLO
	mail.lefthandnetworks.com") by vger.kernel.org with ESMTP
	id S263295AbUDAWVo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 17:21:44 -0500
In-Reply-To: <53CF1076699CD711B7DD0002A51363F102AD7F70@exw-ks.ks.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Qi, Yanling" <yanling.qi@lsil.com>

Thanks for your feedback and suggestions.

I take it from the first reply that the basic mechanism of implementing
persistent reservation out/in (regardless of the nitty gritty) using sg or
sd ioctls is doable? I guess my really big question is can I do this at 
all?
For now, I primarily want to make sure that the facilities (i.e. sg) are
there to implement something.

Is support/non-support for sg (or sd ioctls) adapter driver specific? or is
it supported for any device that plugs into the scsi stack?

Brian


Qi, Yanling wrote:

> 1. You need to issue PROUT (service action: register) first before 
> issuing PROUT reserve service action.
> 2. If you would like only one initiator port to access the LUN, the 
> reservation type should be "Exclusive Access".
> 3. You need to decide whether or not you need to "break" a 
> reservation. PROUT release service action can only release the 
> reservation that owns by this valid registrant but can not clear 
> somebody else's reservation.
>
> Yanling
>
> -----Original Message-----
> From: Brian Auld [mailto:bauld@lefthandnetworks.com]
> Sent: Thursday, April 01, 2004 3:07 PM
> To: linux-scsi@vger.kernel.org
> Subject: Question about the use of PERSISTENT RESERVATION IN/OUT
>
>
> Sorry for the initial staggered email.
>
> I was able to acquire some level of understanding of the use of 
> "persistent
> reservation in/out" commands after having read some SCSI specs and 
> browsing
> this mailing list's archives. I have made some presumptions and wanted
> to run
> them by this list to make sure I wasn't too far out in left field.
>
>
> I'm designing a linux-based application that is going to use LUNs for
> storage
> from a backend FC SAN. It's not very sexy, but there is a one to one
> relationship for i) boxes running my appl and ii) LUNs. One of the
> requirements
> that has been imposed on the appl is that once a given backend LUN has 
> been
> assigned to my application, any other physical entity (i.e. a different
> initiator on a different box, which could be running my appl) is to be
> prevented from accessing this LUN using some kind of protection 
> mechanism.
>
>
> Once a LUN is assigned to a specific box running my appl, this protection
> should exist until I explicitly deassign this LUN in my user 
> interface. In
> other words, the protection should persist across host reboots and target
> reset/reboots.
>
>
> I have made the following assumptions and decisions about how this 
> will be
> handled:
>
>
> 1) As I understand it, there is no reserve/release (persistent or old)
> mechanism in the scsi subsystem itself.
>
>
> 2) WRT (1), there are however 2 mechanisms for sending pass-through 
> commands
> through the scsi subsystem directly to a target device: namely, (i) 
> using an
> sg device or (ii) sd ioctls.
>
>
> 3) What I would like to do is setup my application so the following
> occurs when
> a LUN is assigned/deassigned to my appl:
>
>
> assigned:
> -------------
> In my appl, send an appropriate combination of PERSISTENT RESERVE
> OUT(service
> action: reserve ...) commands to effectivly lock this device so that any
> initiator not included in the list I provide will be prevented from
> accessing
> my LUN. I would use the sg mechanism or sd ioctls to do this.
>
>
> deassigned:
> ---------------
> In my appl, send an appropriate combination of PERSISTENT RESERVE OUT
> (service
> action: release) commands to free up this LUN. Again, I would use sd 
> ioctls
> or the sg mechanism to do this.
>
>
> Is this basic approach flawed? It would seem to be doable based on what
> I have
> read so far, but I don't know for sure.
>
>
> Any feedback would be appreciated.
>
>
> Thanks,
> Brian
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


