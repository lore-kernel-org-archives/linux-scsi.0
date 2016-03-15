From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/22] ncr5380: Adopt uniform DMA setup convention
Date: Tue, 15 Mar 2016 07:49:56 +0100
Message-ID: <56E7B094.3000301@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042702.976019738@telegraphics.com.au> <56E669F6.8070407@suse.de>
 <alpine.LNX.2.00.1603151313510.9662@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1603151313510.9662@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/15/2016 04:19 AM, Finn Thain wrote:
>=20
> On Mon, 14 Mar 2016, Hannes Reinecke wrote:
>=20
>>> @@ -1555,8 +1555,7 @@ static int NCR5380_transfer_dma(struct S
>>>  	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
>>>  	*data =3D d + c;
>>>  	*count =3D 0;
>>> -	*phase =3D NCR5380_read(STATUS_REG) & PHASE_MASK;
>>> -	return foo;
>>> +	return result;
>>>  }
>>> =20
>>>  /*
>>
>> Don't you miss a phase update here?
>=20
> I guess I missed explaining the change in the commit log.
>=20
> The *phase assignment is redundant because after NCR5380_transfer_dma=
()=20
> returns control to NCR5380_information_transfer(), the latter routine=
 then=20
> also returns, and so *phase is dead.
>=20
Right. Please add this to the commit message.

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
