From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Mon, 6 Sep 2004 15:17:27 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409061400560.1676@poirot.grange>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
 <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
 <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
 <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org>
 <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange>
 <Pine.LNX.4.60.0409061143020.8550@poirot.grange> <20040906110150.A4845@infradead.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-101279756-1094476647=:1676"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:3818 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267393AbUIFNSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 09:18:12 -0400
In-Reply-To: <20040906110150.A4845@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-101279756-1094476647=:1676
Content-Type: TEXT/PLAIN; charset=koi8-r; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 6 Sep 2004, Christoph Hellwig wrote:

> Patch looks good to me.  Two hints for a possible followon patch:
>
>> @@ -1552,15 +1520,11 @@
>>  =09    pDCB->Inquiry7 =3D ptr->Flags;
>>
>>  ckc_e:
>
> Here we still have some INQUIRY snooping, and if you look how
> ptr is set you'll see it'll OOPS for machines with more than 1GB of memor=
y.

Right. Will think about a fix, thanks.

>> -=09dc390_updateDCB(pACB, pDCB);
>> +=09if (pDCB->DevMode & SYNC_NEGO_)
>> +=09=09pDCB->SyncMode |=3D SYNC_ENABLE;
>> +=09else {
>> +=09=09pDCB->SyncMode =3D 0;
>
> pDCB is memset to 0 =E5t the start of the function, so the 0 initializati=
on
> here isn't nessecary strictly speaking.

Well, a few lines above on a multi-LUN device for LUN > 0 it will be set=20
from LUN 0:

                 pDCB->SyncMode =3D pDCB2->SyncMode & SYNC_NEGO_DONE;

so, purely theoretically it could be non-zero at that point, at least,=20
that's why I put

                 pDCB->SyncMode =3D 0;

there. But, DevMode is set from LUN 0, so, yes, you are right.

Thanks
Guennadi
---
Guennadi Liakhovetski

---1463811839-101279756-1094476647=:1676--
