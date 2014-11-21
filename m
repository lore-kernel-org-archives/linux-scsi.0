From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] am53c974: BLAST residual handling
Date: Fri, 21 Nov 2014 11:29:30 +0100
Message-ID: <546F140A.5060201@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-9-git-send-email-hare@suse.de> <546F0F81.4030803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaKUK3b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:29:31 -0500
In-Reply-To: <546F0F81.4030803@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/21/2014 11:10 AM, Paolo Bonzini wrote:
>=20
>=20
> On 21/11/2014 10:27, Hannes Reinecke wrote:
>> The am53c974 has an design issue where a single byte might be
>> left in the SCSI FIFO after a DMA transfer.
>> As the handling code is currently untested add a WARN_ON()
>> statement here.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/am53c974.c |  6 ++++++
>>  drivers/scsi/esp_scsi.c | 29 +++++++++++++++++++++++++++++
>>  drivers/scsi/esp_scsi.h |  1 +
>>  3 files changed, 36 insertions(+)
>>
>> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
>> index 652762e..0b7643e 100644
>> --- a/drivers/scsi/am53c974.c
>> +++ b/drivers/scsi/am53c974.c
>> @@ -195,6 +195,12 @@ static void pci_esp_dma_drain(struct esp *esp)
>>  	shost_printk(KERN_INFO, esp->host,
>>  		     "DMA blast done (%d tries, %d bytes left)\n", lim, resid);
>>  #endif
>> +	/* BLAST residual handling is currently untested */
>> +	if (WARN_ON(resid =3D=3D 1)) {
>=20
> WARN_ON_ONCE?
>=20
I have not seen it once so far, so I doubt it's a common
case. But yeah, WARN_ON_ONCE is probably better.

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
