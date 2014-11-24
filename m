From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/12] scsi: add 'am53c974' driver
Date: Mon, 24 Nov 2014 15:01:12 +0100
Message-ID: <54733A28.3010909@suse.de>
References: <1416573716-73890-1-git-send-email-hare@suse.de> <1416573716-73890-8-git-send-email-hare@suse.de> <20141124135041.GA28523@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaKXOBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 09:01:15 -0500
In-Reply-To: <20141124135041.GA28523@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org

On 11/24/2014 02:50 PM, Christoph Hellwig wrote:
>> +/*
>> + * AMD am53c974 driver.
>> + * Copyright (c) 2014 Hannes Reinecke, SUSE Linux GmbH
>> + */
>=20
> Is there anything left from the old driver that should get credit her=
e?
>=20
Hmm. I copied the EEprom handling more-or-less verbatim from the
tmscsim driver; not sure if that warrants a credit.

>> +#define PCI_ESP_GET_PRIV(esp) ((struct pci_esp_priv *) \
>> +			       pci_get_drvdata((struct pci_dev *) \
>> +					       (esp)->dev))
>=20
> I think an inline function would be a lot cleaner, especially as that
> should avoid all these casts.
>=20
Ok.

>> +#ifdef ESP_DMA_DEBUG
>> +	shost_printk(KERN_INFO, esp->host, "start dma addr[%x] count[%d:%d=
]\n",
>> +		     addr, esp_count, dma_count);
>> +#endif
>=20
> Can you add a esp_dma_printk or similar instead of all these ifdefs?
>=20
Yep, I can.

>> +	u8 carryFlag =3D 1, j =3D 0x80, bval;
>=20
> carry_flag.
>=20
As said, copied verbatim. Will be fixing it up.

>> +	if (pci_request_regions(pdev, DRV_MODULE_NAME)) {
>=20
>> +	if (request_irq(pdev->irq, scsi_esp_intr, IRQF_SHARED,
>> +			DRV_MODULE_NAME, esp)) {
>=20
> Please propagate the return values from these two.
>=20
Ok.

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
