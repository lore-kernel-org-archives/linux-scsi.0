From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 11 Oct 2010 16:18:23 +0200
Message-ID: <4CB31CAF.7020808@kernel.org>
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>	 <20101006111621O.fujita.tomonori@lab.ntt.co.jp>	 <1286340405.5685.93.camel@haakon2.linux-iscsi.org>	 <20101006160434M.fujita.tomonori@lab.ntt.co.jp> <1286349898.5685.117.camel@haakon2.linux-iscsi.org> <4CAC833F.2010108@kernel.org> <4CACAE56.6090209@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:45610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0JKOTH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2010 10:19:07 -0400
In-Reply-To: <4CACAE56.6090209@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com, jeff@garzik.org

Hello,

On 10/06/2010 07:13 PM, Vladislav Bolkhovitin wrote:
> Tejun Heo, on 10/06/2010 06:10 PM wrote:
>> On 10/06/2010 09:24 AM, Nicholas A. Bellinger wrote:
>>>> I like to hear the opinions of SCSI maintainer and ATA folks.
>>>
>>> jejb, jgarzik, tejun and co..?  Any thoughts here..?
>>
>> I frankly have no idea whatsoever.  Is there something I can read to
>> educate myself on the subject?
> 
> General information about a SCSI target subsystem you can find in
> http://scst.sourceforge.net. More internal details about implementation
> in http://scst.sourceforge.net/scst_pg.html. Features which are
> implemented in http://scst.sourceforge.net/comparison.html.
> 
> Directly on the subject you can find some considerations in
> http://lkml.org/lkml/2010/10/1/140 (second half of the message).
> 
> My opinion is that in ideal the SCSI initiator subsystem should be
> drivers/scsi/initiator and the target subsystem - drivers/scsi/target
> with shared code in drivers/scsi/. But in reality such big
> reorganization is unlikely possible, so it's better to leave SCSI
> initiator subsystem in drivers/scsi and the target subsystem - in the
> separate directory in drivers/ (drivers/scst for SCST).

Thanks for the pointers.  Yeah, it would be pretty interesting to have
ATA support there too and for ATA I don't really see why anyone would
mix the initiator and target driver implementations.  They may share
protocol constants and some utility functions but that will be about
it, so it will mostly be a completely separate subsystem and I think
it probably is better to put it somewhere separate too.  I think it
would be best if we can keep the two subsystems clearly separated.
They're targeting very different and most likely disjoint audiences
after all.

Thanks.

-- 
tejun
