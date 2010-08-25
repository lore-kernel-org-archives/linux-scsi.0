From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Linux I/O subsystem performance
Date: Wed, 25 Aug 2010 23:12:55 +0400
Message-ID: <4C756B37.4000007@vlnb.net>
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>	<4C701E08.2020005@vlnb.net>	<1282423398.3015.39.camel@mulgrave.site>	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>	<1282508953.3042.102.camel@mulgrave.site>	<4C727BEB.9020100@scalableinformatics.com>	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>	<AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>	<AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com>	<20100824072557.GK2804@reaktio.net>	<4C7404C4.4040704@vlnb.net> <AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0HYTNK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2010 15:13:10 -0400
In-Reply-To: <AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>, Chetan Loke <chetanloke@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, scst-devel <scst-devel@lists.sourceforge.net>

Chris Worley, on 08/25/2010 12:31 AM wrote:
>> I also have an impression that Linux I/O subsystem has some performance
>> problems. For instance, in one recent SCST performance test only 8 Linux
>> initiators with fio as a load generator were able to saturate a single SCST
>> target with dual IB cards (SRP) on 4K AIO direct accesses over an SSD
>> backend. This rawly means that any initiator took several times (8?) more
>> processing time than the target.
>
> While I can't tell you where the bottlenecks are, I can share some
> performance numbers...
>
> 4 initiators can get>600K random 4KB IOPS off a single target...

Hmm, on the data you sent me only 8 initiators were capable to do so... 
I'm glad to see an improvement here ;).

> which is ~150% of what the Emulex/Intel/Microsoft results show using 8
> targets at 4KB (their 1M IOPS was at 512 byte blocks, which is not a
> realistic test point

 From my, a storage developer's, POV it isn't about if this test is 
realistic or not. 512 bytes tests are good if you want to test how 
processing effective your I/O stack, because they produce the max 
possible CPU/memory/hardware interaction load. Since processing power 
isn't unlimited, in case if it is a bottleneck, N IOPS on 512b < N IOPS 
on 4K * 8 and system with more effective processing will have better 
numbers.

Vlad
