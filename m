Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739EFCDB47E
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Oct 2023 16:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjJOQOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Oct 2023 12:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjJOQOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Oct 2023 12:14:40 -0400
Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22637A3;
        Sun, 15 Oct 2023 09:14:39 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 3C656144BDD; Sun, 15 Oct 2023 12:14:38 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
In-Reply-To: <20230927141828.90288-5-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org>
Date:   Sun, 15 Oct 2023 12:14:38 -0400
Message-ID: <87v8b73lsh.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SCSI disks that are runtime suspended, it looks like they skip
waking the disk on system resume, leaving them in runtime suspend.
After these patches, it looks like libata always wakes up the disk, but
I don't see any calls to pm_runtime_disable/set_active/enable to mark
the scsi disk as active after the system resume.  That should result in
a disk that is spinning, but runtime pm thinks is not, and so will not
put it into suspend after the inactivity timeout.
