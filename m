From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Sat, 14 Oct 2017 01:29:55 +0800
Message-ID: <20171013172950.GA32319@ming.t460p>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013160731.GA30899@ming.t460p>
 <1507912260.13345.0.camel@wdc.com>
 <20171013164519.GF30899@ming.t460p>
 <1507914527.13345.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507914527.13345.17.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 13, 2017 at 05:08:52PM +0000, Bart Van Assche wrote:
> On Sat, 2017-10-14 at 00:45 +0800, Ming Lei wrote:
> > On Fri, Oct 13, 2017 at 04:31:04PM +0000, Bart Van Assche wrote:
> > > On Sat, 2017-10-14 at 00:07 +0800, Ming Lei wrote:
> > > > Actually it is in hot path, for example, lpfc and qla2xx's queue depth is 3,
> > > 
> > > Sorry but I doubt whether that is correct. More in general, I don't know any modern
> > > storage HBA for which the default queue depth is so low.
> > 
> > You can grep:
> > 
> > [ming@ming linux]$ git grep -n cmd_per_lun ./drivers/scsi/ | grep -E "qla2xxx|lpfc"
> 
> Such a low queue depth will result in suboptimal performance for adapters
> that communicate over a storage network. I think that's a bug and that both
> adapters support much higher cmd_per_lun values.
> 
> (+James Smart)
> 
> James, can you explain us why commit 445cf4f4d2aa decreased LPFC_CMD_PER_LUN
> from 30 to 3? Was that perhaps a workaround for a bug in a specific target
> implementation?
> 
> (+Himanshu Madhani)
> 
> Himanshu, do you perhaps know whether it is safe to increase cmd_per_lun for
> the qla2xxx initiator driver to the scsi_host->can_queue value?

->can_queue is size of the whole tag space shared by all LUNs, looks it isn't
reasonable to increase cmd_per_lun to .can_queue.

> 
> > Even SRP/IB isn't big too, just 32.
> 
> The default value for ib_srp for cmd_per_lun is 62 but that value can be
> overridden by selecting another value in /etc/default/srp_daemon.conf. Note:
> a lower value is selected if after SRP login it becomes clear that the target
> queue depth is lower than the cmd_per_lun value requested by the user. This
> is a performance optimization and avoids that the SRP target system has to
> send back BUSY responses to the initiator.

OK, thanks for sharing, I just read it as 32 in Laurence's machine.

-- 
Ming
