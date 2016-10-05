From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 6/7] SRP transport: Port srp_wait_for_queuecommand() to
 scsi-mq
Date: Wed, 5 Oct 2016 14:51:50 -0700
Message-ID: <619e3ffc-2123-4cb0-361a-4025ba47b991@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <bedf4b45-00b0-6844-047d-f1e05bb1092f@sandisk.com>
 <8ce2910d-fde0-724f-a61f-8fbd7fbf499d@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <8ce2910d-fde0-724f-a61f-8fbd7fbf499d@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/05/2016 10:38 AM, Sagi Grimberg wrote:
>> +static void srp_mq_wait_for_queuecommand(struct Scsi_Host *shost)
>> +{
>> +    struct scsi_device *sdev;
>> +    struct request_queue *q;
>> +
>> +    shost_for_each_device(sdev, shost) {
>> +        q = sdev->request_queue;
>> +
>> +        blk_mq_quiesce_queue(q);
>> +        blk_mq_resume_queue(q);
>> +    }
>> +}
>> +
>
> This *should* live in scsi_lib.c. I suspect that
> various drivers would really want this functionality.

Hello Sagi,

There are multiple direct blk_*() calls in other SCSI transport drivers. 
So my proposal is to wait with moving this code into scsi_lib.c until 
there is a second user of this code.

Bart.
