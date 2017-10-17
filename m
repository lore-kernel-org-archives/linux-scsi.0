From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Tue, 17 Oct 2017 11:09:15 -0700
Message-ID: <782e3b9b-2aae-e013-bedc-3c35cb0f7edd@wdc.com>
References: <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013160731.GA30899@ming.t460p> <1507912260.13345.0.camel@wdc.com>
 <20171013164519.GF30899@ming.t460p> <1507914527.13345.17.camel@wdc.com>
 <20171013172950.GA32319@ming.t460p>
 <515ca83f-5629-31e2-ef70-1869ae1b75ef@suse.de>
 <20171017012922.GD15996@ming.t460p>
 <6e8162a0-6ff3-2691-af79-13548a8834c6@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <6e8162a0-6ff3-2691-af79-13548a8834c6@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 10/16/17 23:38, Hannes Reinecke wrote:
> Again, these are just some pre-defined values to avoid I/O starvation
> when having several LUNs. _if_ we can guarantee I/O fairness between
> several (hundreds!) devices all sharing the same tagspace we wouldn't
> need these variables.

I think we already have two mechanisms for guaranteeing I/O fairness:
* Scsi_Host.starved_list for both the legacy SCSI core and scsi-mq.
* For scsi-mq, the active_queues counter in the blk-mq core. See also
   hctx_may_queue().

Bart.
