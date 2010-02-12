From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_transport_fc: handle transient error on multipath
 environment
Date: Fri, 12 Feb 2010 12:03:32 -0600
Message-ID: <4B7597F4.6070403@cs.wisc.edu>
References: <4B750CB7.4030805@jp.fujitsu.com> <4B7593F4.2050102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B7593F4.2050102@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/12/2010 11:46 AM, Mike Christie wrote:
> - Maybe you want to instead hook something into the dm-mutlipath's
> request (no more bios like in 2004 :)). Can you set a timer on that
> level of request. If that times out then, dm-multipath could do
> something like call blk_abort_queue.

Some more detail. I was thinking maybe you could stack the timeout
handlers like is done for request_fn handlers or maybe the scsi cmd
would use the upper layer's timer somehow. Not sure... but at the least
I think we would not want both a scsi request and dm request timers
running at the same time.

Then for the error handling and timeout handling, most FC drivers have a
terminate_rport_io which works without having to block the entire host.
Those drivers could implement a newer eh where instead of firing the
code in scsi_error.c when a cmd times out, it would run
terminate_rport_io from some workqueue.

new dm request timed out()
	-> scsi_timed_out
		-> fc_timed_out()
			{
				run new eh from workqueue();
			}


new_eh()
	/* no new cmds should be started until we figure out what is going on */
	block rport()
	/* releases cmds upwards so they can run while we try to figure out
what is going on */
	terminate_rport_io()
	/* check if devices are ok */
	send_tur()
	if (tur failed)
		start old scsi_error.c code to unjam us.
	else
		/* everything looks ok so let IO run to this path again */
		unblock rport()


> 
> I think the problem with blk_abort_queue might be that it stops all IO
> to the entire host where you probably just want to work on the remote
> port/path. For that you could call something like
> recover_transient_error. Maybe it could just be a call to
> terminate_rport_io from a workqueue though.
