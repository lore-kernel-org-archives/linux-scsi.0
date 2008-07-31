From: "Grant Grundler" <grundler@google.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Thu, 31 Jul 2008 16:44:28 -0700
Message-ID: <da824cf30807311644r595241ffq97f530eceeef7ef7@mail.gmail.com>
References: <20080619160342.GJ4392@parisc-linux.org>
	 <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	 <20080625172015.GR4392@parisc-linux.org>
	 <20080625172638.GE20851@kernel.dk>
	 <yq1d4m575je.fsf@sermon.lab.mkp.net> <488DCB5A.9080105@redhat.com>
	 <yq1od4ikrl2.fsf@sermon.lab.mkp.net>
	 <da824cf30807311400i59065c74q549aa1b62819781e@mail.gmail.com>
	 <48923C32.3040901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:32490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYGaXou (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 19:44:50 -0400
Received: from spaceape24.eur.corp.google.com (spaceape24.eur.corp.google.com [172.28.16.76])
	by smtp-out.google.com with ESMTP id m6VNiUVd020337
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2008 00:44:30 +0100
Received: from rv-out-0708.google.com (rvfb17.prod.google.com [10.140.179.17])
	by spaceape24.eur.corp.google.com with ESMTP id m6VNgNXl029511
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2008 16:44:29 -0700
Received: by rv-out-0708.google.com with SMTP id b17so656412rvf.40
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2008 16:44:28 -0700 (PDT)
In-Reply-To: <48923C32.3040901@redhat.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Thu, Jul 31, 2008 at 3:26 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> Grant Grundler wrote:
...
>> rpm isn't a great gauge of performance either since the perf is a
>> function of rpm * bit density.
>>
>
> Is this real rotational latency, or normalized?

Sorry... I was thinking throughput (MB/s) and not rotational latency.
mkp is right that rotaional latency (ie rpm) is a significant part of
total avg latency.

>  I think that the avg seek
> time is usually a bit more predictive of how well we do with the worst case
> load (fsck).

*nod*

....
>> erase and/or write times could be exported as well somehow for SSDs
>> if the FS (or other higher layer that wants to know) can't avoid
>> garbage collection and erase cycles. I was just told today that flash
>> devices
>> have 10x higher write time than read time. erase is another order of
>> magnitude higher. This doesn't include any garbage collection overhead.
>>
>
> This is changing - they have various ways of getting them much closer
> together. On the other hand, a USB flash drive is much slower than a high
> end SSD which can hit 20,000 IOPS.

The IOPS isn't the issue. It's the difference between having a rotation/seek
latency and not. The efficiency (percent of theoretical throughput or IOPS)
of either USB stick or enterprise SSD shouldn't be that different if the
FS is aware of erase blocks and how it lays out the data. The USB stick
will always be slower - the question is efficiency not comparing it to
a faster SSD.

>>
>> I think new file systems should be tuned to work with SSDs before we
>> worry so much about the differences between SSDs/flash technologies
>> and vendors. And then prescribe a different FS for different
>> storage technologies. This avoids the "layering violations" discussion
>> and helps keep the FSs (testing and developement) substantially simpler.
>>
>> grant
>>
>
> If we have access to the parts, we will try to get them to self tune given
> whatever we can grab.

I'm just pointing out that "self tuning" is more complex, more work,
and requires
more testing. Ultimately it will take longer to deploy and I don't think we have
time for it.  Just trying to defer this work until I see substantial
evidence of at
least one FS that works well with SSDs and can be deployed.

I'm not against "self tuning". But I believe sufficiently good results are
achievable by directly embedding the device attributes in the FS
as we've done for conventional rotational media in ext2.

Maybe I'm being too skeptical that developments can't be done in
parallel for new features.

thanks,
grants
