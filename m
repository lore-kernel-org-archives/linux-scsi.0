From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 07/12] IB/srp: Avoid that I/O hangs due to a cable
 pull during LUN scanning
Date: Mon, 20 Oct 2014 14:15:07 +0200
Message-ID: <5444FCCB.2030503@acm.org>
References: <5433E43D.3010107@acm.org> <5433E504.1070306@acm.org> <5443E66F.7050901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5443E66F.7050901-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/19/14 18:27, Sagi Grimberg wrote:
> On 10/7/2014 4:05 PM, Bart Van Assche wrote:
>> +static int srp_sdev_count(struct Scsi_Host *host)
>> +{
>> +    struct scsi_device *sdev;
>> +    int c = 0;
>> +
>> +    shost_for_each_device(sdev, host)
>> +        c++;
>> +
>> +    return c;
>> +}
>> +
>
> Is this really an SRP specific routine?
> Can you move it to a more natural location?

How about renaming this function into shost_sdev_count() and moving its 
declaration to <scsi/scsi_device.h> and its implementation to 
drivers/scsi/scsi_lib.c ?

>>   static int srp_add_target(struct srp_host *host, struct
>> srp_target_port *target)
>>   {
>>       struct srp_rport_identifiers ids;
>>       struct srp_rport *rport;
>>
>> +    target->state = SRP_TARGET_SCANNING;
>>       sprintf(target->target_name, "SRP.T10:%016llX",
>>            (unsigned long long) be64_to_cpu(target->id_ext));
>>
>> @@ -2634,11 +2650,26 @@ static int srp_add_target(struct srp_host
>> *host, struct srp_target_port *target)
>>       list_add_tail(&target->list, &host->target_list);
>>       spin_unlock(&host->target_lock);
>>
>> -    target->state = SRP_TARGET_LIVE;
>> -
>>       scsi_scan_target(&target->scsi_host->shost_gendev,
>>                0, target->scsi_id, SCAN_WILD_CARD, 0);
>>
>> +    if (!target->connected || target->qp_in_error) {
>> +        shost_printk(KERN_INFO, target->scsi_host,
>> +                 PFX "SCSI scan failed - removing SCSI host\n");
>> +        srp_queue_remove_work(target);
>> +        goto out;
>> +    }
>
> So my impression is that by conditioning target->qp_in_error you are
> relying on the fact that SRP eh was invoked here (RC error), what if
> scsi eh was invoked prior to that? did you test this path?

This code path has been tested. It's not that hard to trigger this code 
path - setting the channel count (ch_count) parameter to a high value 
and running a loop at the target side that disables IB ports after a 
random delay between 0s and (2*srp_daemon_scan_interval) is sufficient. 
After not too many iterations this code will be hit because the higher 
the channel count the longer it takes to log in.

The SCSI EH is only activated after a SCSI command has failed. No SCSI 
commands are sent to a target system before the scsi_scan_target() call. 
This means that the SCSI EH can only get activated while 
scsi_scan_target() is in progress or after that function has finished.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
