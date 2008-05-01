From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 17:56:57 +0300
Message-ID: <4819DA39.70505@panasas.com>
References: <4819C9DB.60104@panasas.com> <1209651854.3067.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1209651854.3067.8.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 01 2008 at 17:24 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2008-05-01 at 16:47 +0300, Boaz Harrosh wrote:
>> [PATCH 1/4] scsi_free_command API change - Don't support GFP_DMA
>>   ISA support is going away and is not needed by any potential clients
>>   of this code. So change the API now before it has any users.
> 
> What makes you think this?  We still have lots of ISA installations out
> there (and some broken PCI ones requiring ISA DMA masks) that we have to
> support.
> 

Believe me I'm an expert. I'm working on the complete removal of GFP_DMA dma
support, initiated by Andi Kleen. And will submit the complete work on Sunday
once reviewed by Andi and some preliminary test pass.

> For gdth you have an ISA board that *you* need to support, so the isa
> board has to have this flag.  The reason no-one's run into a bug here is
> that the problematic allocation is the sense buffer not the command.
> Unfortunately, when the fix was added to the gdth driver for the sense
> buffer separation:
> 
> commit 1b96f8955aaeeb05f7fb7ff548aa12415fbf3904
> Author: Sven Schnelle <svens-+2vGQ62mfxRg9hUCZPvPmw@public.gmane.org>
> Date:   Mon Mar 10 22:50:04 2008 +0100
> 
>     [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer dereference
> 
> We actually forgot about this case.  Right at the moment, any ioctl that
> uses gdth_execute on an ISA device will probably fail if the executed
> command resturns sense and there look to be paths down gdth_execute even
> for special commands where the OpCode flips to a regular command (-1)
> and so DMAs into the sense buffer.
> 
> James
> 
> 

I'm soon to submit a patch that fixes that for the ISA case.
[http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=commitdiff;h=f6aceea8a078907224d3e34fcd1118b92ef4e79a]

The call to pci_map_page() on an ISA case will it not bounce the buffer?

Any way it is a chicken and egg thing. I need the API stable to start converting drivers
and then use API in drivers. I thought it was pointless to do it in two stages for this little
thing since the thing is already broken now, and will be fixed very soon by me.

however we could do below patch to fix it. Use scsi_get_command(). It will not interfere with
the reserved command allocation and IO forward progress, because gdth_execute is always submitted
in parallel and never as a result of queuecommand. So there will be more contenders for the spare
command but they will never deadlock.

I was just reviewing those patches I think it will also be better because of the device locking
for the duration of gdth_execute.

---
From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/4] gdth: Use scsi_allocate_command for private command allocation

In gdth_execute() use scsi_allocate_command for allocation of
a command. To be insulated from future scsi_cmnd construction
considerations.

Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/gdth.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 35ad3bf..32a5ee2 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -447,17 +447,10 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
-    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
+    scp = scsi_get_command(GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
 
-    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-    if (!scp->sense_buffer) {
-	kfree(scp);
-	return -ENOMEM;
-    }
