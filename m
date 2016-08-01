From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Mon, 1 Aug 2016 15:15:08 -0400
Message-ID: <20160801191508.GA7084@redhat.com>
References: <6880321d-e14f-169b-d100-6e460dd9bd09@sandisk.com>
 <1110327939.7305916.1469819453678.JavaMail.zimbra@redhat.com>
 <a5c1a149-b1a2-b5a4-2207-bdaf32db3cbd@sandisk.com>
 <757522831.7667712.1470059860543.JavaMail.zimbra@redhat.com>
 <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
 <931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
 <1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
 <17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
 <20160801175948.GA6685@redhat.com>
 <f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbcHATPK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2016 15:15:10 -0400
Content-Disposition: inline
In-Reply-To: <f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Laurence Oberman <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 01 2016 at  2:55pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 08/01/2016 10:59 AM, Mike Snitzer wrote:
> >This says to me that must_push_back is returning false because
> >dm_noflush_suspending() is false.  When this happens -EIO will escape up
> >the IO stack.
> >
> >And this confirms that must_push_back() calling dm_noflush_suspending()
> >is quite suspect given queue_if_no_path was configured: we should
> >_always_ pushback if no paths are available.
> >
> >I'll dig deeper on really understanding _why_ must_push_back() is coded
> >like it is.
> 
> Hello Mike,
> 
> Earlier I had reported that I observe this behavior with
> CONFIG_DM_MQ_DEFAULT=y after the first simulated cable pull. I have
> been able to reproduce this behavior with CONFIG_DM_MQ_DEFAULT=n but
> it takes a large number of iterations to trigger this behavior. The
> output that appears on my setup in the kernel log with a bunch of
> printk()'s added in the dm-mpath driver for CONFIG_DM_MQ_DEFAULT=n
> is as follows (mpath 254:0 and /dev/mapper/mpathbe refer to the same
> multipath device):
> 
> [  314.755582] mpath 254:0: queue_if_no_path 0 -> 1
> [  314.770571] executing DM ioctl DEV_SUSPEND on mpathbe
> [  314.770622] mpath 254:0: queue_if_no_path 1 -> 0
> [  314.770657] __multipath_map(): (a) returning -5
> [  314.770657] map_request(): clone_and_map_rq() returned -5
> [  314.770658] dm_complete_request: error = -5

OK, that makes no sense at all (nevermind that your trace really isn't
useful, my debug patch is more so).

The old .request_fn code checks !blk_queue_stopped() in dm_request_fn().
When a dm-mpath device is suspended the queue gets stopped (same goes
for dm-mq).  So once a request-based DM device is suspended the .map_rq
and .clone_and_map_rq hooks shouldn't get called.

BUT the difference between .request_fn and dm-mq is that dm-mq doesn't
ever check if the queue if stopped.  We rely on blk-core to ensure that
IO is not submitted (via dm_mq_queue_rq) while a device is suspended
(and because the queue is stopped it shouldn't).

Now you're saying both cases aren't working.. which is really confusing.
Basically the request-based DM core should protect against requests
being mapped while a device is suspended... seems to be mounting
evidence that isn't the case.
