Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAB1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 07:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79EB661250
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 07:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhKEHHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 03:07:40 -0400
Received: from peace.netnation.com ([204.174.223.2]:42632 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhKEHHk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 03:07:40 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2021 03:07:39 EDT
Received: from sim by peace.netnation.com with local (Exim 4.92)
        (envelope-from <sim@hostway.ca>)
        id 1miszX-000710-5C; Thu, 04 Nov 2021 23:46:23 -0700
Date:   Thu, 4 Nov 2021 23:46:23 -0700
From:   Simon Kirby <sim@hostway.ca>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Unreliable disk detection order in 5.x
Message-ID: <20211105064623.GD32560@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm seeing disk detection order changing across reboots on 5.x kernels
(5.4, 5.10, 5.14), but not 4.9, 4.14, 4.19, with megaraid_sas (Dell
PERC_H700). With 13 disks and 5.14.14, the order changes almost always.

I did initially try to bisect this issue, but it seems to become more
rare in earlier kernels, and there are some non-booting problems between
4.x and 5.x.

The most common effect is swapping of sda with sdb, or two neighboring
devices in the list; for example:

# diff -u lsblk-S-5.10.0 lsblk-S-5.10.0-2
--- lsblk-S-5.10.0      2021-11-04 15:23:23.767008360 -0400
+++ lsblk-S-5.10.0-2    2021-11-04 17:34:37.748310196 -0400
@@ -1,6 +1,6 @@
 NAME HCTL       TYPE VENDOR   MODEL      REV TRAN
-sda  0:2:0:0    disk DELL     PERC_H700 2.10
-sdb  0:2:2:0    disk DELL     PERC_H700 2.10
+sda  0:2:2:0    disk DELL     PERC_H700 2.10
+sdb  0:2:0:0    disk DELL     PERC_H700 2.10
 sdc  0:2:3:0    disk DELL     PERC_H700 2.10
 sdd  0:2:4:0    disk DELL     PERC_H700 2.10
 sde  0:2:5:0    disk DELL     PERC_H700 2.10

This is happening on vendor (Debian 5.10.0) and home-built kernels, and
on a variety of hosts. On all kernels, the detection printks come up in
an interesting order, but in older kernels, it always ends up with an
sd-name that is ordered by SCSI ID ascending:

[    2.289776] sd 0:2:0:0: [sda] 999030784 512-byte logical blocks: (512 GB/476 GiB)
[    2.289918] sd 0:2:4:0: [sdd] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.289947] sd 0:2:3:0: [sdc] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.290032] sd 0:2:6:0: [sdf] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.290210] sd 0:2:7:0: [sdg] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.290248] sd 0:2:9:0: [sdi] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.290323] sd 0:2:2:0: [sdb] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.290461] sd 0:2:5:0: [sde] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    2.290476] sd 0:2:8:0: [sdh] 11719933952 512-byte logical blocks: (6.00 TB/5.46 TiB)

Full "dmesg" is saved here: https://0x.ca/sim/ref/5.10.0/dmesg

Any ideas on suggestions on what I could use to track down what changed
here, or ideas on what might have influenced it?

Simon-
