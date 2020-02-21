Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64466C35646
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 15:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FDD9206E2
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 15:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBUPh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:37:27 -0500
Received: from smtp.infotech.no ([82.134.31.41]:50614 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgBUPh1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 10:37:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 46F6F20418D;
        Fri, 21 Feb 2020 16:37:26 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8Y5XVWorqR4t; Fri, 21 Feb 2020 16:37:24 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id D48CC204150;
        Fri, 21 Feb 2020 16:37:22 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 02/15] scsi_debug: add doublestore option
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        Damien.LeMoal@wdc.com
References: <20200220200838.15809-1-dgilbert@interlog.com>
 <20200220200838.15809-3-dgilbert@interlog.com>
 <d1d70477-aa64-5ad4-3b35-531504e71ead@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <c3590173-db3c-daa7-f7b0-27c3a3ca3d43@interlog.com>
Date:   Fri, 21 Feb 2020 10:37:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d1d70477-aa64-5ad4-3b35-531504e71ead@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-21 4:46 a.m., Hannes Reinecke wrote:
> On 2/20/20 9:08 PM, Douglas Gilbert wrote:
>> The scsi_debug driver has always been restricted to using one
>> (or none) ramdisk image for its storage. This means that thousands
>> of scsi_debug devices can be created without exhausting the host
>> machine's RAM. The downside is that all scsi_debug devices share
>> the same ramdisk image. This option doubles the amount of ramdisk
>> storage space with the first, third, fifth (etc) created
>> scsi_debug devices using the first ramdisk image while the second,
>> fourth, sixth (etc) created scsi_debug devices using the second
>> ramdisk image.
>>
>> The reason for doing this is to check that (partial) disk to disk
>> copies based on scsi_debug devices have actually worked properly.
>> As an example: assume /dev/sdb and /dev/sg1 are the same
>> scsi_debug device, while /dev/sdc and /dev/sg2 are also the
>> same scsi_debug device. With doublestore=1 they will have
>> different ramdisk images. Then the following pseudocode could
>> be executed to check the if sgh_dd copy worked:
>>      dd if=/dev/urandom of=/dev/sdb
>>      sgh_dd if=/dev/sg1 of=/dev/sg2 [plus option(s) to test]
>>      cmp /dev/sdb /dev/sdc
>>
>> If the cmp fails then the copy has failed (or some other
>> mechanism wrote to /dev/sdb or /dev/sdc in the interim).
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 264 +++++++++++++++++++++++++++-----------
>>   1 file changed, 186 insertions(+), 78 deletions(-)
>>
> Nice use-case, but really should be documented somewhere.
> Otherwise:

As stated in the cover letter:
     "If and when this patchset is accepted, this page will be
      updated:   http://sg.danny.cz/sg/sdebug26.html ".
Doing it before then can lead to confusion if the patchset
is not accepted.

One of my scripts for testing the sg driver uses that pattern
with the cmp replaced by:
     sgh_dd --verify if=/dev/sg1 of=/dev/sg2

The sg_dd utility also has a --verify option and I plan to add
one the the ddpt utility. The pseudo SCSI command sequence that
it performs is:
     PRE-FETCH(sg2, IMMED)
     READ(sg1)
     VERIFY(sg2, BYTCHK=1, data from READ)

Comparing this pattern to the standard READ-READ approach:
   - uses less host CPU and ram resources
   - possibly faster in the inequality case
   - faster if the host does the READ-READ sequentially

Doug Gilbert
