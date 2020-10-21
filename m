Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FF1C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 12:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC752224B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 12:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439576AbgJUMJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 08:09:38 -0400
Received: from avasout07.plus.net ([84.93.230.235]:56831 "EHLO
        avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406256AbgJUMJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 08:09:38 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 08:09:37 EDT
Received: from APOLLO ([212.159.61.44])
        by smtp with ESMTPA
        id VCoekWxQcoEd7VCogkVfot; Wed, 21 Oct 2020 13:02:06 +0100
X-Clacks-Overhead: "GNU Terry Pratchett"
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.3 cv=Kp/WJVeN c=1 sm=1 tr=0
 a=AGp1duJPimIJhwGXxSk9fg==:117 a=AGp1duJPimIJhwGXxSk9fg==:17
 a=kj9zAlcOel0A:10 a=XebB-SxSiyjOAt_Zs2gA:9 a=CjuIK1q_8ugA:10
X-AUTH: perdrix52@:2500
From:   "David C. Partridge" <david.partridge@perdrix.co.uk>
To:     <linux-scsi@vger.kernel.org>
Subject: Adaptec ASR-51245 and aacraid driver timeouts
Date:   Wed, 21 Oct 2020 13:02:04 +0100
Message-ID: <007e01d6a7a1$fed7d820$fc878860$@perdrix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-Language: en-gb
Thread-Index: Adann+LHqUCdaxUGR2KKa89As+/XGA==
X-CMAE-Envelope: MS4wfHy80XRmUXqQGjGaF2ZI5M4FSvUZ3pL0phqHZuW+pBipAkTBv8+pvLc3FAAKZWfsStNTw8LfVa5AAY/Kb+57e6R558zJlJ28Qw/EGSepZuQlz1Zw7IEJ
 rEhJlDNQyuvL1DJ5i6ZY+gG6teRvzm6HsOeIBfh1PeIktzfe1Gnq2kyKT2roaUyMUAqomeIBLsoPfQ==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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





