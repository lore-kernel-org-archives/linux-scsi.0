From: Chris Worley <worleys@gmail.com>
Subject: Re: Linux I/O subsystem performance (was: linuxcon 2010...)
Date: Tue, 24 Aug 2010 14:31:37 -0600
Message-ID: <AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
	<1282508953.3042.102.camel@mulgrave.site>
	<4C727BEB.9020100@scalableinformatics.com>
	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>
	<AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>
	<AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com>
	<20100824072557.GK2804@reaktio.net>
	<4C7404C4.4040704@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63934 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0HXUbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 16:31:38 -0400
In-Reply-To: <4C7404C4.4040704@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>, =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>, Chetan Loke <chetanloke@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.k

On Tue, Aug 24, 2010 at 11:43 AM, Vladislav Bolkhovitin <vst@vlnb.net> =
wrote:
> Pasi K=E4rkk=E4inen, on 08/24/2010 11:25 AM wrote:
>>
>> On Mon, Aug 23, 2010 at 02:03:26PM -0400, Chetan Loke wrote:
>>>
>>> I actually received 3+ off-post emails asking whether I was talking
>>> about initiator or target in the 100K IOPS case below and what did =
I
>>> mean by the ACKs.
>>> I was referring to the 'Initiator' side.
>>> ACKs =3D=3D When scsi-ML down-calls the LLD via the queue-command, =
process
>>> the sgl's(if you like) and then trigger the scsi_done up-call path.
>>>
>>
>> Uhm, Intel and Microsoft demonstrated over 1 million IOPS
>> using software iSCSI and a single 10 Gbit Ethernet NIC (Intel 82599)=
=2E
>>
>> How come there is such a huge difference? What are we lacking in Lin=
ux?
>
> I also have an impression that Linux I/O subsystem has some performan=
ce
> problems. For instance, in one recent SCST performance test only 8 Li=
nux
> initiators with fio as a load generator were able to saturate a singl=
e SCST
> target with dual IB cards (SRP) on 4K AIO direct accesses over an SSD
> backend. This rawly means that any initiator took several times (8?) =
more
> processing time than the target.

While I can't tell you where the bottlenecks are, I can share some
performance numbers...

4 initiators can get >600K random 4KB IOPS off a single target...
which is ~150% of what the Emulex/Intel/Microsoft results show using 8
targets at 4KB (their 1M IOPS was at 512 byte blocks, which is not a
realistic test point) here:

http://itbrandpulse.com/Documents/Test2010001%20-%20The%20Sun%20Rises%2=
0on%20CNAs%20Test%20Report.pdf

The blog referenced earlier used 10 targets... and I'm not sure how
many 10G ports per target.

In general, my target seems capable of 65% the local small-block
random write performance over IB,  and 85% the local small-block
random read performance.  For large block performance, ~95% efficiency
is easily achievable, read or write (i.e. 5.6GB/s over fabric, where
6GB/s is achievable on the drives locally at 1MB random blocks).
These small-block efficiencies are achievable only when tested with
multiple initiators.

The single initiator is only capable of <150K 4KB IOPS... but gets
full bandwidth w/ larger blocks.

If I were to chose my problem, target or initiator bottleneck, I'd
certainly rather have an initiator bottleneck rather than Microsoft's
target bottleneck.

> Hardware used for that target and
> initiators was the same. I can't see on this load why the initiators =
would
> need to do something more than the target. Well, I know we in SCST di=
d an
> excellent work to maximize performance, but such a difference looks t=
oo much
> ;)
>
> Also it looks very suspicious why nobody even tried to match that
> Microsoft/Intel record, even Intel itself who closely works with Linu=
x
> community in the storage area and could do it using the same hardware=
=2E

The numbers are suspicious for other reasons.  "Random" is often used
loosely (and the blog referenced earlier doesn't even claim "random").
 If there is any merging/coalescing going on, then the "IOPS" are
going to look vastly better.  If I allow coalescing, I can easily get
4M 4KB IOPS, but can't honestly call those 4KB IOPS (even if the
benchmark thinks it's doing 4KB I/O).  They need to show that their
advertised block size is maintained end-to-end.

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
