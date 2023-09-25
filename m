Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC83CE7A94
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Sep 2023 14:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjIYOsC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Sep 2023 10:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjIYOsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2023 10:48:01 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC9E111;
        Mon, 25 Sep 2023 07:47:54 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id E4A4D13B2D6; Mon, 25 Sep 2023 10:47:23 -0400 (EDT)
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-6-dlemoal@kernel.org>
User-agent: mu4e 1.7.12; emacs 27.1
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
Subject: Re: [PATCH v6 05/23] ata: libata-scsi: Disable scsi device
 manage_system_start_stop
Date:   Mon, 25 Sep 2023 10:27:42 -0400
In-reply-to: <20230923002932.1082348-6-dlemoal@kernel.org>
Message-ID: <87r0mmux6s.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien Le Moal <dlemoal@kernel.org> writes:

> However, restoring the ATA device to the active power mode must be
> synchronized with libata EH processing of the port resume operation to
> avoid either 1) seeing the start stop unit command being received too
> early when the port is not yet resumed and ready to accept commands, or
> after the port resume process issues commands such as IDENTIFY to

I do not believe this is correct.  The drive must respond to IDENTIFY
and SET FEATURES while in standby mode.  Some of the information in the
IDENTIFY block may be flagged as not available because it requires media
access and the drive is in standby.  There is a bit in the IDENTIFY
block that indicates whether the drive will automatically spin up for
media access commands or not, and if not, then you must issue the SET
FEATURES command to spin it up.  For such drives, that VERIFY command
will fail.

> revalidate the device. In this last case, the risk is that the device
> revalidation fails with timeout errors as the drive is still spun down.

If a request can timeout before the drive has time to spin up, then that
would be a problem outside of suspend/resume.  You would get such
timeouts any time you manually suspend the drive with hdparm -y, or the
drive auto suspends ( hdparm -S ).  The timeout needs to be long enough
for the drive to spin up.  IIRC, it defaults to 10 seconds, which is
plenty of time.


It sounds like you are saying that you unconditionally wake the drive
with a VERIFY command to make sure that you can then IDENTIFY.  This
should not be needed.  In addition, if the drive has PuiS enabled, I
would like to leave it in standby after a system resume, not force it to
wake up.  After all, that is why it has PuiS enabled.

