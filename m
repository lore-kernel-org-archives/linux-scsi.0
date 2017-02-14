From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/1] mpt3sas: Ignore unaligned completion length for
 ZBC_IN
Date: Tue, 14 Feb 2017 12:45:24 +0900
Message-ID: <1f98b2ef-89d6-65e4-6424-c3b4b4cf1b82@wdc.com>
References: <20170213051152.27741-1-damien.lemoal@wdc.com>
 <1487012224.2719.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47576 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdBNDpf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 22:45:35 -0500
In-Reply-To: <1487012224.2719.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

Bart,

On 2/14/17 03:57, Bart Van Assche wrote:
> On Mon, 2017-02-13 at 14:11 +0900, Damien Le Moal wrote:
>> The ZBC_IN command (REPORT ZONES) reply length is always a multiple of
>> 64B and thus may not be aligned on the device LBA size.
>> For this command, retry due to the unaligned completion length is
>> incorrect so do not check alignment of the reply length.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index 0b5b423..f04b872 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -4723,8 +4723,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>>  	 * then scsi-ml does not need to handle this misbehavior.
>>  	 */
>>  	sector_sz = scmd->device->sector_size;
>> -	if (unlikely(scmd->request->cmd_type == REQ_TYPE_FS && sector_sz &&
>> -		     xfer_cnt % sector_sz)) {
>> +	if (scmd->request->cmd_type == REQ_TYPE_FS &&
>> +	    scmd->cmnd[0] != ZBC_IN &&
>> +	    sector_sz && xfer_cnt % sector_sz) {
>>  		sdev_printk(KERN_INFO, scmd->device,
>>  		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
>>  			    xfer_cnt, sector_sz);
> 
> Hello Damien,
> 
> What software generated a ZBC_IN request with type REQ_TYPE_FS? Shouldn't
> all ZBC_IN requests be assigned type REQ_TYPE_BLOCK_PC?

Any application that issues a BLKREPORTZONE ioctl (e.g. mkfs.f2fs or
libzbc tools) or kernel component calling blkdev_report_zones (e.g.
f2fs) will generate one or more REQ_OP_ZONE_REPORT BIO which translate
into a REQ_TYPE_FS requests for the command ZBC_IN. That command does
not operate on LBAs. The transfer length of the request can be any
length larger than 64B and the reply length will be at least 64B and
aligned on a multiple of 64.

The patch "mpt3sas: Force request partial completion alignment" applied
last week forgot this case, and frankly, I did too despite having looked
at it.

Martin,

We really need this fix to go into 4.10. Without it, the REPORT
ZONES/ZBC_IN command can be retried forever by the HBA.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
