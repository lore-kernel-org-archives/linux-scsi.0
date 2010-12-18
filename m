From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: RFC: short reads on block devices
Date: Fri, 17 Dec 2010 20:19:44 -0500
Message-ID: <4D0C0C30.7050204@interlog.com>
References: <4D0B945C.2060309@interlog.com> <1292618194.2820.90.camel@mulgrave.site>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60949 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab0LRBTw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 20:19:52 -0500
In-Reply-To: <1292618194.2820.90.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Penokie, George" <George.Penokie@lsi.com>, mkp@mkp.net, IDE/ATA development list <linux-ide@vger.kernel.org>

On 10-12-17 03:36 PM, James Bottomley wrote:
> On Fri, 2010-12-17 at 11:48 -0500, Douglas Gilbert wrote:
>> Recently while testing with the scsi_debug driver
>> I was able to trick the block layer into reading
>> random data which the block layer thought was
>> valid ***.
>>
>> Best to start with an example, say LBA ** 4660 has
>> an unrecoverable error (aka medium error) and
>> the block layer fires off a SCSI READ for 8
>> blocks (512 byte variety) at LBA 4656. The response
>> will be a medium error with the sense buffer info
>> field indicating LBA 4660. Now are the 4 blocks
>> that precede it (i.e. LBA 4656 to 4659) possibly
>> sitting in the data-in buffer and valid??
>>
>> The block layer thinks they are. This is what my
>> term "short read" in the title alludes to. So I put
>> this question to the T10 reflector:
>>      http://www.t10.org/t10r.htm
>> titled "sbc: reading blocks prior to a medium error".
>> And the answers were pretty clear. And the one from
>> George Penokie of LSI is interesting because Linux's
>> block layer assumption breaks some of LSI's equipment.
>
> Well, unsurprisingly, I was aware of the issue via Novell customer
> interactions.  Since you've outed LSI, we can discuss it openly.
>
> The fact is that for medium errors, every other array returns valid data
> up to the erroring sector.
>
>> On the other hand, big array vendors and database vendors
>> want exactly what the block layer is doing at the moment.
>> So those guys don't want a change. [Please correct me
>> if that is too sweeping.] Also I'm informed some other
>> OSes do this as well.
>
> Plus all disk devices transfer up to the error sector.  Additionally,
> Martin Petersen uses the same code for DIF and he's secured external
> agreement from the DIF based arrays that nothwithstanding the ambiguity
> in the SCSI standards, all DIF arrays return valid data up to the sector
> with the DIF error.
>
>> I would like to propose a solution, at least in the SCSI
>> subsystem context. The 'resid' field was added 11 years
>> ago and is used by a HBA driver to indicate how many bytes
>> less than requested were placed in the scatter gather
>> list (i.e. the data-in buffer). It defaults to zero
>> (meaning all requested bytes have been read). Usually
>> for a medium error one would not bother setting resid
>> (so resid would remain 0). Somewhat surprisingly the
>> block layer has always ignored resid. I propose in the
>> case of a short read caused by a MEDIUM ERROR the block
>> layer checks resid. And if resid equals the requested
>> number of bytes then that means no data in the scatter
>> gather list is valid. So the block layer should act on
>> this information.
>>
>> To this end I propose to change the scsi_debug driver
>> to set resid equal to bufflen when it simulates a
>> medium error.
>>
>> Changes in the block layer and drivers from vendors who
>> want the strict "T10" handling of medium errors would
>> also be required. Maybe the USB mass storage (and UAS)
>> folks might also check if this impacts them.
>
> OK, so I checked, and I think all of the major in-use HBA drivers today
> do set the residue, so I'd be reasonably happy with a modification like
> the following.  It basically believes the lower of either the
> transferred data or the listed error (assuming the listed error is
> valid ... if it's invalid, we still assume we can't trust anything).
> This should mean that HBA drivers that set the residue work for all
> arrays and those that don't work as they do today.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9564961..d41eaa2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1175,6 +1175,12 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
>   	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
>   	u64 bad_lba;
>   	int info_valid;
> +	/*
> +	 * resid is optional but mosly filled in.  When it's unused,
> +	 * its value is zero, so we assume the whole buffer transferred
> +	 */
> +	unsigned int transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
> +	unsigned int good_bytes;
>
>   	if (scmd->request->cmd_type != REQ_TYPE_FS)
>   		return 0;
> @@ -1208,7 +1214,8 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
>   	/* This computation should always be done in terms of
>   	 * the resolution of the device's medium.
>   	 */
> -	return (bad_lba - start_lba) * scmd->device->sector_size;
> +	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
> +	return min(good_bytes, transferred);
>   }
>
>   /**

James,
This patch to the sd driver together with the one I made
to the scsi_debug driver (sent to the linux-scsi list)
fixes the corruption problem in lk 2.6.36 .

Below is a dd command and the resulting log file
ouput. The log shows the actual SCSI READs sent
to the scsi_debug pseudo device (the medium error
is at LBA 0x1234):

# dd if=/dev/sdc of=ttt.img
dd: reading `/dev/sdc': Input/output error
4656+0 records in
4656+0 records out
2383872 bytes (2.4 MB) copied, 0.0722803 s, 33.0 MB/s

....
scsi_debug: cmd 28 00 00 00 0f e0 00 01 00 00
scsi_debug: cmd 28 00 00 00 10 e0 00 01 00 00
scsi_debug: cmd 28 00 00 00 11 e0 00 01 00 00
scsi_debug:    [sense_key,asc,ascq]: [0x3,0x11,0x0]
scsi_debug:    <8 0 0 0> non-zero result=0x8000002
sd 8:0:0:0: [sdc] Unhandled sense code
sd 8:0:0:0: [sdc]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 8:0:0:0: [sdc]  Sense Key : Medium Error [current]
Info fld=0x1234
sd 8:0:0:0: [sdc]  Add. Sense: Unrecovered read error
sd 8:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 11 e0 00 01 00 00
quiet_error: 23 callbacks suppressed
scsi_debug: cmd 28 00 00 00 12 e0 00 01 00 00
scsi_debug: cmd 28 00 00 00 11 e0 00 00 08 00
scsi_debug: cmd 28 00 00 00 11 e8 00 00 08 00
scsi_debug: cmd 28 00 00 00 11 f0 00 00 08 00
scsi_debug: cmd 28 00 00 00 11 f8 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 00 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 08 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 10 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 18 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 20 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 28 00 00 08 00
scsi_debug: cmd 28 00 00 00 12 30 00 00 08 00
scsi_debug:    [sense_key,asc,ascq]: [0x3,0x11,0x0]
scsi_debug:    <8 0 0 0> non-zero result=0x8000002
sd 8:0:0:0: [sdc] Unhandled sense code
sd 8:0:0:0: [sdc]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 8:0:0:0: [sdc]  Sense Key : Medium Error [current]
Info fld=0x1234
sd 8:0:0:0: [sdc]  Add. Sense: Unrecovered read error

Almost perfect. It was reading 256 blocks at a time and
hit trouble at LBA 0x11e0 . So then it reads 4 KB (8
blocks) at a time starting at LBA 0x11e0 until it hits
the medium error again. Well it didn't need to read
the medium error again. And what was it thinking when
it read 256 blocks starting at LBA 0x12e0 (i.e. after
the medium error)? Correct but not optimal.


Moving right along, these words are written in the t13.org
document: d2015r3 otherwise know as ACS-2 for ATA
(including SATA) disks:

"If an unrecoverable error occurs while the device is
processing this command, then the device shall return
command completion with the Error bit set to one and
the LBA field set to the LBA of the logical sector where
the first unrecoverable error occurred . The validity
of the data transferred is indeterminate ."

That is for the READ DMA EXT command. When I check
drivers/ata/libata-scsi.c it doesn't touch the resid
field. That means resid is at its default value of
zero implying the data-in buffer is "all good". So
do we know what common practice is for ATA disks in
this situation?

Doug Gilbert



