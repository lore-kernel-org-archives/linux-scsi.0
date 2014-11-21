From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/10] esp: Use FIFO for command submission
Date: Fri, 21 Nov 2014 11:38:13 +0100
Message-ID: <546F1615.3030009@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-8-git-send-email-hare@suse.de> <546F0E2F.7090502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaKUKiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:38:15 -0500
In-Reply-To: <546F0E2F.7090502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/21/2014 11:04 AM, Paolo Bonzini wrote:
>=20
>=20
> On 21/11/2014 10:27, Hannes Reinecke wrote:
>> The am53c974 has a design flaw causing it to throw an
>> DMA interrupt whenever a DMA transmission completed,
>> even though DMA interrupt reporting is disabled.
>> This confuses the esp routines as it would register
>> a DMA interrupt whenever a cdb has been transmitted
>> to the drive.
>> So implement an option to use the FIFO for command
>> submission and enable it for am53c974.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/am53c974.c |  1 +
>>  drivers/scsi/esp_scsi.c | 83 ++++++++++++++++++++++++++++++++++++++=
-----------
>>  drivers/scsi/esp_scsi.h |  1 +
>>  3 files changed, 66 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
>> index b9af8b0..652762e 100644
>> --- a/drivers/scsi/am53c974.c
>> +++ b/drivers/scsi/am53c974.c
>> @@ -401,6 +401,7 @@ static int pci_esp_probe_one(struct pci_dev *pde=
v,
>>  	esp->host =3D shost;
>>  	esp->dev =3D pdev;
>>  	esp->ops =3D &pci_esp_ops;
>> +	esp->flags |=3D ESP_FLAG_USE_FIFO;
>=20
> Why not invert this patch and the previous one, and add this line
> directly when the am53c974 driver is born?
>=20
I've added it as separate patch as the original esp driver would
always be using DMA for CDB transfer.
And you could actually use the am53c974 driver with that, only you'd
see lots of 'spurious IRQ' messages.

But for the order I don't have any preference; sure I can rearrange
those.

>>  	pep->esp =3D esp;
>> =20
>>  	if (pci_request_regions(pdev, DRV_MODULE_NAME)) {
>> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
>> index 92ab921..ab7d2bc 100644
>> --- a/drivers/scsi/esp_scsi.c
>> +++ b/drivers/scsi/esp_scsi.c
>> @@ -605,7 +605,7 @@ static void esp_autosense(struct esp *esp, struc=
t esp_cmd_entry *ent)
>>  {
>>  	struct scsi_cmnd *cmd =3D ent->cmd;
>>  	struct scsi_device *dev =3D cmd->device;
>> -	int tgt, lun;
>> +	int tgt, lun, i;
>>  	u8 *p, val;
>> =20
>>  	tgt =3D dev->id;
>> @@ -626,7 +626,10 @@ static void esp_autosense(struct esp *esp, stru=
ct esp_cmd_entry *ent)
>> =20
>>  	esp->active_cmd =3D ent;
>> =20
>> -	p =3D esp->command_block;
>> +	if (esp->flags & ESP_FLAG_USE_FIFO)
>> +		p =3D esp->fifo;
>> +	else
>> +		p =3D esp->command_block;
>=20
> Any reason not to use esp->command_block unconditionally?
>=20
'command_block' is actually mapped onto PCI DMA space, the FIFO is
not. Plus I'd thought to use the 'fifo' array here to make things
more obvious about what's going on.
=46or FIFO submission both are pretty close, so, yeah, I could be
using command_block here.

>>  	esp->msg_out_len =3D 0;
>> =20
>>  	*p++ =3D IDENTIFY(0, lun);
>> @@ -648,12 +651,21 @@ static void esp_autosense(struct esp *esp, str=
uct esp_cmd_entry *ent)
>>  	esp_write_tgt_sync(esp, tgt);
>>  	esp_write_tgt_config3(esp, tgt);
>> =20
>> -	val =3D (p - esp->command_block);
>> +	if (esp->flags & ESP_FLAG_USE_FIFO)
>> +		val =3D (p - esp->fifo);
>> +	else
>> +		val =3D (p - esp->command_block);
>> =20
>>  	if (esp->rev =3D=3D FASHME)
>>  		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>=20
> For consistency with what you do elsewhere, please move this in the "=
else".
>=20
No. The 'USE_FIFO' mechanism is a general feature which _should_
work on all chips. The above 'if' condition is a chipset-specific
feature which should be treated separately.

>> -	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
>> -			       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
>> +	if (esp->flags & ESP_FLAG_USE_FIFO) {
>> +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>> +		for (i =3D 0; i < val; i++)
>> +			esp_write8(esp->fifo[i], ESP_FDATA);
>> +		scsi_esp_cmd(esp, ESP_CMD_SELA);
>> +	} else
>> +		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
>> +				       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
>>  }
>=20
> Hmm, what about a wrapper
>=20
>     __send_cmd(esp, data, esp_count, dma_count, cmd, force_flush,
>                force_fifo)
>     {
>         use_fifo =3D
>             force_fifo || (esp->flags & ESP_FLAG_USE_FIFO) ||
>             esp_count =3D=3D 1;
>         if (force_flush || use_fifo || esp->rev =3D=3D FASHME)
>             scsi_esp_cmd(esp, ESP_CMD_FLUSH);
>         if (use_fifo) {
>             for (i =3D 0; i < val; i++)
>                 esp_write8(esp->fifo[i], ESP_FDATA);
>             scsi_esp_cmd(esp, cmd);
>         } else {
>             if (data !=3D esp->command_block)
>                 memcpy(esp->command_block, data, length)
>             esp->ops->send_dma_cmd(esp,
>                                    esp->command_block_dma,
>                                    esp_count, dma_count, 0,
>                                    cmd | ESP_CMD_DMA);
>         }
>     }
>=20
>     send_cmd(esp, data, esp_count, dma_count, cmd)
>     {
>         __send_cmd(esp, data, esp_count, dma_count, cmd, false, false=
);
>     }
>=20
> This would be:
>=20
>     send_cmd(esp, esp->command_block, val, 16, ESP_CMD_SELA);
>=20
Good point.

Will be updating the patch.

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
