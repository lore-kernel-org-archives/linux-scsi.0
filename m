From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH V3] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Sat, 3 Mar 2018 09:41:40 +0800
Message-ID: <e867f55a-a027-4658-1e11-50a65f383626@oracle.com>
References: <1519961474-15236-1-git-send-email-jianchao.w.wang@oracle.com>
 <1520008291.2855.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520008291.2855.7.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Bart

Thanks for your kindly response and directive.

On 03/03/2018 12:31 AM, Bart Van Assche wrote:
> On Fri, 2018-03-02 at 11:31 +0800, Jianchao Wang wrote:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index a86df9c..d2f1838 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -191,7 +191,13 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>>  	 */
>>  	cmd->result = 0;
>>  	if (q->mq_ops) {
>> -		scsi_mq_requeue_cmd(cmd);
>> +		/*
>> +		 * scsi_device.sdev_gendev will be get every time in .get_budget and
>> +		 * be put in scsi_end_request. Hence we need to put the reference
>> +		 * here when we decide to requeue request.
>> +		 */
>> +		blk_mq_requeue_request(cmd->request, true);
>> +		put_device(&device->sdev_gendev);
>>  		return;
>>  	}
>>  	spin_lock_irqsave(q->queue_lock, flags);
> 
> Please consider to change the new comment into something like the following:
> "Before a SCSI command is dispatched, get_device(&sdev->sdev_gendev) is called
> and the host, target and device busy counters are increased. Since requeuing a
> request causes these actions to be repeated and since scsi_device_unbusy() has
> already been called, put_device(&device->sdev_gendev) must still be called. Call
> put_device() after blk_mq_requeue_request() to avoid that removal of the SCSI
> device can start before requeueing has happened."

Yes, your comment is more detailed and clearly.

Sincerely
Jianchao
