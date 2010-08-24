From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Linux I/O subsystem performance (was: linuxcon 2010...)
Date: Tue, 24 Aug 2010 18:43:29 +0400
Message-ID: <4C73DA91.9040101@vlnb.net>
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de> <1282256949.30453.278.camel@haakon2.linux-iscsi.org> <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site> <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site> <4C727BEB.9020100@scalableinformatics.com> <AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com> <AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com> <AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com> <20100824072557.GK2804@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0HXOnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 10:43:24 -0400
In-Reply-To: <20100824072557.GK2804@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: Chetan Loke <chetanloke@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, scst-devel <scst-devel@lists.sourceforge.net>

Pasi K=E4rkk=E4inen, on 08/24/2010 11:25 AM wrote:
> On Mon, Aug 23, 2010 at 02:03:26PM -0400, Chetan Loke wrote:
>> I actually received 3+ off-post emails asking whether I was talking
>> about initiator or target in the 100K IOPS case below and what did I
>> mean by the ACKs.
>> I was referring to the 'Initiator' side.
>> ACKs =3D=3D When scsi-ML down-calls the LLD via the queue-command, p=
rocess
>> the sgl's(if you like) and then trigger the scsi_done up-call path.
>>
>
> Uhm, Intel and Microsoft demonstrated over 1 million IOPS
> using software iSCSI and a single 10 Gbit Ethernet NIC (Intel 82599).
>
> How come there is such a huge difference? What are we lacking in Linu=
x?

I also have an impression that Linux I/O subsystem has some performance=
=20
problems. For instance, in one recent SCST performance test only 8 Linu=
x=20
initiators with fio as a load generator were able to saturate a single=20
SCST target with dual IB cards (SRP) on 4K AIO direct accesses over an=20
SSD backend. This rawly means that any initiator took several times (8?=
)=20
more processing time than the target. Hardware used for that target and=
=20
initiators was the same. I can't see on this load why the initiators=20
would need to do something more than the target. Well, I know we in SCS=
T=20
did an excellent work to maximize performance, but such a difference=20
looks too much ;)

Also it looks very suspicious why nobody even tried to match that=20
Microsoft/Intel record, even Intel itself who closely works with Linux=20
community in the storage area and could do it using the same hardware.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
