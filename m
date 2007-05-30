From: Hannes Reinecke <hare@suse.de>
Subject: Re: cciss broken with 2.6.22-rc2
Date: Wed, 30 May 2007 13:50:04 +0200
Message-ID: <465D64EC.8050406@suse.de>
References: <465C1613.4050600@suse.de> <226E1C65E4F6164E8EA5FD3CC913AE8C0137E704@G3W0639.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:40870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbXE3LuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 07:50:05 -0400
In-Reply-To: <226E1C65E4F6164E8EA5FD3CC913AE8C0137E704@G3W0639.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Miller, Mike (OS Dev) wrote:
> =20
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]=20
>> Sent: Tuesday, May 29, 2007 7:01 AM
>> To: Miller, Mike (OS Dev); SCSI Mailing List
>> Subject: cciss broken with 2.6.22-rc2
>>
>> Hi Mike,
>>
>> with the latest git snapshot the cciss driver hangs during=20
>> initialisation. Enabling debug output I get:
>>
>> cciss0: <0x3230> at PCI 0000:06:00.0 IRQ 4338 using DAC=20
>> Sending cff0000 - down to controller
>> cciss:  FIFO Empty read
>> cciss:  Read cff00000 back from board
>> Sending cff0000 - down to controller
>> cciss:  FIFO Empty read
>> cciss:  Read cff00002 back from board
>> LUN Data
>> --------------------------
>> Sending cff0000 - down to controller
>> cciss:  FIFO Empty read
>> cciss:  Read cff00000 back from board
>>       blocks=3D 286677120 block_size=3D 512
>> Sending cff0000 - down to controller
>> cciss:  FIFO Empty read
>> cciss:  Read cff00002 back from board
>>       heads=3D255, sectors=3D32, cylinders=3D35132
>>
>> Sending 5103000 - down to controller
>>
>> and then the machine hangs.
>> I'll try to investigate, but as I'm no expert in cciss my=20
>> results might be limited.
>> Looks like one of your recent fixes broke it; 2.6.21 worked fine.
>=20
> Hannes,
> Actually, it was someone else who broke the driver by making changes
> in msi.c. This patch fixes the hang:
>=20
> From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:
>=20
> Found what seems the problem with our vectors being listed backward.
> In drivers/pci/msi.c we should be using list_add_tail rather than
> list_add to preserve the ordering across various kernels. Please
> consider this for inclusion.
>=20
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>=20
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index 0e67723..d74=
975d 100644
[ .. ]
>=20
> We found and fixed these late last week. So I hope they make into Lin=
us' git tree ASAP.

Yes, these patches work.

Thanks,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
