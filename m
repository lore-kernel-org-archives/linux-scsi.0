From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [Bug 199003] console stalled, cause Hard LOCKUP.
Date: Tue, 27 Mar 2018 19:37:40 +0900
Message-ID: <20180327103740.GA4872@jagdpanzerIV>
References: <bug-199003-14532@https.bugzilla.kernel.org/>
 <bug-199003-14532-IBTfRpvy7t@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bug-199003-14532-IBTfRpvy7t@https.bugzilla.kernel.org/>
Sender: linux-kernel-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: sergey.senozhatsky@gmail.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'll Cc blockdev

On (03/27/18 08:36), bugzilla-daemon@bugzilla.kernel.org wrote:
> > --- Comment #17 from sergey.senozhatsky.work@gmail.com ---
> > On (03/26/18 13:05), bugzilla-daemon@bugzilla.kernel.org wrote:
> > > Therefore the serial console is actually pretty fast. It seems that the
> > > deadline
> > > 10ms-per-character is not in the game here.
> > 
> > As the name suggests this is dmesg - content of logbuf. We can't tell
> > anything about serial consoles speed from it.
> 
> Grrr, you are right. It would be interesting to see the output from
> the serial port as well.
> 
> Anyway, it does not change the fact that printing so many same lines is
> useless. The throttling still would make sense and probably would
> solve the problem.

You are right.

Looking at backtraces (https://bugzilla.kernel.org/attachment.cgi?id=274953&action=edit)
there *probably* was just one CPU doing all printk-s and all printouts. And
there was one CPU waiting for that printing CPU to unlock the queue spin_lock.

The printing CPU was looping in scsi_request_fn() picking up requests
and calling sdev_printk() for each of them, because the device was
offline. Given that serial console is not very fast, that we called
serial console under queue spin_lock and the number of printks called,
it was enough to lockup the CPU which was spining on queue spin_lock and
to hard lockup the system.

scsi_request_fn() does unlock the queue lock later, but not in that
!scsi_device_online(sdev) error case.

scsi_request_fn()
{
	for (;;) {
		int rtn;
		/*
		 * get next queueable request.  We do this early to make sure
		 * that the request is fully prepared even if we cannot
		 * accept it.
		 */
		req = blk_peek_request(q);
		if (!req)
			break;

		if (unlikely(!scsi_device_online(sdev))) {
			sdev_printk(KERN_ERR, sdev,
				    "rejecting I/O to offline device\n");
			scsi_kill_request(req, q);
			continue;
			^^^^^^^^^ still under spinlock
		}
}

I'd probably just unlock/lock queue lock, rather than ratelimit printk-s,
before `continue'. Dunno.

James, Martin, what do you think?

	-ss
