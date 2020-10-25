Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06DCC388F7
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 10:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCF120773
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 10:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415243AbgJYKmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 06:42:25 -0400
Received: from avasout06.plus.net ([212.159.14.18]:58983 "EHLO
        avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415241AbgJYKmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 06:42:24 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Oct 2020 06:42:23 EDT
Received: from APOLLO ([212.159.61.44])
        by smtp with ESMTPA
        id WdMJkk0BhhO4HWdMKkcMi2; Sun, 25 Oct 2020 10:34:45 +0000
X-Clacks-Overhead: "GNU Terry Pratchett"
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.3 cv=SPPZqNnH c=1 sm=1 tr=0
 a=AGp1duJPimIJhwGXxSk9fg==:117 a=AGp1duJPimIJhwGXxSk9fg==:17
 a=kj9zAlcOel0A:10 a=P1kZ4gAsAAAA:8 a=VwQbUJbxAAAA:8 a=RjYKm9-K-DIam8sJtF8A:9
 a=YgrFyEFIyJ_i3ajs:21 a=MCcI_dHylpfWtlzZ:21 a=CjuIK1q_8ugA:10
 a=fn9vMg-Z9CMH7MoVPInU:22 a=AjGcO6oz07-iQ99wixmX:22
X-AUTH: perdrix52@:2500
From:   "David C. Partridge" <david.partridge@perdrix.co.uk>
To:     <linux-scsi@vger.kernel.org>
References: <007e01d6a7a1$fed7d820$fc878860$@perdrix.co.uk> <009901d6aa01$e49d4690$add7d3b0$@perdrix.co.uk>
In-Reply-To: <009901d6aa01$e49d4690$add7d3b0$@perdrix.co.uk>
Subject: RE: Adaptec ASR-51245 and aacraid driver timeouts
Date:   Sun, 25 Oct 2020 10:34:43 -0000
Message-ID: <002a01d6aaba$7497c230$5dc74690$@perdrix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHRB8w658IXIXOeAUgHC2i4dDaVLwJ7ObcYqZ+LYgA=
Content-Language: en-gb
X-CMAE-Envelope: MS4wfDzqH2a/9O3zOg45e/jPl3dkewrE8PFL61Yh4fPdWUkUahhL7YKItc0QsswwMwsKboQ0kOXXPRy/I1/rSFTDyOMZP7YF80NHZRWUXKbf2gcfvK/Idt2Y
 FXk+/MMAbkMYmD+R6BrbdEzBlxAZmiWYl6NLLOMtz4scpGDOSkiRPObFTlFbQzMtKwrYXjVacbU3Yw==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If this is not the right mailing list, please point me to the correct one
...

-----Original Message-----
From: David C. Partridge [mailto:david.partridge@perdrix.co.uk] 
Sent: 24 October 2020 13:34
To: linux-scsi@vger.kernel.org
Subject: RE: Adaptec ASR-51245 and aacraid driver timeouts

Hi again,

I know there's been a lot of activity lately, so this could well have been
missed.

I'd dearly like to be able to power the drives down when the array is idle,
but this problem seems to make that impossible.

Are any of the folks that know the Adaptec raid cards and the aacraid driver
here?

Thanks
David 

-----Original Message-----
From: David C. Partridge [mailto:david.partridge@perdrix.co.uk] 
Sent: 21 October 2020 13:02
To: linux-scsi@vger.kernel.org
Subject: Adaptec ASR-51245 and aacraid driver timeouts

I'm running LUbuntu x64 20.04.1 kernel 5.4.0-52-generic with an Adapted
ASR-51245 hosting a RAID-5 array.

If I configure the card to power down the drives in the raid array after a
period of idleness, the next time my server attempts to access the logical
device I get:

Oct 19 04:03:03 charon kernel: aacraid: Host adapter abort request.
                               aacraid: Outstanding commands on (0,0,0,0):
Oct 19 04:03:03 charon kernel: aacraid: Host adapter reset request. SCSI
hang ?
Oct 19 04:03:18 charon kernel: aacraid: Host adapter reset request. SCSI
hang ?
Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
midlevel-0
Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
lowlevel-0
Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd: error
handler-0
Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
firmware-1
Oct 19 04:03:18 charon kernel: aacraid 0000:01:00.0: outstanding cmd:
kernel-0
Oct 19 04:03:48 charon kernel: sd 0:0:0:0: Device offlined - not ready after
error recovery
Oct 19 04:03:48 charon kernel: sd 0:0:0:0: [sda] tag#215 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Oct 19 04:03:48 charon kernel: sd 0:0:0:0: [sda] tag#215 CDB: Read(16) 88 00
00 00 00 00 00 05 27 48 00 00 00 08 00 00
Oct 19 04:03:48 charon kernel: blk_update_request: I/O error, dev sda,
sector 337736 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 0
Oct 19 04:03:48 charon kernel: BTRFS error (device sda1): bdev /dev/sda1
errs: wr 1, rd 1, flush 0, corrupt 3, gen 0

at which point the drive is now effectively offline :/

I tried upping the timeout:

root@charon:/etc/udev/rules.d# cat 99-aacraid.rules 
SUBSYSTEM=="block", ACTION=="add", ENV{ID_VENDOR}=="Adaptec",
ENV{ID_MODEL}=="Shared", RUN+="/bin/sh -c 'echo 135 >
/sys/block/%k/device/timeout'"

but that didn't appear to stop the problem occurring (and the kernel wasn't
over happy about a >120s timeout).

Any help much appreciated.
David





