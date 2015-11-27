From: Hannes Reinecke <hare@suse.de>
Subject: Re: QUEUE_FLAG_NO_SG_MERGE and non-block-mq
Date: Fri, 27 Nov 2015 15:29:59 +0100
Message-ID: <565868E7.2010807@suse.de>
References: <5656BF25.3000407@suse.de> <CACVXFVMSNmtcVN1zZ5f=xNbMfpnt7wiQ4U03f1Dk95rOMUQBSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbbK0OaB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Nov 2015 09:30:01 -0500
In-Reply-To: <CACVXFVMSNmtcVN1zZ5f=xNbMfpnt7wiQ4U03f1Dk95rOMUQBSw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 11/26/2015 10:21 AM, Ming Lei wrote:
> On Thu, Nov 26, 2015 at 4:13 PM, Hannes Reinecke <hare@suse.de> wrote=
:
>> Hi all,
>>
>> while investigating the crash in scsi_lib.c I found a rather curious
>> behaviour for QUEUE_FLAG_NO_SG_MERGE.
>>
>> While the flag is evaluated in blk_recalc_rq_segments and
>> blk_recount_segments (resulting in nr_phys_segments being
>> computed based on that flag) it is completely ignored
>> during blk_rq_map_sg() or the actual merging itself.
>=20
> Yes, I guess Jens introduced the flag for decreasing CPU
> consumption when comuputing segments, but it is still
> ignored by blk_rq_map_sg(), but it may not be used
> by some drivers.
>=20
> After bio splitting is introduced, the flag is also ignored
> when computing segments.
>=20
>>
>> This typically shouldn't be an issue, seeing that with
>> QUEUE_FLAG_NO_SG_MERGE nr_phys_segments will always be
>> larger than the actual segment count.
>>
>> However, it still makes me wonder:
>> What is the point of having a QUEUE_FLAG_NO_SG_MERGE
>> which doesn't work as advertised?
>> Or, to be precise, which only works for blk-mq?
>> Should we make it work for non-block-mq, too?
>=20
> Thanks bio splitting, this flag has little effect on performance now,
> so I think it can be removed if Jens has no objection.
>=20
As per your suggestion we've made some performance measurements,
and 4k fio showed little if no impact:

NO_SG_MERGE:
  IOPS R/W: 148097.7+-125.7 / 148124.1+-123.1
  BW   R/W: 592392.4+-502.7 / 592498.3+-492.3
SG_MERGE:
  IOPS R/W: 148054.4+-123.3 / 148082.6+-120.0
  BW   R/W: 592219.2+-493.5 / 592332.3+-479.7

So the performance benefit lies squarely within the
error margin, making me wonder if it's worth bothering
with having the NO_SG_MERGE flag at all.

Thanks to Johannes for doing the measurements :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
