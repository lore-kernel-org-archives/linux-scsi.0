Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15AEE936E6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbjJDVBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjJDVBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:01:33 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB6990;
        Wed,  4 Oct 2023 14:01:30 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 41DBC13E32B; Wed,  4 Oct 2023 17:01:29 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 00/23] Fix libata suspend/resume handling and code
 cleanup
In-Reply-To: <3aae2b14-ce32-261a-46a4-cc8d5f3adab4@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <874jj8sia5.fsf@vps.thesusis.net> <87h6n87dac.fsf@vps.thesusis.net>
 <269e2876-58fd-b73c-0c0d-1593c17c2809@kernel.org>
 <ZRyGIE+NpmtMu7XK@thesusis.net>
 <3aae2b14-ce32-261a-46a4-cc8d5f3adab4@kernel.org>
Date:   Wed, 04 Oct 2023 17:01:29 -0400
Message-ID: <875y3mumom.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien Le Moal <dlemoal@kernel.org> writes:

>> I did some tracing today on a test ext4 fs I created on a loopback device, and it
>> seems that the superblocks are written every time you sync, even if no files on the
>> filesystem have even been opened for read access.
>
> OK. So a fix would need to be on the FS side then if one wants to avoid that
> useless resume. However, this may clash with the FS need to record stuff in its
> sb and so we may not be able to avoid that.

Ok, this is very strange.  I went back to my distro kernel, without
runtime pm, mounted the filesystems rw again, used hdparm -y to suspend
the disk, verified with hdparm -C that they were in suspend, and and
suspended the system.  In dmesg I see:

Filesystems sync: 0.007 seconds

Now, if it were writing the superblocks to the disk there, I would
expect that to take more like 3 seconds while it woke the disks back up,
like it did when I was testing the latest kernel with runtime pm.

Another odd thing I noticed with the runtime pm was that sometimes the
drives would randomly start up even though I was not accessing them.
This never happens when I am normally using the debian kernel with no
runtime pm and just running hdparm -y to put the drives to sleep.  I can
check them hours later and they are still in standby.

I just tried running sync and blktrace and it looks like it is writing
the superblock to the drive, and yet, hdparm -C still says it is in
standby.  This makes no sense.  Here is what blktrace said when I ran
sync:

  8,0    0        1     0.000000000 34004  Q FWS [sync]
  8,0    0        2     0.000001335 34004  G FWS [sync]
  8,0    0        3     0.000004327 31088  D  FN [kworker/0:2H]
  8,0    0        4     0.000068945     0  C  FN 0 [0]
  8,0    0        5     0.000069466     0  C  WS 0 [0]

I just noticed that this trace doesn't show the 0+8 that I saw when I
was testing running sync with a fresh, empty ext4 filesystem on a loop
device.  That showed 0+8 indicating the first 4k block of the disk, as
well as 1023+8, and one or two more offsets that I thought were the
backup superblocks.

What the heck is this sync actually writing, and why does it not cause
the disk to take itself out of standby, but with runtime pm, it does?
Could this just be a FLUSH of some sort, which when the disk is in
standby, it ignores, but the kernel runtime pm decides it must wake the
disk up before dispatching the command, even though it is useless?
