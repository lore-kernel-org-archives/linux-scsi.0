Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53E9C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8197E23110
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbhALQtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:49:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60830 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbhALQtA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 11:49:00 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CGfX5k061742;
        Tue, 12 Jan 2021 11:47:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=sssI6pal2e5UVVHZrLK1JkgMl3tTHzyTZXLdj82NPfg=;
 b=n+EVePn1GsLgLu13JK0GmeJOtQ7pPGlNyVVOBX7CB+5mXmhZ4TifM13TEMhtmXr0fHHj
 GZWmWFWcKrUohmEfX3GBA/xnzjKuC8PJQliOB08iZ1rC4RydKk0pNmnbQEgyRR2M06Fq
 9xMtZFwsNWBN/4rwkQ3AMQ+coXdiHdCJ9BGHQJjVHkfKJnWBxS+w+JkvP2ERBprRB45H
 CzTNWnos4+UJ6sjdFzfTQ0Vp3kgUuItpzcn9ILt+CASvDjpZTBVItz1MnzFcG1ODLkLF
 lnDJfyrnglchAHfC6UBGwYgU6NjSlcQIXiJNJtP1GKlyMeuVslgpXym2tqQxo6L+K6b+ zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361eu116cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:47:48 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CGgSEV064094;
        Tue, 12 Jan 2021 11:47:48 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361eu116cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:47:47 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGg1qQ027155;
        Tue, 12 Jan 2021 16:47:47 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 35y44956s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:47:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGlkAe23200050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:47:46 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2073B7805F;
        Tue, 12 Jan 2021 16:47:46 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 093327805C;
        Tue, 12 Jan 2021 16:47:42 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.180.222])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 16:47:42 +0000 (GMT)
Message-ID: <3e3f929559a9581d17d055966416b827d4c0219b.camel@linux.ibm.com>
Subject: Re: About scsi device queue depth
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Cc:     chenxiang <chenxiang66@hisilicon.com>
Date:   Tue, 12 Jan 2021 08:47:41 -0800
In-Reply-To: <571e3700-2850-3a5d-8fd0-91425a4f810a@huawei.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
         <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
         <b51fc658-b28a-d627-a2a3-b2835132ab13@huawei.com>
         <62b562eae9830830d87ea9f92dcc0018a1935583.camel@linux.ibm.com>
         <571e3700-2850-3a5d-8fd0-91425a4f810a@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1031
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-12 at 10:27 +0000, John Garry wrote:
> > > For this case, it seems the opposite - less is more. And I seem
> > > to be hitting closer to the sweet spot there, with more merges.
> > 
> > I think cheaper SSDs have a write latency problem due to erase
> > block issues.  I suspect all SSDs have a channel problem in that
> > there's a certain number of parallel channels and once you go over
> > that number they can't actually work on any more operations even if
> > they can queue them.  For cheaper (as in fewer channels, and less
> > spare erased block capacity) SSDs there will be a benefit to
> > reducing the depth to some multiplier of the channels (I'd guess 2-
> > 4 as the multiplier).  When SSDs become write throttled, there may
> > be less benefit to us queueing in the block layer (merging produces
> > bigger packets with lower overhead, but the erase block consumption
> > will remain the same).
> > 
> > For the record, the internet thinks that cheap SSDs have 2-4
> > channels, so that would argue a tag depth somewhere from 4-16
> 
> I have seen upto 10-channel devices mentioned being "high end" -
> this would mean upto 40 queue depth using on 4x multiplier; so, based
> on that, the current value of 254 for that driver seems way off.

SSD manufacturers don't want us second guessing their device internals
which is why the mostly don't publish the details.  They want to move
us to a place where we don't do any merging at all and just spray all
the I/O packets at the device and let it handle them.

Your study argues they still aren't actually in a place where reality
matches their rhetoric but it you code latency heuristics based on my
guesses they'll likely be wrong for the next generation of devices.

> > > > SSDs have a peculiar lifetime problem in that when they get
> > > > erase block starved they start behaving more like spinning rust
> > > > in that they reach a processing limit but only for writes, so
> > > > lowering the write queue depth (which we don't even have a knob
> > > > for) might be a good solution.  Trying to track the erase block
> > > > problem hasbeen a constant bugbear.
> > > 
> > > I am only doing read performance test here, and the disks are
> > > SAS3.0 SSDs HUSMM1640ASS204, so not exactly slow.
> > 
> > Possibly ... the stats on most manufacturer SSDs don't give you
> > information about the channels or spare erase blocks.
> 
> For my particular disk, this is the datasheet/manual:
> https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/data-sheet-ultrastar-ssd1600ms.pdf
> 
> https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/product-manual-ultrastar-ssd1600mr-1-92tb.pdf
> 
> And I didn't see explicit info regarding channels or spare erase
> blocks, as you expect.

Right, manufacturers simply aren't going to give us that information. 
I also suspect the device won't return queue full usefully either so we
can't track that meaningfully either.

Remember also that all SSDs have a flash translation layer which
transforms our continuous I/O into a scatter/gather list.  This does
argue there are diminishing returns from merging I/Os anyway and
supports the manufacturer argument that we shouldn't be doing merging.

I think the question for us is: if we do discover additional latency in
an SSD read/write queue what do we do with it?  For spinning rust,
using spare latency to merge requests is a definite win because the
drive machinery is way more efficient with contiguous reads/writes,
what would be a similar win with SSDs?

> > > > I'm assuming you're using spinning rust in the above, so it
> > > > sounds like the firmware in the card might be eating the queue
> > > > full returns.  Icould see this happening in RAID mode, but it
> > > > shouldn't happen in jbod mode.
> > > 
> > > Not sure on that, but I didn't check too much. I did try to
> > > increase fio queue depth and sdev queue depth to be very large to
> > > clobber the disks, but still nothing.
> > 
> > If it's an SSD it's likely not giving the queue full you'd need to
> > get the mid-layer to throttle automatically.
> > 
> 
> So it seems that the queue depth we select should depend on class of 
> device, but then the value can also affect write performance.

Well, it does today.  queue full works for most non SSD devices and it
allows us to set a useful queue depth.  We also have the norotational
flag in block to help.

> As for my issue today, I can propose a smaller value for the mpt3sas 
> driver based on my limited tests, and see how the driver maintainers 
> feel about it.

It will run counter to the SSD manufacturers "just give us all your
packets ASAP" mantra so most commercial driver vendors won't want it
changed.

> I just wonder what intelligence we can add for this. And whether
> LLDDs should be selecting this (queue depth) at all, unless they (the
> HBA) have some limits themselves.

I suspect it's not in the block layer at all.  I'd guess the best thing
we can do is report on read and write latency and let something in
userspace see if it wants to adjust the queue depth.

> You did mention maybe a separate write queue depth - could this be a 
> solution?

I was observing that the gating factors for the read and write latency
characteristics are radically different for SSDs, so I would really
expect optimal queue depths to be different on read and write requests.
Now whether there's a benefit to using that latency is a different
question.  If we had a read and a write queue depth, what would we do
with the latency in the write queue?  The problem on writes is the
device erasing blocks ... merging requests doesn't do anything to help
with that problem, so there may be no real benefit to reducing the
write queue depth.

James


