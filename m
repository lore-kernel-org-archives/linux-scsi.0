From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [v4.13-rc BUG] system lockup when running big buffered write(4M)
 to IB SRP via mpath
Date: Wed, 23 Aug 2017 19:35:27 +0800
Message-ID: <20170823113526.GA8130@ming.t460p>
References: <20170808141715.GB22763@ming.t460p>
 <1502237504.4017.1.camel@redhat.com>
 <1502245693.6511.3.camel@redhat.com>
 <c072e942-0265-f0ad-561d-0e50d50e3cb1@redhat.com>
 <1502298599.2356.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753793AbdHWLfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 07:35:38 -0400
Content-Disposition: inline
In-Reply-To: <1502298599.2356.7.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>

On Wed, Aug 09, 2017 at 05:10:01PM +0000, Bart Van Assche wrote:
> On Wed, 2017-08-09 at 12:43 -0400, Laurence Oberman wrote:
> > Your latest patch on stock upstream without Ming's latest patches is 
> > behaving for me.
> > 
> > As already mentioned, the requeue -11 and clone failure messages are 
> > gone and I am not actually seeing any soft lockups or hard lockups.
> > 
> > When Ming gets back I will work with him on his patch set and the lockups.
> > 
> > Running 10 parallel writes which easily trips into soft lockups on 
> > Ming's kernel (even with your patch) has been stable here on 4.13-RC3 
> > with your patch.
> > 
> > I will leave it running for a while now but the patch is good.
> > 
> > If it survives 4 hours I will add a Tested-by to your latest patch.
> 
> Hello Laurence,
> 
> I'm working on an additional patch that should reduce unnecessary requeuing
> even further. I will let you know when it's ready.
> 
> Additionally, please trim e-mails when replying such that e-mails do not get
> too long.

soft lockup still can be observed easily with patch d4acf3650c7c(
block: Make blk_mq_delay_kick_requeue_list() rerun the queue at a quiet time),
but no hard lockup.

With the patchset of 'blk-mq-sched: improve SCSI-MQ performance', hard
lockup can be observed following some failure log:

	[  269.277653] device-mapper: multipath: blk_get_request() returned -11 - requeuing
	[  269.321244] device-mapper: multipath: blk_get_request() returned -11 - requeuing
	...
	[  273.421688] scsi host2: SRP abort called
	[  273.444577] scsi host2: Sending SRP abort for tag 0x6007e
	[  273.673871] scsi host2: Null scmnd for RSP w/tag 0x0000000006007e received on ch 6 / QP 0x30
	...
	[  274.372110] device-mapper: multipath: blk_get_request() returned -11 - requeuing
	[  278.658671] scsi host2: SRP abort called
	[  278.690630] scsi host2: SRP abort called
	[  278.717634] scsi host2: SRP abort called
	[  278.745629] scsi host2: SRP abort called
	[  279.083227] multipath_clone_and_map: 1092 callbacks suppressed
	....
	[  296.210503] scsi host2: SRP reset_device called
	....
	[  303.784287] NMI watchdog: Watchdog detected hard LOCKUP on cpu 10

The trick thing is that both hard lockup and soft lockup share
one same stack trace.

Another question, I don't understand why request is allocated with
GFP_ATOMIC in multipath_clone_and_map(), looks it shouldn't be
necessary.


--
Ming
