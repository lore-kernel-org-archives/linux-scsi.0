From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] esp: enable CONFIG2_FENAB for am53c974
Date: Fri, 21 Nov 2014 11:22:46 +0100
Message-ID: <546F1276.9000704@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-11-git-send-email-hare@suse.de> <546F0F2B.40901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbaKUKWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:22:52 -0500
In-Reply-To: <546F0F2B.40901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/21/2014 11:08 AM, Paolo Bonzini wrote:
>=20
>=20
> On 21/11/2014 10:27, Hannes Reinecke wrote:
>> CONFIG2_FENAB ('feature enable') changed definition between chip
>> revisions, from 'Latch SCSI Phase' to 'Latch SCSI Phase, display
>> chip ID upon reset, and enable 24 bit addresses'.
>> So only enable it for am53c974 where we know what it's doing.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/am53c974.c | 30 ++++++++++++++++++++++++++++++
>>  drivers/scsi/esp_scsi.c |  4 ++++
>>  2 files changed, 34 insertions(+)
>>
>> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
>> index 0452ed1..722e781 100644
>> --- a/drivers/scsi/am53c974.c
>> +++ b/drivers/scsi/am53c974.c
>> @@ -252,6 +252,8 @@ static void pci_esp_send_dma_cmd(struct esp *esp=
, u32 addr, u32 esp_count,
>> =20
>>  	pci_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
>>  	pci_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
>> +	if (esp->config2 & ESP_CONFIG2_FENAB)
>> +		pci_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
>=20
> Why do this conditionally?  We know that FENAB is true here, don't we=
?
>=20
> (Maybe I'm missing something obvious though).
>=20
Not really. Point is that 'FENAB' does actually three things:
- Enable TCHI for 24-bit DMA transfer lengths
- Provide Chip ID in TCHI after reset
- Latch SCSI phase after completion in SCSI STATUS
So we _might_ run into timing issues due to the last point, so I've
made it conditional in case we'd have to disable it.

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
