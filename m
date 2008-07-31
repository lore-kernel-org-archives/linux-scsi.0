From: "Grant Grundler" <grundler@google.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Thu, 31 Jul 2008 14:00:25 -0700
Message-ID: <da824cf30807311400i59065c74q549aa1b62819781e@mail.gmail.com>
References: <20080619160342.GJ4392@parisc-linux.org>
	 <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>
	 <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	 <20080625172015.GR4392@parisc-linux.org>
	 <20080625172638.GE20851@kernel.dk>
	 <yq1d4m575je.fsf@sermon.lab.mkp.net> <488DCB5A.9080105@redhat.com>
	 <yq1od4ikrl2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:6023 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYGaVAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 17:00:39 -0400
Received: from spaceape13.eur.corp.google.com (spaceape13.eur.corp.google.com [172.28.16.147])
	by smtp-out3.google.com with ESMTP id m6VL0RKg019563
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2008 22:00:27 +0100
Received: from rv-out-0506.google.com (rvbk40.prod.google.com [10.140.87.40])
	by spaceape13.eur.corp.google.com with ESMTP id m6VL0O5l012724
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2008 14:00:26 -0700
Received: by rv-out-0506.google.com with SMTP id k40so691834rvb.11
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2008 14:00:26 -0700 (PDT)
In-Reply-To: <yq1od4ikrl2.fsf@sermon.lab.mkp.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Mon, Jul 28, 2008 at 7:31 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:
>
> Ric> One other thought - is there a way to give non-rotational devices
> Ric> also some indication of latency? (FLASH is slower than enterprise
> Ric> SSD is slower than DRAM ramdisk for example)?
>
> The current SBC draft only distinguishes between rotating media
> speeds.  There is only one classification for non-rotating media in
> the block device characteristics VPD.
>
> For a mechanical disk drive the rpm isn't a terrible gauge for
> performance.  But for a solid state device I think it will be hard to
> define a similar universal metric.

rpm isn't a great gauge of performance either since the perf is a
function of rpm * bit density.

> Ignoring SLC vs. MLC for a moment I think it's also safe to predict
> that the enterprise drive of today will be the consumer drive of
> tomorrow.
>
> Maybe the ssd device could export the anticipated command response
> time for a request that matches the Optimal Transfer Length field in
> the block limits VPD?

erase and/or write times could be exported as well somehow for SSDs
if the FS (or other higher layer that wants to know) can't avoid
garbage collection and erase cycles. I was just told today that flash devices
have 10x higher write time than read time. erase is another order of
magnitude higher. This doesn't include any garbage collection overhead.

I think new file systems should be tuned to work with SSDs before we
worry so much about the differences between SSDs/flash technologies
and vendors. And then prescribe a different FS for different
storage technologies. This avoids the "layering violations" discussion
and helps keep the FSs (testing and developement) substantially simpler.

grant
