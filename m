From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/3] faster workaround
Date: Thu, 11 Oct 2007 10:19:37 -0400
Message-ID: <470E30F9.5060705@garzik.org>
References: <200710081709.18253.bs@q-leap.de>	<200710101112.20448.bs@q-leap.de>	<200710111409.56210.bs@q-leap.de>	<200710111433.23833.bs@q-leap.de> <20071011142628.48272a4a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51935 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXJKOTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 10:19:42 -0400
In-Reply-To: <20071011142628.48272a4a@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bernd Schubert <bs@q-leap.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Alan Cox wrote:
>> -static void ata_fill_sg(struct ata_queued_cmd *qc)
>> +void ata_fill_sg(struct ata_queued_cmd *qc)
>>  {
>>  	struct ata_port *ap = qc->ap;
>>  	struct scatterlist *sg;
>> @@ -4217,10 +4217,15 @@ int ata_check_atapi_dma(struct ata_queue
>>   */
>>  void ata_qc_prep(struct ata_queued_cmd *qc)
>>  {
>> +	struct ata_port *ap = qc->ap;
>> +
>>  	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
>>  		return;
>>  
>> -	ata_fill_sg(qc);
>> +	if (ap->ops->fill_sg)
>> +		ap->ops->fill_sg(qc);
>> +	else
>> +		ata_fill_sg(qc);
>>  }
> 
> Its probably better to simply make your own sil_qc_prep function for this
> case rather than touch the core code.
> 
>> -	.sg_tablesize		= LIBATA_MAX_PRD,
>> +	.sg_tablesize		= 120, /* max 15 kiB sectors ? */
> 
> If you are just fiddling with the way the data is split then
> LIBATA_MAX_PRD - 1 should be totally safe)
> 
>>  	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
>>  	.emulated		= ATA_SHT_EMULATED,
>> -	.use_clustering		= ATA_SHT_USE_CLUSTERING,
>> +	.use_clustering		= 1,
> 
> Un-needed
> 
>>  	.proc_name		= DRV_NAME,
>> -	.dma_boundary		= ATA_DMA_BOUNDARY,
>> +	.dma_boundary		= 0x1fff,
> 
> Ok
> 
>>  	.slave_configure	= ata_scsi_slave_config,
>>  	.slave_destroy		= ata_scsi_slave_destroy,
>>  	.bios_param		= ata_std_bios_param,
> 
>> +	/* Errata workaround: if last segment is exactly 8K, split
>> +	 * into 7.5K and 512b pieces.
>> +	 */
>> +	len = le32_to_cpu(ap->prd[idx].flags_len) & 0xffff;
>> +	if (len == 8192) {
>> +		addr = le32_to_cpu(ap->prd[idx].addr);
>> +		ap->prd[idx].flags_len = cpu_to_le32(15 * 512);
>> +
>> +		idx++;
>> +		ap->prd[idx].addr = cpu_to_le32(addr + (15 * 512));
>> +		ap->prd[idx].flags_len = cpu_to_le32(512 | ATA_PRD_EOT);
>> +	}
>> +}
> 
> And since in this approach we are merely splitting the last PRD entry in
> some obscure cases we might as well do it by default as it should have no
> performance impact of any note done this way.

Unfortunately all this stuff is quite meaningless, which was why my 
patch was never merged.

The problem is that the 3112 generates Data FIS's of a size other than a 
multiple of 512 bytes.  Spec-legal, but exposed firmware bugs in many 
early SATA drives.  Early Seagate hard drives choked when the formula 
(sector%15)==1 was satisfied (or something along those lines).

The problem with the fix is that Data FIS size is only roughly 
correlated to PRD segment length or DMA boundary -- the chip could 
decide to send out a frame even if the PRD length is < 8K.  The 3112 can 
generate not-512b-sized FIS's at any time, not just at the end of the 
transfer.

That leaves us with two observations:

1) Just about the only valid optimization is to ensure that only the 
write path must be limited to small chunks, not both read- and 
write-paths.  Tejun had a patch to do this a long time ago, but it's an 
open question whether the large amount of code is worth it for a rare 
combination.

2) Once we identified, over time, the set of drives affected by this 
3112 quirk (aka drives that didn't fully comply to SATA spec), the 
debugging of corruption cases largely shifted to the standard routine: 
update the BIOS, replace the cables/RAM/power/mainboard/slot/etc. to be 
certain of problem location.

	Jeff


