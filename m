From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Thu, 23 Oct 2014 09:16:31 +0200
Message-ID: <5448AB4F.40507@acm.org>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org> <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593212E0-wwDBVnaDRpYSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Scales, Webb" <webb.scales-VXdhtT5mjnY@public.gmane.org>, "Don Brace (PMC)" <Don.Brace-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/23/14 00:03, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: Bart Van Assche [mailto:bvanassche-HInyCGIudOg@public.gmane.org]
>> Sent: Tuesday, 07 October, 2014 8:07 AM
> ...
>> @@ -1927,7 +1931,7 @@ static int srp_queuecommand(struct Scsi_Host
>> *shost, struct scsi_cmnd *scmnd)
>>
>>   	cmd->opcode = SRP_CMD;
>>   	cmd->lun    = cpu_to_be64((u64) scmnd->device->lun << 48);
>> -	cmd->tag    = req->index;
>> +	cmd->tag    = tag;
>>   	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
>>
>>   	req->scmnd    = scmnd;
> ...
>>
>> +static int srp_slave_alloc(struct scsi_device *sdev)
>> +{
>> +	sdev->tagged_supported = 1;
>> +
>> +	scsi_activate_tcq(sdev, sdev->queue_depth);
>> +
>> +	return 0;
>> +}
>> +
>
> Have you tested this with scsi_mod.use_blk_mq=n?
>
> Trying similar changes in hpsa, we still receive some INQUIRY commands
> submitted through queuecommand with tag -1.  They are for devices for
> which slave_alloc has not yet been run, implying this work needs to
> be done even earlier.  Maybe the midlayer is missing a slave_alloc
> call somewhere?

Hello Rob,

All my tests with use_blk_mq=n were run with a WARN_ON_ONCE(req->tag < 
0) statement present in srp_queuecommand(). I haven't seen any kernel 
warning being triggered during the tests I ran.

I also had a look at scsi_alloc_sdev() in drivers/scsi/scsi_scan.c. The 
number of statements between queue allocation and the slave_alloc() call 
is limited. The only scenario I can think of which could cause 
queuecommand() to be invoked before slave_alloc() is a LUN scan 
initiated from user space via sysfs due to 
scsi_sysfs_device_initialize() being invoked before slave_alloc(). Does 
that make sense to you ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
