From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Wed, 22 May 2002 15:44:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020522154406.A17222@eng2.beaverton.ibm.com>
References: <200205212311.g4LNBYo09061@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200205212311.g4LNBYo09061@localhost.localdomain>; from James.Bottomley@steeleye.com on Tue, May 21, 2002 at 07:11:34PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 21, 2002 at 07:11:34PM -0400, James Bottomley wrote:
> The attached makes the request field in Scsi_Cmnd and Scsi_Request be pointers 
> to the block layer request instead of copies of it.  The advantage of this is 
> that it makes the scsi interface to the block layer conform much more closely 
> to most other block device drivers.  It should also make it quite a lot easier 
> to slot in the block layer tag command queueing functions.
> 
> The disadvantage is that you now _really_ need to use the scsi request 
> interfaces instead of the command based ones (you will get a NULL deref if you 
> allocate and use your own commands with no associated requests).  This also 
> means that the following fibre drivers need some rework:  cpqfc, gdth, pluto, 
> tmscsim.
> 
> It works on my system (at least it stays up during a full kernel compile).  
> Any comments would be welcome.
> 
> After this, I plan to see if I can implement TCQ using the block level generic 
> functions.  This would buy us the ability to support request barriers (modulo 
> the already discussed edge cases) right down through the SCSI subsystem.

Hi - 

I applied your patch and successfuly ran with AIC + 2 disks (one the boot
disk), plus with qla (modified v6.0b20 to remove io request lock) drivers
attached to both Triton (disk array) and Seagate drives using block and raw io.

Do you think the queue depth on some of the adapters/devices should be
shrunk or the request queue increased with your patch? Some adapters set
device queue depths above 200 (for example, aic set mine to 253), this seems
like overkill, but today it means they can have 200 more IO's on the request
queue, where freeing the request after the IO completes means the request
queue (with your patch) means we sometimes would have 200 fewer entries.

I don't understand how/why the journaling file systems want to use a
barrier, and how it helps their IO.

Are the request barriers needed to prevent earlier IO from completing before
the barrier, or later IO from completing before the barrier, or both?

How do the request barriers work with volume managers or multi-path devices?

-- Patrick Mansfield
