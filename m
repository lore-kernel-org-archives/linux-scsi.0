From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
 SAM BUSY/TASK_SET_FULL
Date: Mon, 07 Mar 2016 11:40:06 -0500
Message-ID: <1457368806.632.18.camel@HansenPartnership.com>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com>
	 <1457161634-15756-2-git-send-email-nab@daterainc.com>
	 <20160305210108.GA16337@lst.de>
	 <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
	 <20160306061910.GA1116@infradead.org>
	 <1457301315.32532.12.camel@haakon3.risingtidesystems.com>
	 <20160307075548.GB13884@lst.de>
	 <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-03-07 at 00:03 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2016-03-07 at 08:55 +0100, Christoph Hellwig wrote:
> > On Sun, Mar 06, 2016 at 01:55:15PM -0800, Nicholas A. Bellinger

> >  So as-is this might be well intended but either useless or broken.
> > --
> 
> No, it useful for hosts that have an aggressive SCSI timeout, and it
> works as expected with Linux/SCSI hosts that either retry on BUSY
> status, or retry + reduce queue_depth on TASK_SET_FULL status.

I'm with Christoph on this: BUSY and QUEUE_FULL are already handled
generically in SCSI.  All drivers should use the generics: to handle
separately, the driver has to intercept the error code, which I thought
I checked that none did (although it was a while ago).  Additionally,
the timeout on these operations is retries * command timeout.  So for
the default 5 retries and 30 seconds, you actually get to tolerate
BUSY/QUEUE_FULL for 2.5 minutes before you get an error.  If this is a
problem, you can bump up the timer in

/sys/class/scsi_device/<id>/device/timeout

James
