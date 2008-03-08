From: "Grant Grundler" <grundler@google.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Sat, 8 Mar 2008 13:23:18 -0800
Message-ID: <da824cf30803081323i2911567eu4a03d7167964d92d@mail.gmail.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	 <1204843956.2673.8.camel@vema.umeoce.maine.edu>
	 <200803072239.m27MdGVv028621@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:19279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYCHVXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2008 16:23:22 -0500
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id m28LNJsI016061
	for <linux-scsi@vger.kernel.org>; Sat, 8 Mar 2008 13:23:19 -0800
Received: from hs-out-0708.google.com (hsl4.prod.google.com [10.44.12.4])
	by zps76.corp.google.com with ESMTP id m28LNJIe012420
	for <linux-scsi@vger.kernel.org>; Sat, 8 Mar 2008 13:23:19 -0800
Received: by hs-out-0708.google.com with SMTP id 4so1134517hsl.1
        for <linux-scsi@vger.kernel.org>; Sat, 08 Mar 2008 13:23:18 -0800 (PST)
In-Reply-To: <200803072239.m27MdGVv028621@colby.verdasys.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: Steve Cousins <steve.cousins@maine.edu>, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

On Fri, Mar 7, 2008 at 2:39 PM, Marc Bejarano <beej@alum.mit.edu> wrote:
> At 17:52 3/6/2008, Steve Cousins wrote:
>   >Have you run any memory tests on the machine?
>
>  no, but my suspicions lay elsewhere.  could bad memory explain the
>  right bits ending up in the wrong place on only one half of a mirror?

IMHO, not likely unless the page is getting copied before being DMA'd
but the HBA. DMA is a form of copying but would have a different
"signature" than bad memory (cacheline vs sub-cacheline corruption).

If you know that the two RAID mirrors are different, can you compare
them block-by-block?

First step to solving any data corruption issue is characterizing
the corruption: length of wrong data, alignment of wrong data,
and if possible, determine if wrong data is "stale" or where it
originates. jejb already suggested this.

If you can destroy (and later restore) the data on one or more
of the disks, you might consider running disktest from:
   http://test.kernel.org/autotest/

I've parked an SVN snapshot on:
   http://iou.parisc-linux.org/~grundler/autotest-20080307.tgz

See autotest/tests/disktest/ . IIRC this test will tag each 512 byte
"sector" it writes to a file and will read back those tags later to
verify the sectors made it to media.

hth,
grant
