From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 31 May 2002 18:57:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFEF39177E.C91A3280-ONC1256BCA.005A590B@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, linux-scsi@vger.kernel.org



James,

how about using this silly little patch of mine to do your testing. Should
be easy enough to put into other drivers and it simulates the zSeries
adapter behaviour on a heavily virtualised physical adapter relatively
well. (I admit that testing for one outstanding command is pushing it a
bit....)
I have tried out the bit-change with this. To no avail though, it still
hangs. By the way, blk_plug_device needs to be exported when setting the
bit to 1...so maybe it should always be on the list of exports?

Cheers,
Aron

--- drivers/scsi/aic7xxx/aic7xxx_linux.c        Wed Apr 17 17:31:28 2002
+++ drivers/scsi/aic7xxx/aic7xxx_linux_queuecommand_fails.c     Fri May 31
18:25:25 2002
@@ -1540,6 +1540,10 @@
        /*
         * Save the callback on completion function.
         */
+       if((cmd->host->host_busy==1) && ((jiffies & 0xf0)>0x80)) {
+               printk("**********+causing fail********\n");
+               return FAILED;
+       }
        cmd->scsi_done = scsi_done;

        dev = ahc_linux_get_device(ahc, cmd->channel, cmd->target,

ARZEH@de.ibm.com said:
> I had hoped to be able to reproduce by now, but unfortunately my 2.5
> kernels currently fail to boot on zSeries. I'll try the repro and the
> bit change as soon as that little problem can be alleviated.

Actually, I'm afraid there's more to it than my initial recommendation of
just
plugging the elevator queue.  Your problem lies in the device_blocked flag,

which gets set when queuecommand returns non-zero and is not reset until an

I/O comes back through scsi_finish_command().

I don't believe the host and device blocking serve any purpose anymore.
Also,
with the advent of blocking in the blkdev layer, I think we can even get
rid
of the host_self_blocked flag (which is currently only used by the mesh
driver).  So I'll look into getting rid of them all.

In the mean time, temporarily you may be able to fix it (and this should
work
for 2.4) by manually setting host_blocked to false and running the q->
request_fn(q) from your driver when you detect that the can't accept any
commands condition is alleviated.

James






