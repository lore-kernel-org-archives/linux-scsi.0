From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: Re: [RFC PATCH 07/10] scsi/trace: Use scsi_show_result trace
 point instead of printk
Date: Thu, 28 Aug 2014 10:37:41 +0900
Message-ID: <53FE87E5.6030604@hitachi.com>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115022.6768.33712.stgit@yuno-kbuild.novalocal> <53FDE743.2040705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53FDE743.2040705@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

(2014/08/27 23:12), Hannes Reinecke wrote:
> On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
>> Current SCSI trace has hostbyte table and driverbyte table, so we
>> don't need to
>> have the same table in scsi/constants.c.
>>
>> - Result examples
>>
>> <Before> (printk)
>> sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>
>> <After> (ftrace)
>> scsi_show_result: host_no=2 channel=0 id=0 lun=0 [sda]
>> result=(driver=DRIVER_SENSE host=DID_OK)
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Doug Gilbert <dgilbert@interlog.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>   drivers/scsi/constants.c    |   52
>> -------------------------------------------
>>   drivers/scsi/scsi_trace.c   |   16 +++++++++++++
>>   include/trace/events/scsi.h |   38 +++++++++++++++++++++++++++++++
>>   3 files changed, 53 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 6fad6b4..f7b7f32 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1488,55 +1488,3 @@ void scsi_print_sense(struct scsi_cmnd *cmd)
>>                  SCSI_SENSE_BUFFERSIZE);
>>   }
>>   EXPORT_SYMBOL(scsi_print_sense);
>> -
>> -#ifdef CONFIG_SCSI_CONSTANTS
>> -
>> -static const char * const hostbyte_table[]={
>> -"DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT",
>> "DID_BAD_TARGET",
>> -"DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
>> -"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
>> -"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",
>> "DID_TARGET_FAILURE",
>> -"DID_NEXUS_FAILURE" };
>> -#define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
>> -
>> -static const char * const driverbyte_table[]={
>> -"DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA",
>> "DRIVER_ERROR",
>> -"DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
>> -#define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
>> -
>> -void scsi_show_result(struct scsi_device *sdev, const char *name, int
>> result)
>> -{
>> -    int hb = host_byte(result);
>> -    int db = driver_byte(result);
>> -    const char *hb_string;
>> -    const char *db_string;
>> -
>> -    hb_string = (hb < NUM_HOSTBYTE_STRS) ? hostbyte_table[hb] :
>> "invalid";
>> -    db_string = (db < NUM_DRIVERBYTE_STRS) ?
>> -        driverbyte_table[db] : "invalid";
>> -
>> -
>> -    sdev_printk(KERN_INFO, sdev,
>> -            "[%s] Result: hostbyte=%s driverbyte=%s\n",
>> -            name, hb_string, db_string);
>> -}
>> -
>> -#else
>> -
>> -void scsi_show_result(struct scsi_device *sdev, const char *name, int
>> result)
>> -{
>> -    sdev_printk(KERN_INFO, sdev,
>> -            "[%s] Result: hostbyte=0x%02x driverbyte=0x%02x\n",
>> -            name, host_byte(result), driver_byte(result));
>> -}
>> -
>> -#endif
>> -EXPORT_SYMBOL(scsi_show_result);
>> -
>> -void scsi_print_result(struct scsi_cmnd *cmd)
>> -{
>> -    const char *devname = cmd->request->rq_disk ?
>> -        cmd->request->rq_disk->disk_name : "scsi";
>> -    scsi_show_result(cmd->device, devname, cmd->result);
>> -}
>> -EXPORT_SYMBOL(scsi_print_result);
>> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
>> index 2bea4f0..6ffbc40 100644
>> --- a/drivers/scsi/scsi_trace.c
>> +++ b/drivers/scsi/scsi_trace.c
>> @@ -19,6 +19,8 @@
>>   #include <linux/trace_seq.h>
>>   #include <trace/events/scsi.h>
>>
>> +#include <scsi/scsi_dbg.h>
>> +
>>   #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
>>   #define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
>>
>> @@ -286,3 +288,17 @@ scsi_trace_parse_cdb(struct trace_seq *p,
>> unsigned char *cdb, int len)
>>           return scsi_trace_misc(p, cdb, len);
>>       }
>>   }
>> +
>> +void scsi_show_result(struct scsi_device *sdev, const char *name, int
>> result)
>> +{
>> +    trace_scsi_show_result(sdev, name, result);
>> +}
>> +EXPORT_SYMBOL(scsi_show_result);
>> +
>> +void scsi_print_result(struct scsi_cmnd *cmd)
>> +{
>> +    const char *devname = cmd->request->rq_disk ?
>> +        cmd->request->rq_disk->disk_name : "scsi";
>> +    scsi_show_result(cmd->device, devname, cmd->result);
>> +}
>> +EXPORT_SYMBOL(scsi_print_result);
>> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
>> index 8aecdc2..0675195 100644
>> --- a/include/trace/events/scsi.h
>> +++ b/include/trace/events/scsi.h
>> @@ -123,7 +123,11 @@
>>           scsi_hostbyte_name(DID_IMM_RETRY),        \
>>           scsi_hostbyte_name(DID_REQUEUE),        \
>>           scsi_hostbyte_name(DID_TRANSPORT_DISRUPTED),    \
>> -        scsi_hostbyte_name(DID_TRANSPORT_FAILFAST))
>> +        scsi_hostbyte_name(DID_TRANSPORT_FAILFAST),    \
>> +        scsi_hostbyte_name(DID_TARGET_FAILURE),        \
>> +        scsi_hostbyte_name(DID_NEXUS_FAILURE),        \
>> +        scsi_hostbyte_name(DID_ALLOC_FAILURE),        \
>> +        scsi_hostbyte_name(DID_MEDIUM_ERROR))
>>
>>   #define scsi_driverbyte_name(result)    { result, #result }
>>   #define show_driverbyte_name(val)                \
>> @@ -359,6 +363,38 @@ TRACE_EVENT(scsi_eh_wakeup,
>>       TP_printk("host_no=%u", __entry->host_no)
>>   );
>>
>> +TRACE_EVENT(scsi_show_result,
>> +
>> +    TP_PROTO(struct scsi_device *sdev, const char *devname, int result),
>> +
>> +    TP_ARGS(sdev, devname, result),
>> +
>> +    TP_STRUCT__entry(
>> +        __field( unsigned int,    host_no    )
>> +        __field( unsigned int,    channel    )
>> +        __field( unsigned int,    id    )
>> +        __field( unsigned int,    lun    )
>> +        __string(devname,    devname    )
>> +        __field( int,        result    )
>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->host_no    = sdev->host->host_no;
>> +        __entry->channel    = sdev->channel;
>> +        __entry->id        = sdev->id;
>> +        __entry->lun        = sdev->lun;
>> +        __assign_str(devname, devname);
>> +        __entry->result        = result;
>> +    ),
>> +
>> +    TP_printk("host_no=%u channel=%u id=%u lun=%u [%s]
>> result=(driver=%s "\
>> +          "host=%s)",
>> +          __entry->host_no, __entry->channel, __entry->id, __entry->lun,
>> +          __get_str(devname),
>> +          show_driverbyte_name(driver_byte(__entry->result)),
>> +          show_hostbyte_name(host_byte(__entry->result)))
>> +);
>> +
>>   #endif /*  _TRACE_SCSI_H */
>>
>>   /* This part must be outside protection */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Hmm.
> I'm not sure this is the correct way.
> Currently we have quite some code duplication in scsi_trace.c and
> constants.c, correct.
> So I definitely would like to see them both merged.
>
> But constants.c is influenced by CONFIG_SCSI_CONSTANTS, whereas
> scsi_trace isn't, and the functions in constants.c are used throughout
> the scsi stack.
> So I'd rather see to have scsi_trace to be updated to use the functions
> from constants.c, and remove the duplicate code in
> scsi_trace.

Sure. We'll use decoder in constants.c.
We need to support raw output format for existing traceevents.

> At a later step we should be working on removing/replacing existing
> logging code in the SCSI stack with trace points, but that should be
> reserved for a separate patchset.

OK, I'll create a patch replacing existing decoder first, then
I'll add new traceevents.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
