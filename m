Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B51C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 09:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ABA120C56
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 09:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="JBwKdBjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgH1JyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 05:54:09 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.84]:15941 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728016AbgH1JyA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 05:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1598608436; i=@ts.fujitsu.com;
        bh=7eLsIB0nlUD2DqCD5gVJPZOOXxa4jL8ZdkIe/P+nXws=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=JBwKdBjjOKIpZXmUSqeHFN09zBAUqJl3RpZxJAPeqcRHpiX9luQ0fxAJpgc/56K7G
         UHgtKfdP24yBRB1kUMTdicbDLntGaVUBGjNy1YG7m7ivOi/sRqZ26DtGjXK7KlhnU2
         Mkc1K4uN/zhZDCGf85UktgJQh3aInHr54hpEmFgqKQE9Xu0zvpzlTLTX/2MCata131
         oRBUrDryTLx1V14jIBOxQtWqOm9g0vm+YzDLy/h3Ir1ZLN2Bt4HIXEdDDjNjkQTGUw
         T7ffpRVGF7N3pIlbnIw0mbppd7NAArNHKYSoO2swm/Rgx6R06cpEZdgbItQq1BqXCa
         YrQZS3QMm9GcQ==
Received: from [100.112.199.154] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 93/BD-16187-434D84F5; Fri, 28 Aug 2020 09:53:56 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRWlGSWpSXmKPExsViZ8MRomtyxSP
  e4P0aQYvu6zvYLJYf/8dksf7IBkaL1qVvmRxYPD4+vcXi8X7fVTaPz5vkApijWDPzkvIrElgz
  7nfPYy54JlixddF0lgbGKXxdjFwcQgKTGSWaX21jgXD6GSXa3yxi7WLk5BAWCJN48f0jE0hCR
  GAKo8T/hrnMIAkhgXKJbzvXsYDYbAIGEism3QeyOTh4BRwlJp9OBQmzCKhK3Lm1hhkkLCoQLv
  FshT9ImFdAUOLkzCdgnZwCrhLnWpcygtjMAuoSf+ZdYoawxSVuPZnPBGHLS2x/O4d5AiPfLCT
  ts5C0zELSMgtJywJGllWMFklFmekZJbmJmTm6hgYGuoaGRrqGlha6RoameolVukl6qaW65anF
  JbqGeonlxXrFlbnJOSl6eaklmxiBYZ1ScOz6Dsarrz/oHWKU5GBSEuW1POkRL8SXlJ9SmZFYn
  BFfVJqTWnyIUYaDQ0mCd9FloJxgUWp6akVaZg4wxmDSEhw8SiK8JiBp3uKCxNzizHSI1ClGXY
  4XVxcvYhZiycvPS5US531yCahIAKQoozQPbgQs3i8xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52B
  UEubtAJnCk5lXArfpFdARTEBHzA1zBTmiJBEhJdXAlJPM9uB5cuGZb4YG5Zk6Wqv/1L6f3DCp
  bVHcSX1pp5XXZ881dF3RpbeNv6Q3ivldvkO2QOC1k2cXmdSvzvRSdsu0YPDs4nmefGr5Zb737
  G3tFpWHz+UqaWiw7NpR9DSd83XVNAfRo0GB14MlAuKiaqPrz/H8unhzjdKODpvKKedOHVL1Da
  rUzlr+fzLzxXNHiw54c4TKzbbqdKxqubfQ0cr1O9Nd4zO3T75RdBf12vyGP6lrtqEVv9gDw+A
  urlku+7mOe+aeOay7uyntpo/UBbNeT631hdpXHC89L+ZcZ7NXY+Uk0Ql/VDcfSL77YWHPTcHl
  x9i//Ip/87Ziy8ygA4G7Q7zuZe4v7pYxseVXYinOSDTUYi4qTgQAnhkfK3IDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-19.tower-285.messagelabs.com!1598608435!89167!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 22575 invoked from network); 28 Aug 2020 09:53:56 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-19.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 28 Aug 2020 09:53:56 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 07S9rnrP031224;
        Fri, 28 Aug 2020 10:53:49 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id C7E2B20411;
        Fri, 28 Aug 2020 11:53:40 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to
 tcmu_flush_dcache_range
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mchristi@redhat.com
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
 <159114947916.26776.943125808891892721.b4-ty@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
Date:   Fri, 28 Aug 2020 11:53:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <159114947916.26776.943125808891892721.b4-ty@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I'm adding stable@vger.kernel.org

On 2020-06-03 04:31, Martin K. Petersen wrote:
> On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:
> 
>> 1) If remaining ring space before the end of the ring is
>>     smaller then the next cmd to write, tcmu writes a padding
>>     entry which fills the remaining space at the end of the
>>     ring.
>>     Then tcmu calls tcmu_flush_dcache_range() with the size
>>     of struct tcmu_cmd_entry as data length to flush.
>>     If the space filled by the padding was smaller then
>>     tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>>     an address range reaching behind the end of the vmalloc'ed
>>     ring.
>>     tcmu_flush_dcache_range() in a loop calls
>>        flush_dcache_page(virt_to_page(start));
>>     for every page being part of the range. On x86 the line is
>>     optimized out by the compiler, as flush_dcache_page() is
>>     empty on x86.
>>     But I assume the above can cause trouble on other
>>     architectures that really have a flush_dcache_page().
>>     For paddings only the header part of an entry is relevant
>>     Due to alignment rules the header always fits in the
>>     remaining space, if padding is needed.
>>     So tcmu_flush_dcache_range() can safely be called with
>>     sizeof(entry->hdr) as the length here.
>>
>> [...]
> 
> Applied to 5.8/scsi-queue, thanks!
> 
> [1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
>        https://git.kernel.org/mkp/scsi/c/8c4e0f212398
> 

The full commit of this patch is:
    8c4e0f212398cdd1eb4310a5981d06a723cdd24f

This patch is the first of four patches that are necessary to run tcmu
on ARM without crash. For details please see
    https://bugzilla.kernel.org/show_bug.cgi?id=208045
Upsteam commits of patches 2,3, and 4 are:
  2: 3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
  3: 3145550a7f8b "scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM"
  4: 5a0c256d96f0 "scsi: target: tcmu: Fix crash on ARM during cmd completion"

Since patches 3 and 4 already were accepted for 5.8, 5.4, and 4.19, and
I sent a request to add patch 2 about 1 hour ago, please consider adding
this patch to 5.4 and 4.19, because without it tcmu on ARM will still
crash.

Thank you,
Bodo
