From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
 SAM BUSY/TASK_SET_FULL
Date: Mon, 07 Mar 2016 14:44:50 -0800
Message-ID: <1457390690.30747.33.camel@haakon3.risingtidesystems.com>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com>
	 <1457161634-15756-2-git-send-email-nab@daterainc.com>
	 <20160305210108.GA16337@lst.de>
	 <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
	 <20160306061910.GA1116@infradead.org>
	 <1457301315.32532.12.camel@haakon3.risingtidesystems.com>
	 <20160307075548.GB13884@lst.de>
	 <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
	 <1457368806.632.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56192 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbcCGWow (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 17:44:52 -0500
In-Reply-To: <1457368806.632.18.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>

On Mon, 2016-03-07 at 11:40 -0500, James Bottomley wrote:
> On Mon, 2016-03-07 at 00:03 -0800, Nicholas A. Bellinger wrote:
> > On Mon, 2016-03-07 at 08:55 +0100, Christoph Hellwig wrote:
> > > On Sun, Mar 06, 2016 at 01:55:15PM -0800, Nicholas A. Bellinger
> 
> > >  So as-is this might be well intended but either useless or broken.
> > > --
> > 
> > No, it useful for hosts that have an aggressive SCSI timeout, and it
> > works as expected with Linux/SCSI hosts that either retry on BUSY
> > status, or retry + reduce queue_depth on TASK_SET_FULL status.
> 
> I'm with Christoph on this: BUSY and QUEUE_FULL are already handled
> generically in SCSI.  All drivers should use the generics: to handle
> separately, the driver has to intercept the error code, which I thought
> I checked that none did (although it was a while ago).  Additionally,
> the timeout on these operations is retries * command timeout.  So for
> the default 5 retries and 30 seconds, you actually get to tolerate
> BUSY/QUEUE_FULL for 2.5 minutes before you get an error.  If this is a
> problem, you can bump up the timer in
> 
> /sys/class/scsi_device/<id>/device/timeout
> 

Yes, Linux/SCSI hosts have a sane default timeout + retries, and aren't
the ones who really need SAM_STAT_BUSY + SAM_STAT_TASK_SET_FULL
responses intermittently to avoid going nuts.

It's for ESX 5+ hosts, that with iscsi use a hard-coded (non user
configurable) timeout of 5 seconds, before attempting ABORT_TASK and
friends.  For FC, it's LLD dependent, and IIRC the default for qla2xxx
is 20 seconds.


