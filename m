From: Brian De Wolf <bldewolf@cpp.edu>
Subject: mptsas doesn't detect hot-added disk drives in ESX guest
Date: Wed, 15 Mar 2017 16:21:24 -0700
Message-ID: <20170315162124.737d6919@cpp.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0097.outbound.protection.outlook.com ([104.47.33.97]:61511
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753797AbdCOXVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 19:21:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, I'm looking for some help tracking down why I can no longer
hot-add disks to my virtual machines.  They are guests on ESXi 6.0
using the LSI Logic SAS controller emulation, using the mptsas kernel
module.  At some point between 3.18.27 and 4.4.50, we lost the ability
to hot-add disks to the guest machines.  Even echoing "- - -"
into /sys/.../scan doesn't cause the new disks to show up.

I performed a bisect between 3.18 and 4.4.50 where I built the kernel,
rebooted, and attached a disk, marking it as bad if mptsas did not see
the new disk.  It ended at the commit:

    1bd04bf timer: Remove FIFO "guarantee"

This commit mentions

    It's a seperate patch so any (unlikely to happen) regression caused by
    this can be identified clearly.

so I'm not sure if I've run into an unlikely regression or if my
testing procedure was buggy.

I also reproduced the issue using an Arch linux live CD running
4.9.11.  I suspect this issue hasn't been noticed in the more stable
distros yet because they're still mostly pre-4.0.

The issue doesn't show up if I use pvscsi, which will probably be our
long-term solution.

Anyone know if this is a known issue?  Is there anything else I should
try or anyone I should notify?
