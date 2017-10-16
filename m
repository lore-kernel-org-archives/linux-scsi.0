From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Mon, 16 Oct 2017 13:30:09 +0200
Message-ID: <515ca83f-5629-31e2-ef70-1869ae1b75ef@suse.de>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013160731.GA30899@ming.t460p> <1507912260.13345.0.camel@wdc.com>
 <20171013164519.GF30899@ming.t460p> <1507914527.13345.17.camel@wdc.com>
 <20171013172950.GA32319@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013172950.GA32319@ming.t460p>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2017 07:29 PM, Ming Lei wrote:
> On Fri, Oct 13, 2017 at 05:08:52PM +0000, Bart Van Assche wrote:
>> On Sat, 2017-10-14 at 00:45 +0800, Ming Lei wrote:
>>> On Fri, Oct 13, 2017 at 04:31:04PM +0000, Bart Van Assche wrote:
>>>> On Sat, 2017-10-14 at 00:07 +0800, Ming Lei wrote:
>>>>> Actually it is in hot path, for example, lpfc and qla2xx's queue depth is 3,
>>>>
>>>> Sorry but I doubt whether that is correct. More in general, I don't know any modern
>>>> storage HBA for which the default queue depth is so low.
>>>
>>> You can grep:
>>>
>>> [ming@ming linux]$ git grep -n cmd_per_lun ./drivers/scsi/ | grep -E "qla2xxx|lpfc"
>>
>> Such a low queue depth will result in suboptimal performance for adapters
>> that communicate over a storage network. I think that's a bug and that both
>> adapters support much higher cmd_per_lun values.
>>
>> (+James Smart)
>>
>> James, can you explain us why commit 445cf4f4d2aa decreased LPFC_CMD_PER_LUN
>> from 30 to 3? Was that perhaps a workaround for a bug in a specific target
>> implementation?
>>
>> (+Himanshu Madhani)
>>
>> Himanshu, do you perhaps know whether it is safe to increase cmd_per_lun for
>> the qla2xxx initiator driver to the scsi_host->can_queue value?
> 
> ->can_queue is size of the whole tag space shared by all LUNs, looks it isn't
> reasonable to increase cmd_per_lun to .can_queue.
> 
'3' is just a starting point; later on it'll be adjusted via
scsi_change_depth().
Looks like it's not working correctly with blk-mq, though.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
