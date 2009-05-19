From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: how to block in_atomic scsi requests for long time
Date: Tue, 19 May 2009 07:32:18 -0600
Message-ID: <20090519133218.GB31779@parisc-linux.org>
References: <c70ff3ad0905190504o77d966dbxcb07eb39d1225f08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37875 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZESNcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 09:32:17 -0400
Content-Disposition: inline
In-Reply-To: <c70ff3ad0905190504o77d966dbxcb07eb39d1225f08@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: saeed bishara <saeed.bishara@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 19, 2009 at 03:04:07PM +0300, saeed bishara wrote:
>     I have a system with 4 disks that configured to enter standby
> mode, the power supplier of this system can't drive concurrent
> spin-ups of more than one disk, and it needs the spin-ups to be few
> seconds far from each other.
>     I've implemented this feature by adding a semaphore, and in the
> scsi_dispatch_command, the process will wait for that semaphore if the
> disk in standby mode and other disk in a middle of doing spinup. but
> the problem is that sometimes that function is called while in atomic
> context, and waiting to the semaphore is prohibeted.
>     how do you guys suggest to block a request which comes in atomic mode?

Call scsi_queue_insert(cmd, SCSI_MLQUEUE_HOST_BUSY); and return
SCSI_MLQUEUE_HOST_BUSY.  The midlayer won't retry the command until
another command finishes.  This has the downside that it won't try a
command to the spun-up device until a command has finished either ...

This is kind of the wrong way to do it though.  Are you sending down
commands to standby the device, or are the drives moving to standby
state on their own recognisance?  It would be better to block the other
devices.  See this code?

        /* Check to see if the scsi lld made this device blocked. */
        if (unlikely(scsi_device_blocked(cmd->device))) {
                /* 
                 * in blocked state, the command is just put back on
                 * the device queue.  The suspend state has already
                 * blocked the queue so future requests should not
                 * occur until the device transitions out of the
                 * suspend state.
                 */

                scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);

                SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));

                /*
                 * NOTE: rtn is still zero here because we don't need the
                 * queue to be plugged on return (it's already stopped)
                 */
                goto out;
        }

You need to make the drives go into this state (by calling
scsi_internal_device_block()) when they suspend, if you can tell when
they suspend.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
