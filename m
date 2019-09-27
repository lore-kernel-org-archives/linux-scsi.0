Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9AEC352AB
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 00:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CF8B21924
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 00:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfI0Ay6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 20:54:58 -0400
Received: from smtp.infotech.no ([82.134.31.41]:53491 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfI0Ay5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 20:54:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9CA0B204164;
        Fri, 27 Sep 2019 02:54:54 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7me66Fx3w7TQ; Fri, 27 Sep 2019 02:54:46 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id B3E2020414D;
        Fri, 27 Sep 2019 02:54:45 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
To:     Alan Stern <stern@rowland.harvard.edu>,
        Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
References: <Pine.LNX.4.44L0.1909261943230.24988-100000@netrider.rowland.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <631aa72f-4eee-bb5d-a81c-62df3a5a09e8@interlog.com>
Date:   Thu, 26 Sep 2019 20:54:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1909261943230.24988-100000@netrider.rowland.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-26 7:57 p.m., Alan Stern wrote:
> On Fri, 27 Sep 2019, Damien Le Moal wrote:
> 
>> If a non-passthrough command is terminated with a CHECK CONDITION, the
>> scsi error recovery code reuses the failed command scsi_cmnd structure
>> to process error recovery request sense. To preserve information
>> regarding the failed command, the functions scsi_eh_prep_cmnd() and
>> scsi_eh_restore_cmnd() respectively save and restore the original
>> command information. However, the resid field of the failed command
>> request structure is not preserved and reused for the request sense
>> handling, leading to the original command having an incorrect resid
>> when:
>> A) The command is not retried and terminated with an error
>> B) The command completes after retry and the underlying LLD does not set
>>     resid for a fully completed command (resid=0)
>>
>> The first patch of this series addresses case (A) above by adding resid
>> as part of the command information saved using struct scsi_eh_save.
> 
> Good catch.
> 
>> Case B can be observed with a WD My Book USB disks when a read or write
>> command is sent to the disk while the disk is in deep sleep mode
>> (spun down) due to a long period of inactivity (~30min).
>> In such case, the following command sequence happen:
>> 1) The read or write command is terminated after a few seconds with
>>     CHECK CONDITION and an asc/ascq of 04/01 (LOGICAL UNIT IS IN PROCESS
>>     OF BECOMING READY)
>> 2) In response to this failure, the USB mass storage driver triggers
>>     autosense processing, reusing the command descriptor to issue a
>>     request sense command with a 96B sense buffer size. The reply
>>     to this command gives a NOT READY / LOGICAL UNIT IS IN PROCESS
>>     OF BECOMING READY sense of 18B, resulting in a resid of 78B.
>> 3) The original command is retried and failed again, with step 2
>>     repeated, until the drive spins up and becomes ready.
>> 4) When the original command completes after the drive has become ready,
>>     the request sense command resid of 78B is seen by the scsi disk
>>     driver sd_done() function and wrongly generates a warning about the
>>     unaligned value reported.
> 
> But with the 1/1 patch in place, 4 won't happen any more, right?
> sd_done() will see the resid from the successful read or write.
> 
>> This problem is fixed in patch 2 by always setting a command resid to 0
>> when there is no residual in usb_stor_Bulk_transport(). Note that
>> usb_stor_CB_transport() does not need changes since usb_stor_bulk_srb()
>> always sets the resid for a completed command, regardless of the
>> residual value.
> 
> Exactly the same reasoning shows that usb_stor_Bulk_transport() also
> does not need changes, doesn't it?  Which means that patch 2/2 is
> unnecessary.
> 
> Alan Stern
> 
> PS: The correct term is "residue", not "residual".  I know that the
> code sometimes uses the wrong word.

Digging into my T10 document archive I found this cam3r03.pdf :

   − cam_resid;
     The data residual length member contains the difference in twos
     complement form of the number of data bytes transferred by the
     HA for the SCSI command compared with the number of bytes
     requested by the CCB cam_dxfer_len member. This is calculated
     by the total number of bytes requested to be transferred by the
     CCB minus the actual number of bytes transferred by the HA.

CAM is a now withdrawn T10 standard from the 1990s that was influential
at the time. FreeBSD's SCSI subsystem is (still) based on CAM.

For a more recent standard/draft there is fcp5r00.pdf that uses the
term "residual value" when defining its fcp_resid.

The only reference to the term "residue" that I found is in CAM: an
optional message: IGNORE WIDE RESIDUE .

So I would leave the naming up to the patch author. It is pretty
clear what is being referred to in either case.

Doug Gilbert


P.S. I prefer "residual" because it is more flexible being both
an adjective and a noun.
[Ref: https://www.lexico.com/en/definition/residual]


