From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Wed, 28 Aug 2002 09:38:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208281438.g7SEcbl26622@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA07508
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 07:38:46 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Mon, 26 Aug 2002 15:38:09 PDT." <20020826223809.GB9917@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

andmike@us.ibm.com said:
> Is there no need to represent a I_T nexus and a I_T_L nexus? It would
> seem to be a lost of information if we dump everything into to large
> of a bucket and then need to make extra links to regain this
> information. 

As far as the mid-layer is concerned, no.  I_T vs I_T_L is really somewhat of 
a fiction even in SAM-2 since the M_IDENTIFY for I_T just looks like a 
M_IDENTIFY for I_T_L with LUN set to 0.

> The tgts where just examples, these could be port names, etc. My point
> was to say if luns (which can have any name you want) where contained
> under a port node than it would be easy to determine siblings. The
> only drawback would be an extra lun0 node. 

Oh, yes, I agree with that.   The mid-layer just uses a Scsi_Device with a 
driverfs pointer attached.  If the driverfs representation happens to be a 
simple tgt1 or tgt1/lun0, the mid-layer won't care.

> I am confused as the scsi subsystem is creating parts of this tree by
> deciding when and what to register with driverfs. Driverfs is only
> providing the interface and some default nodes. While driverfs is
> doing a lot, how we register can make future code easier or hard. 

OK, I see, conceptually what I'm aiming at is that the bulk of the mid-layer 
doesn't know or care about the name:  it thinks in terms of Scsi_Host or 
Scsi_Device.  When the mid-layer needs to print a name, it fishes it out of 
driverfs.

Currently, the code that generates these names lives in the mid-layer, but it 
is possible that the day may come when we need standardisation amongst all 
disc like devices (or tape like devices, etc.), and it may not live there any 
longer (or at least, parts of it may not).

The ideal now is that we separate these as cleanly as possible inside the 
mid-layer.  I'd like us to be to the point where if we don't like the current  
host/chan/pun/lun/... naming scheme, a few formatting characters get altered 
in one routine and the new naming scheme is implemented. In the long run, I 
think we probably turn over one piece (the host/chan/pun) to the Host driver 
so that it can be used for naming an mapping (with library routines in the mid 
layer for the usual pun numbering) and the LUN part probably always belongs in 
the mid layer since that's fairly universal.

James


