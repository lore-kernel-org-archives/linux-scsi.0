From: Russell King <rmk@arm.linux.org.uk>
Subject: SCSI woes
Date: Tue, 24 Sep 2002 12:06:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924120637.A19313@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

For those who haven't had the (mis-)fortune of following my SCSI
problems, (they're the lucky ones) I've been testing out some of the
error handling code in 2.4.19.

Currently, I'm seeing the whole SCSI subsystem grind to a halt while
scanning for devices after a command (purposely) times out to one
device.

The nitty gritty of the problem comes down to the way we restart
operations after error handling has been completed, and what actually
happens at that point.  The steps leading up to the problem are:

1. bus scanning finds IDs 1 and 2, and reports their type (tape and
   disk devices respectively, both with "removable" media type)

2. INQUIRY to ID 3 times out, and we wake up the error handler.  We
   do all our error handling stuff and successfully free up the bus.

3. We try to restart operations on the host.

(3) is where stuff goes down the pan.  Basically, we loop through each
SCSI device (ID1 and ID2 in this case) and call its request function.
(see scsi_error.c::scsi_restart_operations().)  The first device is ID1.

So we enter scsi_lib.c::scsi_request_fn(), and at this point the
request queue is currently empty.  We do all sorts of checks for
device busy/plugged/host busy etc, and we determine the device was
reset.

At this point, we perform an ioctl to lock the door.  (Side note: why
lock the door when (a) there is no request pending, (b) we don't even
have any drivers attached, (c) the device is not in use by user space.
I believe this may be related to a previous problem I've seen where a
tape in the tape drive can't be ejected after an error occurs.  I've
not looked too hard at this particular issue yet.)

This causes a prevent/allow medium removal command to filter back
through to scsi_request_fn().  We pass all the tests, and get past
"req = blkdev_entry_next_request(&q->queue_head);"

This is a "special" request (req->cmd == SPECIAL), so we're going to be
calling scsi_allocate_device().  I'm theorising that this is where we
fail, presumably because we haven't finished initialisation of this
device.  We leave scsi_request_fn() and wait for the request to finish
(scsi.c::scsi_wait_req).

At this point, we have:

1. zero commands actually running on ID1.
2. the error handler is blocked waiting for the prevent/allow medium
   removal command to complete, which it never does (see 1).
3. meanwhile, we started an IDENTIFY command to ID4, which seems to
   timeout (I'm not sure why, but it does.)  This requires error
   handler work, but the error handler is blocked (see 2).

The end result is that everything on this host grinds to a complete
halt and we're dead in the water.

Making scsi_restart_operations() skip devices whose request queue is
empty allows the bus scanning to complete, but instead we lock up
trying to attach ID2, the disk, to sd.  It looks like we're dropping
out of the request function in the same place as above after succesfully
sending one command (TEST UNIT READY) to the device.  Again, this seems
to be connected with the door locking stuff.

It looks like there's something weird going on with scsi_allocate_device()
after the error handler has run.  I'm going to focus here next.

Comments?  Suggestions?  Patches?  Fixes?  8)

Oh, and please note that if the forced error with ID3 is removed,
everything works as expected.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

