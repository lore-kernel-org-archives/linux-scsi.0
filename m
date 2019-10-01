Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889DBC352AA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 09:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61E4C2133F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 09:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJAJ3e convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Oct 2019 05:29:34 -0400
Received: from mailout6.zih.tu-dresden.de ([141.30.67.75]:40520 "EHLO
        mailout6.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727326AbfJAJ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2019 05:29:34 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2019 05:29:33 EDT
Received: from mail.zih.tu-dresden.de ([141.76.14.4] helo=umx-horde-web5.mailcluster.zih.tu-dresden.de)
        by mailout6.zih.tu-dresden.de with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.84_2)
        (envelope-from <sebastian.hegler@tu-dresden.de>)
        id 1iFECe-0002co-5A; Tue, 01 Oct 2019 11:12:16 +0200
Received: from hfsync.ifn.et.tu-dresden.de ([141.30.128.60] helo=[192.168.128.2])
        by umx-horde-web5.mailcluster.zih.tu-dresden.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-SHA:256)
        (Exim 4.92)
        (envelope-from <sebastian.hegler@tu-dresden.de>)
        id 1iFECd-000Np4-9l; Tue, 01 Oct 2019 11:12:15 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: RAID6: "Bad block number requested"
From:   Sebastian Hegler <sebastian.hegler@tu-dresden.de>
In-Reply-To: <506BB5FA-F184-4768-BC74-D9D499A20C70@tu-dresden.de>
Date:   Tue, 1 Oct 2019 11:12:13 +0200
Cc:     linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8C7BD3C3-262C-4DB9-B8D0-423F4CAD7263@tu-dresden.de>
References: <165E54F8-0494-4430-B8A5-0C7DCDF1D91C@tu-dresden.de>
 <1528729598.4000.2.camel@HansenPartnership.com>
 <506BB5FA-F184-4768-BC74-D9D499A20C70@tu-dresden.de>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-TUD-Original-From: sebastian.hegler@tu-dresden.de
X-TUD-Virus-Scanned: mailout6.zih.tu-dresden.de
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear James, dear all,

this is to let you know that I'll not pursue this issue further. I spent some days building a test system, but I could not reproduce the error.
There's a tool named HUGO by HGST/Western Digital to re-configure the HDD's firmware to use 512byte blocks, which solved the problem for me.

Sorry about the bad news.

Yours,
Sebastian


Am 14.06.2018 um 14:11 schrieb Sebastian Hegler <sebastian.hegler@tu-dresden.de>:
> Dear James, dear all!
> 
> Am 11.06.2018 um 17:06 schrieb James Bottomley <James.Bottomley@HansenPartnership.com>:
>> This means that somehow, something sent a non 4k aligned 4k sized
>> request. SCSI here is just the messenger.  However, if you apply this
>> patch, it will capture the stack trace of what above it triggered this,
>> which may help us in debugging.  It could be we may also want to see
>> what the values of block and blk_rq_sectors(rq) actually are, but lets
>> begin with the stack trace.
>> ---
>> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 9421d9877730..ac865e048533 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1109,6 +1109,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>> 		if ((block & 7) || (blk_rq_sectors(rq) & 7)) {
>> 			scmd_printk(KERN_ERR, SCpnt,
>> 				    "Bad block number requested\n");
>> +			WARN_ON_ONCE(1);
>> 			goto out;
>> 		} else {
>> 			block = block >> 3;
> I'll give that a try. But don't expect to hear from me soon, I'll need to build a test system for that. The error occurred in a production system, which I am very hesitant to re-boot, let alone insert drives that cause error messages.
> 
> Yours sincerely,
> Sebastian

