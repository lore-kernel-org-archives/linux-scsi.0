From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 9/9] sd: Implement support for ZBC devices
Date: Sat, 16 Apr 2016 13:34:49 +0200
Message-ID: <57122359.60004@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-10-git-send-email-hare@suse.de>
 <5711336D.80201@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbcDPLew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Apr 2016 07:34:52 -0400
In-Reply-To: <5711336D.80201@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/15/2016 08:31 PM, Bart Van Assche wrote:
> On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
>> @@ -728,6 +729,10 @@ static int sd_setup_discard_cmnd(struct scsi_cm=
nd
>> *cmd)
>>       int ret =3D 0;
>>       char *buf;
>>       struct page *page =3D NULL;
>> +#ifdef CONFIG_SCSI_ZBC
>> +    struct blk_zone *zone;
>> +    unsigned long flags;
>> +#endif
>
> There is a strong preference in the Linux kernel for avoiding #ifdefs
> and to move code that depends on the value of a CONFIG_* variable int=
o a
> file for which the compilation depends on that CONFIG_* variable. Ple=
ase
> consider to move the ZBC code from sd_setup_discard_cmnd() into a new
> function in sd_zbc.c.
>
Well; the integrity code also added some #ifdefs, so I thought it would=
=20
be acceptable, too.

I can reconsider it, of course, if preferred.

>> +#ifdef CONFIG_SCSI_ZBC
>> +        zone =3D blk_lookup_zone(rq->q, sector);
>> +        if (!zone) {
>> +            ret =3D BLKPREP_KILL;
>> +            goto out;
>> +        }
>> +        spin_lock_irqsave(&zone->lock, flags);
>> +        if (zone->state =3D=3D BLK_ZONE_BUSY) {
>> +            sd_printk(KERN_INFO, sdkp,
>> +                  "Discarding busy zone %zu/%zu\n",
>> +                  zone->start, zone->len);
>> +            spin_unlock_irqrestore(&zone->lock, flags);
>> +            ret =3D BLKPREP_DEFER;
>> +            goto out;
>> +        }
>> +        if (!blk_zone_is_smr(zone)) {
>> +            sd_printk(KERN_INFO, sdkp,
>> +                  "Discarding %s zone %zu/%zu\n",
>> +                  blk_zone_is_cmr(zone) ? "CMR" : "unknown",
>> +                  zone->start, zone->len);
>> +            spin_unlock_irqrestore(&zone->lock, flags);
>> +            ret =3D BLKPREP_DONE;
>> +            goto out;
>> +        }
>> +        if (blk_zone_is_empty(zone)) {
>> +            spin_unlock_irqrestore(&zone->lock, flags);
>> +            ret =3D BLKPREP_DONE;
>> +            goto out;
>> +        }
>> +        if (zone->start !=3D sector ||
>> +            zone->len < nr_sectors) {
>> +            sd_printk(KERN_INFO, sdkp,
>> +                  "Misaligned RESET WP, start %zu/%zu "
>> +                  "len %zu/%u\n",
>> +                  zone->start, sector, zone->len, nr_sectors);
>> +            spin_unlock_irqrestore(&zone->lock, flags);
>> +            ret =3D BLKPREP_KILL;
>> +            goto out;
>> +        }
>> +        /*
>> +         * Opportunistic setting, needs to be fixed up
>> +         * if RESET WRITE POINTER fails.
>> +         */
>> +        zone->wp =3D zone->start;
>> +        spin_unlock_irqrestore(&zone->lock, flags);
>> +#endif
>  >           cmd->cmd_len =3D 16;
>  >           cmd->cmnd[0] =3D ZBC_OUT;
>  >           cmd->cmnd[1] =3D ZO_RESET_WRITE_POINTER;
>
> Which mechanism prevents that zone->state is modified after it has be=
en
> checked and before the RESET WRITE POINTER command has finished?
>
See below.

>> @@ -990,6 +1041,13 @@ static int sd_setup_read_write_cmnd(struct
>> scsi_cmnd *SCpnt)
>>       SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=3D%ll=
u\n",
>>                       (unsigned long long)block));
>>
>> +    if (sdkp->zoned =3D=3D 1 || sdp->type =3D=3D TYPE_ZBC) {
>> +        /* sd_zbc_lookup_zone lba is in block layer sector units */
>> +        ret =3D sd_zbc_lookup_zone(sdkp, rq, block, this_count);
>> +        if (ret !=3D BLKPREP_OK)
>> +            goto out;
>> +    }
>> +
>
> Which mechanism guarantees that the above code won't run concurrently
> with zbc_parse_zones()?
>
See below. There is no overall lock (the zone layout is considered=20
immutable once set), but each zone has its own spinlock.
If the zone state is set to BUSY (see below) sd_zbc_lookup_zone will=20
return BLKPREP_DEFER, and the request won't be scheduled.

>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>> index 5debd49..35c75fa 100644
>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -65,6 +65,12 @@ struct scsi_disk {
>>       struct scsi_device *device;
>>       struct device    dev;
>>       struct gendisk    *disk;
>> +#ifdef CONFIG_SCSI_ZBC
>> +    struct workqueue_struct *zone_work_q;
>> +    unsigned long    zone_flags;
>> +#define SD_ZBC_ZONE_RESET 1
>> +#define SD_ZBC_ZONE_INIT  2
>> +#endif
>
> The above two constants are only used in source file sd_zbc.c. Have y=
ou
> considered to move the definition of these constants into sd_zbc.c?
>
>> +#undef SD_ZBC_DEBUG
>
> Please use the dynamic_debug facility instead of #ifdef SD_ZBC_DEBUG =
+
> sd_printk().
>
Okay, will be doing so.

>> +void sd_zbc_refresh_zone_work(struct work_struct *work)
>> +{
>> +    struct zbc_update_work *zbc_work =3D
>> +        container_of(work, struct zbc_update_work, zone_work);
>> +    struct scsi_disk *sdkp =3D zbc_work->sdkp;
>> +    struct request_queue *q =3D sdkp->disk->queue;
>> +    unsigned int zone_buflen;
>> +    int ret;
>> +    sector_t last_sector;
>> +    sector_t capacity =3D logical_to_sectors(sdkp->device,
>> sdkp->capacity);
>> +    sector_t zone_lba =3D sectors_to_logical(sdkp->device,
>> +                           zbc_work->zone_sector);
>> +
>> +    zone_buflen =3D zbc_work->zone_buflen;
>> +    ret =3D sd_zbc_report_zones(sdkp, zone_lba, zbc_work->zone_buf,
>> +                  zone_buflen);
>> +    if (ret)
>> +        goto done_free;
>> +
>> +    last_sector =3D zbc_parse_zones(sdkp, zbc_work->zone_buf,
>> zone_buflen);
>> +    if (last_sector !=3D -1 && last_sector < capacity) {
>> +        if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
>> +#ifdef SD_ZBC_DEBUG
>> +            sd_printk(KERN_INFO, sdkp,
>> +                  "zones in reset, cancelling refresh\n");
>> +#endif
>> +            ret =3D -EAGAIN;
>> +            goto done_free;
>> +        }
>> +
>> +        zbc_work->zone_sector =3D last_sector;
>> +        queue_work(sdkp->zone_work_q, &zbc_work->zone_work);
>> +        /* Kick request queue to be on the safe side */
>> +        goto done_start_queue;
>> +    }
>> +done_free:
>> +    kfree(zbc_work);
>> +    if (test_and_clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags) &&
>> ret) {
>> +        sd_printk(KERN_INFO, sdkp,
>> +              "Cancelling zone initialisation\n");
>> +    }
>> +done_start_queue:
>> +    if (q->mq_ops)
>> +        blk_mq_start_hw_queues(q);
>> +    else {
>> +        unsigned long flags;
>> +
>> +        spin_lock_irqsave(q->queue_lock, flags);
>> +        blk_start_queue(q);
>> +        spin_unlock_irqrestore(q->queue_lock, flags);
>> +    }
>> +}
>
> Which mechanism prevents concurrent execution of
> sd_zbc_refresh_zone_work() and READ and WRITE commands?
>
When sd_zbc_refresh_zone_work is started it'll set all zones to be=20
updated to 'BUSY', and the prep_rq() function will defer any I/O
until REPORT_ZONES has returned and updated the state to something=20
other, like BLK_ZONE_OPEN.

Thanks for the review.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
