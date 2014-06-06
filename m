From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] tcm_fc: Generate TASK_SET_FULL for DataIN +
 response failures
Date: Fri, 06 Jun 2014 14:09:16 -0700
Message-ID: <1402088956.26205.14.camel@haakon3.risingtidesystems.com>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
	 <1402087121.5752.91.camel@vi-devel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43608 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaFFVJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 17:09:18 -0400
In-Reply-To: <1402087121.5752.91.camel@vi-devel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Jun Wu <jwu@stormojo.com>

On Fri, 2014-06-06 at 13:38 -0700, Vasu Dev wrote:
> On Thu, 2014-06-05 at 23:30 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Vasu,
> > 
> > This series generates SAM_STAT_TASK_SET_FULL status for lport->tt.seq_send()
> > failures in DataIN + response status codepaths, which is done in order to get
> > the initiator to reduce it's current queue_depth thus reducing the number of
> > outstanding I/Os permitted in flight on the wire.
> > 
> > For the DataIN case, once a lport->tt.seq_send() failure occurs it will stop
> > attempting to send subsequent DataIN payload data, and immediately attempt to
> > send a response packet with SAM_STAT_TASK_SET_FULL status.
> > 
> > For the response case, once a lport->tt.seq_send() failure occurs it will
> > set SAM_STAT_TASK_SET_FULL status and return -ENOMEM to the target, forcing
> > the response to be requeued by target-core
> > 
> 
> Good change and it was missing in tcm_fc.
> 
> > Note this series has been compile tested only, so please review + test.
> 
> Just did review and basic test but should be stressed to really ensure
> it does work & fixes issues resulting these patches.

So if you don't mind I'll go ahead and queue these up for now in
target-pending/for-next, given they are pretty straight-forward fixes.

If they end up being problematic, they can be dropped before the v3.16
PULL request goes out next week.

Jun can you please test both cases..?  Eg: the first with an explicitly
reduced fcoe initiator queue_depth setting mentioned earlier, and the
second with these two patches to return TASK_SET_FULL when the sequence
failures start occurring.

Thanks,

--nab

