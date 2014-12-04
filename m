From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/12] advansys: Update to version 3.5 and remove compilation
 warning
Date: Thu, 04 Dec 2014 10:26:01 +0100
Message-ID: <548028A9.8060403@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-13-git-send-email-hare@suse.de> <20141204092305.GA24091@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaLDJ0D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:26:03 -0500
In-Reply-To: <20141204092305.GA24091@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 12/04/2014 10:23 AM, Christoph Hellwig wrote:
>>  /* FIXME:
>>   *
>> - *  1. Although all of the necessary command mapping places have th=
e
>> - *     appropriate dma_map.. APIs, the driver still processes its i=
nternal
>> - *     queue using bus_to_virt() and virt_to_bus() which are illega=
l under
>> - *     the API.  The entire queue processing structure will need to=
 be
>> - *     altered to fix this.
>> + *  1. (done)
>>   *  2. Need to add memory mapping workaround. Test the memory mappi=
ng.
>>   *     If it doesn't work revert to I/O port access. Can a test be =
done
>>   *     safely?
>>   *  3. Handle an interrupt not working. Keep an interrupt counter i=
n
>>   *     the interrupt handler. In the timeout function if the interr=
upt
>>   *     has not occurred then print a message and run in polled mode=
=2E
>> - *  4. Need to add support for target mode commands, cf. CAM XPT.
>> - *  5. check DMA mapping functions for failure
>> + *  4. (obsolete)
>> + *  5. (done)
>>   *  6. Use scsi_transport_spi
>>   *  7. advansys_info is not safe against multiple simultaneous call=
ers
>>   *  8. Add module_param to override ISA/VLB ioport array
>=20
>=20
> Just drop the done/obsolete items and renumber the rest :)
>=20
>> +	if (dma_mapping_error(board->dev, scp->SCp.dma_handle)) {
>> +		ASC_DBG(1, "failed to map sense buffer\n");
>> +		return 0;
>> +	}
>>  	dma_cache_sync(board->dev, scp->sense_buffer,
>>  		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
>>  	return cpu_to_le32(scp->SCp.dma_handle);
>> @@ -7794,6 +7794,8 @@ static int asc_build_req(struct asc_board *boa=
rdp, struct scsi_cmnd *scp,
>>  	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
>>  	asc_scsi_q->q1.sense_addr =3D advansys_get_sense_buffer_dma(scp);
>>  	asc_scsi_q->q1.sense_len =3D SCSI_SENSE_BUFFERSIZE;
>> +	if (!asc_scsi_q->q1.sense_addr)
>> +		return ASC_ERROR;
>=20
> Please split the addition of error handling into a separate patch,
> or in case of newly added mappigns add them to the patch that add the
> mappings.
>=20
Okay.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
