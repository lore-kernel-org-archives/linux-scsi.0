From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] libata: ATA Information VPD page, lk 2.6.14-rc1+
Date: Wed, 05 Oct 2005 15:18:01 +1000
Message-ID: <43436209.1090208@torque.net>
References: <432E7C48.8060205@torque.net> <43426A36.8050605@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43426A36.8050605@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> Jeff,
<snip>
>>
>> Changelog:
>>   - add support for the ATA Information VPD page [0x89]
>>   - add function to redo IDENTIFY (PACKET) DEVICE ATA
>>     command to update the array dev->id, assumes
>>     ata_dev_identify() has been called.
> 
> 
> Basic idea OK, patch rejected due to the following concerns.  Please
> resend an updated patch.

Jeff,
This patch was sent on 19 September 2005.
Why does a response take so long? [Has Luben's
"I request inclusion ..." thread been going that
long :-) ] With the passage of time, it takes me
longer to rework and retest. Please also consider
the submitter's time.

IMO you are quite capable of making the changes
that you are now requesting me to make ... but
I'll have another shot ...

In the last year or so I have suggested around
twenty libata patches and bug fixes which have
resulted in large signal_to_noise and ignore_or_reject
ratios. Progress seems glacial in terms of SCSI
support. Others have submitted more code than me.
What happened to the ATA PASS THROUGH SCSI commands?
[I would like to use them in smartmontools, hdparm
is coded for them.] My suspicion is that SAT layer in
libata is being maintained "half-baked" so it can be
displaced more easily when the "emulation is bad"
policy is implemented some time in the future.
Makes it hard to get motivated to (re-)roll another
SAT libata patch.

>> @@ -1059,6 +1137,79 @@
>>  }
>>  
>>  /**
>> + *    ata_scsiop_inq_89 - Simulate INQUIRY EVPD page 83, ATA information
>> + *    @args: device IDENTIFY data / SCSI command of interest.
>> + *    @rbuf: Response buffer, to which simulated SCSI cmd output is
>> sent.
>> + *    @buflen: Response buffer length.
>> + *
>> + *    Yields ATA (and SAT layer) information. Defined per sat-r05
>> + *    This function should also be called for S-ATAPI devices.
>> + *
>> + *    LOCKING:
>> + *    spin_lock_irqsave(host_set lock)
>> + */
>> +
>> +unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
>> +                   unsigned int buflen)
>> +{
>> +    struct ata_port *ap;
>> +    struct ata_device *dev;
>> +    struct scsi_cmnd *cmd = args->cmd;
>> +    struct scsi_device *scsidev = cmd->device;
>> +    u8 *scsicmd = cmd->cmnd;
>> +    unsigned int out_len;
>> +    int res;
>> +    const int spec_page_len = 568;
>> +    u8 b[60];
>> +    int is_atapi_dev = 0;
>> +
>> +    out_len = (scsicmd[3] << 8) + scsicmd[4];
>> +    out_len = (buflen < out_len) ? buflen : out_len;
>> +    memset(b, 0, sizeof(b));
>> +    ap = (struct ata_port *)&scsidev->host->hostdata[0];
>> +    if (ap) {
>> +        dev = ata_scsi_find_dev(ap, scsidev);
>> +        if (dev && (dev->class != ATA_DEV_ATA)) {
> 
> 
> test dev->class == ATA_DEV_ATAPI, as we may soon add port multiplier
> device classes, breaking the assumption you're making here.

Ok. Perhaps you could add the appropriate code here
since I'm not familiar with what is planned. I just
looked at existing ATA code for guidance.

>> +            is_atapi_dev = 1;
>> +            b[0] = 0x5;    /* assume MMC device, dubious */
>> +        }
>> +    } else
>> +        dev = NULL;
>> +    b[1] = 0x89;            /* this page code */
>> +    b[2] = (spec_page_len >> 8) & 0xff;
>> +    b[3] = spec_page_len & 0xff;
>> +    strncpy(b + 8, "linux   ", 8);
>> +    strncpy(b + 16, "libata          ", 16);
> 
> 
> can we stuff DRV_VERSION in there too?

Sure ...

>> +    strncpy(b + 32, "0001", 4);
>> +    /* signature stuff goes here, where to fetch it from? */
>> +    b[36] = 0x34;        /* FIS type */
>> +    b[36 + 1] = 0x0;    /* interrupt + PM port */
>> +    b[36 + 4] = 0x1;    /* lba low */
>> +    b[36 + 5] = is_atapi_dev ? 0x14 : 0x0;    /* lba mid */
>> +    b[36 + 6] = is_atapi_dev ? 0xeb : 0x0;    /* lba high */
>> +    b[36 + 12] = 0x1;    /* sector count */
> 
> 
> this is a sufficient simulation for now.  for the future, when other
> devices such as enclosure, port multipliers, and such are supported,
> we'll probably want to cache the signature returned by the device.

What the draft wanted was a copy of those registers just after the
most recent device reset. I do not know how to do this (or if that
information is held) so I filled those in from a table of
indicative values in the draft.

>> +    b[56] = is_atapi_dev ? 0xa1 : 0xec;    /* command code */
>> +
>> +    memcpy(rbuf, b, ((sizeof(b) < out_len) ? sizeof(b) : out_len));
>> +    if ((out_len <= sizeof(b)) || (! ap) || (! dev))
>> +        return 0;
>> +   
>> +    spin_unlock_irq(&ap->host_set->lock);
>> +    res = ata_dev_redo_identify(ap, scsidev->id);
>> +    spin_lock_irq(&ap->host_set->lock);
>> +    if (res) {
>> +        /* sat-r05 says ok, leave IDENTIFY response all zeroes */
>> +        DPRINTK("ata_dev_redo_identify failed\n");
>> +        return 0;
>> +    }
> 
> 
> Just eliminate this.  dev->id should be considered always current.  If
> it is not, that should be fixed elsewhere in libata.

"Since some fields within the IDENTIFY DEVICE and IDENTIFY PACKET
DEVICE may change depending on the state of the attached ATA
device the SATL shall issue the IDENTIFY DEVICE or IDENTIFY
PACKET DEVICE command to retrieve the updated data whenever the
ATA Information VPD page is requested." [sat-r06, section 10.3.5
page 84, describing that field]

Well that seems pretty clear to me. When I write apps like sdparm
and sg_inq then I would feel confident documenting that the most
up to date response data will be fetched irrespective of the
the transport and the topology. As I have pointed out on
another thread, the presence of multiple initiators in SAS with
the STP makes caching device state problematic. STP affiliations
seem only to span a single connection which at best stops
co-incident ATA commands interfering with one another, however
they won't help if 2 hosts (initiators) send contradictory SET
FEATURE commands, one soon after the other.

So if you disagree with that then that is your decision
as the maintainer. However I don't want to sign off on
code that I am aware violates a draft that I claim to
follow unless I agree with the change. If I disagree with
the SAT draft then I take it up with t10@t10.org , just
as you have in the past.

As discussed in relation to the implementation of the MODE
SELECT SCSI command (to change SATA disk attributes), there
is a need for a function like ata_dev_redo_identify() anyway.
If there is another function to do this (and for that matter
a way for the userspace to resync the dev->id array), perhaps
you could point it out to me.


Is anyone aware if other OSes have a SAT layer that we
might study? It seems as if SAT layers are appearing
in silicon judging from the SR-1216 and the BR-2401
FC to SATA bridge/routers from Sierra Logic.

Doug Gilbert



