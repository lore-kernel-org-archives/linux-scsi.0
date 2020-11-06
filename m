Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645C7C388F2
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 09:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17CD920B80
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 09:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgKFJC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 04:02:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:40158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgKFJC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Nov 2020 04:02:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 036D5AEC4;
        Fri,  6 Nov 2020 09:02:26 +0000 (UTC)
Subject: Re: Adaptec ASR-51245 and aacraid driver timeouts
To:     "David C. Partridge" <david.partridge@perdrix.co.uk>,
        linux-scsi@vger.kernel.org
References: <007e01d6a7a1$fed7d820$fc878860$@perdrix.co.uk>
 <009901d6aa01$e49d4690$add7d3b0$@perdrix.co.uk>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b7698064-9c1a-25fd-982f-9707d87ccc42@suse.de>
Date:   Fri, 6 Nov 2020 10:02:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <009901d6aa01$e49d4690$add7d3b0$@perdrix.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/20 2:33 PM, David C. Partridge wrote:
> Hi again,
> 
> I know there's been a lot of activity lately, so this could well have been
> missed.
> 
> I'd dearly like to be able to power the drives down when the array is idle,
> but this problem seems to make that impossible.
> 
> Are any of the folks that know the Adaptec raid cards and the aacraid driver
> here?
> 
> Thanks
> David
> 
> -----Original Message-----
> From: David C. Partridge [mailto:david.partridge@perdrix.co.uk]
> Sent: 21 October 2020 13:02
> To: linux-scsi@vger.kernel.org
> Subject: Adaptec ASR-51245 and aacraid driver timeouts
> 
> I'm running LUbuntu x64 20.04.1 kernel 5.4.0-52-generic with an Adapted
> ASR-51245 hosting a RAID-5 array.
> 
> If I configure the card to power down the drives in the raid array after a
> period of idleness, the next time my server attempts to access the logical
> device I get:
> 
> Oct 19 04:03:03 charon kernel: aacraid: Host adapter abort request.
>                                 aacraid: Outstanding commands on (0,0,0,0):
> Oct 19 04:03:03 charon kernel: aacraid: Host adapter reset request. SCSI
> hang ?
> Oct 19 04:03:18 charon kernel: aacraid: Host adapter reset request. SCSI
> hang ?
> Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
> midlevel-0
> Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
> lowlevel-0
> Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd: error
> handler-0
> Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
> firmware-1
> Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
> kernel-0
> Oct 19 04:03:48 charon kernel: sd 0:0:0:0: Device offlined - not ready after
> error recovery
> Oct 19 04:03:48 charon kernel: sd 0:0:0:0: [sda] tag#215 FAILED Result:
> hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
> Oct 19 04:03:48 charon kernel: sd 0:0:0:0: [sda] tag#215 CDB: Read(16) 88 00
> 00 00 00 00 00 05 27 48 00 00 00 08 00 00
> Oct 19 04:03:48 charon kernel: blk_update_request: I/O error, dev sda,
> sector 337736 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 0
> Oct 19 04:03:48 charon kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 1, rd 1, flush 0, corrupt 3, gen 0
> 
> at which point the drive is now effectively offline :/
> 
> I tried upping the timeout:
> 
> root@charon:/etc/udev/rules.d# cat 99-aacraid.rules
> SUBSYSTEM=="block", ACTION=="add", ENV{ID_VENDOR}=="Adaptec",
> ENV{ID_MODEL}=="Shared", RUN+="/bin/sh -c 'echo 135 >
> /sys/block/%k/device/timeout'"
> 
> but that didn't appear to stop the problem occurring (and the kernel wasn't
> over happy about a >120s timeout).
> 
> Any help much appreciated.
> David
> 
Can you send a 'START/STOP UNIT' command to the device,
eg via sg_start /dev/sda?

It looks to me as if the devices are simply spun down, and for some 
reason the driver doesn't report this correctly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
