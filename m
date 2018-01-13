From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 3/4] scsi: Avoid that .queuecommand() gets called for
 a quiesced SCSI device
Date: Sat, 13 Jan 2018 23:54:32 +0800
Message-ID: <20180113155431.GG8013@ming.t460p>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
 <20180110181817.25166-4-bart.vanassche@wdc.com>
 <20180111022341.GA7290@ming.t460p>
 <1515797155.2396.86.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515797155.2396.86.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "jgg@mellanox.com" <jgg@mellanox.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 12, 2018 at 10:45:57PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 10:23 +0800, Ming Lei wrote:
> > > not sufficient to prevent .queuecommand() calls from scsi_send_eh_cmnd().
> > 
> > Given it is error handling, do we need to prevent the .queuecommand() call
> > in scsi_send_eh_cmnd()? Could you share us what the actual issue
> > observed is from user view?
> 
> Please have a look at the kernel bug report in the description of patch 4/4 of
> this series.

Thanks for your mentioning, then I can find the following comment in
srp_queuecommand():

		/*
		 * The SCSI EH thread is the only context from which srp_queuecommand()
		 * can get invoked for blocked devices (SDEV_BLOCK /
		 * SDEV_CREATED_BLOCK). Avoid racing with srp_reconnect_rport() by
		 * locking the rport mutex if invoked from inside the SCSI EH.
		 */

That means EH request is allowed to send to blocked device.

I also replied in patch 4/4, looks there is one simple one line change
which should address the issue of 'sleep in atomic context', please discuss that
in patch 4/4 thread.

-- 
Ming
