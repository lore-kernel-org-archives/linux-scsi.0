From: Russell King <rmk@arm.linux.org.uk>
Subject: SCSI woes (followup)
Date: Tue, 24 Sep 2002 12:35:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924123508.A24521@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

In my previous mail, I said I thought scsi_allocate_device() was the cause
of the lockup while trying to attach devices to drivers.  This doesn't
seem to be the case.

Instead, we have something interesting going on:

1. We submit a test unit ready command for the disk device.  This command
   is at the head, and we call scsi_request_fn()
2. the scsi_request_fn() realises that the device was reset, and performs
   a scsi_ioctl to lock the door.
3. the ioctl queues up another request on the tail of the request queue
   to lock the door, and calls scsi_request_fn()
4. scsi_request_fn() processes the test unit ready command at the head of
   the queue, and hands this off to the driver.  The driver is now busy.
5. scsi_request_fn() returns, and waits for our door lock request to
   complete.
6. the test unit ready command completes.  We pass completion notification
   through scsi_done, the bottom half handler, scsi_finish_command,
   the scsi command's done function (which is the scsi requests sr_done
   function.)  At no point to we kick the queue to go and execute that
   door lock request.

So, we are left with one invocation of scsi_request_fn() spinning in the
scsi ioctl code waiting for a command that can never ever complete.

I'm getting the impression that the door lock handling code is misplaced,
and is probably the cause of these problems.  I'm going to try disabling
that code, and reverting my previous change to scsi_restart_operations().

Help!

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

