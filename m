From: Chris Worley <worleys@gmail.com>
Subject: Re: Linux I/O subsystem performance (was: linuxcon 2010...)
Date: Thu, 16 Sep 2010 09:05:51 -0600
Message-ID: <AANLkTi=wEJugA3fB87U0+b8Vtw89VW4cDtzB1wV2ub_z__21125.6685819992$1284649612$gmane$org@mail.gmail.com>
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
	<AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47095 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0IPPFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 11:05:52 -0400
In-Reply-To: <AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>, =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>, Chetan Loke <chetanloke@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.k

On Tue, Aug 24, 2010 at 2:31 PM, Chris Worley <worleys@gmail.com> wrote=
:
> On Tue, Aug 24, 2010 at 11:43 AM, Vladislav Bolkhovitin <vst@vlnb.net=
> wrote:
>> Pasi K=E4rkk=E4inen, on 08/24/2010 11:25 AM wrote:
>>>
>>> On Mon, Aug 23, 2010 at 02:03:26PM -0400, Chetan Loke wrote:
>>>>
>>>> I actually received 3+ off-post emails asking whether I was talkin=
g
>>>> about initiator or target in the 100K IOPS case below and what did=
 I
>>>> mean by the ACKs.
>>>> I was referring to the 'Initiator' side.
>>>> ACKs =3D=3D When scsi-ML down-calls the LLD via the queue-command,=
 process
>>>> the sgl's(if you like) and then trigger the scsi_done up-call path=
=2E
>>>>
>>>
>>> Uhm, Intel and Microsoft demonstrated over 1 million IOPS
>>> using software iSCSI and a single 10 Gbit Ethernet NIC (Intel 82599=
).
>>>
>>> How come there is such a huge difference? What are we lacking in Li=
nux?
>>
>> I also have an impression that Linux I/O subsystem has some performa=
nce
>> problems. For instance, in one recent SCST performance test only 8 L=
inux
>> initiators with fio as a load generator were able to saturate a sing=
le SCST
>> target with dual IB cards (SRP) on 4K AIO direct accesses over an SS=
D
>> backend. This rawly means that any initiator took several times (8?)=
 more
>> processing time than the target.
>
> While I can't tell you where the bottlenecks are, I can share some
> performance numbers...

I've been asked to share more details of the single SRP initiator
case, comparing Windows to Linux...

The configurations tested are represented by four digits separated by d=
ashes:

- The number of initiators used in the test (always one in this case).
- The number of target ports used.
- The number of initiator ports used.
- the number of drives used.

SRP Upstream Initiator

                            1-1-1-1 1-1-1-2  1-2-2-2   1-1-1-4
1-2-2-4   1-1-1-8  1-2-2-8
Random Write    122880  141568  206592  144384  163840  141824  165376
30/70 R/W mix     72113   123136 144640  143616  163072  145920  163584
70/30 R/W mix     55938     91392 114176  135680  156160  145920  16230=
4
Random Read     50688     78336 107008  121600  149760  143872  161536

SRP Windows Initiator

                           1-?-1-1 1-?-1-2   1-?-2-2  1-?-1-4  1-?-2-4
 1-?-1-8    1-?-2-8
Random Write     57774  116738  114464  146972  202891                 =
 221819
30/70 R/W mix    49719    95697    97831  154328  181221               =
   227786
70/30 R/W mix    45242    90694    89559  167341  176178               =
   244661
Random Read     48016    94867   92984  178227  183631                 =
 257449

Note that the question marks are where I'm not sure how Windows is
using the second target port... in Linux, you select the target port
from the initiator, but there's no such option in Windows, so the
target port could be used in those cases.  The 1-1-1-8 case is where I
tried to force it to use just one target port (by disabling the target
port), and Windows wouldn't do any I/O at all.

Chris
>
> 4 initiators can get >600K random 4KB IOPS off a single target...
> which is ~150% of what the Emulex/Intel/Microsoft results show using =
8
> targets at 4KB (their 1M IOPS was at 512 byte blocks, which is not a
> realistic test point) here:
>
> http://itbrandpulse.com/Documents/Test2010001%20-%20The%20Sun%20Rises=
%20on%20CNAs%20Test%20Report.pdf
>
> The blog referenced earlier used 10 targets... and I'm not sure how
> many 10G ports per target.
>
> In general, my target seems capable of 65% the local small-block
> random write performance over IB, =A0and 85% the local small-block
> random read performance. =A0For large block performance, ~95% efficie=
ncy
> is easily achievable, read or write (i.e. 5.6GB/s over fabric, where
> 6GB/s is achievable on the drives locally at 1MB random blocks).
> These small-block efficiencies are achievable only when tested with
> multiple initiators.
>
> The single initiator is only capable of <150K 4KB IOPS... but gets
> full bandwidth w/ larger blocks.
>
> If I were to chose my problem, target or initiator bottleneck, I'd
> certainly rather have an initiator bottleneck rather than Microsoft's
> target bottleneck.
>
>> Hardware used for that target and
>> initiators was the same. I can't see on this load why the initiators=
 would
>> need to do something more than the target. Well, I know we in SCST d=
id an
>> excellent work to maximize performance, but such a difference looks =
too much
>> ;)
>>
>> Also it looks very suspicious why nobody even tried to match that
>> Microsoft/Intel record, even Intel itself who closely works with Lin=
ux
>> community in the storage area and could do it using the same hardwar=
e.
>
> The numbers are suspicious for other reasons. =A0"Random" is often us=
ed
> loosely (and the blog referenced earlier doesn't even claim "random")=
=2E
> =A0If there is any merging/coalescing going on, then the "IOPS" are
> going to look vastly better. =A0If I allow coalescing, I can easily g=
et
> 4M 4KB IOPS, but can't honestly call those 4KB IOPS (even if the
> benchmark thinks it's doing 4KB I/O). =A0They need to show that their
> advertised block size is maintained end-to-end.
>
> Chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
